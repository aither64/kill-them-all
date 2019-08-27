local PowerUpList = {}

function PowerUpList:new(owner)
  return setmetatable({owner = owner, list = {}}, {__index = self})
end

function PowerUpList:activate(powerup)
  self.list[powerup.name] = powerup
end

function PowerUpList:isActive(name)
  return self.list[name] ~= nil
end

function PowerUpList:get(name)
  return self.list[name]
end

function PowerUpList:update(dt)
  for i, p in pairs(self.list) do
    p:update(dt)

    if p:isSpent() then
      self.list[p.name] = nil
      self.owner:powerUpSpent(p)
    end
  end
end

return PowerUpList
