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

function Armament:fire(name)
  self:fireWeapon(self.weapons[name])
end

function Armament:fireAll()
  local now = love.timer.getTime()

  for i, w in pairs(self.weapons) do
    self:fireWeapon(w, now)
  end
end

function Armament:fireWeapon(weapon, now)
  local now = now or love.timer.getTime()

  if weapon.lastshot == nil or weapon.lastshot + weapon.frequency < now then
    weapon.fire()
    weapon.lastshot = now
  end
end

return Armament
