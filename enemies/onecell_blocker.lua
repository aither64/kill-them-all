local Enemy = require '../enemy'
local OneCellBlocker = Enemy:new(nil, 0, 0)

function OneCellBlocker:new(world, x, y)
  t = Enemy.new(self, world, x, y)
  t.hitpoints = 1000
  t.speed = 50
  t.value = 100
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

function OneCellBlocker:checkCollisionWith(x, y)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(22, 2)
end

return OneCellBlocker
