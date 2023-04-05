local TargetLock = {}

TargetLock.strategy = {
  edge = 0,
  closest = 1,
}

function TargetLock:new(opts)
  return setmetatable({
    world = opts.world,
    owner = opts.owner,
    strategy = opts.strategy or TargetLock.strategy.edge,
    target = opts.target or nil,
    age = 0,
    maxAge = opts.maxAge or 0.3,
    damageDealt = 0,
    maxDamageDealt = nil,
  }, {__index = self})
end

function TargetLock:isLocked()
  if self.target then
    return true
  else
    return false
  end
end

function TargetLock:findTarget(dt)
  local refreshTarget = false
  local previousTarget = nil

  self.age = self.age + dt

  if self.target and self.target:isDestroyed() then
    self.target = nil
  end

  if not self.target or (self.maxAge and self.age > self.maxAge) then
    refreshTarget = true
  elseif self.maxDamageDealt and self.damageDealt >= self.maxDamageDealt then
    refreshTarget = true
    previousTarget = self.target
  end

  if refreshTarget then
    if self.target then
      self.target:releaseTarget()
    end

    if self.strategy == TargetLock.strategy.closest then
      self.target = self.world:findClosestEnemy(
        self.owner.x,
        self.owner.y,
        {newTarget = true, exclude = {previousTarget}}
      )
    elseif self.strategy == TargetLock.strategy.edge then
      self.target = self.world:findEdgeEnemy(
        {newTarget = true, exclude = {previousTarget}}
      )
    else
      return nil
    end

    if self.target then
      self.target:setTargeted(self)
      self.age = 0
      self.damageDealt = 0
      self.maxDamageDealt = self.target.hitpoints * 1.2
    end
  end

  return self.target
end

function TargetLock:release()
  if self.target then
    self.target:releaseTarget()
    self.target = nil
  end
end

function TargetLock:addDamageDealt(damage)
  self.damageDealt = self.damageDealt + damage
end

return TargetLock
