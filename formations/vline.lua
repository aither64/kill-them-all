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

function VLine:deploy(opts)
  local opts = opts or {}
  local x = opts.x or self.x or self.world.w + 50
  local y = opts.y or self.y or self.world.h / 2

  -- head
  self.world:addEnemy(self.enemy:new(
    self.world,
    x,
    y
  ))

  -- top wing
  for i = 1,self.wingspan do
    self.world:addEnemy(self.enemy:new(
      self.world,
      x,
      y - i * self.spacing
    ))
  end

  -- bottom wing
  for i = 1,self.wingspan do
    self.world:addEnemy(self.enemy:new(
      self.world,
      x,
      y + i * self.spacing
    ))
  end
end

return VLine
