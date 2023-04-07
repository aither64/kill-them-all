local PowerUp = require '../powerup'
local SuperShield = PowerUp:new()

function SuperShield:new(opts)
  local t = PowerUp.new(self, opts)
  t.name = 'supershield'
  t.class = SuperShield
  t.stacksize = 1
  t.basehitpoints = 2000
  t.hitpoints = t.basehitpoints
  return t
end

function SuperShield:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(stylesheet.powerups.SuperShield.bgColor)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)

  love.graphics.setColor(stylesheet.powerups.SuperShield.fontColor)
  love.graphics.setFont(self.font)
  love.graphics.print('S', -4, -6)

  love.graphics.pop()
end

function SuperShield:stacked(pos, stacksize)
  self.hitpoints = self.basehitpoints
  self:extendBy(60)
end

function SuperShield:isSpent()
  return PowerUp.isSpent(self) or self.hitpoints <= 0
end

function SuperShield:takeDamage(damage)
  self.hitpoints = self.hitpoints - damage
end

return SuperShield
