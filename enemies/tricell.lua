local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local TriCell = Enemy:new(nil, 0, 0)

function TriCell:new(world, x, y)
  t = Enemy.new(self, world, x, y)
  t.lastshot = love.timer.getTime()
  t.speed = 90
  t.hitpoints = 120
  return t
end

function TriCell:update(dt)
  Enemy.update(self, dt)

  now = love.timer.getTime()

  if self.lastshot + 1.5 < now then
    self:fireBullet({offsetY = -15, damage = 20, speed = 300})
    self:fireBullet({offsetY = 15, damage = 20, speed = 300})
    self:fireBullet({offsetX = -15, damage = 20, speed = 300})
    self.lastshot = now
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

function TriCell:checkCollisionWith(x, y)
  local r2 = math.pow(22, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - self.y - 15, 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - self.y + 15, 2) <= r2)
    or
    (math.pow(x - self.x - 15, 2) + math.pow(y - self.y, 2) <= r2)
  )
end

return TriCell
