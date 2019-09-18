local PowerUp = require '../powerup'
local Firewall = PowerUp:new(nil, 0, 0, nil)

function Firewall:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'firewall'
  t.stacksize = 1
  t.duration = 1
  t.lifes = 1
  return t
end

function Firewall:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)
  love.graphics.setColor(0, 0, 0, 255)

  love.graphics.setFont(self.font)
  love.graphics.print('W', -5, -6)

  love.graphics.pop()
end

return Firewall