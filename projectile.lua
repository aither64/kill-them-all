local Projectile = {}

function Projectile:new(world, x, y)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.x = x
  t.y = y
  t.speed = 800
  return t
end

function Projectile:update(dt)
  self.x = self.x + self.speed * dt
end

function Projectile:draw()
  love.graphics.setColor(249, 255, 64, 255)
  love.graphics.line(self.x, self.y, self.x - 10, self.y)
end

function Projectile:isOut()
  return self.x + 10 > self.world.w or self.x + 10 < 0
end

return Projectile
