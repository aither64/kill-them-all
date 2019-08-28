local PowerUp = {}

function PowerUp:new(world, x, y, target)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.x = x
  t.y = y
  t.r = 12
  t.target = target
  t.name = 'undefined'
  t.stacksize = 1
  t.duration = 60
  t.active = false
  t.font = love.graphics.newFont(12)
  return t
end

function PowerUp:update(dt)

end

function PowerUp:draw(dt)

end

function PowerUp:activate(stacksize)
  self.active = true
  self.activeSince = love.timer.getTime()
end

function PowerUp:stacked(pos, stacksize)
end

function PowerUp:isSpent()
  if self.duration > 0 then
    now = love.timer.getTime()

    if self.activeSince + self.duration < now then
      return true
    end
  end

  return false
end

function PowerUp:extendBy(secs)
  local timeleft = self.duration - (love.timer.getTime() - self.activeSince)

  if timeleft + secs > self.duration then
    self.activeSince = self.activeSince + self.duration - timeleft
  else
    self.activeSince = self.activeSince + secs
  end
end

function PowerUp:isOut()
  return self.x < self.world.startX or self.x > self.world.w
end

return PowerUp
