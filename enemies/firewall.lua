local Enemy = require '../enemy'
local Firewall = Enemy:new()

Firewall.hints = {
  spacing = 60,
  r = 700
}

function Firewall:new(opts)
  local t = Enemy.new(self, opts)
  t.r = Firewall.hints.r
  t.w = 20

  if not t.formation then
    t.x = t.world.w + t.r
    t.y = t.world.h / 2
  end

  if opts.border then
    t.border = opts.border
  else
    local maxw = t.world.w + t.r
    t.border = maxw - maxw / 4
  end

  t.hitpoints = 300000
  t.value = 10000
  t.speed = 10
  return t
end

function Firewall:update(dt)
  if self.x > self.border then
    self.x = self.x - self.speed * dt
  end
end

function Firewall:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 0, 0, 255)

  for r = self.r,self.r+self.w,2 do
    love.graphics.circle('line', 0, 0, r)
  end

  love.graphics.pop()
end

function Firewall:checkCollisionWithPoint(x, y)
  return self:doCheckCollision(x, y, 0)
end

function Firewall:checkCollisionWithCircle(x, y, r)
  return self:doCheckCollision(x, y, r)
end

function Firewall:doCheckCollision(x, y, r)
  local startR2 = math.pow(self.r, 2)
  local endR2 = math.pow(self.r + self.w, 2)
  local distance = math.pow(x - self.x, 2) + math.pow(y - self.y, 2)

  return distance >= startR2 and distance <= endR2
end

return Firewall
