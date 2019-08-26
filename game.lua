World = require 'world'
Topbar = require 'topbar'

local Game = {}

function Game:new(startX, startY, endX, endY)
  local t = setmetatable({}, { __index = self })
  t.startX = startX
  t.startY = startY
  t.endX = endX
  t.endY = endY
  t.w = endX - startX
  t.h = endY - startY
  t.topbar = Topbar:new(t, 0, 0)
  t.world = World:new(
    t,
    startX, startY + t.topbar.h,
    endX, endY - t.topbar.h
  )
  return t
end

function Game:load()
  self.world:load()
end

function Game:update(dt)
  self.world:update(dt)
end

function Game:draw()
  love.graphics.translate(self.startX, self.startY + self.topbar.h)
  love.graphics.push()
  self.world:draw()
  love.graphics.pop()

  self.topbar:draw()
end

return Game
