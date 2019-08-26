local World = require 'world'
local w = 1280
local h = 720
local world = World:new(w, h)

function love.load()
  love.window.setMode(w, h, {resizable = false})
  world:load()
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  world:draw()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
