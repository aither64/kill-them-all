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
    t.value = t.hitpoints
    t.firstshot = true
  end

  return t
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

function Friendly:isDestroyed()
  return self.hitpoints <= 0
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