local ObjectList = {}

function ObjectList:new()
  return setmetatable({list = {}}, {__index = self})
end

function ObjectList:add(obj)
  for i, o in pairs(self.list) do
    if obj == nil then
      self.list[i] = obj
      return
    end
  end

  table.insert(self.list, obj)
end

function ObjectList:remove(index)
  self.list[index] = false
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
