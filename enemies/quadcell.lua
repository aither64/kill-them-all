local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local QuadCell = Enemy:new(nil, 0, 0)

function QuadCell:new(world, x, y)
  t = Enemy.new(self, world, x, y)
  t.lastshot = love.timer.getTime()
  t.speed = 70
  t.hitpoints = 200
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

function QuadCell:checkCollisionWith(x, y)
  local r2 = math.pow(22, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - self.y - 15, 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - self.y + 15, 2) <= r2)
    or
    (math.pow(x - self.x - 15, 2) + math.pow(y - self.y - 30, 2) <= r2)
    or
    (math.pow(x - self.x + 15, 2) + math.pow(y - self.y + 30, 2) <= r2)
  )
end

function QuadCell:canFire()
  now = love.timer.getTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 1.5 < now
end

function QuadCell:fire()
  self.firstshot = false
  self:fireBullet({offsetY = -15, damage = 20, speed = 300})
  self:fireBullet({offsetY = 15, damage = 20, speed = 300})
  self:fireBullet({offsetX = 15, offsetY = -30, damage = 20, speed = 300})
  self:fireBullet({offsetX = 15, offsetY = 30, damage = 20, speed = 300})
  self.lastshot = love.timer.getTime()
end

return QuadCell
