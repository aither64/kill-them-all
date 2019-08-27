local PowerUp = require '../powerup'
local Shotgun = PowerUp:new(nil, 0, 0, nil)

function Shotgun:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'shotgun'
  t.stacksize = 5
  t.duration = 30
  return t
end

function Shotgun:update(dt)
  if not self.active then
    self.x = self.x - 100 * dt
  end
end

function Shotgun:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(148, 154, 156, 255)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print('G', -4, -6)

  love.graphics.pop()
end

return Shotgun
