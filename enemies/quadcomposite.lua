local Enemy = require '../enemy'
local Armament = require "armament"
local SimpleExplosion = require 'explosions/simple'
local QuadComposite = Enemy:new()

QuadComposite.hints = {
  spacing = 140
}

function QuadComposite:new(opts)
  local t = Enemy.new(self, opts)
  t.armament = Armament:new()
  t.armament:add('machinegun', {
    frequency = 1.5,
    fire = function() t:fireMachineGun() end
  })
  t.armament:add('cannon', {
    frequency = 1.5,
    fire = function() t:fireCannon() end
  })
  t.speed = 10
  t.hitpoints = 5000
  t.value = 1000
  t:init()
  return t
end

function QuadComposite:update(dt)
  if self.x > (self.world.w - self.world.w / 6) then
    self.x = self.x - self.speed * dt
  end

  if self:canFire() then
    self.armament:fireAll(self:getGameTime())
  end
end

function QuadComposite:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  local alpha = 0.4 + self.hitpoints / self.baseHitpoints

  love.graphics.setColor(stylesheet.enemies.QuadComposite.outlineColor:withAlpha(alpha))
  love.graphics.circle('line', 0, 0, 80)
  love.graphics.circle('line', 0, 0, 79)

  love.graphics.setColor(stylesheet.enemies.QuadComposite.bodyColor:withAlpha(alpha))
  love.graphics.circle('fill', -25, 25, 30)
  love.graphics.circle('fill', 25, 25, 30)
  love.graphics.circle('fill', -25, -25, 30)
  love.graphics.circle('fill', 25, -25, 30)

  love.graphics.setColor(stylesheet.enemies.QuadComposite.inlineColor:withAlpha(alpha))
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

function QuadComposite:checkCollisionWithRectangle(x, y, w, h)
  return self:checkCollisionCircleRectangle(self.x, self.y, 80, x, y, w, h)
end

function QuadComposite:doCheckCollision(x, y, r)
  local r2 = math.pow(80 + r, 2)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= r2
end

function QuadComposite:destroyed()
  Enemy.destroyed(self)

  self.world:addExplosion(SimpleExplosion:new({
    world = self.world,
    owner = self,
    x = self.x,
    y = self.y,
    color = stylesheet.explosions.Simple.enemyBaseColor,
    lethal = "player",
    damage = 20,
    speed = 200,
    maxSize = 160,
  }))
end

function QuadComposite:canFire()
  return (self.firstshot and self.x <= self.world.w) or true
end

function QuadComposite:fireMachineGun()
  self.firstshot = false

  self:fireBulletAtAngleFrom(-25, 25)
  self:fireBulletAtAngleFrom(25, 25)
  self:fireBulletAtAngleFrom(-25, -25)
  self:fireBulletAtAngleFrom(25, -25)
end

function QuadComposite:fireCannon()
  self.firstshot = false

  self:fireShellAtAngleFrom(0, -25)
  self:fireShellAtAngleFrom(0, 25)
end

function QuadComposite:fireBulletAtAngleFrom(offsetX, offsetY)
  self:fireBullet({
    offsetX = offsetX,
    offsetY = offsetY,
    damage = 20,
    speed = 300,
    angle = self:calcAngleToPlayer(offsetX, offsetY)
  })
end

function QuadComposite:fireShellAtAngleFrom(offsetX, offsetY)
  self:fireShell({
    offsetX = offsetX,
    offsetY = offsetY,
    damage = 100,
    speed = 400,
    angle = self:calcAngleToPlayer(offsetX, offsetY)
  })
end

return QuadComposite
