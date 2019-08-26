local Projectile = require '../projectile'
local Bullet = Projectile:new()

function Bullet:new(world, x, y, lethal, direction, speed)
  t = Projectile.new(self, world, x, y)
  t.direction = direction
  t.speed = speed
  t.lethal = lethal
  return t
end

function Bullet:update(dt)
  self.x = self.x + self.direction * self.speed * dt
end

function Bullet:draw()
  love.graphics.setColor(249, 255, 64, 255)
  love.graphics.line(self.x, self.y, self.x - 10, self.y)
end

return Bullet
