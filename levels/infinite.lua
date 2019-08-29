local Intro = require '../scenarios/intro'
local LevelInfinite = {}

function LevelInfinite:new(world)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.scenario = Intro:new({world = world})
  return t
end

function LevelInfinite:load()
  self.scenario:load()
end

function LevelInfinite:update(dt)
  self.scenario:update(dt)

  if self.scenario:isDone() then
    self.world.game:gameFinished()
  end
end

function LevelInfinite:enemyDestroyed(enemy)
  self.scenario:enemyDestroyed(enemy)
end

function LevelInfinite:enemyOut(enemy)
  self.scenario:enemyOut(enemy)
end

function LevelInfinite:powerUpUsed(powerup)
  self.scenario:powerUpUsed(powerup)
end

function LevelInfinite:powerUpOut(powerup)
  self.scenario:powerUpOut(powerup)
end

return LevelInfinite
