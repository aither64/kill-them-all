local WorldEntity = require 'world_entity'
local Projectile = WorldEntity:new()

function Projectile:new(opts)
  local t = WorldEntity.new(self, opts)

  if opts then
    t.owner = opts.owner
    t.startX = opts.x
    t.startY = opts.y
    t.x = opts.x
    t.y = opts.y
    t.angle = opts.angle or 0
    t.speed = opts.speed or 200
    t:setVelocity(t.speed, t.angle)
    t.lethal = opts.lethal or 'all'
    t.damage = opts.damage or 1
  end

  return t
end

function Projectile:isOut()
  return self.x > self.world.w or self.x < 0 or self.y > self.world.h or self.y < 0
end

function Projectile:hit(target)
  if self.owner then
    self.owner:projectileHit(self, target)
  end
end

function Projectile:getDistance()
  return math.sqrt(math.pow(self.startX - self.x, 2) + math.pow(self.startY - self.y, 2))
end

return Projectile
