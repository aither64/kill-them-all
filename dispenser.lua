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
    active = 0,
    maxactive = opts.maxactive,
    probability = opts.probability,
    cooldown = opts.cooldown or 0,
    maxdelay = opts.maxdelay,
    last = love.timer.getTime()
  }
end

function Dispenser:get()
  local items = {}
  local now = love.timer.getTime()

  for item, opts in pairs(self) do
    if (not opts.maxactive or opts.active < opts.maxactive)
       and
       opts.last + opts.cooldown <= now
       and (
        (opts.maxdelay and opts.last + opts.maxdelay < now)
        or
        love.math.random() <= opts.probability
      )
    then
      opts.last = now
      opts.active = opts.active + 1
      table.insert(items, item)
    end
  end

  return items
end

function Dispenser:decrementActive(item, n)
  local opts = self[item]

  if not opts then
    return
  end

  opts.active = opts.active - n

  if opts.active < 0 then
    opts.active = 0
  end
end

return Dispenser
