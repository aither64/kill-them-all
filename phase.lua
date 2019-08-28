local Phase = {}

function Phase:new(opts)
  local t = setmetatable({}, {__index = self})

  if opts then
    t.opts = opts
    t.startX = opts.startX
    t.startY = opts.startY
    t.endX = opts.endX
    t.endY = opts.endY
    t.w = opts.endX - opts.startX
    t.h = opts.endY - opts.startY
  end

  return t
end

function Phase:start()
  self.startedAt = love.timer.getTime()
  self:load()
end

function Phase:load()

end

function Phase:update(dt)

end

function Phase:draw()

end

function Phase:keypressed()

end

function Phase:isDone()
  return false
end

function Phase:nextPhase()

end

return Phase
