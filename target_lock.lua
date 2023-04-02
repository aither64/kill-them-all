local TargetLock = {}

function TargetLock:new(opts)
  return setmetatable({
    world = opts.world,
    owner = opts.owner,
    target = opts.target or nil,
    age = 0,
    maxAge = opts.maxAge or 0.3,
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
  self.age = self.age + dt

  if self.target and self.target:isDestroyed() then
    self.target = nil
  end

  if not self.target or (self.maxAge and self.age > self.maxAge) then
    if self.target then
      self.target:releaseTarget()
    end

    self.target = self.world:findClosestEnemy(self.owner.x, self.owner.y, {newTarget = true})

    if self.target then
      self.target:setTargeted(self)
      self.age = 0
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

return TargetLock
