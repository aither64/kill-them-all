local Formation = {}

function Formation:new(opts)
  local t = setmetatable({}, {__index = self})
  return t
end

function Formation:deploy(world)

end

return Formation
