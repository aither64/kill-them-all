local Formation = require '../formation'
local VLine = Formation:new()

function VLine:new(opts)
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

function VLine:deploy(world)
  -- head
  world:addEnemy(self.enemy:new(
    world,
    world.w + 50,
    world.h / 2
  ))

  -- top wing
  for i = 1,self.wingspan do
    world:addEnemy(self.enemy:new(
      world,
      world.w + 50,
      world.h / 2 - i * self.spacing
    ))
  end

  -- bottom wing
  for i = 1,self.wingspan do
    world:addEnemy(self.enemy:new(
      world,
      world.w + 50,
      world.h / 2 + i * self.spacing
    ))
  end
end

return VLine
