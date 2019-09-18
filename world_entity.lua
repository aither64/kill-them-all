local WorldEntity = {}

function WorldEntity:new(opts)
  local opts = opts or {}
  return setmetatable({
    world = opts.world
  }, {__index = self})
end

function WorldEntity:getGameTime()
  return self.world.game.gameTime:getTime()
end

return WorldEntity
