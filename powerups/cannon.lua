local PowerUp = require '../powerup'
local Cannon = PowerUp:new()

function Cannon:new(opts)
  local t = PowerUp.new(self, opts)
  t.name = 'cannon'
  t.class = Cannon
  t.stacksize = 4
  t.duration = 60
  return t
end

function Cannon:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.Cannon.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.Cannon.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('C', -5, -6)

  love.graphics.pop()
end

function Cannon:stacked(pos, stacksize)
  self:extendBy(20)
end

return Cannon
