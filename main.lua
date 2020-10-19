-- Princess Game DX
_USE_BUFFERED_SPRITESHEETS = true

-- Imports
BGE = require("bge.basicGameEngine")
love.run = require("bge.customRun")

-- Localized love
local lgRect = love.graphics.rectangle
local lgDraw = love.graphics.draw
local lgSetColor = love.graphics.setColor
local lgPop = love.graphics.pop
local lgPush = love.graphics.push
local lgScale = love.graphics.scale


-- Localized Vars


-------------------------------------------------------------------------------
-- Load Function
-------------------------------------------------------------------------------
function love.load(arg)
  BGE:load()
  
  BGE.resourceManager:loadEntities("entities/")
  BGE.resourceManager:loadImages("images/")

  local plr = BGE.resourceManager:getNewEntity("player", 32,32)
  BGE.entitySystem:addEntity(plr)
  BGE.camera:setFocus(plr)
  makeWalls()
end


-------------------------------------------------------------------------------
-- Main Loop
-------------------------------------------------------------------------------
function love.update(dt)
  BGE:update(dt)
end


-------------------------------------------------------------------------------
-- Drawing Loop
-------------------------------------------------------------------------------
function love.draw()
  BGE:draw()
end


-------------------------------------------------------------------------------
-- Other Callbacks
-------------------------------------------------------------------------------
function love.focus(f)
end


function love.keypressed(key, isrepeat)
  if key == 'escape' or key == 'q' then love.event.quit() end
  if key == "f" then BGE.camera:toggleFullscreen() end
end


function love.joystickpressed(joystick, button)
end


function love.joystickaxis(joystick, axis, value)
end




-------------------------------------------------------------------------------
-- Entites
-------------------------------------------------------------------------------


function makeWalls()
  for x = 1, 16 do
    BGE.entitySystem:addEntity(BGE.resourceManager:getNewEntity("wall", x * 16, 100))
  end
end




