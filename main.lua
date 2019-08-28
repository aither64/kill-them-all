local Intro = require 'phases/intro'
local w = 1280
local h = 720
local phase = Intro:new({
  startX = 0,
  startY = 0,
  endX = w,
  endY = h
})

function love.load()
  love.window.setMode(w, h, {resizable = false})
  phase:start()
end

function love.update(dt)
  phase:update(dt)

  if phase:isDone() then
    type, opts = phase:nextPhase()
    phase = type:new(opts)
    phase:start()
    phase:update(dt)
  end
end

function love.draw()
  phase:draw()
end

function love.keypressed(key)
  phase:keypressed(key)
end
