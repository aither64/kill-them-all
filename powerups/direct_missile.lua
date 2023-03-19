local PowerUp = require '../powerup'
local DirectMissile = PowerUp:new(nil, 0, 0, nil)

function DirectMissile:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'direct_missile'
  t.class = DirectMissile
  t.stacksize = 3
  t.duration = 60
  return t
end

function DirectMissile:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.DirectMissile.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.DirectMissile.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('M', -5, -6)

  love.graphics.pop()
end

function DirectMissile:stacked(pos, stacksize)
  self:extendBy(40)
end

return DirectMissile
