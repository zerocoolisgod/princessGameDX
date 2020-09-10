-----------------------------
-- Import Engine as Globals
local bge = {}
bge.gameStateManager  = require("bge.gameStateSystem")
bge.entitySystem      = require("bge.entitySystem")
bge.collisionSystem   = require("bge.collisionSystem")
bge.camera            = require("bge.camera")
bge.resourceManager   = require("bge.resourceManager")
bge.gameData          = require("bge.gameData")
bge.overWorld         = require("bge.overworldMap")
bge.inputManager      = require("bge.inputManager")


function bge:load()
  -- Scaling filter / Mouse Cursor Off
  love.graphics.setDefaultFilter('nearest')
  love.mouse.setVisible(false)
  BGE.camera:setLowResMode("tpg")

  -- load font
  local font = love.graphics.newFont("bge/OSC_Font.ttf", 8)
  love.graphics.setFont(font)

  -- Set Volume
  local volume = 0
  love.audio.setVolume(volume)
end

function bge:update(dt) end
function bge:draw() end

function bge:gsmUpdate(dt)
  self.inputManager:update(dt)
  self.gameStateManager:updateEnts(dt)
  self.camera:update(dt)
end

function bge:gsmDraw()
  self.camera:set()
  self.gameStateManager:drawEnts()
  self.camera:unset()
end


function bge:statlessUpdate(dt)
  self.inputManager:update(dt)
  self.entitySystem:updateEnts(dt)
  self.camera:update(dt)
end


function bge:statlessDraw()
  self.camera:set()
  self.entitySystem:drawEnts()
  self.camera:unset()
end


function bge:setUseGameStates(ugs)
  -- games states must be loaded before this is set
  self.update = self.statlessUpdate
  self.draw = self.statlessDraw
  
  if ugs then
    self.update = self.gsmUpdate
    self.draw = self.gsmDraw
  end
end

bge:setUseGameStates(false)

return bge