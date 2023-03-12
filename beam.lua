local WorldEntity = require 'world_entity'
local Beam = WorldEntity:new()

function Beam:new(opts)
  local t = WorldEntity.new(self, opts)

  if opts then
    t.owner = opts.owner

    if opts.x and opts.y then
      t.x = opts.x
      t.w = t.world.w - t.x
      t.y = opts.y
      t.h = opts.h
    end

    t.lethal = opts.lethal or 'all'
    t.damage = opts.damage or 10000
  end

  return t
end

function Beam:update(dt)

end

function Beam:isActive()
  return false
end

function Beam:hit(target)
  if self.owner then
    self.owner:beamHit(self, target)
  end
end

function Beam:discharged()
  if self.owner then
    self.owner:beamDischarged(self)
  end
end

return Beam
