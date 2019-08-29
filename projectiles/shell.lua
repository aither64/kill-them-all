local Projectile = require '../projectile'
local Shell = Projectile:new()

function Shell:new(opts)
  t = Projectile.new(self, opts)
  t.collisionType = 'circle'
  t.r = opts.r or 3
  t.color = opts.color
  return t
end

function Shell:update(dt)
  self.x = self.x + math.cos(self.angle) * self.speed * dt
  self.y = self.y + math.sin(self.angle) * self.speed * dt
end

function Shell:draw()
  local r, g, b = self:getColor()
  love.graphics.setColor(r, g, b, 255)
  love.graphics.circle('fill', self.x, self.y, self.r)
end

function Shell:isOut()
  local w = self.world.w
  local h = self.world.h
  local xOut = self.x + self.r < 0 or self.x - self.r > w
  local yOut = self.y + self.r < 0 or self.y - self.r > h
  return xOut or yOut
end

function Shell:getColor()
  if self.color then
    return self.color[1], self.color[2], self.color[3]
  end

  return 255, 255, 224
end

return Shell