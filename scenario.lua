local WorldEntity = require 'world_entity'
local Scenario = WorldEntity:new()

function Scenario:new(opts)
  return WorldEntity.new(self, opts)
end

function Scenario:load()

end

function Scenario:update(dt)

end

function Scenario:draw()

end

function Scenario:keypressed(key)

end

function Scenario:keyreleased(key)

end

function Scenario:isDone()
  return false
end

function Scenario:enemyDestroyed(enemy)

end

function Scenario:enemyOut(enemy)

end

function Scenario:friendlyDestroyed(friendlyl)

end

function Scenario:friendlyOut(friendly)

end

function Scenario:powerUpUsed(powerup)

end

function Scenario:powerUpOut(powerup)

end

function Scenario:spawnEnemy(type)
  self.world:addEnemy(type:new({
    world = self.world,
    x = self.world.w + 50,
    y = 50 + love.math.random(self.world.h - 50)
  }))
end

function Scenario:spawnFriendly(type)
  self.world:addFriendly(type:new({
    world = self.world,
    x = -50,
    y = 50 + love.math.random(self.world.h - 50)
  }))
end

function Scenario:spawnPowerUp(type, opts)
  local opts = opts or {}

  self.world:addPowerUp(type:new(
    self.world,
    opts.x or self.world.w,
    opts.y or (50 + love.math.random(self.world.h - 50))
  ))
end

return Scenario
