local Missile = require '../missile'
local TargetLock = require 'target_lock'
local Guided = Missile:new()

function Guided:new(opts)
  local t = Missile.new(self, opts)
  t.collisionType = 'circle'
  t.r = opts.r or 6
  t.color = opts.color

  local types
  if t.lethal == 'enemy' then
    types = {'enemies'}
  else
    types = {'friendlies', 'players'}
  end

  t.target_lock = TargetLock:new({
    world = t.world,
    owner = t,
    strategy = TargetLock.strategy.closest,
    targetTypes = types,
    targetFilter = function(closest, ent)
      if closest then
        return ent.hitpoints >= t.damage
      else
        return true
      end
    end,
    target = opts.target or nil,
    maxAge = nil,
  })
  return t
end

function Guided:updateDrift(dt)
  Missile.updateDrift(self, dt)

  if self.redirected then
    return
  end

  if not self.target_lock:findTarget(dt) then
    return
  end

  self:setInterceptAngle(dt)
end

function Guided:updateFire(dt)
  if self.redirected then
    Missile.updateFire(self, dt)
    return
  end

  if not self.target_lock:findTarget(dt) then
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt
    return
  end

  if self.speed < self.maxSpeed then
    self.speed = self.speed + self.acceleration * dt

    if self.speed > self.maxSpeed then
      self.speed = self.maxSpeed
    end
  end

  self:setInterceptAngle(dt)
  self:setVelocity(self.speed, self.angle)

  self.x = self.x + self.velocity.x * dt
  self.y = self.y + self.velocity.y * dt
end

function Guided:draw()
  local r, g, b = self:getColor()

  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  local length = 20
  local width = 10

  love.graphics.setColor(r, g, b, 255)
  love.graphics.rotate(self.angle)
  love.graphics.polygon('fill', -length/2, -width/2, -length/2, width /2, length/2, 0)
  -- love.graphics.circle('line', 0, 0, self.r) -- collision debug

  love.graphics.pop()
end

function Guided:isOut()
  local w = self.world.w
  local h = self.world.h
  local xOut = self.x + self.r < 0 or self.x - self.r > w
  local yOut = self.y + self.r < 0 or self.y - self.r > h
  return xOut or yOut
end

function Guided:detonate()
  Missile.detonate(self)
  self.target_lock:release()
end

function Guided:setInterceptAngle(dt)
  local newAngle = self:findInterceptionAngle(
    self.target_lock.target.x, self.target_lock.target.y,
    self.target_lock.target.velocity.x, self.target_lock.target.velocity.y,
    self.x, self.y,
    self.speed
  )

  if newAngle then
    if newAngle > 2 * math.pi then
      newAngle = newAngle - 2 * math.pi
    elseif newAngle < 0 then
      newAngle = newAngle + 2 * math.pi
    end

    if self.angle < newAngle and newAngle - self.angle <= math.pi then
      self.angle = self.angle + dt
    elseif self.angle < newAngle and newAngle - self.angle > math.pi then
      self.angle = self.angle - dt
    elseif self.angle > newAngle and self.angle - newAngle <= math.pi then
      self.angle = self.angle - dt
    elseif self.angle > newAngle and self.angle - newAngle > math.pi then
      self.angle = self.angle + dt
    end

    if self.angle > 2 * math.pi then
      self.angle = self.angle - 2 * math.pi
    elseif self.angle < 0 then
      self.angle = self.angle + 2 * math.pi
    end
  end
end

function Guided:getColor()
  if self.color then
    return self.color
  end

  return stylesheet.missiles.Guided.color[self.lethal]
end

return Guided
