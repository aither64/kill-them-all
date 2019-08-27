local OneCell = require 'enemies/onecell'
local TwinCell = require 'enemies/twincell'
local Shield = require 'powerups/shield'
local Shotgun = require 'powerups/shotgun'
local Dispenser = require 'dispenser'
local LevelInfinite = {}

function LevelInfinite:new(world)
  local t = setmetatable({}, { __index = self })
  t.world = world
  now = love.timer.getTime()
  t.lastenemy = now
  t.lastpowerup = now
  t.enemyDispenser = Dispenser:new({
    [OneCell] = 0.4,
    [TwinCell] = 0.25
  })
  t.powerupDispenser = Dispenser:new({
    [Shield] = 0.1,
    [Shotgun] = 0.1,
  })
  return t
end

function LevelInfinite:load()
  for i = 1,8 do
    self:spawnEnemy(OneCell)
  end
end

function LevelInfinite:update(dt)
  now = love.timer.getTime()

  if self.lastenemy + 0.5 < now then
    self:spawnRandomEnemies()
    self.lastenemy = now
  end

  if self.lastpowerup + 1 < now then
    self:spawnRandomPowerUps()
    self.lastpowerup = now
  end
end

function LevelInfinite:enemyDestroyed(enemy)
  if love.math.random() > 0.5 then
    self:spawnRandomEnemies()
  end
end

function LevelInfinite:enemyOut(enemy)
  if love.math.random() > 0.5 then
    self:spawnRandomEnemies()
  end
end

function LevelInfinite:powerUpOut(powerup)
  if love.math.random() > 0.5 then
    self:spawnRandomPowerUps()
  end
end

function LevelInfinite:spawnRandomEnemies()
  for i, e in pairs(self.enemyDispenser:get()) do
    self:spawnEnemy(e)
  end
end

function LevelInfinite:spawnEnemy(type)
  self.world:addEnemy(type:new(
    self.world,
    self.world.w + 50,
    50 + love.math.random(self.world.h - 50)
  ))
end

function LevelInfinite:spawnRandomPowerUps()
  for i, p in pairs(self.powerupDispenser:get()) do
    self:spawnPowerUp(p)
  end
end

function LevelInfinite:spawnPowerUp(type)
  self.world:addPowerUp(type:new(
    self.world,
    self.world.w,
    50 + love.math.random(self.world.h - 50)
  ))
end

return LevelInfinite
