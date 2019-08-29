local Projectile = {}

function Projectile:new(opts)
  local t = setmetatable({}, { __index = self })

  if opts then
    t.world = opts.world
    t.startX = opts.x
    t.startY = opts.y
    t.x = opts.x
    t.y = opts.y
    t.angle = opts.angle or 0
    t.speed = opts.speed or 200
    t.lethal = opts.lethal or 'all'
    t.damage = opts.damage or 1
  end

  return t
end

function Projectile:isOut()
  return self.x > self.world.w or self.x < 0 or self.y > self.world.h or self.y < 0
end

function Projectile:getDistance()
  return math.sqrt(math.pow(self.startX - self.x, 2) + math.pow(self.startY - self.y, 2))
end

return Projectile
