local Player = {}
local Bullet = require "projectiles/bullet"
local PowerUpList = require "powerup_list"

function Player:new(world, x, y)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.x = x
  t.y = y
  t.baseR = 12
  t.r = t.baseR
  t.basespeed = 300
  t.curspeed = 300
  t.maxspeed = 600
  t.acceleration = 20
  t.angle = 0
  t.lastshot = love.timer.getTime()
  t.score = 0
  t.hitpoints = 100
  t.powerups = PowerUpList:new(t)
  return t
end

function Player:update(dt)
  local up = love.keyboard.isDown('up')
  local down = love.keyboard.isDown('down')
  local left = love.keyboard.isDown('left')
  local right = love.keyboard.isDown('right')
  local shift = love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')

  if shift and (up or down or left or right) then
    if (self.curspeed + self.acceleration) < self.maxspeed then
      self.curspeed = self.curspeed + self.acceleration
    end
  else
    self.curspeed = self.basespeed
  end

  if love.keyboard.isDown('up') then
    self.y = self.y - self.curspeed * dt
  end

  if love.keyboard.isDown('down') then
    self.y = self.y + self.curspeed * dt
  end

  if love.keyboard.isDown('left') then
    self.x = self.x - self.curspeed * dt
  end

  if love.keyboard.isDown('right') then
    self.x = self.x + self.curspeed * dt
  end

  if self.x < 0 then
    self.x = 0
  elseif self.x > self.world.w then
    self.x = self.world.w
  end

  if self.y < 0 then
    self.y = 0
  elseif self.y > self.world.h then
    self.y = self.world.h
  end

  self.powerups:update(dt)

  if love.keyboard.isDown('space') then
    now = love.timer.getTime()

    if self.lastshot + 0.1 < now then
      self:fireBullet()
      self.lastshot = now

      if self.powerups:isActive('cannon') then
        local cnt = self.powerups:getCount('cannon')

        self:fireBullet({offsetY = -5})
        self:fireBullet({offsetY = 5})

        if cnt > 1 then
          self:fireBullet({angle = -1 * math.pi / 16})
          self:fireBullet({angle =  1 * math.pi / 16})
        end

        if cnt > 2 then
          self:fireBullet({angle = -1 * math.pi / 14})
          self:fireBullet({angle =  1 * math.pi / 14})
        end

        if cnt > 3 then
          self:fireBullet({angle = -1 * math.pi / 12})
          self:fireBullet({angle =  1 * math.pi / 12})
        end

        if cnt > 4 then
          self:fireBullet({angle = -1 * math.pi / 10})
          self:fireBullet({angle =  1 * math.pi / 10})
        end
      end
    end
  end
end

function Player:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle('fill', 0, 0, self.baseR - 2)
  love.graphics.circle('line', 0, 0, self.baseR)

  if self.powerups:isActive('shield') then
    love.graphics.setColor(0, 255, 238, 255)

    local cnt = self.powerups:getCount('shield')
    local r = self.baseR
    for i = 1,cnt do
      r = r + 2
      love.graphics.circle('line', 0, 0, r)
      if i > 3 then break end
    end

    love.graphics.setColor(168, 250, 244, 255)

    if cnt > 3 then
      r = r+1
      love.graphics.circle('line', 0, 0, r)
    end
    if cnt > 4 then
      r = r+1
      love.graphics.circle('line', 0, 0, r)
    end

    love.graphics.setColor(186, 255, 250, 255)

    if cnt > 5 then
      r = r+1
      love.graphics.circle('line', 0, 0, r)
    end
  end

  love.graphics.pop()
end

function Player:checkCollisionWith(x, y)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(self.r, 2)
end

function Player:checkCollisionWithCircle(x, y, r)
  local distance = math.pow(x - self.x, 2) + math.pow(y - self.y, 2)
  return distance <= math.pow(r, 2) or distance <= math.pow(self.r, 2)
end

function Player:hitByProjectile(projectile)
  if self.powerups:isActive('shield') then
    self.powerups:getTop('shield'):hitByProjectile(projectile)
    return
  end

  self.hitpoints = self.hitpoints - projectile.damage

  if self.hitpoints <= 0 then
    self.score = self.score - 1000
    self.hitpoints = 30
  end
end

function Player:enemyKilled(enemy)
  self.score = self.score + enemy.value
end

function Player:enemyMissed(enemy)
  self.score = self.score - 1000
end

function Player:addPowerUp(powerup)
  self.powerups:activate(powerup)

  if powerup.name == 'shield' then
    local cnt = self.powerups:getCount('shield')

    if cnt > 3 then
      self.r = self.baseR + 3 * 2 + (cnt - 3)
    else
      self.r = self.baseR + cnt * 2
    end
  end
end

function Player:powerUpSpent(powerup, countLeft)
  if powerup.name == 'shield' then
    self.r = self.baseR + countLeft * 2
  end
end

function Player:fireBullet(opts)
  local opts = opts or {}

  self.world:addProjectile(Bullet:new(
    self.world,
    opts.x or self.x + (opts.offsetX or 0),
    opts.y or self.y + (opts.offsetY or 0),
    'enemy',
    opts.damage or 10,
    opts.angle or 0,
    opts.speed or 800
  ))
end

return Player
