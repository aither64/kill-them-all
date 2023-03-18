local PowerUp = require '../powerup'
local Missile = PowerUp:new(nil, 0, 0, nil)

function Missile:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'missile'
  t.class = Missile
  t.stacksize = 2
  t.duration = 60
  return t
end

function Missile:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.Missile.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.Missile.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('M', -5, -6)

  love.graphics.pop()
end

function Missile:stacked(pos, stacksize)
  self:extendBy(40)
end

return Missile
