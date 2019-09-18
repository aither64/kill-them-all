local WorldEntity = require 'world_entity'
local Player = WorldEntity:new()
local Bullet = require "projectiles/bullet"
local Shell = require "projectiles/shell"
local Armament = require "armament"
local PowerUpList = require "powerup_list"
local types = require 'types'

function Player:new(world, x, y)
  local t = WorldEntity.new(self, {world = world})
  t.x = x
  t.y = y
  t.baseR = 12
  t.r = t.baseR
  t.basespeed = 300
  t.curspeed = 300
  t.maxspeed = 600
  t.acceleration = 20
  t.angle = 0
  t.score = 0
  t.basehitpoints = 100
  t.hitpoints = t.basehitpoints
  t.lifes = 5
  t.maxlifes = 5
  t.armament = Armament:new()
  t.armament:add('machinegun', {
    frequency = 0.1,
    fire = function() t:fireMachineGun() end
  })
  t.powerups = PowerUpList:new(t)
  t.kills = 0
  t.damageDealt = 0
  t.autofire = false
  return t
end

function Player:update(dt)
  local up = love.keyboard.isDown('up')
  local down = love.keyboard.isDown('down')
  local left = love.keyboard.isDown('left')
  local right = love.keyboard.isDown('right')
  local shift = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')

  if not shift and (up or down or left or right) then
    if (self.curspeed + self.acceleration) < self.maxspeed then
      self.curspeed = self.curspeed + self.acceleration
    end
  else
    self.curspeed = self.basespeed
  end

  if love.keyboard.isDown('up') then
    self.y = self.y - self.curspeed * dt
  end

  if love.keyboard.isDown('down') then
    self.y = self.y + self.curspeed * dt
  end

  if love.keyboard.isDown('left') then
    self.x = self.x - self.curspeed * dt
  end

  if love.keyboard.isDown('right') then
    self.x = self.x + self.curspeed * dt
  end

  if self.x < 0 then
    self.x = 0
  elseif self.x > self.world.w then
    self.x = self.world.w
  end

  if self.y < 0 then
    self.y = 0
  elseif self.y > self.world.h then
    self.y = self.world.h
  end

  self.powerups:update(dt)

  if self.autofire or love.keyboard.isDown('space') then
    self.armament:fireAll(self:getGameTime())
  end
end

function Player:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  if self.powerups:isActive('invulnerability') then
    love.graphics.setColor(200, 145, 255, 255)
  else
    love.graphics.setColor(255, 255, 255, 255)
  end

  love.graphics.circle('fill', 0, 0, self.baseR - 2)
  love.graphics.circle('line', 0, 0, self.baseR)

  local r = self.baseR

  if self.powerups:isActive('shield') then
    love.graphics.setColor(0, 255, 238, 255)

    local cnt = self.powerups:getCount('shield')
    for i = 1,cnt do
      r = r + 2
      love.graphics.circle('line', 0, 0, r)
      if i > 3 then break end
    end

    love.graphics.setColor(168, 250, 244, 255)

    if cnt > 3 then
      r = r+1
      love.graphics.circle('line', 0, 0, r)
    end
    if cnt > 4 then
      r = r+1
      love.graphics.circle('line', 0, 0, r)
    end

    love.graphics.setColor(186, 255, 250, 255)

    if cnt > 5 then
      r = r+1
      love.graphics.circle('line', 0, 0, r)
    end
  end

  if self.powerups:isActive('supershield') then
    love.graphics.setColor(255, 237, 36, 255)
    love.graphics.circle('line', 0, 0, r + 1)
    love.graphics.circle('line', 0, 0, r + 2)
    r = r + 2
  end

  love.graphics.pop()
end

function Player:checkCollisionWithPoint(x, y)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(self.r, 2)
end

function Player:checkCollisionWithCircle(x, y, r)
  local distance = math.pow(x - self.x, 2) + math.pow(y - self.y, 2)
  return distance <= math.pow(r, 2) or distance <= math.pow(self.r, 2)
end

function Player:isAlive()
  return self.lifes > 0 and self.score >= 0
end

function Player:toggleAutoFire()
  self.autofire = not self.autofire
end

function Player:hitByProjectile(projectile)
  if self.powerups:isActive('invulnerability') then
    return
  end

  if self.powerups:isActive('supershield') then
    self.powerups:getTop('supershield'):hitByProjectile(projectile)
    return
  end

  if self.powerups:isActive('shield') then
    self.powerups:getTop('shield'):hitByProjectile(projectile)
    return
  end

  self.hitpoints = self.hitpoints - projectile.damage

  if self.hitpoints <= 0 then
    self.hitpoints = self.basehitpoints
    self.lifes = self.lifes - 1
  end
