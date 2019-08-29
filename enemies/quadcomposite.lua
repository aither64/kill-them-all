local Enemy = require '../enemy'
local QuadComposite = Enemy:new(nil, 0, 0)

function QuadComposite:new(world, x, y)
  local t = Enemy.new(self, world, x, y)
  t.lastshot = love.timer.getTime()
  t.speed = 10
  t.hitpoints = 5000
  t.value = 1000
  return t
end

function QuadComposite:update(dt)
  if self.x > (self.world.w - self.world.w / 6) then
    self.x = self.x - self.speed * dt
  end

  if self:canFire() then
    self:fire()
  end
end

function QuadComposite:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 66, 66, 255)
  love.graphics.circle('line', 0, 0, 80)
  love.graphics.circle('line', 0, 0, 79)

  love.graphics.setColor(250, 122, 30, 255)
  love.graphics.circle('fill', -25, 25, 30)
  love.graphics.circle('fill', 25, 25, 30)
  love.graphics.circle('fill', -25, -25, 30)
  love.graphics.circle('fill', 25, -25, 30)

  love.graphics.setColor(201, 84, 0, 255)
  love.graphics.circle('line', -25, 25, 32)
  love.graphics.circle('line', 25, 25, 32)
  love.graphics.circle('line', -25, -25, 32)
  love.graphics.circle('line', 25, -25, 32)

  love.graphics.pop()
end

function QuadComposite:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function QuadComposite:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function QuadComposite:doCheckCollision(x, y, r)
  local r2 = math.pow(80 + r, 2)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= r2
end

function QuadComposite:canFire()
  now = love.timer.getTime()
  return (self.firstshot and self.x <= self.world.w) or self.lastshot + 1.5 < now
end

function QuadComposite:fire()
  self.firstshot = false

  self:fireBulletAtAngleFrom(-25, 25)
  self:fireBulletAtAngleFrom(25, 25)
  self:fireBulletAtAngleFrom(-25, -25)
  self:fireBulletAtAngleFrom(25, -25)

  self.lastshot = love.timer.getTime()
end

function QuadComposite:fireBulletAtAngleFrom(offsetX, offsetY)
  local angle = math.atan2(
    self.world.player.y - self.y + offsetY,
    self.world.player.x - self.x + offsetX
  )

  self:fireBullet({
    offsetX = offsetX,
    offsetY = offsetY,
    damage = 20,
    speed = 300,
    angle = angle
  })
end

return QuadComposite
