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

function HLine:deploy(opts)
  local opts = opts or {}
  local x = opts.x or self.x or self.world.w + 50
  local y = opts.y or self.y or self.world.h / 2

  for i = 1,self.wingspan do
    self.world:addEnemy(self.enemy:new(
      self.world,
      x + (i - 1) * self.spacing,
      y
    ))
  end
end

return HLine
