local PowerUpList = {}

function PowerUpList:new(owner)
  return setmetatable({owner = owner, list = {}}, {__index = self})
end

function PowerUpList:activate(powerup)
  if self.list[powerup.name] and powerup.stacksize > 1 then
    local t = self.list[powerup.name]

    if t.count >= powerup.stacksize then
      t.stack[1] = powerup
    else
      t.count = t.count + 1
      table.insert(t.stack, 1, powerup)
    end
  else
    self.list[powerup.name] = {
      count = 1,
      stack = {powerup}
    }
  end

  powerup:activate()
end

function PowerUpList:isActive(name)
  return self.list[name] ~= nil
end

function PowerUpList:getTop(name)
  for i, p in pairs(self.list[name].stack) do
    return p
  end
end

function PowerUpList:getCount(name)
  return self.list[name].count
end

function PowerUpList:update(dt)
  for i, tbl in pairs(self.list) do
    local toRemove = {}

    for j, p in pairs(tbl.stack) do
      p:update(dt)

      if p:isSpent() then
        table.insert(toRemove, j)
        tbl.count = tbl.count - 1
        self.owner:powerUpSpent(p, tbl.count)
      end
    end

    if tbl.count == 0 then
      self.list[i] = nil
    else
      for index = #toRemove, 1, -1 do
        table.remove(tbl.stack, toRemove[index])
      end
    end
  end
end

return PowerUpList
