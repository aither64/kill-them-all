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
  t.pause = false
  t.stop = false
  return t
end

function Game:load()
  self.font = love.graphics.newFont(40)
  self.world:load()
end

function Game:update(dt)
  if not self.pause then
    self.world:update(dt)
  end
end

function Game:draw()
  love.graphics.translate(self.startX, self.startY + self.statusbar.h)
  love.graphics.push()
  self.world:draw()
  love.graphics.pop()

  self.statusbar:draw()

  if self.pause then
    love.graphics.setFont(self.font)
    love.graphics.printf(
      'Paused',
      0, self.h / 2, self.w,
      "center"
    )
  end
end

function Game:keypressed(key)
  if key == "escape" then
    self.stop = true
  elseif key == "p" then
    self.pause = not self.pause
  else
    self.world:keypressed(key)
  end
end

function Game:gameOver()
  self.stop = true
  self.victory = false
end

function Game:gameFinished()
  self.stop = true
  self.victory = true
end

function Game:isDone()
  return self.stop
end

function Game:nextPhase()
  self.opts.player = self.world.player
  self.opts.victory = self.victory

  return require('phases/gameover'), self.opts
end

return Game
