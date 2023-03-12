local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local TwinCell = Enemy:new()

TwinCell.hints = {
  spacing = 60
}

function TwinCell:new(opts)
  local t = Enemy.new(self, opts)
  t.lastshot = t:getGameTime()
  t.hitpoints = 75
  t.value = 20
  t:setVelocity(t.speed, math.pi)
  return t
end

function TwinCell:update(dt)
  Enemy.update(self, dt)

  if self:canFire() then
    self:fire()
  end
end

function TwinCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.enemies.TwinCell.bgColor)
  love.graphics.circle('fill', 0, -10, 18)
  love.graphics.circle('fill', 0, 10, 18)

  love.graphics.setColor(stylesheet.enemies.TwinCell.lineColor)
  love.graphics.circle('line', 0, -10, 20)
  love.graphics.circle('line', 0, -10, 21)
  love.graphics.circle('line', 0, -10, 22)
  love.graphics.circle('line', 0, 10, 20)
  love.graphics.circle('line', 0, 10, 21)
  love.graphics.circle('line', 0, 10, 22)

  love.graphics.pop()
end

function TwinCell:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function TwinCell:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function TwinCell:checkCollisionWithRectangle(x, y, w, h)
  return (
    self:checkCollisionCircleRectangle(self.x, self.y - 10, 22, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x, self.y + 10, 22, x, y, w, h)
  )
end

function TwinCell:doCheckCollision(x, y, r)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - (self.y - 10), 2) <= math.pow(22 + r, 2))
    or
    (math.pow(x - self.x, 2) + math.pow(y - (self.y + 10), 2) <= math.pow(22 + r, 2))
  )
end

function TwinCell:canFire()
  now = self:getGameTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 2 < now
end

function TwinCell:fire()
  self.firstshot = false
  self:fireBullet({offsetY = -10, damage = 15})
  self:fireBullet({offsetY = 10, damage = 15})
  self.lastshot = self:getGameTime()
end

return TwinCell
