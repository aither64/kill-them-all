local Phase = require '../phase'
local GameOver = Phase:new()

function GameOver:new(opts)
  local t = Phase.new(self, opts)
  t.font = love.graphics.newFont(40)
  t.player = opts.player
  t.victory = opts.victory
  return t
end

function GameOver:draw()
  love.graphics.translate(self.startX, self.startY)
  love.graphics.push()
  love.graphics.setFont(self.font)

  local msg

  if self.victory then
    msg = "You're just good!"
  else
    msg = "Game over!"
  end

  love.graphics.printf(
    msg,
    0,
    self.h / 2 - 200,
    self.w,
    "center"
  )

  love.graphics.printf(
    string.format("Score: %d", self.player.score),
    0,
    self.h / 2 - 100,
    self.w,
    "center"
  )

  love.graphics.printf(
    string.format("Kills: %d", self.player.kills),
    0,
    self.h / 2 + 0,
    self.w,
    "center"
  )

  love.graphics.printf(
    string.format("Damage: %d", self.player.damageDealt),
    0,
    self.h / 2 + 100,
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
