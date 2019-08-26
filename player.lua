local Player = {}
local Projectile = require "projectile"

function Player:new(x, y)
  local t = setmetatable({}, { __index = self })
  t.x = x
  t.y = y
  t.basespeed = 300
  t.curspeed = 300
  t.maxspeed = 600
  t.acceleration = 20
  t.angle = 0
  t.projectiles = {}
  t.lastshot = love.timer.getTime()
  return t
end

function Player:update(dt, w, h)
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
  elseif self.x > w then
    self.x = w
  end

  if self.y < 0 then
    self.y = 0
  elseif self.y > h then
    self.y = h
  end

  if love.keyboard.isDown('space') then
    now = love.timer.getTime()

    if self.lastshot + 0.1 < now then
      self:addProjectile(Projectile:new(self.x, self.y))
      self.lastshot = now
    end
  end
end

function Player:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle('fill', 0, 0, 10)
  love.graphics.circle('line', 0, 0, 12)

  love.graphics.pop()
end

function Player:addProjectile(projectile)
  for i, p in pairs(self.projectiles) do
    if p == nil then
      self.projectiles[i] = projectile
      return
    end
  end

  table.insert(self.projectiles, projectile)
end

return Player
