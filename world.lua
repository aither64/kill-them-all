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
  t.projectiles = ObjectList:new()
  t.powerups = ObjectList:new()
  return t
end

function World:load()
  self.level:load()
end

function World:update(dt)
  self.background:update(dt)
  self.level:update(dt)
  self.player:update(dt)

  for i, p in self.projectiles:pairs() do
    if p == nil then goto continue end

    p:update(dt)

    if p:isOut() then
      self.projectiles:remove(i)
      goto continue
    end

    if (p.lethal == 'player' or p.lethal == 'all') and self.player:checkCollisionWith(p.x, p.y) then
      self.player:hitByProjectile(p)
      p:hit(self.player)
      self.projectiles:remove(i)
    end

    if p.lethal == 'enemy' or p.lethal == 'all' then
      for j, e in self.enemies:pairs() do
        if e:checkCollisionWith(p.x, p.y) then
          p:hit(e)
          self.projectiles:remove(i)

          e:hitByProjectile(p)

          if e:isDestroyed() then
            self.enemies:remove(j)
            self.level:enemyDestroyed(e)
            self.player:enemyKilled(e)
          end
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

  for i, p in self.powerups:pairs() do
    p:update(dt)

    if self.player:checkCollisionWithCircle(p.x, p.y, p.r) then
      self.player:addPowerUp(p)
      self.powerups:remove(i)
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

  for i, p in self.projectiles:pairs() do
    if p then p:draw() end
  end

  for i, p in self.powerups:pairs() do
    if p then p:draw() end
  end

  for i, e in self.enemies:pairs() do
    e:draw()
  end

  love.graphics.pop()
end

function World:addEnemy(enemy)
  self.enemies:add(enemy)
end

function World:addProjectile(projectile)
  self.projectiles:add(projectile)
end

function World:addPowerUp(powerup)
  self.powerups:add(powerup)
end

return World
