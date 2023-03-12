local WorldEntity = require 'world_entity'
local Background = WorldEntity:new()

function Background:new(world)
  local t = WorldEntity.new(self, {world = world})

  t.world = world
  t.stars = {}
  t.speed = 50

  for i = 1,200 do
    table.insert(t.stars, {
      x = love.math.random(world.w),
      y = love.math.random(world.h)
    })
  end

  return t
end

function Background:update(dt)
  for i, s in pairs(self.stars) do
    s.x = s.x - self.speed * dt

    if s.x < 0 then
      s.x = self.world.w + self.speed * dt
    end
  end
end

function Background:draw()
  love.graphics.setColor(stylesheet.background.starColor)

  for i, s in pairs(self.stars) do
    love.graphics.points(s.x, s.y)
  end
end

return Background
