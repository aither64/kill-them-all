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
  self.player:update(dt)

  for i, b in self.beams:pairs() do
    b:update(dt)

    if not b:isActive() then
      self.beams:remove(i)
      goto nextbeam
    end

    if b.lethal == 'enemy' or b.lethal == 'all' then
      for j, e in self.enemies:pairs() do
        if self:checkCollision(e, b) then
          b:hit(e)
          e:hitByBeam(p, b.damage * dt)

          if e:isDestroyed() then
            self.enemies:remove(j)
            self.level:enemyDestroyed(e)
            self.player:enemyKilled(e)
          end

          if not b:isActive() then
            self.beams:remove(i)
            goto nextbeam
          end
        end
      end
    end

    ::nextbeam::
  end

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

    if (p.lethal == 'player' or p.lethal == 'all') then
      for j, f in self.friendlies:pairs() do
        if self:checkCollision(f, p) then
          p:hit(f)
          self.projectiles:remove(i)

          f:hitByProjectile(p)

          if f:isDestroyed() then
            self.friendlies:remove(j)
            self.level:friendlyDestroyed(e)
          end

          goto continue
        end
      end

      if self:checkCollision(self.player, p) then
        self.player:hitByProjectile(p)
        p:hit(self.player)
        self.projectiles:remove(i)
        goto continue
      end
    end

    if p.lethal == 'enemy' or p.lethal == 'all' then
      for j, e in self.enemies:pairs() do
        if self:checkCollision(e, p) then
          p:hit(e)
          self.projectiles:remove(i)

          e:hitByProjectile(p)

          if e:isDestroyed() then
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

  for i, ex in self.explosions:pairs() do
    ex:update(dt)

    if ex:isDone() then
      self.explosions:remove(i)
      goto continue
    end

    if (ex.lethal == 'enemy' or ex.lethal == 'all') then
      for j, e in self.enemies:pairs() do
        if self:checkCollision(e, ex) then
          e:hitByExplosion(ex)

          if e:isDestroyed() then
            self.enemies:remove(j)
            self.level:enemyDestroyed(e)
          end
        end
      end

      for j, p in self.projectiles:pairs() do
        if p.lethal == 'player' and self:checkCollision(ex, p) then
          self.projectiles:remove(j)
        end
      end
    end

    ::continue::
  end

  for i, e in self.enemies:pairs() do
    e:update(dt)

    if e:isOut() then
      self.enemies:remove(i)
      self.level:enemyOut(e)
      self.player:enemyMissed(e)
    end
  end

  for i, f in self.friendlies:pairs() do
    f:update(dt)

    if f:isOut() then
      self.friendlies:remove(i)
      self.level:friendlyOut(e)
    end
  end

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

    elseif self:checkCollision(self.player, p, {r = self.player.r * 3}) then
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

  if not self.player:isAlive() then
    self.game:gameOver()
  end
end

function World:draw()
  love.graphics.translate(self.startX, self.startY)
  love.graphics.push()

  self.background:draw()
  self.player:draw()

  for i, ex in self.explosions:pairs() do
    if ex then ex:draw() end
  end

  for i, p in self.projectiles:pairs() do
    if p then p:draw() end
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

function World:findClosestEnemy(x, y)
  local closest = {
    enemy = nil,
    distance = nil
  }

  for i, e in self.enemies:pairs() do
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
  end

  return closest.enemy
end

return World
