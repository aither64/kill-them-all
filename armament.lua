local Armament = {}

function Armament:new()
  return setmetatable({weapons = {}}, {__index = self})
end

function Armament:add(name, opts)
  self.weapons[name] = {
    frequency = opts.frequency,
    fire = opts.fire,
    lastshot = nil,
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
  if weapon.lastshot == nil or weapon.lastshot + weapon.frequency < time then
    weapon.fire()
    weapon.lastshot = time
  end
end

return Armament
