local Scenario = require '../scenario'
local Random = Scenario:new()

local Dispenser = require 'dispenser'
local types = require 'types'

function Random:new(opts)
  local t = Scenario.new(self, opts)

  now = t:getGameTime()
  t.startedAt = now
  t.lastenemy = now
  t.lastformation = now
  t.lastpowerup = now

  t.enemyDispenser = Dispenser:new(t.world.game.gameTime, {
    [types.enemies.OneCell] = {probability = 0.5, maxdelay = 1},
    [types.enemies.TwinCell] = {probability = 0.3, maxdelay = 2},
    [types.enemies.TriCell] = {probability = 0.2, maxdelay = 4},
    [types.enemies.QuadCell] = {probability = 0.1, maxdelay = 6},
    [types.enemies.QuintCell] = {probability = 0.05, maxdelay = 10},
    [types.enemies.QuadComposite] = {probability = 0.025, maxdelay = 20},
    [types.enemies.Speeder] = {probability = 0.05, maxdelay = 15},
    [types.enemies.OneCellBlocker] = {probability = 0.05, maxdelay = 10},
    [types.enemies.QuadCellBlocker] = {probability = 0.025, maxdelay = 20},
    [types.enemies.MaskedTriCell] = {probability = 0.025, maxdelay = 40},
    [types.enemies.Firewall] = {probability = 0.01, cooldown = 60, maxdelay = 180, maxactive=1}
  })

  t.formations = {
    onecell_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.OneCell
    }),
    twincell_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.TwinCell
    }),
    twincell_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.TwinCell
    }),
    tricell_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.TriCell
    }),
    quadcell_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.QuadCell
    }),
    quadcell_blocker_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.QuadCellBlocker, wingspan = 1
    }),
    quadcomposite_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.QuadComposite, wingspan = 1
    }),
    quadcomposite_vline = types.formations.VLine:new({
      world = t.world,
      enemy = types.enemies.QuadComposite, wingspan = 1
    }),
    quintcell_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.QuintCell
    }),
    quintcell_vline = types.formations.VLine:new({
      world = t.world,
      enemy = types.enemies.QuintCell, wingspan = 2
    }),
    speeder_arrow = types.formations.Arrow:new({
      world = t.world,
      enemy = types.enemies.Speeder, wingspan = 6
    }),
    speeder_hline = types.formations.HLine:new({
      world = t.world,
      enemy = types.enemies.Speeder, wingspan = 12
    }),
    speeder_vline = types.formations.VLine:new({
      world = t.world,
      enemy = types.enemies.Speeder, wingspan = 6
    }),
    firewall_hline = types.formations.HLine:new({
      world = t.world,
      enemy = types.enemies.Firewall,
      wingspan = 3,
      x = t.world.w + types.enemies.Firewall.hints.r,
      y = t.world.h / 2
    }),
  }

  t.formationDispenser = Dispenser:new(t.world.game.gameTime, {
    firewall_hline = {probability = 0.01, cooldown = 180, maxdelay = 240},
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

  t.powerupDispenser = Dispenser:new(t.world.game.gameTime, {
    [types.powerups.Shield] = {probability = 0.1, cooldown = 5, maxdelay = 10, maxactive = 2},
    [types.powerups.SuperShield] = {probability = 0.025, cooldown = 10, maxdelay = 20, maxactive = 2},
    [types.powerups.MachineGun] = {probability = 0.05, cooldown = 6, maxdelay = 20, maxactive = 2},
    [types.powerups.Cannon] = {probability = 0.025, cooldown = 10, maxdelay = 30, maxactive = 1},
    [types.powerups.Invulnerability] = {probability = 0.01, cooldown = 20, maxdelay = 40, maxactive = 1},
    [types.powerups.QuadDamage] = {probability = 0.01, cooldown = 20, maxdelay = 60, maxactive = 1},
    [types.powerups.Magnet] = {probability = 0.01, cooldown = 30, maxdelay = 60, maxactive = 1},
    [types.powerups.Life] = {probability = 0.005, cooldown = 20, maxdelay = 90, maxactive = 1},
    [types.powerups.Firewall] = {probability = 0.005, cooldown = 60, maxdelay = 240, maxactive = 1},
    [types.powerups.Reinforcement] = {probability = 0.025, cooldown = 60, maxdelay = 150, maxactive = 1}
  })

  return t
end

function Random:load()
  self:spawnPowerUp(types.powerups.Life)
  self:spawnPowerUp(types.powerups.Life)
  self:spawnPowerUp(types.powerups.Shield)
  self:spawnPowerUp(types.powerups.Shield)
  self:spawnPowerUp(types.powerups.Shield)
  self:spawnPowerUp(types.powerups.Shield)
  self:spawnPowerUp(types.powerups.Shield)
  self:spawnPowerUp(types.powerups.Shield)
  self:spawnPowerUp(types.powerups.SuperShield)
  self:spawnPowerUp(types.powerups.MachineGun)
  self:spawnPowerUp(types.powerups.MachineGun)
  self:spawnPowerUp(types.powerups.MachineGun)
  self:spawnPowerUp(types.powerups.MachineGun)
  self:spawnPowerUp(types.powerups.MachineGun)
  self:spawnPowerUp(types.powerups.MachineGun)
  self:spawnPowerUp(types.powerups.Cannon)
  self:spawnPowerUp(types.powerups.Cannon)
  self:spawnPowerUp(types.powerups.Cannon)
end

function Random:update(dt)
  now = self:getGameTime()

  if self.startedAt + 10 < now then
    if self.lastenemy + 0.5 < now and self:canSpawnMoreEnemies() then
      self:spawnRandomEnemies()
      self.lastenemy = now
    end

    if self.lastformation + 10 < now and self:canSpawnMoreEnemies() then
      self:spawnRandomFormation()
      self.lastformation = now
    end
  end

  if self.lastpowerup + 1 < now then
    self:spawnRandomPowerUps()
    self.lastpowerup = now
  end
end

function Random:keypressed(key)
  if key == "i" then
    self.world.player:addPowerUp(types.powerups.Invulnerability:new(
      self.world,
      0, 0
    ))
  elseif key == "q" then
    self.world.player:addPowerUp(types.powerups.QuadDamage:new(
      self.world,
      0, 0
    ))
  end
end

function Random:isDone()
  return false
end

function Random:enemyDestroyed(enemy)
  self.enemyDispenser:decrementActive(enemy.type, 1)

  if self:canSpawnMoreEnemies() and love.math.random() > 0.5 then
    self:spawnRandomEnemies()
  end
end

function Random:enemyOut(enemy)
  self.enemyDispenser:decrementActive(enemy.type, 1)

  if self:canSpawnMoreEnemies() and love.math.random() > 0.5 then
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

function Random:canSpawnMoreEnemies()
  return self.world.enemies.count < 100
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
