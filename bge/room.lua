-------------------------------------------------------------------------------
-- Tiled tmx map container object
-- Loads tile layers and converts them to love drawables
-- Loads Object layers into a table of ent names and positions for object spawning
--


-----------------------------
-- Localized Globals
local gameStateManager  = GSTMAN
local entitySystem      = ENTSYS
local collisionSystem   = COLSYS
local camera            = CAMERA
local resourceManager   = RESMAN
local gameData          = GAMDAT
local overWorld         = OVRWLD

local logicComponents = require("bge.logicComponents")
local renderComponents = require("bge.renderComponents")

local lgDraw = love.graphics.draw

local Room = {}

function Room:new( )
  local e = {}
  e.screen = {x=0, y=0, w=0, h=0}
  e.tileset = {}
  e.tsQuads = {}
  e.mapfile = {}
  e.mapSize = {w = 0, h = 0}
  e.tileMap = {}
  e.tileSize = {w = 0, h = 0}

  e.ents = {}  


  function e:activateRoom()
    local limitX = self.mapSize.w * self.tileSize.w
    local limitY = self.mapSize.h * self.tileSize.h

    love.graphics.setBackgroundColor(self.backGroundColor)
    self:loadObjectLayer()
    camera:setLimit(limitX, limitY)
  end
  

  function e:loadMapFromFile(path)
    local mapFile = require(path)
    self:loadLayersFromMap(mapFile)
  end


  function e:loadLayersFromMap(mapFile)
    self.backGroundColor = {0,0,0}
    if mapFile.backgroundcolor then
      self.backGroundColor[1] = mapFile.backgroundcolor[1]/255
      self.backGroundColor[2] = mapFile.backgroundcolor[2]/255
      self.backGroundColor[3] = mapFile.backgroundcolor[3]/255
    end
    
    for layer = 1,#mapFile.layers do
      if mapFile.layers[layer].type == "tilelayer" then
        self:loadTileLayer(mapFile, layer)
      end
      if mapFile.layers[layer].type == "objectgroup" then
        self.objectLayer = mapFile.layers[layer]["objects"]
      end
    end
  end


  function e:loadTileLayer(mapFile, layerNumber)
    local tilesetData = mapFile.tilesets[1] 
    local spacing = tilesetData.spacing
    local margin = tilesetData.margin

    self.tileset = resourceManager:getImage(tilesetData.name)
    self.tileSize.w = tilesetData.tilewidth
    self.tileSize.h = tilesetData.tileheight
    self.tsQuads = resourceManager:getQuads(self.tileset, self.tileSize.w, self.tileSize.h, margin, spacing)
    self.mapSize.w  = mapFile.width
    self.mapSize.h  = mapFile.height

    for i = 1, mapFile.width do
      self.tileMap[i] = {}
    end

    self:addTiles(mapFile.layers[layerNumber].data)
    self:makeSpriteBatch(layerNumber)
  end


  function e:addTiles(data)
    local index = 1
    for y = 1, self.mapSize.h do
      for x = 1, self.mapSize.w do
        self.tileMap[x][y] = data[index]
        index = index + 1
      end
    end
  end


  function e:makeSpriteBatch(mapLayer, posX, posY, screenW, screenH)
    posX = posX or 1
    posY = posY or 1
    layer = mapLayer or 1
    screenW = screenW or self.mapSize.w
    screenH = screenH or self.mapSize.h
    if not self.tileBatch then self.tileBatch = {} end
    self.tileBatch[layer] = love.graphics.newSpriteBatch(self.tileset)
    self.tileBatch[layer]:clear()
    for y = posY, screenH do
      for x = posX, screenW do
        if self.tileMap[x][y] ~= 0 then
          local quadID = self.tileMap[x][y]
          local quad = self.tsQuads[quadID]
          local posX = (x - 1) * self.tileSize.w
          local posY = (y - 1) * self.tileSize.h
          self.tileBatch[layer]:add(quad, posX, posY)
        end
      end
    end
  end


  function e:loadObjectLayer()

    local objlay = self.objectLayer
    local ents={}
    
    for i=1,#objlay do
      local type = objlay[i].type
      local x = objlay[i].x
      local y = objlay[i].y
      local w = objlay[i].width
      local h = objlay[i].height
      local props = objlay[i].properties
      local o = resourceManager:getNewEntity(type, x, y, w, h, props)
      table.insert(ents, o)
    end
    self.ents = {}
    self.ents = ents
  end


  function e:getRoomEntities()
    return self.ents
  end

  function e:update(dt)
    entitySystem:updateEnts(dt)
  end


  function e:draw(x, y, w, h)

    if x and y and w and h then
      -- For updateing spritebatch when the camera moves
      -- with rooms bigger than a single screen.
      -- Figure this out later
      -- stop making an engine and make a game >:[
      self.tileBatch:flush()
    end
    x = x or 0
    y = y or 0
    if self.tileBatch then 
      for l=1,#self.tileBatch do
        lgDraw(self.tileBatch[l], x, y) 
      end
    end
    entitySystem:drawEnts()
  end

  return e
end

return Room