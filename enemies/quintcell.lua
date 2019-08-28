local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local QuintCell = Enemy:new(nil, 0, 0)

function QuintCell:new(world, x, y)
  t = Enemy.new(self, world, x, y)
  t.lastshot = love.timer.getTime()
  t.speed = 50
  t.hitpoints = 600
  t.value = 150
  return t
end

function QuintCell:update(dt)
  Enemy.update(self, dt)

  if self:canFire() then
    self:fire()
  end
end

function QuintCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(163, 0, 0, 255)
  love.graphics.circle('fill', 0, -15, 18)
  love.graphics.circle('fill', 0, 15, 18)
  love.graphics.circle('fill', 30, -15, 18)
  love.graphics.circle('fill', 30, 15, 18)

  love.graphics.setColor(240, 144, 0, 255)
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

  love.graphics.setColor(163, 0, 0, 255)
  love.graphics.circle('fill', 14, 0, 18)
  love.graphics.setColor(240, 144, 0, 255)
  love.graphics.circle('line', 14, 0, 20)
  love.graphics.circle('line', 14, 0, 21)
  love.graphics.circle('line', 14, 0, 22)

  love.graphics.pop()
end

function QuintCell:checkCollisionWith(x, y)
  local r2 = math.pow(22, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - self.y - 15, 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - self.y + 15, 2) <= r2)
    or
    (math.pow(x - self.x + 30, 2) + math.pow(y - self.y - 15, 2) <= r2)
    or
    (math.pow(x - self.x + 30, 2) + math.pow(y - self.y + 15, 2) <= r2)
    or
    (math.pow(x - self.x + 14, 2) + math.pow(y - self.y, 2) <= r2)
  )
end

function QuintCell:canFire()
  now = love.timer.getTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 1.5 < now
end

function QuintCell:fire()
  self.firstshot = false
  self:fireBullet({offsetY = -15, damage = 25, speed = 300})
  self:fireBullet({offsetY = 15, damage = 25, speed = 300})
  self:fireBullet({offsetX = 30, offsetY = -30, damage = 25, speed = 300})
  self:fireBullet({offsetX = 30, offsetY = 30, damage = 25, speed = 300})

  local angle = math.atan2(self.world.player.y - self.y, self.world.player.x - self.x)
  self:fireBullet({offsetX = 14, offsetY = 0, damage = 35, speed = 400, angle = angle})

  self.lastshot = love.timer.getTime()
end

return QuintCell
