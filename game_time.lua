local GameTime = {}

function GameTime:new()
  return setmetatable({
    offset = 0
  }, {__index = self})
end

function GameTime:getTime()
  return love.timer.getTime() + self.offset
end

function GameTime:pause()
  self.pausedAt = love.timer.getTime()
end

function GameTime:resume()
  now = love.timer.getTime()
  self.offset = self.offset + (self.pausedAt - now)
  self.pausedAt = nil
end

return GameTime
