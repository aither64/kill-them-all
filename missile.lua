local WorldEntity = require 'world_entity'
local SimpleExplosion = require 'explosions/simple'
local Missile = WorldEntity:new()

local audio = {
  launch = love.audio.newSource('sfx/missile_launch.ogg', 'static'),
  go = love.audio.newSource('sfx/missile_go.ogg', 'static'),
  hit = love.audio.newSource('sfx/missile_hit.ogg', 'static'),
}

function Missile:new(opts)
  local t = WorldEntity.new(self, opts)

  if opts then
    t.owner = opts.owner
    t.startX = opts.x
    t.startY = opts.y
    t.x = opts.x
    t.y = opts.y
    t.stage = "drift"
    t.driftTime = opts.driftTime or 1
    t.driftSpeed = opts.driftSpeed or 100
    t.drifted = 0
    t.angle = opts.angle or 0
    t.startSpeed = opts.startSpeed or 100
    t.maxSpeed = opts.maxSpeed or 2000
    t.speed = t.startSpeed
    t.acceleration = opts.acceleration or 1600
    t:setVelocity(t.speed, t.angle)
    t.lethal = opts.lethal or 'all'
    t.damage = opts.damage or 100
    t.audio = t:cloneAudio(audio)
  end

  return t
end

function Missile:worldAdd()
  self.audio.launch:play()
end

function Missile:update(dt)
  if self.stage == "drift" then
    self:updateDrift(dt)
  else
    self:updateFire(dt)
  end
end

function Missile:updateDrift(dt)
  self.drifted = self.drifted + dt

  if self.drifted >= self.driftTime then
    self.stage = "fire"
    self.audio.go:play()
    self:updateFire(dt)
    return
  end

  self.y = self.y + self.driftSpeed * dt

  if self.y < 0 then
    self.y = 0
  elseif self.y > self.world.h then
    self.y = self.world.h
  end
end

function Missile:updateFire(dt)
  if self.speed < self.maxSpeed then
    self.speed = self.speed + self.acceleration * dt

    if self.speed > self.maxSpeed then
      self.speed = self.maxSpeed
    end

    self:setVelocity(self.speed, self.angle)
  end

  self.x = self.x + self.velocity.x * dt
  self.y = self.y + self.velocity.y * dt
end

function Missile:redirect(angle)
  self.angle = angle
  self:setVelocity(self.speed, self.angle)
end

function Missile:isOut()
  return self.x > self.world.w or self.x < 0 or self.y > self.world.h or self.y < 0
end

function Missile:hit(target)
  if self.owner then
    self.owner:missileHit(self, target)
  end

  self:detonate()
end

function Missile:detonate()
  self.audio.hit:play()

  self.world:addExplosion(SimpleExplosion:new({
    world = self.world,
    owner = self,
    x = self.x,
    y = self.y,
    lethal = self.lethal,
    damage = 100,
    speed = 300,
    maxSize = 200,
  }))
end

return Missile
