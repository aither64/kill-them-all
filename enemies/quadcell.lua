local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local QuadCell = Enemy:new()

QuadCell.hints = {
  spacing = 80
}

function QuadCell:new(opts)
  local t = Enemy.new(self, opts)
  t.lastshot = t:getGameTime()
  t.speed = 70
  t.hitpoints = 400
  t.value = 100
  return t
end

function QuadCell:update(dt)
  Enemy.update(self, dt)

  if self:canFire() then
    self:fire()
  end
end

function QuadCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(163, 0, 0, 255)
  love.graphics.circle('fill', 0, -15, 18)
  love.graphics.circle('fill', 0, 15, 18)
  love.graphics.circle('fill', 15, -30, 18)
  love.graphics.circle('fill', 15, 30, 18)

  love.graphics.setColor(240, 144, 0, 255)
  love.graphics.circle('line', 0, -15, 20)
  love.graphics.circle('line', 0, -15, 21)
  love.graphics.circle('line', 0, -15, 22)
  love.graphics.circle('line', 0, 15, 20)
  love.graphics.circle('line', 0, 15, 21)
  love.graphics.circle('line', 0, 15, 22)
  love.graphics.circle('line', 15, -30, 20)
  love.graphics.circle('line', 15, -30, 21)
  love.graphics.circle('line', 15, -30, 22)
  love.graphics.circle('line', 15, 30, 20)
  love.graphics.circle('line', 15, 30, 21)
  love.graphics.circle('line', 15, 30, 22)

  love.graphics.pop()
end

function QuadCell:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function QuadCell:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function QuadCell:doCheckCollision(x, y, r)
  local r2 = math.pow(22 + r, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - (self.y - 15), 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - (self.y + 15), 2) <= r2)
    or
    (math.pow(x - (self.x - 15), 2) + math.pow(y - (self.y - 30), 2) <= r2)
    or
    (math.pow(x - (self.x + 15), 2) + math.pow(y - (self.y + 30), 2) <= r2)
  )
end

function QuadCell:canFire()
  now = self:getGameTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 1.5 < now
end

function QuadCell:fire()
  self.firstshot = false
  self:fireBullet({offsetY = -15, damage = 20, speed = 300})
  self:fireBullet({offsetY = 15, damage = 20, speed = 300})
  self:fireBullet({offsetX = 15, offsetY = -30, damage = 20, speed = 300})
  self:fireBullet({offsetX = 15, offsetY = 30, damage = 20, speed = 300})
  self.lastshot = self:getGameTime()
end

return QuadCell
