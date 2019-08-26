local Game = require 'game'
local w = 1280
local h = 720
local game = Game:new(0, 0, w, h)

function love.load()
  love.window.setMode(w, h, {resizable = false})
  game:load()
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
