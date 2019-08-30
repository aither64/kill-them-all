local Formation = require '../formation'
local Arrow = Formation:new()

function Arrow:new(opts)
  local t = Formation.new(self, opts)
  t.wingspan = opts.wingspan or 3
  t.enemy = opts.enemy

  if t.enemy.hints and t.enemy.hints.spacing then
    t.spacing = t.enemy.hints.spacing
  else
    t.spacing = opts.spacing or 60
  end

  return t
end

function Arrow:deploy(opts)
  local opts = opts or {}
  local x = opts.x or self.x or self.world.w + 50
  local y = opts.y or self.y or self.world.h / 2

  -- head
  self.world:addEnemy(self.enemy:new({
    world = self.world,
    x = x,
    y = y,
    formation = true
  }))

  -- top wing
  for i = 1,self.wingspan do
    self.world:addEnemy(self.enemy:new({
      world = self.world,
      x = x + i * self.spacing,
      y = y - i * self.spacing,
      formation = true
    }))
  end

  -- bottom wing
  for i = 1,self.wingspan do
    self.world:addEnemy(self.enemy:new({
      world = self.world,
      x = x + i * self.spacing,
      y = y + i * self.spacing,
      formation = true
    }))
  end
end

return Arrow
