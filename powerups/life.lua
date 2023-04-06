local PowerUp = require '../powerup'
local Life = PowerUp:new(nil, 0, 0, nil)

function Life:new(world, x, y, target)
  local t = PowerUp.new(self, world, x, y, target)
  t.name = 'life'
  t.class = Life
  t.stacksize = 1
  t.duration = 1
  t.lifes = 1
  return t
end

function Life:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.Life.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.Life.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('L', -3, -6)

  love.graphics.pop()
end

return Life
