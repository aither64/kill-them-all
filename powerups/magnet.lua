local PowerUp = require '../powerup'
local Magnet = PowerUp:new()

function Magnet:new(opts)
  local t = PowerUp.new(self, opts)
  t.name = 'magnet'
  t.class = Magnet
  t.pickable = false
  t.stacksize = 1
  t.duration = 12
  t.mode = 'inactive'
  t.circles = { 80, 40 }
  return t
end

function Magnet:update(dt)
  PowerUp.update(self, dt)

  if self.mode == 'active' and self.activeSince + 8 < self:getGameTime() then
    self.mode = 'finishing'
    self.world:removeCallback('addProjectile', 'magnet')
    self.world:removeCallback('addMissile', 'magnet')
  end

  for i, c in pairs(self.circles) do
    self.circles[i] = self.circles[i] - 40 * dt

    if self.circles[i] <= self.r then
      self.circles[i] = 80
    end
  end
end

function Magnet:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.Magnet.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.Magnet.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('M', -6, -6)

  if self.active then
    love.graphics.setColor(stylesheet.powerups.Magnet.activeColor)
    for i, c in pairs(self.circles) do
      love.graphics.circle('line', 0, 0, c)
    end
  end

  love.graphics.pop()
end

function Magnet:activate()
  PowerUp.activate(self)

  self.mode = 'active'

  -- Redirect projectiles
  self.world:addCallback('addProjectile', 'magnet', function (p)
    if p.lethal == 'player' then
      p:redirect(self:getAngleFrom(p.x, p.y))
    end
  end)

  self.world:addCallback('projectileCollision', 'magnet', function (p)
    return self.world:checkCollision(self, p, {r = self.r * 2})
  end)

  for i, p in self.world.projectiles:pairs() do
    if p.lethal == 'player' then
      p:redirect(self:getAngleFrom(p.x, p.y))
    end
  end

  -- Redirect missiles
  self.world:addCallback('addMissile', 'magnet', function (m)
    if m.lethal == 'player' then
      m:redirect(self:getAngleFrom(m.x, m.y))
    end
  end)

  self.world:addCallback('missileCollision', 'magnet', function (m)
    return self.world:checkCollision(self, m, {r = self.r * 8})
  end)

  for i, m in self.world.missiles:pairs() do
    if m.lethal == 'player' then
      m:redirect(self:getAngleFrom(m.x, m.y))
    end
  end
end

function Magnet:deactivate()
  self.world:removeCallback('projectileCollision', 'magnet')
  self.world:removeCallback('missileCollision', 'magnet')
end

function Magnet:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function Magnet:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function Magnet:doCheckCollision(x, y, r)
  return math.pow(x - self.x, 2) + math.pow(y - self.y, 2) <= math.pow(self.r + r, 2)
end

function Magnet:getAngleFrom(x, y)
  return math.atan2(self.y - y, self.x - x)
end

return Magnet
