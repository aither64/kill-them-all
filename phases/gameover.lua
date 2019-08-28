local Phase = require '../phase'
local GameOver = Phase:new()

function GameOver:new(opts)
  local t = Phase.new(self, opts)
  t.font = love.graphics.newFont(40)
  return t
end

function GameOver:draw()
  love.graphics.translate(self.startX, self.startY)
  love.graphics.push()
  love.graphics.setFont(self.font)

  love.graphics.printf(
    "Game over!",
    0,
    self.h / 2 - 40,
    self.w,
    "center"
  )

  love.graphics.pop()
end

function GameOver:keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function GameOver:isDone()
  return false
end

return GameOver
