local Scenario = require '../scenario'
local Intro = Scenario:new()

-- Enemies
local OneCell = require 'enemies/onecell'
local TwinCell = require 'enemies/twincell'
local TriCell = require 'enemies/tricell'
local QuadCell = require 'enemies/quadcell'
local QuintCell = require 'enemies/quintcell'
local OneCellBlocker = require 'enemies/onecell_blocker'
local QuadCellBlocker = require 'enemies/quadcell_blocker'
local MaskedTriCell = require 'enemies/masked_tricell'
local QuadComposite = require 'enemies/quadcomposite'
local Firewall = require 'enemies/firewall'
local Speeder = require 'enemies/speeder'

-- Powerups
local Shield = require 'powerups/shield'
local SuperShield = require 'powerups/supershield'
local Invulnerability = require 'powerups/invulnerability'
local QuadDamage = require 'powerups/quaddamage'
local Life = require 'powerups/life'
local MachineGun = require 'powerups/machinegun'
local Cannon = require 'powerups/cannon'

local Dispenser = require 'dispenser'

function Intro:new(opts)
  local t = Scenario.new(self, opts)

  now = love.timer.getTime()
  t.startedAt = now
  t.lastenemy = now
  t.lastpowerup = now
  t.stage = 0
  t.enemyDispenser = Dispenser:new({
    [OneCell] = {probability = 0.5, maxdelay = 1},
  })
  t.powerupDispenser = Dispenser:new({
    [Shield] = {probability = 0.1, cooldown = 6, maxdelay = 20, maxactive = 1},
    [MachineGun] = {probability = 0.05, cooldown = 8, maxdelay = 30, maxactive = 1},
  })

  return t
end

function Intro:load()
  for i = 1,8 do
    self:spawnEnemy(OneCell)
  end

  self:spawnPowerUp(Shield)
end

function Intro:update(dt)
  now = love.timer.getTime()

  if self.stage == 0 and self.startedAt + 10 < now then
    self.stage = 1
    self.enemyDispenser:add(TwinCell, {probability = 0.3, maxdelay = 2})
    self:spawnPowerUp(MachineGun)
  end

  if self.stage == 1 and self.startedAt + 30 < now then
    self.stage = 2
    self.enemyDispenser:add(TriCell, {probability = 0.2, maxdelay = 4})
  end

  if self.stage == 2 and self.startedAt + 75 < now then
    self.stage = 3
    self.enemyDispenser:add(QuadCell, {probability = 0.1, maxdelay = 6})
  end

  if self.stage == 3 and self.startedAt + 90 < now then
    self.stage = 4
    self.enemyDispenser:add(QuintCell, {probability = 0.05, maxdelay = 10})
    self.powerupDispenser:add(SuperShield, {probability = 0.025, cooldown = 20, maxdelay = 60, maxactive = 1})
    self.powerupDispenser:add(Cannon, {probability = 0.025, cooldown = 20, maxdelay = 40, maxactive = 1})
    self:spawnPowerUp(Cannon)
  end

  if self.stage == 4 and self.startedAt + 100 < now then
    self.stage = 5
    self.enemyDispenser:add(OneCellBlocker, {probability = 0.05, maxdelay = 10})
  end

  if self.stage == 5 and self.startedAt + 120 < now then
    self.stage = 6
    self.enemyDispenser:add(QuadComposite, {probability = 0.025, maxdelay = 20})
    self.enemyDispenser:add(Speeder, {probability = 0.05, maxdelay = 15})
    self.powerupDispenser:add(Invulnerability, {probability = 0.01, cooldown = 20, maxdelay = 90, maxactive = 1})
    self.powerupDispenser:add(QuadDamage, {probability = 0.01, cooldown = 20, maxdelay = 120, maxactive = 1})
    self.powerupDispenser:add(Life, {probability = 0.005, cooldown = 20, maxdelay = 120, maxactive = 1})
  end

  if self.stage == 6 and self.startedAt + 150 < now then
    self.stage = 7
    self.enemyDispenser:add(QuadCellBlocker, {probability = 0.025, maxdelay = 20})
    self.enemyDispenser:add(MaskedTriCell, {probability = 0.025, maxdelay = 40, maxactive=2})
  end

  if self.stage == 7 and self.startedAt + 180 < now then
    self.stage = 8
    self:spawnEnemy(Firewall)
  end

  if self.stage == 8 and self.startedAt + 280 < now then
    self.stage = 9
  end

  if self.stage == 9 and self.startedAt + 290 < now then
    self.stage = 10
  end

  if self:isActive() then
    if self.lastenemy + 0.5 < now then
      self:spawnRandomEnemies()
      self.lastenemy = now
    end
  end

  if self.lastpowerup + 1 < now then
    self:spawnRandomPowerUps()
    self.lastpowerup = now
  end
end

function Intro:isActive()
  return self.stage < 9
end

function Intro:isDone()
  return self.stage == 10
end

function Intro:enemyDestroyed(enemy)
  self.enemyDispenser:decrementActive(enemy.type, 1)

  if self:isActive() and love.math.random() > 0.5 then
    self:spawnRandomEnemies()
  end
end

function Intro:enemyOut(enemy)
  self.enemyDispenser:decrementActive(enemy.type, 1)

  if self:isActive() and love.math.random() > 0.5 then
    self:spawnRandomEnemies()
  end
end

function Intro:powerUpUsed(powerup)
  self.powerupDispenser:decrementActive(powerup.type, 1)
end

function Intro:powerUpOut(powerup)
  self.powerupDispenser:decrementActive(powerup.type, 1)

  if love.math.random() > 0.5 then
    self:spawnRandomPowerUps()
  end
end

function Intro:spawnRandomEnemies()
  for i, e in pairs(self.enemyDispenser:get()) do
    self:spawnEnemy(e)
  end
end

function Intro:spawnRandomPowerUps()
  for i, p in pairs(self.powerupDispenser:get()) do
    self:spawnPowerUp(p)
  end
end

return Intro