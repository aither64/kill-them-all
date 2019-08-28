local PowerUp = require '../powerup'
local Cannon = PowerUp:new(nil, 0, 0, nil)

function Cannon:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'cannon'
  t.stacksize = 7
  t.duration = 60
  return t
end

function Cannon:update(dt)
  if not self.active then
    self.x = self.x - 100 * dt
  end
end

function Cannon:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(148, 154, 156, 255)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print('G', -5, -6)

  love.graphics.pop()
end

function Cannon:stacked(pos, stacksize)
  self:extendBy(20)
end

return Cannon
