local PowerUp = {}

function PowerUp:new(world, x, y, target)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.x = x
  t.y = y
  t.r = 12
  t.target = target
  t.name = 'undefined'
  t.stacksize = 1
  t.duration = 60
  t.active = false
  return t
end

function PowerUp:update(dt)

end

function PowerUp:draw(dt)

end

function PowerUp:activate()
  self.active = true
  self.activeSince = love.timer.getTime()
end

function PowerUp:isOut()
  return self.x < self.world.startX or self.x > self.world.w
end

return PowerUp
