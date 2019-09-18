local WorldEntity = {}

function WorldEntity:new(opts)
  local opts = opts or {}
  return setmetatable({
    world = opts.world
  }, {__index = self})
end

return WorldEntity
