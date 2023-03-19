local Missile = require '../missile'
local Guided = Missile:new()

function Guided:new(opts)
  t = Missile.new(self, opts)
  t.collisionType = 'circle'
  t.r = opts.r or 6
  t.color = opts.color
  t.target = opts.target
  t.strategy = opts.strategy or "closest"
  return t
end

function Guided:updateDrift(dt)
  Missile.updateDrift(self, dt)

  if not self:hasTarget() then
    if not self:findTarget() then
      return
    end
  end

  self:setInterceptAngle(dt)
end

function Guided:updateFire(dt)
  if not self:hasTarget() then
    if not self:findTarget() then
      self.x = self.x + self.velocity.x * dt
      self.y = self.y + self.velocity.y * dt
      return
    end
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

function Guided:hasTarget()
  return self.target and not self.target:isDestroyed()
end

function Guided:findTarget()
  if self.strategy == "closest" then
    self.target = self.world:findClosestEnemy(self.x, self.y, {newTarget = true})

    if self.target then
      self.target:setTargeted(self)
    end
  end

  return self.target
end

function Guided:setInterceptAngle(dt)
  local newAngle = self:findInterceptionAngle(
    self.target.x, self.target.y,
    self.target.velocity.x, self.target.velocity.y,
    self.x, self.y,
    self.speed
  )

  if newAngle then
    if self.angle < newAngle then
      self.angle = self.angle + dt
    elseif self.angle > newAngle then
      self.angle = self.angle - dt
    end
  end
end

function Guided:getColor()
  if self.color then
    return self.color
  end

  return stylesheet.missiles.Guided.baseColor
end

return Guided
