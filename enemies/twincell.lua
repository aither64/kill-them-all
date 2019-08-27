local Enemy = require '../enemy'
local Bullet = require '../projectiles/bullet'
local TwinCell = Enemy:new(nil, 0, 0)

function TwinCell:new(world, x, y)
  t = Enemy.new(self, world, x, y)
  t.lastshot = love.timer.getTime()
  t.hitpoints = 40
  return t
end

function TwinCell:update(dt)
  Enemy.update(self, dt)

  now = love.timer.getTime()
  if self.lastshot + 2 < now then
    self.world:addProjectile(Bullet:new(
      self.world,
      self.x,
      self.y-10,
      'player',
      10,
      math.pi,
      200
    ))
    self.world:addProjectile(Bullet:new(
      self.world,
      self.x,
      self.y+10,
      'player',
      10,
      math.pi,
      200
    ))

    self.lastshot = now
  end
end

function TwinCell:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(196, 0, 0, 255)
  love.graphics.circle('fill', 0, -10, 18)
  love.graphics.circle('fill', 0, 10, 18)

  love.graphics.setColor(255, 79, 15, 255)
  love.graphics.circle('line', 0, -10, 20)
  love.graphics.circle('line', 0, -10, 21)
  love.graphics.circle('line', 0, -10, 22)
  love.graphics.circle('line', 0, 10, 20)
  love.graphics.circle('line', 0, 10, 21)
  love.graphics.circle('line', 0, 10, 22)

  love.graphics.pop()
end

function TwinCell:checkCollisionWith(x, y)
  return (
    (math.pow(x - self.x, 2) + math.pow(y - self.y - 10, 2) <= math.pow(22, 2))
    or
    (math.pow(x - self.x, 2) + math.pow(y - self.y + 10, 2) <= math.pow(22, 2))
  )
end

return TwinCell
