local WorldEntity = require 'world_entity'
local PowerUp = WorldEntity:new()

function PowerUp:new(world, x, y, target)
  local t = WorldEntity.new(self, {world = world})
  t.type = self
  t.collisionType = 'circle'
  t.x = x
  t.y = y
  t.r = 12
  t.baseAngle = math.pi
  t.angle = t.baseAngle
  t.baseSpeed = 100
  t.speed = t.baseSpeed
  t.target = target
  t.name = 'undefined'
  t.stacksize = 1
  t.duration = 60
  t.active = false
  t.font = love.graphics.newFont(12)
  t.atraction = false
  return t
end

function PowerUp:update(dt)
  if not self.active then
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
  end
end

function PowerUp:draw(dt)

end

function PowerUp:attractTo(x, y)
  self.atraction = true
  self.speed = self.speed * 2
  self.angle = math.atan2(y - self.y, x - self.x)
end

function PowerUp:isAttracted()
  return self.atraction
end

function PowerUp:activate(stacksize)
  self.active = true
  self.activeSince = self:getGameTime()
end

function PowerUp:stacked(pos, stacksize)
end

function PowerUp:isSpent()
  if self.duration > 0 then
    now = self:getGameTime()

    if self.activeSince + self.duration < now then
      return true
    end
  end

  return false
end

function PowerUp:extendBy(secs)
  local timeleft = self.duration - (self:getGameTime() - self.activeSince)

  if timeleft + secs > self.duration then
    self.activeSince = self.activeSince + self.duration - timeleft
  else
    self.activeSince = self.activeSince + secs
  end
end

function PowerUp:isOut()
  return self.x < self.world.startX
    or self.x > self.world.w
    or self.y < self.world.startY
    or self.y > self.world.h
end

return PowerUp
