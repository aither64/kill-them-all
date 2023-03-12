local Explosion = require '../explosion'
local Simple = Explosion:new()

function Simple:new(opts)
  t = Explosion.new(self, opts)
  t.collisionType = 'circle'
  return t
end

function Simple:update(dt)
  self.r = self.r + self.speed * dt
end

function Simple:draw()
  local r, g, b = unpack(self:getColor())

  -- outer circle
  love.graphics.setColor(r, g, b)
  love.graphics.circle('line', self.x, self.y, self.r)

  -- darker inner circles
  if self.r > 40 then
    r = r * 0.5
    g = g * 0.5
    b = b * 0.5

    love.graphics.setColor(r, g, b)
    love.graphics.circle('line', self.x, self.y, self.r - 40)
  end

  if self.r > 80 then
    r = r * 0.5
    g = g * 0.5
    b = b * 0.5

    love.graphics.setColor(r, g, b)
    love.graphics.circle('line', self.x, self.y, self.r - 80)
  end
end

function Simple:getColor()
  if self.color then
    return self.color
  end

  return stylesheet.explosions.Simple.baseColor
end

return Simple