end

function Player:projectileHit(projectile, target)
  self.damageDealt = self.damageDealt + projectile.damage
end

function Player:enemyKilled(enemy)
  self.score = self.score + enemy.value
  self.kills = self.kills + 1
end

function Player:enemyMissed(enemy)
  if enemy.cost then
    self.score = self.score - enemy.cost
  else
    self.score = self.score - enemy.value * 100
  end

  if self.score < 0 then
    self.lifes = self.lifes - 1
    self.hitpoints = self.basehitpoints
    self.score = 0
  end
end

function Player:addPowerUp(powerup)
  if powerup.name == 'life' then
    self.lifes = self.lifes + powerup.lifes
    self.hitpoints = self.basehitpoints

    if (self.lifes > self.maxlifes) then
      self.lifes = self.maxlifes
    end
  elseif powerup.name == 'firewall' then
    self.world:addFriendly(types.friendlies.Firewall:new({world = self.world}))
  else
    self.powerups:activate(powerup)
    self.r = self:calcR()

    if powerup.name == 'cannon' and not self.armament:contains(powerup.name) then
      self.armament:add('cannon', {
        frequency = 0.3,
        fire = function() self:fireCannon() end
      })
    end
  end
end

function Player:powerUpSpent(powerup, countLeft)
  self.r = self:calcR()

  if powerup.name == 'cannon' then
    if self.powerups:getCount('cannon') == 0 then
      self.armament:remove('cannon')
    end
  end
end

function Player:calcR()
  local r = self.baseR

  if self.powerups:isActive('shield') then
    local cnt = self.powerups:getCount('shield')

    if cnt > 3 then
      r = r + 3 * 2 + (cnt - 3)
    else
      r = r + cnt * 2
    end
  end

  if self.powerups:isActive('supershield') then
    r = r + 2
  end

  return r
end

function Player:fireMachineGun()
  self:fireBullet()

  if self.powerups:isActive('machinegun') then
    local cnt = self.powerups:getCount('machinegun')
    local divider = 20

    self:fireBullet({offsetY = -5})
    self:fireBullet({offsetY = 5})

    for i = 1,8 do
      if cnt <= i then
        break
      end

      self:fireBullet({angle = -1 * math.pi / divider})
      self:fireBullet({angle =  1 * math.pi / divider})

      divider = divider - 2
    end
  end
end

function Player:fireCannon()
  local cnt = self.powerups:getCount('cannon')


  if cnt > 2 then
    self:fireShell({offsetY = -5})
    self:fireShell({offsetY = 5})
  else
    self:fireShell()
  end

  if cnt > 1 then
    self:fireShell({angle = -1 * math.pi / 16})
    self:fireShell({angle =  1 * math.pi / 16})
  end

  if cnt > 3 then
    self:fireShell({angle = -1 * math.pi / 14})
    self:fireShell({angle =  1 * math.pi / 14})
  end
end

function Player:fireBullet(opts)
  local opts = opts or {}

  self.world:addProjectile(Bullet:new({
    world = self.world,
    owner = self,
    color = self:projectileColor(),
    x = opts.x or self.x + (opts.offsetX or 0),
    y = opts.y or self.y + (opts.offsetY or 0),
    lethal = 'enemy',
    damage = self:machinegunDamage(opts.damage or 10),
    angle = opts.angle or 0,
    speed = opts.speed or 800
  }))
end

function Player:fireShell(opts)
  local opts = opts or {}

  self.world:addProjectile(Shell:new({
    world = self.world,
    owner = self,
    color = self:projectileColor(),
    x = opts.x or self.x + (opts.offsetX or 0),
    y = opts.y or self.y + (opts.offsetY or 0),
    r = opts.r,
    lethal = 'enemy',
    damage = self:cannonDamage(opts.damage or 100),
    angle = opts.angle or 0,
    speed = opts.speed or 600
  }))
end

function Player:machinegunDamage(base)
  local dmg = base

  if self.powerups:isActive('machinegun') then
    dmg = dmg + self.powerups:getCount('machinegun')
  end

  if self.powerups:isActive('quaddamage') then
    dmg = dmg * 4
  end

  return dmg
end

function Player:projectileColor()
  if self.powerups:isActive('quaddamage') then
    return {88, 247, 59}
  end
end

function Player:cannonDamage(base)
  local dmg = base

  dmg = dmg + (self.powerups:getCount('machinegun') - 1) * 50

  if self.powerups:isActive('quaddamage') then
    dmg = dmg * 4
  end

  return dmg
end

return Player
