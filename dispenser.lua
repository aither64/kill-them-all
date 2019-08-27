local Dispenser = {}

function Dispenser:new(items)
  return setmetatable(items or {}, {__index = self})
end

function Dispenser:add(item, probability)
  self[item] = probability
end

function Dispenser:get()
  items = {}

  for item, prob in pairs(self) do
    if love.math.random() <= prob then
      table.insert(items, item)
    end
  end

  return items
end

return Dispenser
