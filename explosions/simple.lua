local Explosion = require '../explosion'
local Simple = Explosion:new()

function Simple:new(opts)
  local t = Explosion.new(self, opts)
  t.collisionType = 'circle'
  t:setDrawColor(0.0)
  return t
end

function Simple:update(dt)
  self.r = self.r + self.speed * dt

  -- 100% ... maxSize
  -- x%   ... r
  -- x / 100 = r / maxSize
  -- x = (r / maxSize) * 100
  local progress = self.r / self.maxSize

  self:setDrawColor(progress)
  self.damage = self.startDamage * (1.0 - progress * self.fadeFactor)
end

function Simple:draw()
  local r, g, b = unpack(self.drawColor)

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

function Simple:setDrawColor(progress)
  local r, g, b = unpack(self:getColor())

  -- fadeFactor%  ... color
  -- progress%    ... newColor
  -- progress / fadeFactor = newColor / color
  -- newColor = (progress / fadeFactor) * color
  self.drawColor = {
    r * (1.0 - progress * self.fadeFactor),
    g * (1.0 - progress * self.fadeFactor),
    b * (1.0 - progress * self.fadeFactor),
  }
end

function Simple:getColor()
  if self.color then
    return self.color
  end

  return stylesheet.explosions.Simple.color[self.lethal]
end

return Simple
