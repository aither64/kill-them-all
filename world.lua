Player = require 'player'
Enemy = require 'enemy'
LevelInfinite = require 'levels/infinite'

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
  t.level = LevelInfinite:new(t)
  t.player = Player:new(t, 50, t.h / 2)
  t.enemies = {}
  t.projectiles = {}
  t.powerups = {}
  return t
end

function World:load()
  self.level:load()
end

function World:update(dt)
  self.level:update(dt)
  self.player:update(dt)

  for i, p in pairs(self.projectiles) do
    if p == nil then goto continue end

    p:update(dt)

    if p:isOut() then
      self.projectiles[i] = nil
      goto continue
    end

    if (p.lethal == 'player' or p.lethal == 'all') and self.player:checkCollisionWith(p.x, p.y) then
      self.player:hitByProjectile(p)
      self.projectiles[i] = nil
    end

    if p.lethal == 'enemy' or p.lethal == 'all' then
      for j, e in pairs(self.enemies) do
        if e:checkCollisionWith(p.x, p.y) then
          self.projectiles[i] = nil

          e:hitByProjectile(p)

          if e:isDestroyed() then
            self.enemies[j] = nil
            self.level:enemyDestroyed(e)
            self.player:enemyKilled(e)
          end
        end
      end
    end

    ::continue::
  end

  for i, e in pairs(self.enemies) do
    e:update(dt)

    if e:isOut() then
      self.enemies[i] = nil
      self.level:enemyOut(e)
    end
  end

  for i, p in pairs(self.powerups) do
    p:update(dt)

    if self.player:checkCollisionWithCircle(p.x, p.y, p.r) then
      self.player:addPowerUp(p)
      self.powerups[i] = nil
    end

    if p:isOut() then
      self.powerups[i] = nil
      self.level:powerUpOut(p)
    end
  end
end

function World:draw()
  love.graphics.translate(self.startX, self.startY)
  love.graphics.push()

  self.player:draw()

  for i, p in pairs(self.projectiles) do
    if p then p:draw() end
  end

  for i, p in pairs(self.powerups) do
    if p then p:draw() end
  end

  for i, e in pairs(self.enemies) do
    e:draw()
  end

  love.graphics.pop()
end

function World:addEnemy(enemy)
  for i, p in pairs(self.enemies) do
    if p == nil then
      self.enemies[i] = enemy
      return
    end
  end

  table.insert(self.enemies, enemy)
end

function World:addProjectile(projectile)
  for i, p in pairs(self.projectiles) do
    if p == nil then
      self.projectiles[i] = projectile
      return
    end
  end

  table.insert(self.projectiles, projectile)
end

function World:addPowerUp(powerup)
  for i, p in pairs(self.powerups) do
    if p == nil then
      self.powerups[i] = powerup
      return
    end
  end

  table.insert(self.powerups, powerup)
end

return World
