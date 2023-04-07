local WorldEntity = require 'world_entity'
local Bullet = require '../projectiles/bullet'
local Shell = require '../projectiles/shell'
local Friendly = WorldEntity:new()

function Friendly:new(opts)
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
    t.velocity = { x = 0, y = 0 } -- for compatibility
  end

  return t
end

function Friendly:init()
  self.baseHitpoints = self.hitpoints
end

function Friendly:update(dt)
  self.x = self.x + self.speed * dt
end

function Friendly:isOut()
  return self.x + 50 > self.world.w
end

function Friendly:hitByProjectile(projectile)
  self.hitpoints = self.hitpoints - projectile.damage
end

function Friendly:hitByMissile(missile)
  self.hitpoints = self.hitpoints - missile.damage
end

function Friendly:hitByBeam(beam)
  self.hitpoints = self.hitpoints - beam.damage
end

function Friendly:hitByExplosion(explosion)
  self.hitpoints = self.hitpoints - explosion.damage
end

function Friendly:isDestroyed()
  return self.hitpoints <= 0
end

function Friendly:destroyed()

end

function Friendly:setTargeted(attacker)
  self.targetedBy = attacker
end

function Friendly:releaseTarget()
  self.targetedBy = nil
end

function Friendly:isTargeted()
  if self.targetedBy then
    return true
  else
    return false
  end
end

function Friendly:fireBullet(opts)
  local opts = opts or {}

  self.world:addProjectile(Bullet:new({
    world = self.world,
    x = opts.x or self.x + (opts.offsetX or 0),
    y = opts.y or self.y + (opts.offsetY or 0),
    lethal = 'enemy',
    damage = opts.damage or 10,
    angle = opts.angle or 0,
    speed = opts.speed or 800
  }))
end

function Friendly:fireShell(opts)
  local opts = opts or {}

  self.world:addProjectile(Shell:new({
    world = self.world,
    x = opts.x or self.x + (opts.offsetX or 0),
    y = opts.y or self.y + (opts.offsetY or 0),
    r = opts.r,
    lethal = 'enemy',
    damage = opts.damage or 100,
    angle = opts.angle or 0,
    speed = opts.speed or 600
  }))
end

return Friendly
