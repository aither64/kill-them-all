Phase = require '../phase'
World = require '../world'
StatusBar = require '../statusbar'

local Game = Phase:new()

function Game:new(opts)
  local t = Phase.new(self, opts)
  t.statusbar = StatusBar:new(t, 0, 0)
  t.world = World:new(
    t,
    t.startX, t.startY + t.statusbar.h,
    t.endX, t.endY - t.statusbar.h
  )
  t.stop = false
  return t
end

function Game:load()
  self.world:load()
end

function Game:update(dt)
  self.world:update(dt)
end

function Game:draw()
  love.graphics.translate(self.startX, self.startY + self.statusbar.h)
  love.graphics.push()
  self.world:draw()
  love.graphics.pop()

  self.statusbar:draw()
end

function Game:keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function Game:gameOver()
  self.stop = true
end

function Game:isDone()
  return self.stop
end

function Game:nextPhase()
  return require('phases/gameover'), self.opts
end

return Game
