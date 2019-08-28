local Background = {}

function Background:new(world)
  local t = setmetatable({
    world = world,
    stars = {},
    speed = 50,
  }, {__index = Background})

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
  love.graphics.setColor(255, 255, 255, 255)

  for i, s in pairs(self.stars) do
    love.graphics.points(s.x, s.y)
  end
end

return Background
