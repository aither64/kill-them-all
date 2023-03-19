local Armament = {}

function Armament:new()
  return setmetatable({weapons = {}}, {__index = self})
end

function Armament:add(name, opts)
  self.weapons[name] = {
    frequency = opts.frequency,
    fire = opts.fire,
    lastShot = nil,
    burstFrequency = opts.burstFrequency or nil,
    burstShots = opts.burstShots or 3,
    burstOpen = false,
    currentBurstShots = 0,
    lastBurst = nil,
  }
end

function Armament:remove(name)
  self.weapons[name] = nil
end

function Armament:contains(name)
  return self.weapons[name] ~= nil
end

function Armament:reset()
  self.weapons = {}
end

function Armament:fire(name)
  self:fireWeapon(self.weapons[name])
end

function Armament:fireAll(time)
  for i, w in pairs(self.weapons) do
    self:fireWeapon(w, time)
  end
end

function Armament:fireWeapon(weapon, time)
  if weapon.burstFrequency then
    self:fireBurst(weapon, time)
  else
    self:fireShot(weapon, time)
  end
end

function Armament:fireBurst(weapon, time)
  if weapon.burstOpen then
    self:fireShotInBurst(weapon, time)
  elseif not weapon.lastBurst or weapon.lastBurst + weapon.burstFrequency < time then
    weapon.burstOpen = true
    weapon.lastShot = nil
    self:fireShotInBurst(weapon, time)
  end
end

function Armament:fireShotInBurst(weapon, time)
  if self:fireShot(weapon, time) then
    weapon.currentBurstShots = weapon.currentBurstShots + 1

    if weapon.currentBurstShots >= weapon.burstShots then
      weapon.burstOpen = false
      weapon.currentBurstShots = 0
      weapon.lastBurst = time
    end
  end
end

function Armament:fireShot(weapon, time)
  if weapon.lastShot == nil or weapon.lastShot + weapon.frequency < time then
    weapon.fire()
    weapon.lastShot = time
    return true
  end

  return false
end

return Armament
