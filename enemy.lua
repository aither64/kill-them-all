local Enemy = {}

function Enemy:new(world, x, y)
  local t = setmetatable({}, { __index = self })
  t.world = world
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
end

function Enemy:isOut()
  return self.x + 50 < 0
end

return Enemy
