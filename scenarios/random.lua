local Scenario = require '../scenario'
local Random = Scenario:new()

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

-- Formations
local Arrow = require 'formations/arrow'
local VLine = require 'formations/vline'
local HLine = require 'formations/hline'

-- Powerups
local Shield = require 'powerups/shield'
local SuperShield = require 'powerups/supershield'
local Invulnerability = require 'powerups/invulnerability'
local QuadDamage = require 'powerups/quaddamage'
local Life = require 'powerups/life'
local MachineGun = require 'powerups/machinegun'
local Cannon = require 'powerups/cannon'

local Dispenser = require 'dispenser'

function Random:new(opts)
  local t = Scenario.new(self, opts)

  now = love.timer.getTime()
  t.startedAt = now
  t.lastenemy = now
  t.lastformation = now
  t.lastpowerup = now

  t.enemyDispenser = Dispenser:new({
    [OneCell] = {probability = 0.5, maxdelay = 1},
    [TwinCell] = {probability = 0.3, maxdelay = 2},
    [TriCell] = {probability = 0.2, maxdelay = 4},
    [QuadCell] = {probability = 0.1, maxdelay = 6},
    [QuintCell] = {probability = 0.05, maxdelay = 10},
    [QuadComposite] = {probability = 0.025, maxdelay = 20},
    [Speeder] = {probability = 0.05, maxdelay = 15},
    [OneCellBlocker] = {probability = 0.05, maxdelay = 10},
    [QuadCellBlocker] = {probability = 0.025, maxdelay = 20},
    [MaskedTriCell] = {probability = 0.025, maxdelay = 40},
    [Firewall] = {probability = 0.01, cooldown = 60, maxdelay = 180, maxactive=1}
  })

  t.formations = {
    onecell_arrow = (Arrow:new({
      world = t.world,
      enemy = OneCell
    })),
    twincell_arrow = Arrow:new({
      world = t.world,
      enemy = TwinCell
    }),
    twincell_arrow = Arrow:new({
      world = t.world,
      enemy = TwinCell
    }),
    tricell_arrow = Arrow:new({
      world = t.world,
      enemy = TriCell
    }),
    quadcell_arrow = Arrow:new({
      world = t.world,
      enemy = QuadCell
    }),
    quadcell_blocker_arrow = Arrow:new({
      world = t.world,
      enemy = QuadCellBlocker, wingspan = 1
    }),
    quadcomposite_arrow = Arrow:new({
      world = t.world,
      enemy = QuadComposite, wingspan = 1
    }),
    quadcomposite_vline = VLine:new({
      world = t.world,
      enemy = QuadComposite, wingspan = 1
    }),
    quintcell_arrow = Arrow:new({
      world = t.world,
      enemy = QuintCell
    }),
    quintcell_vline = VLine:new({
      world = t.world,
      enemy = QuintCell, wingspan = 2
    }),
    speeder_arrow = Arrow:new({
      world = t.world,
      enemy = Speeder, wingspan = 6
    }),
    speeder_hline = HLine:new({
      world = t.world,
      enemy = Speeder, wingspan = 12
    }),
    speeder_vline = VLine:new({
      world = t.world,
      enemy = Speeder, wingspan = 6
    }),
  }

  t.formationDispenser = Dispenser:new({
    quadcomposite_arrow = {probability = 0.05, cooldown = 60, maxdelay = 120},
    quadcomposite_vline = {probability = 0.05, cooldown = 60, maxdelay = 120},
    quintcell_arrow = {probability = 0.1, cooldown = 60, maxdelay = 120},
    quintcell_vline = {probability = 0.1, cooldown = 60, maxdelay = 120},
    quadcell_blocker_arrow = {probability = 0.1, cooldown = 60, maxdelay = 120},
    speeder_vline = {probability = 0.1, maxdelay = 30},
    speeder_arrow = {probability = 0.2, maxdelay = 20},
    speeder_hline = {probability = 0.2, maxdelay = 20},
    quadcell_arrow = {probability = 0.2, maxdelay = 20},
    tricell_arrow = {probability = 0.3, maxdelay = 15},
    twincell_arrow = {probability = 0.4, maxdelay = 15},
    onecell_arrow = {probability = 0.5, maxdelay = 10}
  })

  t.powerupDispenser = Dispenser:new({
    [Shield] = {probability = 0.1, cooldown = 5, maxdelay = 10, maxactive = 2},
    [SuperShield] = {probability = 0.025, cooldown = 10, maxdelay = 20, maxactive = 2},
    [MachineGun] = {probability = 0.05, cooldown = 6, maxdelay = 20, maxactive = 2},
    [Cannon] = {probability = 0.025, cooldown = 10, maxdelay = 30, maxactive = 1},
    [Invulnerability] = {probability = 0.01, cooldown = 20, maxdelay = 40, maxactive = 1},
    [QuadDamage] = {probability = 0.01, cooldown = 20, maxdelay = 60, maxactive = 1},
    [Life] = {probability = 0.005, cooldown = 20, maxdelay = 90, maxactive = 1}
  })

  return t
end

function Random:load()
  self:spawnPowerUp(Life)
  self:spawnPowerUp(Life)
  self:spawnPowerUp(Shield)
  self:spawnPowerUp(Shield)
  self:spawnPowerUp(Shield)
  self:spawnPowerUp(Shield)
  self:spawnPowerUp(Shield)
  self:spawnPowerUp(Shield)
  self:spawnPowerUp(SuperShield)
  self:spawnPowerUp(MachineGun)
  self:spawnPowerUp(MachineGun)
  self:spawnPowerUp(MachineGun)
  self:spawnPowerUp(MachineGun)
  self:spawnPowerUp(MachineGun)
  self:spawnPowerUp(MachineGun)
  self:spawnPowerUp(Cannon)
  self:spawnPowerUp(Cannon)
  self:spawnPowerUp(Cannon)
end

function Random:update(dt)
  now = love.timer.getTime()

  if self.startedAt + 10 < now then
    if self.lastenemy + 0.5 < now then
      self:spawnRandomEnemies()
      self.lastenemy = now
    end

    if self.lastformation + 10 < now then
      self:spawnRandomFormation()
      self.lastformation = now
    end
  end

  if self.lastpowerup + 1 < now then
    self:spawnRandomPowerUps()
    self.lastpowerup = now
  end
end

function Random:isDone()
  return false
end

function Random:enemyDestroyed(enemy)
  self.enemyDispenser:decrementActive(enemy.type, 1)

  if love.math.random() > 0.5 then
    self:spawnRandomEnemies()
  end
end

function Random:enemyOut(enemy)
  self.enemyDispenser:decrementActive(enemy.type, 1)

  if love.math.random() > 0.5 then
    self:spawnRandomEnemies()
  end
end

function Random:powerUpUsed(powerup)
  self.powerupDispenser:decrementActive(powerup.type, 1)
end

function Random:powerUpOut(powerup)
  self.powerupDispenser:decrementActive(powerup.type, 1)

  if love.math.random() > 0.5 then
    self:spawnRandomPowerUps()
  end
end

function Random:spawnRandomEnemies()
  for i, e in pairs(self.enemyDispenser:get()) do
    self:spawnEnemy(e)
  end
end

function Random:spawnRandomFormation()
  for i, f in pairs(self.formationDispenser:get()) do
    self.formations[f]:deploy()
  end
end

function Random:spawnRandomPowerUps()
  for i, p in pairs(self.powerupDispenser:get()) do
    self:spawnPowerUp(p)
  end
end

return Random
