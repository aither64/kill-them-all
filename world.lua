Player = require 'player'
Enemy = require 'enemy'
LevelInfinite = require 'levels/infinite'
ObjectList = require 'object_list'
Background = require 'background'

local World = {}

function World:new(game, startX, startY, endX, endY)
  local t = setmetatable({}, { __index = self })
  t.game = game
  t.startX = startX
  t.startY = startY
  t.endX = endX
  t.endY = endY
  t.w = endX - startX
  t.h = endY - startY
  t.background = Background:new(t)
  t.level = LevelInfinite:new(t)
  t.player = Player:new(t, 50, t.h / 2)
  t.enemies = ObjectList:new()
  t.friendlies = ObjectList:new()
  t.projectiles = ObjectList:new()
  t.missiles = ObjectList:new()
  t.beams = ObjectList:new()
  t.explosions = ObjectList:new()
  t.powerups = ObjectList:new()
  t.hooks = {}
  return t
end

function World:load()
  self.level:load()
end

function World:update(dt)
  self.background:update(dt)
  self.level:update(dt)

  if self.player:isAlive() then
    self.player:update(dt)
  end

  -- Check beam collisions
  for i, b in self.beams:pairs() do
    b:update(dt)

    if not b:isActive() then
      self.beams:remove(i)
      b:discharged()
      goto nextbeam
    end

    -- Player/friendly hits
    if b.lethal == 'player' or b.lethal == 'all' then
      for j, f in self.friendlies:pairs() do
        if self:checkCollision(f, b) then
          b:hit(f)
          f:hitByBeam(b)

          if f:isDestroyed() then
            f:destroyed()
            self.friendlies:remove(j)
            self.level:friendlyDestroyed(f)
          end
        end
      end

      if self.player:isAlive() and self:checkCollision(self.player, b) then
        self.player:hitByBeam(b)
        b:hit(self.player)
      end
    end

    -- Enemy hits
    if b.lethal == 'enemy' or b.lethal == 'all' then
      for j, e in self.enemies:pairs() do
        if self:checkCollision(e, b) then
          b:hit(e)
          e:hitByBeam(p, b.damage * dt)

          if e:isDestroyed() then
            e:destroyed()
            self.enemies:remove(j)
            self.level:enemyDestroyed(e)
            self.player:enemyKilled(e)
          end
        end
      end
    end

    ::nextbeam::
  end

  -- Check projectile collisions
  for i, p in self.projectiles:pairs() do
    if p == nil then goto continue end

    p:update(dt)

    if p:isOut() then
      self.projectiles:remove(i)
      goto continue
    end

    if self:invokeCallback('projectileCollision', p) then
      self.projectiles:remove(i)
      goto continue
    end

    -- Remove projectiles hit by explosions
    for j, ex in self.explosions:pairs() do
      if (ex.lethal == 'all'
         or (ex.lethal == 'enemy' and p.lethal == 'player')
         or (ex.lethal == 'player' and p.lethal == 'enemy'))
         and self:checkCollision(ex, p) then
        self.projectiles:remove(i)
        goto continue
      end
    end

    -- Player/friendly hits
    if (p.lethal == 'player' or p.lethal == 'all') then
      for j, f in self.friendlies:pairs() do
        if self:checkCollision(f, p) then
          p:hit(f)
          self.projectiles:remove(i)

          f:hitByProjectile(p)

          if f:isDestroyed() then
            f:destroyed()
            self.friendlies:remove(j)
            self.level:friendlyDestroyed(f)
          end

          goto continue
        end
      end

      if self.player:isAlive() and self:checkCollision(self.player, p) then
        self.player:hitByProjectile(p)
        p:hit(self.player)
        self.projectiles:remove(i)
        goto continue
      end
    end

    -- Enemy hits
    if p.lethal == 'enemy' or p.lethal == 'all' then
      for j, e in self.enemies:pairs() do
        if self:checkCollision(e, p) then
          p:hit(e)
          self.projectiles:remove(i)

          e:hitByProjectile(p)

          if e:isDestroyed() then
            e:destroyed()
            self.enemies:remove(j)
            self.level:enemyDestroyed(e)
            self.player:enemyKilled(e)
          end

          goto continue
        end
      end
    end

    ::continue::
  end

  -- Check missile collisions
  for i, m in self.missiles:pairs() do
    if m == nil then goto continue end

    m:update(dt)

    if m:isOut() then
      m:detonate()
      self.missiles:remove(i)
      goto continue
    end

    -- Player/friendly hits
    if (m.lethal == 'player' or m.lethal == 'all') then
      for j, f in self.friendlies:pairs() do
        if self:checkCollision(f, m) then
          m:hit(f)
          self.missiles:remove(i)

          f:hitByMissile(m)

          if f:isDestroyed() then
            f:destroyed()
            self.friendlies:remove(j)
            self.level:friendlyDestroyed(f)
          end

          goto continue
        end
      end

      if self.player:isAlive() and self:checkCollision(self.player, m) then
        self.player:hitByMissile(m)
        m:hit(self.player)
        self.missiles:remove(i)
        goto continue
      end
    end

    -- Enemy hits
    if m.lethal == 'enemy' or m.lethal == 'all' then
      for j, e in self.enemies:pairs() do
        if self:checkCollision(e, m) then
          m:hit(e)
          self.missiles:remove(i)

          e:hitByMissile(m)

          if e:isDestroyed() then
            e:destroyed()
            self.enemies:remove(j)
            self.level:enemyDestroyed(e)
            self.player:enemyKilled(e)
          end

          goto continue
        end
      end
    end

    ::continue::
  end

  -- Check explosion collisions
  for i, ex in self.explosions:pairs() do
    ex:update(dt)

    if ex:isDone() then
      self.explosions:remove(i)
      goto continue
    end

    -- Player/friendly hits
    if ex.lethal == 'player' or ex.lethal == 'all' then
      for j, f in self.friendlies:pairs() do
        if self:checkCollision(f, ex) then
          f:hitByExplosion(ex)

          if f:isDestroyed() then
            f:destroyed()
            self.friendlies:remove(j)
            self.level:friendlyDestroyed(f)
          end
        end
      end

      if self.player:isAlive() and self:checkCollision(self.player, ex) then
        self.player:hitByExplosion(ex)
      end
    end

    -- Enemy hits
    if (ex.lethal == 'enemy' or ex.lethal == 'all') then
      for j, e in self.enemies:pairs() do
        if self:checkCollision(e, ex) then
          e:hitByExplosion(ex)

          if e:isDestroyed() then
            e:destroyed()
            self.enemies:remove(j)
            self.level:enemyDestroyed(e)
          end
        end
      end
    end

    ::continue::
  end

  -- Update enemies
  for i, e in self.enemies:pairs() do
    e:update(dt)

    if e:isOut() then
      self.enemies:remove(i)
      self.level:enemyOut(e)
      self.player:enemyMissed(e)
    end
  end

  -- Update friendlies
  for i, f in self.friendlies:pairs() do
    f:update(dt)

    if f:isOut() then
      self.friendlies:remove(i)
      self.level:friendlyOut(e)
    end
  end

  -- Update powerups
  for i, p in self.powerups:pairs() do
    p:update(dt)

    if p.active then
      if p:isSpent() then
        p:deactivate()
        self.powerups:remove(i)
      end

    elseif self:checkCollision(self.player, p) then
      if p.pickable then
        self.player:addPowerUp(p)
        self.powerups:remove(i)
      else
        p:activate()
      end

      self.level:powerUpUsed(p)

    elseif self.player:isAlive() and self:checkCollision(self.player, p, {r = self.player.r * 3}) then
      p:attractTo(self.player.x, self.player.y)

    elseif p:isAttracted() then
      if p.pickable then
        self.player:addPowerUp(p)
        self.powerups:remove(i)
      else
        p:activate()
      end

      self.level:powerUpUsed(p)
    end

    if p:isOut() then
      self.powerups:remove(i)
      self.level:powerUpOut(p)
    end
  end

  -- Check player
  if not self.player:isAlive() and self.player:canRespawn() then
    self.player:respawn()
  elseif not self.player:canPlay() then
    self.game:gameOver()
  end
