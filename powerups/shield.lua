local PowerUp = require '../powerup'
local Shield = PowerUp:new(nil, 0, 0, nil)

function Shield:new(world, x, y, target)
  t = PowerUp.new(self, world, x, y, target)
  t.name = 'shield'
  t.stacksize = 5
  t.basehitpoints = 50
  t.hitpoints = t.basehitpoints
  return t
end

function Shield:update(dt)
  if not self.active then
    self.x = self.x - 100 * dt
  end
end

function Shield:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  love.graphics.setColor(0, 255, 238, 255)
  love.graphics.circle('fill', 0, 0, self.r-2)
  love.graphics.circle('line', 0, 0, self.r)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print('S', -4, -6)

  love.graphics.pop()
end

function Shield:stacked(pos, stacksize)
  self.hitpoints = self.basehitpoints * math.pow(2, pos)
end

function Shield:isSpent()
  return PowerUp.isSpent(self) or self.hitpoints <= 0
end

function Shield:hitByProjectile(projectile)
  self.hitpoints = self.hitpoints - projectile.damage
end

return Shield
