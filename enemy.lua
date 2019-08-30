local Bullet = require '../projectiles/bullet'
local Shell = require '../projectiles/shell'
local Enemy = {}

function Enemy:new(opts)
  local t = setmetatable({}, { __index = self })
  t.type = self

  if opts then
    t.world = opts.world
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

function Enemy:update(dt)
  self.x = self.x - self.speed * dt
end

function Enemy:isOut()
  return self.x + 50 < 0
end

function Enemy:hitByProjectile(projectile)
  self.hitpoints = self.hitpoints - projectile.damage
end

function Enemy:isDestroyed()
  return self.hitpoints <= 0
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

function Enemy:calcAngleToPlayer(offsetX, offsetY)
  return math.atan2(
    self.world.player.y - self.y + offsetY,
    self.world.player.x - self.x + offsetX
  )
end

return Enemy
