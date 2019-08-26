local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local OneCell = Enemy:new(nil, 0, 0)

function OneCell:new(world, x, y)
  t = Enemy.new(self, world, x, y)
  t.lastshot = love.timer.getTime()
  return t
end

function OneCell:update(dt)
  Enemy.update(self, dt)

  now = love.timer.getTime()
  if self.lastshot + 2 < now then
    self.world:addProjectile(Bullet:new(
      self.world,
      self.x,
      self.y,
      'player',
      -1,
      200
    ))

    self.lastshot = now
  end
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
