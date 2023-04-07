local PowerUp = require '../powerup'
local Shield = PowerUp:new()

function Shield:new(opts)
  local t = PowerUp.new(self, opts)
  t.name = 'shield'
  t.class = Shield
  t.stacksize = 6
  t.basehitpoints = 100
  t.hitpoints = t.basehitpoints
  return t
end

function Shield:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.Shield.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.Shield.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('S', -4, -6)

  love.graphics.pop()
end

function Shield:stacked(pos, stacksize)
  self.hitpoints = self.basehitpoints * (stacksize + 1 - pos)
  self:extendBy(30)
end

function Shield:isSpent()
  return PowerUp.isSpent(self) or self.hitpoints <= 0
end

function Shield:takeDamage(damage)
  self.hitpoints = self.hitpoints - damage
end

return Shield
