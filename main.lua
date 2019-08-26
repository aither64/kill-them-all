Player = require 'player'
Enemy = require 'enemy'

local w = 1280
local h = 720
local player = Player:new(50, h / 2)
local enemies = {}

function love.load()
  love.window.setMode(w, h, {resizable = false})

  for i = 1,5 do
    -- enemies[i] = Enemy:new(w, h - 100 * i)
    enemies[i] = Enemy:new(w + 50, 100 + 100*i)
  end
end

function love.update(dt)
  player:update(dt, w, h)

  for i, p in pairs(player.projectiles) do
    if p == nil then goto continue end

    p:update(dt, w, h)

    if p:isOut(w, h) then
      player.projectiles[i] = nil
      goto continue
    end

    for j, e in pairs(enemies) do
      if e:checkCollisionWith(p.x, p.y) then
        player.projectiles[i] = nil
        e:respawn()
      end
    end

    ::continue::
  end

  for i, e in pairs(enemies) do
    e:update(dt, w, h)
  end
end

function love.draw()
  player:draw()

  for i, p in pairs(player.projectiles) do
    if p then p:draw() end
  end

  for i, e in pairs(enemies) do
    e:draw()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
