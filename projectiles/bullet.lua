local Projectile = require '../projectile'
local Bullet = Projectile:new()

function Bullet:new(opts)
  local t = Projectile.new(self, opts)
  t.collisionType = 'point'
  t.color = opts.color
  t.x1 = t.x
  t.y1 = t.y
  t.x2 = t.x + math.cos(t.angle) * 10
  t.y2 = t.y + math.sin(t.angle) * 10
  return t
end

function Bullet:update(dt)
  self.x1 = self.x1 + self.velocity.x * dt
  self.y1 = self.y1 + self.velocity.y * dt
  self.x2 = self.x2 + self.velocity.x * dt
  self.y2 = self.y2 + self.velocity.y * dt
  self.x = self.x1
  self.y = self.y1
end

function Bullet:draw()
  local r, g, b = self:getColor()
  love.graphics.setColor(r, g, b, 255)
  love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

function Bullet:redirect(angle)
  Projectile.redirect(self, angle)
  self.x2 = self.x1 + math.cos(self.angle) * 10
  self.y2 = self.y1 + math.sin(self.angle) * 10
end

function Bullet:isOut()
  local w = self.world.w
  local h = self.world.h
  local xOut = (self.x1 < 0 and self.x2 < 0) or (self.x1 > w and self.x2 > w)
  local yOut = (self.y1 < 0 and self.y2 < 0) or (self.y1 > h and self.y2 > h)
  return xOut or yOut
end

function Bullet:getColor()
  if self.color then
    return self.color
  end

  local r, g, b, a = unpack(stylesheet.projectiles.Bullet.baseColor)

  g = g - ((self.damage * 3) / 255)
  b = b - (self.damage / 255)

  if b < 0 then
    b = 0
  end

  if g < 0 then
    g = 0
  end

  return r, g, b
end

return Bullet
