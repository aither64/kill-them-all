local PowerUp = require '../powerup'
local MachineGun = PowerUp:new(nil, 0, 0, nil)

function MachineGun:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'machinegun'
  t.stacksize = 10
  t.duration = 60
  return t
end

function MachineGun:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(148, 154, 156, 255)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)
  love.graphics.setColor(0, 0, 0, 255)

  love.graphics.setFont(self.font)
  love.graphics.print('M', -5, -6)

  love.graphics.pop()
end

function MachineGun:stacked(pos, stacksize)
  self:extendBy(20)
end

return MachineGun
