local Scenario = {}

function Scenario:new(opts)
  local t = setmetatable({}, {__index = self})

  if opts then
    t.world = opts.world
  end

  return t
end

function Scenario:load()

end

function Scenario:update(dt)

end

function Scenario:draw()

end

function Scenario:isDone()
  return false
end

function Scenario:enemyDestroyed(enemy)

end

function Scenario:enemyOut(enemy)

end

function Scenario:powerUpUsed(powerup)

end

function Scenario:powerUpOut(powerup)

end

function Scenario:spawnEnemy(type)
  self.world:addEnemy(type:new(
    self.world,
    self.world.w + 50,
    50 + love.math.random(self.world.h - 50)
  ))
end

function Scenario:spawnPowerUp(type)
  self.world:addPowerUp(type:new(
    self.world,
    self.world.w,
    50 + love.math.random(self.world.h - 50)
  ))
end

return Scenario