end

function World:draw()
  love.graphics.translate(self.startX, self.startY)
  love.graphics.push()

  self.background:draw()

  if self.player:isAlive() then
    self.player:draw()
  end

  for i, ex in self.explosions:pairs() do
    if ex then ex:draw() end
  end

  for i, p in self.projectiles:pairs() do
    if p then p:draw() end
  end

  for i, m in self.missiles:pairs() do
    if m then m:draw() end
  end

  for i, p in self.powerups:pairs() do
    if p then p:draw() end
  end

  for i, e in self.enemies:pairs() do
    e:draw()
  end

  for i, b in self.beams:pairs() do
    if b then b:draw() end
  end

  for i, f in self.friendlies:pairs() do
    f:draw()
  end

  self.level:draw()

  love.graphics.pop()
end

function World:keypressed(key)
  self.level:keypressed(key)
end

function World:keyreleased(key)
  if key == "a" then
    self.player:toggleAutoFire()
  end

  self.level:keyreleased(key)
end

function World:checkCollision(object, collider, overrides)
  local overrides = overrides or {}

  if collider.collisionType == 'point' then
    return object:checkCollisionWithPoint(
      overrides.x or collider.x,
      overrides.y or collider.y
    )
  elseif collider.collisionType == 'circle' then
    return object:checkCollisionWithCircle(
      overrides.x or collider.x,
      overrides.y or collider.y,
      overrides.r or collider.r
    )
  elseif collider.collisionType == 'rectangle' then
    return object:checkCollisionWithRectangle(
      overrides.x or collider.x,
      overrides.y or collider.y,
      overrides.w or collider.w,
      overrides.w or collider.h
    )
  else
    return false
  end
