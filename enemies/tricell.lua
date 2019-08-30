local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local TriCell = Enemy:new()

TriCell.hints = {
  spacing = 70
}

function TriCell:new(opts)
  local t = Enemy.new(self, opts)
  t.lastshot = love.timer.getTime()
  t.speed = 90
  t.hitpoints = 200
  t.value = 50
  return t
end

function TriCell:update(dt)
  Enemy.update(self, dt)

  if self:canFire() then
    self:fire()
  end
end

function TriCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(163, 0, 0, 255)
  love.graphics.circle('fill', 0, -15, 18)
  love.graphics.circle('fill', 0, 15, 18)
  love.graphics.circle('fill', -15, 0, 18)

  love.graphics.setColor(240, 144, 0, 255)
  love.graphics.circle('line', 0, -15, 20)
  love.graphics.circle('line', 0, -15, 21)
  love.graphics.circle('line', 0, -15, 22)
  love.graphics.circle('line', 0, 15, 20)
  love.graphics.circle('line', 0, 15, 21)
  love.graphics.circle('line', 0, 15, 22)
  love.graphics.circle('line', -15, 0, 20)
  love.graphics.circle('line', -15, 0, 21)
  love.graphics.circle('line', -15, 0, 22)

  love.graphics.pop()
end

function TriCell:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function TriCell:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function TriCell:doCheckCollision(x, y, r)
  local r2 = math.pow(22 + r, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - self.y - 15, 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - self.y + 15, 2) <= r2)
    or
    (math.pow(x - self.x - 15, 2) + math.pow(y - self.y, 2) <= r2)
  )
end

function TriCell:canFire()
  now = love.timer.getTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 1.5 < now
end

function TriCell:fire()
  self.firstshot = false
  self:fireBullet({offsetY = -15, damage = 20, speed = 300})
  self:fireBullet({offsetY = 15, damage = 20, speed = 300})
  self:fireBullet({offsetX = -15, damage = 20, speed = 300})
  self.lastshot = love.timer.getTime()
end

return TriCell
