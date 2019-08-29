local PowerUp = require '../powerup'
local QuadDamage = PowerUp:new(nil, 0, 0, nil)

function QuadDamage:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'quaddamage'
  t.stacksize = 1
  t.duration = 10
  return t
end

function QuadDamage:update(dt)
  if not self.active then
    self.x = self.x - 100 * dt
  end
end

function QuadDamage:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(88, 247, 59, 255)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)
  love.graphics.setColor(0, 0, 0, 255)

  love.graphics.setFont(self.font)
  love.graphics.print('Q', -5, -7)

  love.graphics.pop()
end

function QuadDamage:stacked(pos, stacksize)
  self:extendBy(5)
end

return QuadDamage
