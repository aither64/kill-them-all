local Enemy = {}

function Enemy:new(game, x, y)
  local t = setmetatable({}, { __index = self })
  t.game = game
  t.startX = x
  t.startY = y
  t:respawn()
  return t
end

function Enemy:respawn()
  self.x = self.startX
  self.y = self.startY
  self.speed = 100
end

function Enemy:update(dt)
  self.x = self.x - self.speed * dt

  if self.x + 50 < 0 then
    self:respawn()
  end
end

function Enemy:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.circle('fill', 0, 0, 18)
  love.graphics.circle('line', 0, 0, 20)
  love.graphics.circle('line', 0, 0, 21)
  love.graphics.circle('line', 0, 0, 22)

  love.graphics.pop()
end

function Enemy:checkCollisionWith(x, y)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(22, 2)
end

return Enemy
