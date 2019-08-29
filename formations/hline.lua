local Formation = require '../formation'
local HLine = Formation:new()

function HLine:new(opts)
  local t = Formation.new(self, opts)
  t.wingspan = opts.wingspan or 6
  t.enemy = opts.enemy

  if t.enemy.hints and t.enemy.hints.spacing then
    t.spacing = t.enemy.hints.spacing
  else
    t.spacing = opts.spacing or 60
  end

  return t
end

function HLine:deploy(world)
  for i = 1,self.wingspan do
    world:addEnemy(self.enemy:new(
      world,
      world.w + 50 + (i - 1) * self.spacing,
      world.h / 2
    ))
  end
end

return HLine
