local Missile = require '../missile'
local Direct = Missile:new()

function Direct:new(opts)
  t = Missile.new(self, opts)
  t.collisionType = 'circle'
  t.r = opts.r or 6
  t.color = opts.color
  return t
end

function Direct:draw()
  local r, g, b = self:getColor()

  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  local length = 20
  local width = 10

  love.graphics.setColor(r, g, b, 255)
  love.graphics.rotate(self.angle)
  love.graphics.polygon('fill', -length/2, -width/2, -length/2, width /2, length/2, 0)
  -- love.graphics.circle('line', 0, 0, self.r) -- collision debug

  love.graphics.pop()
end

function Direct:isOut()
  local w = self.world.w
  local h = self.world.h
  local xOut = self.x + self.r < 0 or self.x - self.r > w
  local yOut = self.y + self.r < 0 or self.y - self.r > h
  return xOut or yOut
end

function Direct:getColor()
  if self.color then
    return self.color
  end

  return stylesheet.missiles.Direct.baseColor
end

return Direct
