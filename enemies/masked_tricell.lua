local Enemy = require '../enemy'
local MaskedTriCell = Enemy:new()

MaskedTriCell.hints = {
  spacing = 80
}

function MaskedTriCell:new(opts)
  local t = Enemy.new(self, opts)
  t.lastshot = love.timer.getTime()
  t.speed = 120
  t.hitpoints = 2000
  t.value = 400
  return t
end

function MaskedTriCell:update(dt)
  Enemy.update(self, dt)
end

function MaskedTriCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(6, 6, 6, 255)
  love.graphics.circle('fill', 0, -15, 18)
  love.graphics.circle('fill', 0, 15, 18)
  love.graphics.circle('fill', -15, 0, 18)

  love.graphics.setColor(32, 26, 22, 255)
  love.graphics.circle('line', 0, -15, 20)
  love.graphics.circle('line', 0, -15, 21)
  love.graphics.circle('line', 0, -15, 22)
  love.graphics.circle('line', 0, 15, 20)
  love.graphics.circle('line', 0, 15, 21)
  love.graphics.circle('line', 0, 15, 22)
  love.graphics.circle('line', -15, 0, 20)
  love.graphics.circle('line', -15, 0, 21)
  love.graphics.circle('line', -15, 0, 22)

  love.graphics.pop()
end

function MaskedTriCell:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function MaskedTriCell:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function MaskedTriCell:doCheckCollision(x, y, r)
  local r2 = math.pow(22 + r, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - (self.y - 15), 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - (self.y + 15), 2) <= r2)
    or
    (math.pow(x - self.x - 15, 2) + math.pow(y - self.y, 2) <= r2)
  )
end

return MaskedTriCell
