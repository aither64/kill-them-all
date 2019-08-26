local OneCell = require 'enemies/onecell'
local LevelInfinite = {}

function LevelInfinite:new(world)
  local t = setmetatable({}, { __index = self })
  t.world = world
  return t
end

function LevelInfinite:load()
  for i = 1,5 do
    self.world:addEnemy(OneCell:new(self.world, self.world.w + 50, 100 + 100*i))
  end

  self.time = love.timer.getTime()
end

function LevelInfinite:update(dt)
end

function LevelInfinite:enemyDestroyed(enemy)
  enemy:respawn()
end

function LevelInfinite:enemyOut(enemy)
  enemy:respawn()
end

return LevelInfinite
