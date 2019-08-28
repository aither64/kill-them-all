local Projectile = require '../projectile'
local Bullet = Projectile:new()

function Bullet:new(world, x, y, lethal, damage, angle, speed)
  t = Projectile.new(self, world, x, y)
  t.x1 = x
  t.y1 = y
  t.x2 = x + math.cos(angle) * 10
  t.y2 = y + math.sin(angle) * 10
  t.angle = angle
  t.speed = speed
  t.lethal = lethal
  t.damage = damage
  return t
end

function Bullet:update(dt)
  self.x1 = self.x1 + math.cos(self.angle) * self.speed * dt
  self.y1 = self.y1 + math.sin(self.angle) * self.speed * dt
  self.x2 = self.x2 + math.cos(self.angle) * self.speed * dt
  self.y2 = self.y2 + math.sin(self.angle) * self.speed * dt
  self.x = self.x1
  self.y = self.y1
end

function Bullet:draw()
  local r, g, b = self:getColor()
  love.graphics.setColor(r, b, g, 255)
  love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

function Bullet:isOut()
  local w = self.world.w
  local h = self.world.h
  local xOut = (self.x1 < 0 and self.x2 < 0) or (self.x1 > w and self.x2 > w)
  local yOut = (self.y1 < 0 and self.y2 < 0) or (self.y1 > h and self.y2 > h)
  return xOut or yOut
end

function Bullet:getColor()
  local r = 249
  local b = 255 - self.damage * 3
  local g = 64 - self.damage

  if b < 0 then
    b = 0
  end

  if g < 0 then
    g = 0
  end

  return r, g, b
end

return Bullet
