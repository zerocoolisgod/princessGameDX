-------------------------------------------------------------------------------
-- Resource Manager
-- Loads everything in a path once
-- to be retrieved with the appropriate rsm:get()
-------------------------------------------------------------------------------
local rsm = {}

local newImage = love.graphics.newImage
local newSound = love.audio.newSource
local la = love.audio

local function lError(msg)
  love.errhand(msg)
  love.event.quit()
end


rsm.res = {
  img = {},
  aud = {},
  ent = {}
}


function rsm:clear ()
  self.res = {
    img = {},
    aud = {},
    ent = {}
  }
end



-------------------------------------------------------------------------------
-- Images
-------------------------------------------------------------------------------
function rsm:loadImages(path)
  -- takes every image in $path and adds it to
  -- self.img as {str fileName = obj drawable}
  local dir = love.filesystem.getDirectoryItems(path)
  local id,res

  for i,v in ipairs(dir) do
    id = string.sub(dir[i],1,-5)
    res = path..dir[i]
    self:addImg(res,id)
  end
end


function rsm:addImg (resource,id)
  self.res.img[id] = newImage(resource)
end


function rsm:getImage (id)
  -- takes id (str fileName)
  -- returnes drawable
  if self.res.img[id] then
    return self.res.img[id]
  else
    lError(id..' is not a valid image sheet.')
  end
end

function rsm:getQuads (img, width, height, margin, spacing)
  -- Cut quads
  local frameWidth = width
  local frameHeight = height
  local s = spacing or 0
  local m = margin or 0
  local imageWidth = img:getWidth()
  local imageHeight = img:getHeight()
  
  local quadTable = {}

  -- Position in image is based on cells,
  -- frame size is the size of the tile or spriteframe.
  -- If we are using a buffered sprite sheet then the cell
  -- will be the size of the frame + 2*spacing on all 4 sides,
  -- or cx=fx+s*2 cy=fy+s*2
  local cellWidth = frameWidth + s
  local cellHeight = frameHeight + s

  local numberWide = imageWidth / cellWidth
  local numberHigh = imageHeight / cellHeight

  -- Cut tile sheet into quads
  for y = 1, numberHigh do
    for x = 1, numberWide do
      -- add margin to whole thing to get the first position off
      -- of the 0x and 0y
      local xpos = ((x-1) * (cellWidth)) + m
      local ypos = ((y-1) * (cellWidth)) + m
      table.insert(quadTable, love.graphics.newQuad(xpos, ypos, frameWidth, frameHeight, imageWidth, imageHeight))
    end
  end
  return quadTable
end



-------------------------------------------------------------------------------
-- Sound
-------------------------------------------------------------------------------
function rsm:loadSounds(path)
  local dir = love.filesystem.getDirectoryItems(path)
  local id,res

  for i,v in ipairs(dir) do
    id = string.sub(dir[i],1,-5)
    res = path..dir[i]

    self:addAud(res,id)
  end
end


function rsm:addAud (resource,id)
  
  self.res.aud[id] = newSound(resource)
end


function rsm:playSound (id)
  if self.res.aud[id] then
    self.res.aud[id]:stop()
    self.res.aud[id]:play()
  else
    lError(id..' is not a valid sound file.')
  end
end


function rsm:playMusic (id,volume)
  la.stop()
  volume = volume or 1
  if self.res.aud[id] then
    self.res.aud[id]:stop()
    self.res.aud[id]:setVolume(volume)
    self.res.aud[id]:setLooping(true)
    self.res.aud[id]:play()
  else
    lError(id..' is not a valid song file.')
  end
end



-------------------------------------------------------------------------------
-- Objects
-------------------------------------------------------------------------------
function rsm:loadEntities(path)
  -- takes every class in $path and adds it to
  -- self.obj as {str fileName = obj classConstructor}
  local dir = love.filesystem.getDirectoryItems(path)
  local id,res

  for i,v in ipairs(dir) do
    if string.sub(dir[i],-4) == '.lua' then
      id = string.sub(dir[i],1,-5)
      res = path..id
      self:addEntity(res,id)
    end
  end
end


function rsm:addEntity(resource, id)
  self.res.ent[id] = require(resource)
end


function rsm:getNewEntity(id, x, y, h, w, props)
  -- takes id (str fileName) and position
  -- returnes object at that position

  if self.res.ent[id] then
    return self.res.ent[id]:new(x, y, h, w, props)
  end
end



-------------------------------------------------------------------------------
-- Maps
-------------------------------------------------------------------------------


function rsm:getNewTile (x,y,w,h,q)
  -- returnes tile at that position
end

return rsm
