local Projectile = {}

function Projectile:new(world, x, y)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.startX = x
  t.startY = y
  t.x = x
  t.y = y
  t.damage = 1
  return t
end

function Projectile:isOut()
  return self.x + 10 > self.world.w or self.x + 10 < 0 or self.y + 10 > self.world.h or self.y + 10 < 0
end

function Projectile:getDistance()
  return math.sqrt(math.pow(self.startX - self.x, 2) + math.pow(self.startY - self.y, 2))
end

return Projectile
