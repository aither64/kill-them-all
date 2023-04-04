local Enemy = require '../enemy'
local Armament = require "armament"
local QuintCell = Enemy:new()

QuintCell.hints = {
  spacing = 80
}

function QuintCell:new(opts)
  local t = Enemy.new(self, opts)
  t.armament = Armament:new()
  t.armament:add('machinegun', {
    frequency = 1.5,
    fire = function() t:fireMachineGun() end
  })
  t.armament:add('cannon', {
    frequency = 1.5,
    fire = function() t:fireCannon() end
  })
  t.speed = 50
  t.hitpoints = 800
  t.value = 200
  t:init()
  return t
end

function QuintCell:update(dt)
  Enemy.update(self, dt)
  self.armament:fireAll(self:getGameTime())
end

function QuintCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.enemies.QuintCell.quadBgColor)
  love.graphics.circle('fill', 0, -15, 18)
  love.graphics.circle('fill', 0, 15, 18)
  love.graphics.circle('fill', 30, -15, 18)
  love.graphics.circle('fill', 30, 15, 18)

  love.graphics.setColor(stylesheet.enemies.QuintCell.quadLineColor)
  love.graphics.circle('line', 0, -15, 20)
  love.graphics.circle('line', 0, -15, 21)
  love.graphics.circle('line', 0, -15, 22)
  love.graphics.circle('line', 0, 15, 20)
  love.graphics.circle('line', 0, 15, 21)
  love.graphics.circle('line', 0, 15, 22)
  love.graphics.circle('line', 30, -15, 20)
  love.graphics.circle('line', 30, -15, 21)
  love.graphics.circle('line', 30, -15, 22)
  love.graphics.circle('line', 30, 15, 20)
  love.graphics.circle('line', 30, 15, 21)
  love.graphics.circle('line', 30, 15, 22)

  love.graphics.setColor(stylesheet.enemies.QuintCell.towerBgColor)
  love.graphics.circle('fill', 14, 0, 18)
  love.graphics.setColor(stylesheet.enemies.QuintCell.towerLineColor)
  love.graphics.circle('line', 14, 0, 20)
  love.graphics.circle('line', 14, 0, 21)
  love.graphics.circle('line', 14, 0, 22)

  love.graphics.pop()
end

function QuintCell:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function QuintCell:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function QuintCell:checkCollisionWithRectangle(x, y, w, h)
  return (
    self:checkCollisionCircleRectangle(self.x, self.y - 15, 22, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x, self.y + 15, 22, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x + 30, self.y - 15, 22, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x + 30, self.y + 15, 22, x, y, w, h)
  )
end

function QuintCell:doCheckCollision(x, y, r)
  local r2 = math.pow(22 + r, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - (self.y - 15), 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - (self.y + 15), 2) <= r2)
    or
    (math.pow(x - (self.x + 30), 2) + math.pow(y - (self.y - 15), 2) <= r2)
    or
    (math.pow(x - (self.x + 30), 2) + math.pow(y - (self.y + 15), 2) <= r2)
    or
    (math.pow(x - (self.x + 14), 2) + math.pow(y - self.y, 2) <= r2)
  )
end

function QuintCell:canFire()
  return (self.firstshot and self.x <= self.world.w) or true
end

function QuintCell:fireMachineGun()
  self.firstshot = false
  self:fireBullet({offsetY = -15, damage = 25, speed = 300})
  self:fireBullet({offsetY = 15, damage = 25, speed = 300})
  self:fireBullet({offsetX = 30, offsetY = -30, damage = 25, speed = 300})
  self:fireBullet({offsetX = 30, offsetY = 30, damage = 25, speed = 300})
end

function QuintCell:fireCannon()
  self.firstshot = false

  self:fireShell({
    offsetX = 14,
    offsetY = 0,
    damage = 80,
    speed = 400,
    angle = self:calcAngleToPlayer(0, 0),
  })
end

return QuintCell
