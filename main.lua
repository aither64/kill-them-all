local Intro = require 'phases/intro'
local baseW = 1280
local baseH = 720
local phase = nil

function love.load()
  local _, _, flags = love.window.getMode()
  local width, height = love.window.getDesktopDimensions(flags.display)

  love.window.setMode(width, height, {resizable = false})

  phase = Intro:new({
    startX = 0,
    startY = 0,
    endX = width,
    endY = height
  })
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
