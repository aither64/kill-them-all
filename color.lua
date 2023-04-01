local Color = {}

function Color:new(r, g, b, a)
  return setmetatable({r, g, b, a}, {__index = self})
end

function Color:withAlpha(alpha)
  return Color:new(self[1], self[2], self[3], alpha)
end

return Color
