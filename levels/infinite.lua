local OneCell = require 'enemies/onecell'
local TwinCell = require 'enemies/twincell'
local Shield = require 'powerups/shield'
local LevelInfinite = {}

function LevelInfinite:new(world)
  local t = setmetatable({}, { __index = self })
  t.world = world
  now = love.timer.getTime()
  t.lastspawn = now
  t.lastpowerup = now
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

  if self.lastpowerup + 15 < now then
    if love.math.random() > 0.1 then
      self:spawnPowerUp(Shield)
    end

    self.lastpowerup = now
  end
end

function LevelInfinite:enemyDestroyed(enemy)
  if love.math.random() > 0.5 then
    self:spawnEnemy(TwinCell)
  end
end

function LevelInfinite:enemyOut(enemy)
  if love.math.random() > 0.5 then
    self:spawnEnemy(OneCell)
  end
end

function LevelInfinite:powerUpOut(powerup)
  if love.math.random() > 0.9 then
    self:spawnPowerUp(Shield)
  end
end

function LevelInfinite:spawnEnemy(type)
  self.world:addEnemy(type:new(
    self.world,
    self.world.w + 50,
    50 + love.math.random(self.world.h - 50)
  ))
end

function LevelInfinite:spawnPowerUp(type)
  self.world:addPowerUp(type:new(
    self.world,
    self.world.w,
    50 + love.math.random(self.world.h - 50)
  ))
end

return LevelInfinite
