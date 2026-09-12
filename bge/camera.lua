--[[
Localized Framework Calls
--]]
local lg        = love.graphics
local pop       = lg.pop
local push      = lg.push
local translate = lg.translate
local rotate    = lg.rotate
local scale     = lg.scale
local m_floor   = math.floor




local Camera = {}

function Camera:init()
  local w, h = love.graphics.getDimensions()
  self.pos = {x=0,y=0}
  self.scale = {x=1,y=1}
  self.rot = 0
  self.focus = nil
  self.limit = {l=0,r=64000,t=0,b=64000}
  --needs setters
  self.flags = {vsync = false, fullscreen = false, fullscreentype = "exclusive"}
  self.viewSize = {x=w, y=h}   -- Game Resolution
  self.windowSize = {x=w,y=h}  -- Screen Resolution
  self.zoomW = {x=1,y=1}       -- Windowed zoom factor
  self.zoomF = {x=1,y=1}       -- Fullscreen zoom factor
  self.halfView = {x = w/2, y = h/2}
end


function Camera:setLowResMode(mode)
  love.window.setMode(0, 0)
  local screenWidth, screenHeight = love.graphics.getDimensions()
  
  local modes = {
    nes = {x = 256, y = 240}, --(32x30) 8x8 pixel sprites
    gbc = {x = 160, y = 144}, --(20x18) 8x8 pixel sprites
    gba = {x = 240, y = 160}, --(30x20) 8x8 pixel sprites
    tpg = {x = 320, y = 180}  --(40x22) 8x8 pixel sprites (The Princess Game)
  }
  
  local camRes = modes[mode]
  local windowScale = 3
  local windowSize = {x = camRes.x * windowScale, y = camRes.y * windowScale}
  --local fullscreenSize = {x = 1366, y = 768}
  local fullscreenSize = {x = screenWidth, y = screenHeight}
  local mode = "window"

  self:init()
  self:setViewSize(camRes.x, camRes.y)
  self:setWindowSize(windowSize.x, windowSize.y)
  self:setFullscreenSize(fullscreenSize.x, fullscreenSize.y)
  self:setMode(mode)
end



function Camera:update(dt)
  if self.focus then
    local camPosX, camPosY
    -- ADD size to position because cameras translate
    -- is the reverse of it position
    camPosX = self.focus.pos.x + (self.focus.size.w / 2)
    camPosY = self.focus.pos.y + (self.focus.size.h / 2)
    self:centerOn(camPosX, camPosY, dt)
    self:clamp()
  end
end


function Camera:set ()
  self.scale = self.zoomW
  if self.flags.fullscreen then self.scale = self.zoomF end
  push()
  rotate(-self.rot)
  scale(self.scale.x, self.scale.y)
  translate(-self.pos.x, -self.pos.y)
end


function Camera:unset ()
  pop()
end


function Camera:setGui ()
  self.scale = self.zoomW
  if self.flags.fullscreen then self.scale = self.zoomF end
  push()
  --rotate(-self.rot)
  scale(self.scale.x, self.scale.y)
  --translate(-self.pos.x, -self.pos.y)
end


function Camera:centerOn (posX, posY,dt)
  -- sets position to be centered on pos
  -- size is the constant resolution that we are working from
  self.pos.x = posX - self.halfView.x
  self.pos.y = posY - self.halfView.y
end

function Camera:setPos(x,y)
  -- sets position of top left corner
  self.pos.x = x
  self.pos.y = y
end

function Camera:getPos()
  return self.pos
end

function Camera:resetPos ()
  self.pos.x = 0
  self.pos.y = 0
end

function Camera:toggleFullscreen ()
  local mode = 'full'
  if self.flags.fullscreen then mode = 'window' end

  self:setMode(mode)
end

function Camera:setFocus (obj)
  -- object to follow, camera:update() must be called back for this to work
  self.focus = obj
end

function Camera:unsetFocus ()
  self.focus = nil
  self:resetPos()
end

function Camera:setLimit (rightSide, bottomSide)
  self.limit.r = rightSide - self.viewSize.x
  self.limit.b = bottomSide - self.viewSize.y
end

function Camera:clamp ()
  -- make sure camera stays inside its limits
  local lim = self.limit
  local x, y = self.pos.x, self.pos.y
  if x < lim.l then x = lim.l end
  if x > lim.r then x = lim.r end
  if y < lim.t then y = lim.t end
  if y > lim.b then y = lim.b end
  self:setPos(x,y)
end

-------------------------------------------------------------------------------
-- Setters
-------------------------------------------------------------------------------
function Camera:setViewSize (x,y)
  -- Internal resolution.
  -- All object will use a coordinate system based off this resolution.
  self.viewSize.x = x
  self.viewSize.y = y

  self.halfView.x = x/2
  self.halfView.y = y/2
end

function Camera:getViewSize ()
  -- Internal resolution.
  return {x = self.viewSize.x, y = self.viewSize.y}
end

function Camera:setWindowSize (x,y)
  -- sets display resolution when windowed
  -- sets zoom based on window/game res
  self:setWindowedZoom (x / self.viewSize.x, y / self.viewSize.y)
end

function Camera:setFullscreenSize(x, y)
  -- sets display resolution when fullscreen
  self:setFullscreenZoom (x / self.viewSize.x, y / self.viewSize.y)
end

function Camera:setMode (m)
  if m == 'window' then
    self.scale = self.zoomW
    self.flags.fullscreen = false
  elseif m == 'full' then
    self.flags.fullscreen = true
    self.scale = self.zoomF
  end

  love.window.setMode(self.viewSize.x * self.scale.x,
    self.viewSize.y * self.scale.y, self.flags)

  self.windowSize.x = love.graphics.getWidth()
  self.windowSize.y = love.graphics.getHeight()
end

function Camera:setWindowedZoom (x,y)
  self.zoomW.x = x
  self.zoomW.y = y or x
end

function Camera:setFullscreenZoom (x,y)
  self.zoomF.x = x
  self.zoomF.y = y or x
end

return Camera
