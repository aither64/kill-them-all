local StatusBar = {}

function StatusBar:new(game, x, y)
  local t = setmetatable({}, { __index = self })
  t.game = game
  t.x = x
  t.y = y
  t.w = game.endX - x
  t.h = 30
  t.font = love.graphics.newFont(22)
  return t
end

function StatusBar:draw()
  love.graphics.translate(self.x, self.y)
  love.graphics.push()

  love.graphics.setFont(self.font)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.line(0, self.h, self.w, self.h)

  love.graphics.printf(
    string.format(
      "Lives: %d/%d",
      self.game.world.player.lives,
      self.game.world.player.maxlives
    ),
    10,
    0,
    200,
    "left"
  )
  love.graphics.printf(
    string.format("Score: %d", self.game.world.player.score),
    self.w - 200,
    0,
    200,
    "right"
  )

  love.graphics.pop()
end

return StatusBar
