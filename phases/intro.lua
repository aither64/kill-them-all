local Phase = require '../phase'
local Intro = Phase:new()

function Intro:new(opts)
  local t = Phase.new(self, opts)
  t.font = love.graphics.newFont(40)
  t.skip = false
  return t
end

function Intro:draw()
  love.graphics.translate(self.startX, self.startY)
  love.graphics.push()
  love.graphics.setFont(self.font)

  love.graphics.printf(
    "ratatatatatata presents",
    0,
    self.h / 2 - 40,
    self.w,
    "center"
  )

  if self.startedAt + 1 < love.timer.getTime() then
    love.graphics.printf(
      "Kill 'em All or Die!",
      0,
      self.h / 2 + 40,
      self.w,
      "center"
    )
  end

  love.graphics.pop()
end

function Intro:keypressed(key)
  if key == "space" then
    self.skip = true
  end
end

function Intro:isDone()
  return self.skip or self.startedAt + 3 < love.timer.getTime()
end

function Intro:nextPhase()
  return require('./phases/game'), self.opts
end

return Intro