end

function World:addEnemy(enemy)
  self.enemies:add(enemy)
end

function World:addFriendly(friendly)
  self.friendlies:add(friendly)
end

function World:addProjectile(projectile)
  self:invokeCallback('addProjectile', projectile)
  self.projectiles:add(projectile)
end

function World:addMissile(missile)
  self.missiles:add(missile)
end

function World:addBeam(beam)
  self.beams:add(beam)
end

function World:addExplosion(explosion)
  self.explosions:add(explosion)
end

function World:addPowerUp(powerup)
  self.powerups:add(powerup)
end

function World:addCallback(hook, name, fn)
  if not self.hooks[hook] then
    self.hooks[hook] = { [name] = fn }
  else
    self.hooks[hook][name] = fn
  end
end

function World:invokeCallback(hook, ...)
  if not self.hooks[hook] then
    return
  end

  local ret

  for k, v in pairs(self.hooks[hook]) do
    ret = v(...)
    if ret then return ret end
  end

  return ret
end

function World:removeCallback(hook, name)
  if not self.hooks[hook] then
    return
  end

  self.hooks[hook][name] = nil
end

function World:findClosestEnemy(x, y, opts)
  local opts = opts or {}

  local closest = {
    enemy = nil,
    distance = nil
  }

  for i, e in self.enemies:pairs() do
    if opts.newTarget and e:isTargeted() then
      goto continue
    elseif opts.exclude then
      for _, exc in pairs(opts.exclude) do
        if exc == e then
          goto continue
        end
      end
    end

    local distance = math.sqrt(
      math.pow(x - e.x, 2)
      +
      math.pow(y - e.y, 2)
    )

    if closest.distance == nil then
      closest.enemy = e
      closest.distance = distance
    elseif closest.distance > distance then
      closest.enemy = e
      closest.distance = distance
    end

    ::continue::
  end

  return closest.enemy
end

return World
