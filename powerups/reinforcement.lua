local PowerUp = require '../powerup'
local Reinforcement = PowerUp:new()

function Reinforcement:new(opts)
  local t = PowerUp.new(self, opts)
  t.name = 'reinforcement'
  t.class = Reinforcement
  t.stacksize = 1
  t.duration = 1
  return t
end

function Reinforcement:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.Reinforcement.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.Reinforcement.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('R', -4, -6)

  love.graphics.pop()
end

return Reinforcement
