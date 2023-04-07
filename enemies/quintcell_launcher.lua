local Enemy = require '../enemy'
local Armament = require "armament"
local GuidedMissile = require 'missiles/guided'
local QuintCellLauncher = Enemy:new()

QuintCellLauncher.hints = {
  spacing = 90
}

function QuintCellLauncher:new(opts)
  local t = Enemy.new(self, opts)
  t.armament = Armament:new()
  t.armament:add('machinegun', {
    frequency = 1.5,
    fire = function() t:fireMachineGun() end
  })
  t.armament:add('guided_missile', {
    frequency = 5,
    fire = function() t:fireGuidedMissile() end
  })
  t.speed = 35
  t.hitpoints = 1600
  t.value = 400
  t:init()
  return t
end

function QuintCellLauncher:update(dt)
  Enemy.update(self, dt)

  if self:canFire() then
    self.armament:fireAll(self:getGameTime())
  end
end

function QuintCellLauncher:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.enemies.QuintCellLauncher.quadBgColor)
  love.graphics.circle('fill', 0, -17, 24)
  love.graphics.circle('fill', 0, 17, 24)
  love.graphics.circle('fill', 34, -17, 24)
  love.graphics.circle('fill', 34, 17, 24)

  love.graphics.setColor(stylesheet.enemies.QuintCellLauncher.quadLineColor)
  love.graphics.circle('line', 0, -17, 26)
  love.graphics.circle('line', 0, -17, 27)
  love.graphics.circle('line', 0, -17, 28)
  love.graphics.circle('line', 0, 17, 26)
  love.graphics.circle('line', 0, 17, 27)
  love.graphics.circle('line', 0, 17, 28)
  love.graphics.circle('line', 34, -17, 26)
  love.graphics.circle('line', 34, -17, 27)
  love.graphics.circle('line', 34, -17, 28)
  love.graphics.circle('line', 34, 17, 26)
  love.graphics.circle('line', 34, 17, 27)
  love.graphics.circle('line', 34, 17, 28)

  love.graphics.setColor(stylesheet.enemies.QuintCellLauncher.towerBgColor)
  love.graphics.circle('fill', 17, 0, 24)
  love.graphics.setColor(stylesheet.enemies.QuintCellLauncher.towerLineColor)
  love.graphics.circle('line', 17, 0, 26)
  love.graphics.circle('line', 17, 0, 27)
  love.graphics.circle('line', 17, 0, 28)

  love.graphics.pop()
end

function QuintCellLauncher:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function QuintCellLauncher:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function QuintCellLauncher:checkCollisionWithRectangle(x, y, w, h)
  return (
    self:checkCollisionCircleRectangle(self.x, self.y - 17, 28, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x, self.y + 17, 28, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x + 34, self.y - 17, 28, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x + 34, self.y + 17, 28, x, y, w, h)
  )
end

function QuintCellLauncher:doCheckCollision(x, y, r)
  local r2 = math.pow(28 + r, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - (self.y - 17), 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - (self.y + 17), 2) <= r2)
    or
    (math.pow(x - (self.x + 34), 2) + math.pow(y - (self.y - 17), 2) <= r2)
    or
    (math.pow(x - (self.x + 34), 2) + math.pow(y - (self.y + 17), 2) <= r2)
    or
    (math.pow(x - (self.x + 17), 2) + math.pow(y - self.y, 2) <= r2)
  )
end

function QuintCellLauncher:canFire()
  return self.x + 40 <= self.world.w
end

function QuintCellLauncher:fireMachineGun()
  self:fireBullet({offsetY = -15, damage = 25, speed = 300})
  self:fireBullet({offsetY = 15, damage = 25, speed = 300})
  self:fireBullet({offsetX = 30, offsetY = -30, damage = 25, speed = 300})
  self:fireBullet({offsetX = 30, offsetY = 30, damage = 25, speed = 300})
end

function QuintCellLauncher:fireGuidedMissile()
  self:fireGenericMissile({
    class = GuidedMissile,
    offsetX = 14,
    offsetY = 0,
    damage = 160,
  })
end

return QuintCellLauncher
