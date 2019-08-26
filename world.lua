Player = require 'player'
Enemy = require 'enemy'

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
  t.player = Player:new(t, 50, t.h / 2)
  t.enemies = {}
  t.projectiles = {}
  return t
end

function World:load()
  for i = 1,5 do
    -- enemies[i] = Enemy:new(w, h - 100 * i)
    self.enemies[i] = Enemy:new(self, self.w + 50, 100 + 100*i)
  end
end

function World:update(dt)
  self.player:update(dt)

  for i, p in pairs(self.projectiles) do
    if p == nil then goto continue end

    p:update(dt)

    if p:isOut() then
      self.projectiles[i] = nil
      goto continue
    end

    for j, e in pairs(self.enemies) do
      if e:checkCollisionWith(p.x, p.y) then
        self.projectiles[i] = nil
        self.player.score = self.player.score + 10
        e:respawn()
      end
    end

    ::continue::
  end

  for i, e in pairs(self.enemies) do
    e:update(dt)
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
