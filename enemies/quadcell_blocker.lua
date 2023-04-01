local Enemy = require '../enemy'
local QuadCellBlocker = Enemy:new()

QuadCellBlocker.hints = {
  spacing = 160
}

function QuadCellBlocker:new(opts)
  local t = Enemy.new(self, opts)
  t.lastshot = t:getGameTime()
  t.speed = 40
  t.hitpoints = 6000
  t.value = 600
  t:init()
  return t
end

function QuadCellBlocker:update(dt)
  Enemy.update(self, dt)
end

function QuadCellBlocker:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.enemies.QuadCellBlocker.color)

  for r = 1,40,3 do
    love.graphics.circle('line', 0, -40, r)
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

function QuadCellBlocker:checkCollisionWithRectangle(x, y, w, h)
  return (
    self:checkCollisionCircleRectangle(self.x, self.y - 15, 40, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x, self.y + 15, 40, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x + 15, self.y - 30, 40, x, y, w, h)
    or
    self:checkCollisionCircleRectangle(self.x + 15, self.y + 30, 40, x, y, w, h)
  )
end

function QuadCellBlocker:doCheckCollision(x, y, r)
  local r2 = math.pow(40 + r, 2)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - (self.y - 40), 2) <= r2)
    or
    (math.pow(x - self.x, 2) + math.pow(y - (self.y + 40), 2) <= r2)
    or
    (math.pow(x - (self.x + 40), 2) + math.pow(y - (self.y - 70), 2) <= r2)
    or
    (math.pow(x - (self.x + 40), 2) + math.pow(y - (self.y + 70), 2) <= r2)
  )
end

return QuadCellBlocker
