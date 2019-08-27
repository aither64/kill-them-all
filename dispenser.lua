local Dispenser = {}

function Dispenser:new(items)
  local t = setmetatable({}, {__index = self})

  for item, opts in pairs(items) do
    t:add(item, opts)
  end

  return t
end

function Dispenser:add(item, opts)
  self[item] = {
    probability = opts.probability,
    maxdelay = opts.maxdelay,
    last = love.timer.getTime()
  }
end

function Dispenser:get()
  local items = {}
  local now = love.timer.getTime()

  for item, opts in pairs(self) do
    if (opts.maxdelay and opts.last + opts.maxdelay < now) or love.math.random() <= opts.probability then
      opts.last = now
      table.insert(items, item)
    end
  end

  return items
end

return Dispenser
