local PowerUp = require '../powerup'
local SuperShield = PowerUp:new(nil, 0, 0, nil)

function SuperShield:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'supershield'
  t.stacksize = 1
  t.basehitpoints = 2000
  t.hitpoints = t.basehitpoints
  return t
end

function SuperShield:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(255, 237, 36, 255)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)
  love.graphics.setColor(0, 0, 0, 255)

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

function SuperShield:hitByProjectile(projectile)
  self.hitpoints = self.hitpoints - projectile.damage
end

return SuperShield
