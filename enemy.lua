local Bullet = require '../projectiles/bullet'
local Enemy = {}

function Enemy:new(world, x, y)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.x = x
  t.y = y
  t.speed = 100
  t.hitpoints = 10
  t.value = t.hitpoints
  t.firstshot = true
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

  self.world:addProjectile(Bullet:new(
    self.world,
    opts.x or self.x + (opts.offsetX or 0),
    opts.y or self.y + (opts.offsetY or 0),
    'player',
    opts.damage or 10,
    opts.angle or math.pi,
    opts.speed or 200
  ))
end

return Enemy
