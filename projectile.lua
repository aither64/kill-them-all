local Projectile = {}

function Projectile:new(world, x, y)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.x = x
  t.y = y
  t.damage = 1
  return t
end

function Projectile:isOut()
  return self.x + 10 > self.world.w or self.x + 10 < 0
end

return Projectile
