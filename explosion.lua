local WorldEntity = require 'world_entity'
local Explosion = WorldEntity:new()

function Explosion:new(opts)
  local t = WorldEntity.new(self, opts)

  if opts then
    t.owner = opts.owner
    t.startX = opts.x
    t.startY = opts.y
    t.x = opts.x
    t.y = opts.y
    t.lethal = opts.lethal or 'all'
    t.damage = opts.damage or 1000
    t.speed = opts.speed or 400
    t.startSize = opts.startSize or 10
    t.maxSize = opts.maxSize or 400
    t.r = t.startSize
    t.color = opts.color
  end

  return t
end

function Explosion:isDone()
  return self.r >= self.maxSize
end

function Explosion:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function Explosion:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function Explosion:doCheckCollision(x, y, r)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(self.r + r, 2)
end

return Explosion
