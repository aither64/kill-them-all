local Friendly = require '../friendly'
local Armament = require "armament"
local QuadComposite = Friendly:new()

QuadComposite.hints = {
  spacing = 140
}

function QuadComposite:new(opts)
  local t = Friendly.new(self, opts)
  t.armament = Armament:new()
  t.armament:add('machinegun', {
    frequency = 0.2,
    fire = function() t:fireMachineGun() end
  })
  t.armament:add('cannon', {
    frequency = 0.8,
    fire = function() t:fireCannon() end
  })
  t.speed = 10
  t.hitpoints = 10000
  t.target = nil
  t.targetAge = 0
  return t
end

function QuadComposite:update(dt)
  if self.x < (self.world.w / 10) then
    self.x = self.x + self.speed * dt
  end

  if not self:findTarget(dt) then
    return
  end

  if self:canFire() then
    self.armament:fireAll(self:getGameTime())
  end
end

function QuadComposite:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.friendlies.QuadComposite.outlineColor)
  love.graphics.circle('line', 0, 0, 80)
  love.graphics.circle('line', 0, 0, 79)

  love.graphics.setColor(stylesheet.friendlies.QuadComposite.bgColor)
  love.graphics.circle('fill', -25, 25, 30)
  love.graphics.circle('fill', 25, 25, 30)
  love.graphics.circle('fill', -25, -25, 30)
  love.graphics.circle('fill', 25, -25, 30)

  love.graphics.setColor(stylesheet.friendlies.QuadComposite.inlineColor)
  love.graphics.circle('line', -25, 25, 32)
  love.graphics.circle('line', 25, 25, 32)
  love.graphics.circle('line', -25, -25, 32)
  love.graphics.circle('line', 25, -25, 32)

  love.graphics.pop()
end

function QuadComposite:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function QuadComposite:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function QuadComposite:doCheckCollision(x, y, r)
  local r2 = math.pow(80 + r, 2)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= r2
end

function QuadComposite:findTarget(dt)
  self.targetAge = self.targetAge + dt

  if self.target and self.target:isDestroyed() then
    self.target = nil
  end

  if not self.target or self.targetAge > 0.3 then
    if self.target then
      self.target:releaseTarget()
    end

    self.target = self.world:findClosestEnemy(self.x, self.y, {newTarget = true})

    if self.target then
      self.target:setTargeted(self)
      self.targetAge = 0
    end
  end

  return self.target
end

function QuadComposite:canFire()
  return (self.firstshot and self.x <= self.world.w) or true
end

function QuadComposite:fireMachineGun()
  self.firstshot = false

  if self.target then
    self:fireBulletAtEnemyFrom(self.target, -25, 25)
    self:fireBulletAtEnemyFrom(self.target, 25, 25)
    self:fireBulletAtEnemyFrom(self.target, -25, -25)
    self:fireBulletAtEnemyFrom(self.target, 25, -25)
  end
end

function QuadComposite:fireCannon()
  self.firstshot = false

  if self.target then
    self:fireShellAtEnemyFrom(self.target, 0, -25)
    self:fireShellAtEnemyFrom(self.target, 0, 25)
  end
end

function QuadComposite:fireBulletAtEnemyFrom(enemy, offsetX, offsetY)
  local speed = 800
  local fromX = self.x + offsetX
  local fromY = self.y + offsetY
  local angle = self:findInterceptionAngle(
    enemy.x, enemy.y,
    enemy.velocity.x, enemy.velocity.y,
    fromX, fromY,
    speed
  )

  if angle ~= nil then
    self:fireBullet({
      x = fromX,
      y = fromY,
      speed = speed,
      angle = angle,
      damage = 30
    })
  end
end

function QuadComposite:fireShellAtEnemyFrom(enemy, offsetX, offsetY)
  local speed = 400
  local fromX = self.x + offsetX
  local fromY = self.y + offsetY
  local angle = self:findInterceptionAngle(
    enemy.x, enemy.y,
    enemy.velocity.x, enemy.velocity.y,
    fromX, fromY,
    speed
  )

  if angle ~= nil then
    self:fireShell({
      x = fromX,
      y = fromY,
      speed = speed,
      angle = angle,
      damage = 250
    })
  end
end

return QuadComposite
