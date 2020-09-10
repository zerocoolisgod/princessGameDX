-- Princess Game DX

-- Imports
BGE = require("bge.basicGameEngine")



-- Localized Engine
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
  
  -- Scaling filter / Mouse Cursor Off
  love.graphics.setDefaultFilter('nearest')
  love.mouse.setVisible(false)
  _CAMERA:setLowResMode("tpg")

  -- load font
  local font = love.graphics.newFont('OSC_Font.ttf', 8)
  love.graphics.setFont(font)

  -- Volume
  local volume = 0
  love.audio.setVolume(volume)
  local plr = newPlayer(16,16)
  _ENTSYS:addEntity(plr)
  _CAMERA:setFocus(plr)
  makeWalls()
end


-------------------------------------------------------------------------------
-- Main Loop
-------------------------------------------------------------------------------
function love.update(dt)
  _INPUTS:update(dt)
  _ENTSYS:updateEnts(dt)
  _CAMERA:update(dt)
end


-------------------------------------------------------------------------------
-- Drawing Loop
-------------------------------------------------------------------------------
function love.draw()
  _CAMERA:set()
  
  local text = "Hello World"
  love.graphics.print(text, 100,100)
  _ENTSYS:drawEnts()
  
  _CAMERA:unset()
end


-------------------------------------------------------------------------------
-- Other Callbacks
-------------------------------------------------------------------------------
function love.focus(f)
end


function love.keypressed(key, isrepeat)
  if key == 'escape' or key == 'q' then love.event.quit() end
  if key == "f" then _CAMERA:toggleFullscreen() end
end


function love.joystickpressed(joystick, button)
end


function love.joystickaxis(joystick, axis, value)
end



-------------------------------------------------------------------------------
-- Entites
-------------------------------------------------------------------------------
function newPlayer(x,y)
  local p = _ENTSYS:newEnt(x,y,16,16)
  p:addRectangle({0.2, 0.2, 1, 1})
  
  p:addOnUpdate(
    function(self, dt)
      local nx,ny = self:getPosition()
      local speed = 120
      
      if _INPUTS:isDown("up") then ny = ny - (speed * dt) end
      if _INPUTS:isDown("down") then ny = ny + (speed * dt) end
      if _INPUTS:isDown("left") then nx = nx - (speed * dt) end
      if _INPUTS:isDown("right") then nx = nx + (speed * dt) end
      
      self:setPosition(nx, ny)
    end
  )
  
  return p
end


function newWall(x,y)
  local e = _ENTSYS:newEnt(x,y,16,16)
  e:addRectangle({0.2, 1, 0.2, 1})

  return e
end

function makeWalls()
  for x=0, 8 do
    _ENTSYS:addEntity(newWall(x*16, 200))
  end
end