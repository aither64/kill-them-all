local Beam = require '../beam'
local Laser = Beam:new()

function Laser:new(opts)
  t = Beam.new(self, opts)
  t.collisionType = 'rectangle'
  t.source = opts.source
  t.speed = opts.speed or 5000
  t.x = t.source.x
  t.w = 0
  t.h = opts.h or 10
  t.y = t.source.y - t.h / 2
  t.firedAt = t:getGameTime()
  t.duration = opts.duration or 10
  return t
end

function Laser:update(dt)
  local maxw = self.world.w - self.x

  self.x = self.source.x

  self.w = self.w + self.speed * dt

  if self.w > maxw then
    self.w = maxw
  end

  self.y = self.source.y - self.h / 2
end

function Laser:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

function Laser:isActive()
  return self.firedAt + self.duration > self:getGameTime()
end

return Laser
