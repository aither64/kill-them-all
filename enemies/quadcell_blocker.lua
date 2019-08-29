local Enemy = require '../enemy'
local QuadCellBlocker = Enemy:new(nil, 0, 0)

function QuadCellBlocker:new(world, x, y)
  local t = Enemy.new(self, world, x, y)
  t.lastshot = love.timer.getTime()
  t.speed = 40
  t.hitpoints = 6000
  t.value = 600
  return t
end

function QuadCellBlocker:update(dt)
  Enemy.update(self, dt)
end

function QuadCellBlocker:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(176, 111, 26, 255)

  for r = 1,40,3 do
    love.graphics.circle('line', 0, -30, r)
    love.graphics.circle('line', 0, 40, r)
    love.graphics.circle('line', 40, -70, r)
    love.graphics.circle('line', 40, 70, r)
  end

  love.graphics.pop()
end

function QuadCellBlocker:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function QuadCellBlocker:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function QuadCellBlocker:doCheckCollision(x, y, r)
  local r2 = math.pow(40 + r, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - self.y - 15, 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - self.y + 15, 2) <= r2)
    or
    (math.pow(x - self.x - 15, 2) + math.pow(y - self.y - 30, 2) <= r2)
    or
    (math.pow(x - self.x + 15, 2) + math.pow(y - self.y + 30, 2) <= r2)
  )
end

return QuadCellBlocker