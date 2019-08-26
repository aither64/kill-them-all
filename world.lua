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
      self.player.score = self.player.score - 1000
      self.projectiles[i] = nil
    end

    if p.lethal == 'enemy' or p.lethal == 'all' then
      for j, e in pairs(self.enemies) do
        if e:checkCollisionWith(p.x, p.y) then
          self.projectiles[i] = nil
          self.player.score = self.player.score + 10
          self.level:enemyDestroyed(e)
        end
      end
    end

    ::continue::
  end

  for i, e in pairs(self.enemies) do
    e:update(dt)

    if e:isOut() then
      self.level:enemyOut(e)
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

return World