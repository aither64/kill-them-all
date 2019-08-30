local ObjectList = {}

function ObjectList:new()
  return setmetatable({
    list = {},
    lastfree = 0
  }, {__index = self})
end

function ObjectList:add(obj)
  for i = self.lastfree,math.huge do
    if not self.list[i] then
      self.list[i] = obj
      self.lastfree = self.lastfree + 1
      return
    end
  end

  table.insert(self.list, obj)
end

function ObjectList:remove(index)
  self.list[index] = false
  self.lastfree = index
end

function ObjectList:pairs()
  local iter, state, var = pairs(self.list)
  return function()
    repeat
      var, val = iter(state, var)
    until val ~= false

    return var, val
  end
end

return ObjectList
