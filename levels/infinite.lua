local OneCell = require 'enemies/onecell'
local LevelInfinite = {}

function LevelInfinite:new(world)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.lastspawn = love.timer.getTime()
  return t
end

function LevelInfinite:load()
  for i = 1,5 do
    self:spawnEnemy(OneCell)
  end
end

function LevelInfinite:update(dt)
  now = love.timer.getTime()

  if self.lastspawn + 1 < now then
    self:spawnEnemy(OneCell)
    self.lastspawn = now
  end
end

function LevelInfinite:enemyDestroyed(enemy)
  if love.math.random() > 0.5 then
    self:spawnEnemy(OneCell)
  end
end

function LevelInfinite:enemyOut(enemy)
  if love.math.random() > 0.5 then
    self:spawnEnemy(OneCell)
  end
end

function LevelInfinite:spawnEnemy(type)
  self.world:addEnemy(type:new(
    self.world,
    self.world.w + 50,
    50 + love.math.random(self.world.h - 50)
  ))
end

return LevelInfinite
