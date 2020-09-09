-------------------------------------------------------------------------------
-- Overworld map. 
-- Holds single screen rooms in a three dimensional array
-- If Tiled tmx maps have "x,y,z" properties, an entire
-- directory can be loadded with loadMaps()

local Room = require("bge.room")


local e = { }

e.map = {}

for x = 1, 50 do
  e.map[x] = {}
  for y = 1, 50 do 
    e.map[x][y] = {}
    for z = 1, 3 do
      e.map[x][y][z] = {}
    end
  end
end


function e:setMapSize (width, height, depth)
  width = width or 5
  height = height or 5
  depth = depth or 3
  
  for x = 1, width do
    self.map[x] = {}
    for y = 1, height do 
      self.map[x][y] = {}
      for z = 1, depth do
        self.map[x][y][z] = Room:new()
      end
    end
  end
end


function e:loadMaps(path)
  -- takes every map in $path and adds it to
  -- self.map at position [x][y][z]
  local dir = love.filesystem.getDirectoryItems(path)
  local id,res

  for i,v in ipairs(dir) do
    if string.sub(dir[i],-4) == '.lua' then
      id = string.sub(dir[i],1,-5)
      fullPath = path.."."..id
      self:newRoom(fullPath)
    end
  end
end


function e:newRoom(fullPath,xpos,ypos,zpos)
  local mapFile = require(fullPath)
  local x,y,z = xpos or mapFile.properties["x"], ypos or mapFile.properties["y"], xpos or mapFile.properties["z"]
  
  if x and y and z then
    local r = Room:new()
    r:loadLayersFromMap(mapFile)
    self:addRoom(r, x, y, z)
  else
    print("MapFile "..fullPath.." Needs x, y, and z properties to be loaded from path!")
  end
end


function e:addRoom (room, x, y, z)
  self.map[x][y][z] = room
end


function e:getRoom (x,y,z)
  return self.map[x][y][z]
end

return e
