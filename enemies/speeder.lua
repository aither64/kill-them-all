local Enemy = require '../enemy'
local Speeder = Enemy:new()

Speeder.hints = {
  spacing = 40
}

function Speeder:new(opts)
  local t = Enemy.new(self, opts)
  t.hitpoints = 100
  t.speed = 400
  t.value = 200
  t.cost = 10000
  t.lastshot = t:getGameTime()
  t:init()
  return t
end

function Speeder:update(dt)
  Enemy.update(self, dt)

  if self:canFire() then
    self:fire()
  end
end

function Speeder:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.enemies.Speeder.color)
  love.graphics.circle('fill', 0, 0, 13)
  love.graphics.circle('line', 0, 0, 15)
  love.graphics.circle('line', 0, 0, 16)

  love.graphics.pop()
end

function Speeder:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function Speeder:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function Speeder:checkCollisionWithRectangle(x, y, w, h)
  return self:checkCollisionCircleRectangle(self.x, self.y, 16, x, y, w, h)
end

function Speeder:doCheckCollision(x, y, r)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(16 + r, 2)
end

function Speeder:canFire()
  now = self:getGameTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 1 < now
end

function Speeder:fire()
  self.firstshot = false
  self:fireBullet({
    damage = 30,
    speed = 600,
    angle = self:calcAngleToPlayer(0, 0)
  })
  self.lastshot = self:getGameTime()
end

return Speeder
