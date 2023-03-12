local Intro = require '../scenarios/intro'
local Random = require '../scenarios/random'
local LevelInfinite = {}

function LevelInfinite:new(world)
  local t = setmetatable({}, { __index = self })
  t.world = world
  t.scenario = Intro:new({world = world})
  t.intro = true
  t.introDone = false
  return t
end

function LevelInfinite:load()
  self.scenario:load()
end

function LevelInfinite:update(dt)
  if not self.intro or not self.introDone then
    self.scenario:update(dt)
  end

  if not self.introDone and self.scenario:isDone() then
    self.introDone = true
  end
end

function LevelInfinite:draw()
  love.graphics.push()
  self.scenario:draw()
  love.graphics.pop()

  if self.introDone then
    if not self.font then
      self.font = love.graphics.newFont(40)
    end

    love.graphics.setColor(stylesheet.colors.white)
    love.graphics.setFont(self.font)
    love.graphics.printf(
      "Victory!",
      0,
      self.world.h / 2 - 50,
      self.world.w,
      "center"
    )
    love.graphics.printf(
      "Press enter to continue, enter to exit",
      0,
      self.world.h / 2 + 50,
      self.world.w,
      "center"
    )
  end
end

function LevelInfinite:keypressed(key)
  if key == "return" and self.intro and self.introDone then
    self.intro = false
    self.introDone = false
    self.scenario = Random:new({world = self.world})
    self.scenario:load()
  elseif self.scenario then
    self.scenario:keypressed(key)
  end
end

function LevelInfinite:keyreleased(key)
  self.scenario:keyreleased(key)
end

function LevelInfinite:enemyDestroyed(enemy)
  self.scenario:enemyDestroyed(enemy)
end

function LevelInfinite:enemyOut(enemy)
  self.scenario:enemyOut(enemy)
end

function LevelInfinite:friendlyDestroyed(friendly)
  self.scenario:friendlyDestroyed(friendly)
end

function LevelInfinite:friendlyOut(friendly)
  self.scenario:friendlyOut(friendly)
end

function LevelInfinite:powerUpUsed(powerup)
  self.scenario:powerUpUsed(powerup)
end

function LevelInfinite:powerUpOut(powerup)
  self.scenario:powerUpOut(powerup)
end

return LevelInfinite
