local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local OneCell = Enemy:new(nil, 0, 0)

function OneCell:new(world, x, y)
  local t = Enemy.new(self, world, x, y)
  t.hitpoints = 20
  t.lastshot = love.timer.getTime()
  return t
end

function OneCell:update(dt)
  Enemy.update(self, dt)

  if self:canFire() then
    self:fire()
  end
end

function OneCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.circle('fill', 0, 0, 18)
  love.graphics.circle('line', 0, 0, 20)
  love.graphics.circle('line', 0, 0, 21)
  love.graphics.circle('line', 0, 0, 22)

  love.graphics.pop()
end

function OneCell:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function OneCell:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function OneCell:doCheckCollision(x, y, r)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(22 + r, 2)
end

function OneCell:canFire()
  now = love.timer.getTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 4 < now
end

function OneCell:fire()
  self.firstshot = false
  self:fireBullet()
  self.lastshot = love.timer.getTime()
end

return OneCell
