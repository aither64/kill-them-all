local WorldEntity = require 'world_entity'
local Bullet = require '../projectiles/bullet'
local Shell = require '../projectiles/shell'
local Enemy = WorldEntity:new()

local audio = {
  destroyed = love.audio.newSource('sfx/enemy_destroyed.ogg', 'static'),
}

function Enemy:new(opts)
  local t = WorldEntity.new(self, opts)
  t.type = self

  if opts then
    t.x = opts.x
    t.y = opts.y
    t.formation = opts.formation
    t.speed = 100
    t.hitpoints = 10
    t.baseHitpoints = t.hitpoints
    t.value = t.hitpoints
    t.firstshot = true
    t.targetedBy = nil
  end

  t.audio = t:cloneAudio(audio)

  return t
end

function Enemy:init()
  self.baseHitpoints = self.hitpoints
  self:setVelocity(self.speed, math.pi)
end

function Enemy:update(dt)
  self.x = self.x + self.velocity.x * dt
  self.y = self.y + self.velocity.y * dt
end

function Enemy:isOut()
  return self.x + 50 < 0
end

function Enemy:missileHit(missile, target)
end

function Enemy:hitByProjectile(projectile)
  self.hitpoints = self.hitpoints - projectile.damage
end

function Enemy:hitByMissile(missile)
  self.hitpoints = self.hitpoints - missile.damage
end

function Enemy:hitByBeam(beam, damage)
  self.hitpoints = self.hitpoints - damage
end

function Enemy:hitByExplosion(explosion)
  self.hitpoints = self.hitpoints - explosion.damage
end

function Enemy:isDestroyed()
  return self.hitpoints <= 0
end

function Enemy:destroyed()
  self.audio.destroyed:play()
end

function Enemy:setTargeted(attacker)
  self.targetedBy = attacker
end

function Enemy:releaseTarget()
  self.targetedBy = nil
end

function Enemy:isTargeted()
  if self.targetedBy then
    return true
  else
    return false
  end
end

function Enemy:fireBullet(opts)
  local opts = opts or {}

  self.world:addProjectile(Bullet:new({
    world = self.world,
    x = opts.x or self.x + (opts.offsetX or 0),
    y = opts.y or self.y + (opts.offsetY or 0),
    lethal = 'player',
    damage = opts.damage or 10,
    angle = opts.angle or math.pi,
    speed = opts.speed or 200
  }))
end

function Enemy:fireShell(opts)
  local opts = opts or {}

  self.world:addProjectile(Shell:new({
    world = self.world,
    x = opts.x or self.x + (opts.offsetX or 0),
    y = opts.y or self.y + (opts.offsetY or 0),
    r = opts.r,
    lethal = 'player',
    damage = opts.damage or 100,
    angle = opts.angle or 200,
    speed = opts.speed or 300
  }))
end

function Enemy:fireGenericMissile(opts)
  local opts = opts or {}

  self.world:addMissile(opts.class:new({
    world = self.world,
    owner = self,
    color = opts.color,
    x = opts.x or self.x + (opts.offsetX or 0),
    y = opts.y or self.y + (opts.offsetY or 0),
    r = opts.r,
    lethal = 'player',
    damage = opts.damage or 100,
    angle = opts.angle or math.pi,
    driftSpeed = opts.driftSpeed or self:getMissileDriftSpeed(),
    driftTime = 1,
    maxSpeed = 1200,
  }))
end

function Enemy:getMissileDriftSpeed()
  if self.lastMissileDriftSpeed then
    self.lastMissileDriftSpeed = self.lastMissileDriftSpeed * -1;
  else
    self.lastMissileDriftSpeed = 100
  end

  return self.lastMissileDriftSpeed
end

function Enemy:calcAngleToPlayer(offsetX, offsetY)
  return math.atan2(
    self.world.player.y - self.y + offsetY,
    self.world.player.x - self.x + offsetX
  )
end

function Enemy:getSpeedVector()
  return (math.cos(math.pi) * self.speed),
         (math.sin(math.pi) * self.speed)
end

return Enemy
