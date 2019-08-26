local Enemy = require '../enemy'
local OneCell = Enemy:new(nil, 0, 0)

function OneCell:respawn()
  Enemy.respawn(self)
end

function OneCell:update(dt)
  Enemy.update(self, dt)
end

function OneCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.circle('fill', 0, 0, 18)
  love.graphics.circle('line', 0, 0, 20)
  love.graphics.circle('line', 0, 0, 21)
  love.graphics.circle('line', 0, 0, 22)

  love.graphics.pop()
end

function OneCell:checkCollisionWith(x, y)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(22, 2)
end

return OneCell
