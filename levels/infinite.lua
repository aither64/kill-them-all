local OneCell = require 'enemies/onecell'
local TwinCell = require 'enemies/twincell'
local TriCell = require 'enemies/tricell'
local QuadCell = require 'enemies/quadcell'
local Shield = require 'powerups/shield'
local Cannon = require 'powerups/cannon'
local Dispenser = require 'dispenser'
local LevelInfinite = {}

function LevelInfinite:new(world)
  local t = setmetatable({}, { __index = self })
  t.world = world
  now = love.timer.getTime()
  t.startedAt = now
  t.lastenemy = now
  t.lastpowerup = now
  t.stage = 0
  t.enemyDispenser = Dispenser:new({
    [OneCell] = 0.5,
  })
  t.powerupDispenser = Dispenser:new({
    [Shield] = 0.1,
    [Cannon] = 0.1,
  })
  return t
end

function LevelInfinite:load()
  for i = 1,8 do
    self:spawnEnemy(OneCell)
  end

  self:spawnPowerUp(Shield)
end

function LevelInfinite:update(dt)
  now = love.timer.getTime()

  if self.stage == 0 and self.startedAt + 10 < now then
    self.stage = 1
    self.enemyDispenser:add(TwinCell, 0.3)
    self:spawnPowerUp(Cannon)
  end

  if self.stage == 1 and self.startedAt + 30 < now then
    self.stage = 2
    self.enemyDispenser:add(TriCell, 0.2)
  end

  if self.stage == 2 and self.startedAt + 75 < now then
    self.stage = 3
    self.enemyDispenser:add(QuadCell, 0.1)
  end

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
