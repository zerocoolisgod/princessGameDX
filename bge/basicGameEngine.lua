-----------------------------
-- Import Engine as Globals
BGE = {}
BGE.gameStateManager  = require("bge.gameStateSystem")
BGE.collisionSystem   = require("bge.collisionSystem")
BGE.camera            = require("bge.camera")
BGE.resourceManager   = require("bge.resourceManager")
BGE.gameData          = require("bge.gameData")
BGE.overWorld         = require("bge.overworldMap")
BGE.inputManager      = require("bge.inputManager")
BGE.entitySystem      = require("bge.entitySystem")
BGE.logicComponents   = require("bge.logicComponents")
BGE.renderComponents  = require("bge.renderComponents")
BGE.entity            = require("bge.entity")

BGE._framAcum = 0 -- make this togelable like a vsync or something

function BGE:load()
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

function BGE:update(dt) end
function BGE:draw() end


--Using Game State Manager
function BGE:gsmUpdate(dt)
  self.inputManager:update(dt)
  self.gameStateManager:updateEnts(dt)
  self.camera:update(dt)
end

function BGE:gsmDraw()
  self.camera:set()
  self.gameStateManager:drawEnts()
  self.camera:unset()
end


-- Using Statless update
-- Easier for prototyping
function BGE:statlessUpdate(dt)
  self.entitySystem:updateEnts(dt)
  self.camera:update(dt)
  self.inputManager:update(dt)
end


function BGE:statlessDraw()
  self.camera:set()
  self.entitySystem:drawEnts()
  self.camera:unset()
end


function BGE:setUseGameStates(ugs)
  -- games states must be loaded before this is set
  self.update = self.statlessUpdate
  self.draw = self.statlessDraw
  
  if ugs then
    self.update = self.gsmUpdate
    self.draw = self.gsmDraw
  end
end



BGE:setUseGameStates(false)

return BGE