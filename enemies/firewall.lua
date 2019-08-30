local Enemy = require '../enemy'
local Firewall = Enemy:new()

function Firewall:new(opts)
  local t = Enemy.new(self, opts)
  t.r = 700
  t.w = 20
  t.x = t.world.w + t.r
  t.y = t.world.h / 2
  t.hitpoints = 300000
  t.value = 10000
  t.speed = 10
  return t
end

function Firewall:update(dt)
  maxw = self.world.w + self.r

  if self.x > (maxw - maxw / 4) then
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
