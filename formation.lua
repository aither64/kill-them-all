local Formation = {}

function Formation:new(opts)
  local t = setmetatable({}, {__index = self})

  if opts then
    t.world = opts.world
    t.x = opts.x
    t.y = opts.y
  end

  return t
end

function Formation:deploy(opts)

end

return Formation
