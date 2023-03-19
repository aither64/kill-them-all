local PowerUp = require '../powerup'
local GuidedMissile = PowerUp:new(nil, 0, 0, nil)

function GuidedMissile:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'guided_missile'
  t.class = GuidedMissile
  t.stacksize = 3
  t.duration = 60
  return t
end

function GuidedMissile:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.GuidedMissile.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.GuidedMissile.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('G', -5, -6)

  love.graphics.pop()
end

function GuidedMissile:stacked(pos, stacksize)
  self:extendBy(20)
end

return GuidedMissile
