local PowerUp = require '../powerup'
local QuadDamage = PowerUp:new()

function QuadDamage:new(opts)
  local t = PowerUp.new(self, opts)
  t.name = 'quaddamage'
  t.class = QuadDamage
  t.stacksize = 1
  t.duration = 6
  return t
end

function QuadDamage:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.QuadDamage.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.QuadDamage.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('Q', -5, -7)

  love.graphics.pop()
end

function QuadDamage:stacked(pos, stacksize)
  self:extendBy(5)
end

return QuadDamage
