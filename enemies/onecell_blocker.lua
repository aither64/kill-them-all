local Enemy = require '../enemy'
local OneCellBlocker = Enemy:new()

OneCellBlocker.hints = {
  spacing = 50
}

function OneCellBlocker:new(opts)
  local t = Enemy.new(self, opts)
  t.hitpoints = 1000
  t.speed = 50
  t.value = 100
  t:setVelocity(t.speed, math.pi)
  return t
end

function OneCellBlocker:update(dt)
  Enemy.update(self, dt)
end

function OneCellBlocker:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(176, 111, 26, 255)

  for r = 1,22,3 do
    love.graphics.circle('line', 0, 0, r)
  end

  love.graphics.pop()
end

function OneCellBlocker:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function OneCellBlocker:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function OneCellBlocker:doCheckCollision(x, y, r)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(22 + r, 2)
end

return OneCellBlocker
