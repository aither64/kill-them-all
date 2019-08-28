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
  local p = self.game.world.player

  love.graphics.translate(self.x, self.y)
  love.graphics.push()

  love.graphics.setFont(self.font)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.line(0, self.h, self.w, self.h)

  love.graphics.printf(
    string.format(
      "Lives: %d/%d",
      p.lives,
      p.maxlives
    ),
    10,
    0,
    200,
    "left"
  )
  love.graphics.printf(
    string.format(
      "HP: %d/%d",
      p.hitpoints,
      p.basehitpoints
    ),
    200,
    0,
    200,
    "left"
  )

  if p.powerups:isActive('supershield') then
    self:shieldStatus(p.powerups:getTop('supershield'))

  elseif p.powerups:isActive('shield') then
    self:shieldStatus(p.powerups:getTop('shield'))
  end

  love.graphics.printf(
    string.format(
      "Kills: %d",
      p.kills
    ),
    600,
    0,
    200,
    "left"
  )

  love.graphics.printf(
    string.format("Score: %d", p.score),
    self.w - 200,
    0,
    200,
    "right"
  )

  love.graphics.pop()
end

function StatusBar:shieldStatus(shield)
  love.graphics.printf(
    string.format(
      "Shield: %d",
      shield.hitpoints
    ),
    400,
    0,
    200,
    "left"
  )
end

return StatusBar
