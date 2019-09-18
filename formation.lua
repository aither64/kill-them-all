local WorldEntity = require 'world_entity'
local Formation = WorldEntity:new()

function Formation:new(opts)
  local t = WorldEntity.new(self, opts)

  if opts then
    t.x = opts.x
    t.y = opts.y
  end

  return t
end

function Formation:deploy(opts)

end

return Formation
