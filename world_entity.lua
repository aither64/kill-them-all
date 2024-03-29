local WorldEntity = {}

function WorldEntity:new(opts)
  local opts = opts or {}
  return setmetatable({
    world = opts.world
  }, {__index = self})
end

function WorldEntity:getGameTime()
  return self.world.game.gameTime:getTime()
end

function WorldEntity:setVelocity(speed, angle)
  self.velocity = {
    x = math.cos(angle) * speed,
    y = math.sin(angle) * speed
  }
end

function WorldEntity:cloneAudio(audio)
  local ret = {}

  for k, v in pairs(audio) do
    ret[k] = v:clone()
  end

  return ret
end

function WorldEntity:findInterceptionAngle(targetX, targetY, speedX, speedY, fromX, fromY, interceptSpeed)
  local x, y = self:findInterceptionPoint(
    targetX, targetY,
    speedX, speedY,
    fromX, fromY,
    interceptSpeed
  )

  if x == nil then
    return nil
  end

  return math.atan2(y - fromY, x - fromX)
end

-- Based on
--   http://jaran.de/goodbits/2011/07/17/calculating-an-intercept-course-to-a-target-with-constant-direction-and-velocity-in-a-2-dimensional-plane/
function WorldEntity:findInterceptionPoint(targetX, targetY, speedX, speedY, fromX, fromY, speed)
  local ox = targetX - fromX
  local oy = targetY - fromY

  local h1 = speedX * speedX + speedY * speedY - speed * speed
  local h2 = ox * speedX + oy * speedY
  local t

  if h1 == 0 then -- problem collapses into a simple linear equation
    t = -(ox * ox + oy * oy) / (2 * h2)
  else -- // solve the quadratic equation
    local minusPHalf = -h2 / h1;

    local discriminant = minusPHalf * minusPHalf - (ox * ox + oy * oy) / h1 -- term in brackets is h3
    if discriminant < 0 then -- no (real) solution then...
      return nil
    end

    local root = math.sqrt(discriminant)

    local t1 = minusPHalf + root
    local t2 = minusPHalf - root

    local tMin = math.min(t1, t2);
    local tMax = math.max(t1, t2);

    -- get the smaller of the two times, unless it's negative
    if tMin > 0 then
      t = tMin
    else
      t = tMax
    end

    if t < 0 then -- we don't want a solution in the past
      return nil;
    end
  end

  -- calculate the point of interception using the found intercept time and return it
  return (targetX + t * speedX), (targetY + t * speedY)
end

function WorldEntity:checkCollisionCircleRectangle(cx, cy, cr, rx, ry, rw, rh)
  local clamp = function (x, min, max)
    if x < min then
      return min
    elseif x > max then
      return max
    else
      return x
    end
  end

  -- Find the closest point to the circle within the rectangle
  local closestX = clamp(cx, rx, rx + rw)
  local closestY = clamp(cy, ry, ry + rh)

  -- Calculate the distance between the circle's center and this closest point
  local distanceX = cx - closestX
  local distanceY = cy - closestY

  -- If the distance is less than the circle's radius, an intersection occurs
  local distanceSquared = math.pow(distanceX, 2) + math.pow(distanceY, 2)
  return distanceSquared < math.pow(cr, 2)
end

return WorldEntity
