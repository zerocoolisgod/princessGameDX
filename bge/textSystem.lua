--===========================================================================--
-- Text System
--
-- Allows the creation of text boxes
--===========================================================================--

local lgGetFont   = love.graphics.getFont
local lgPrintf    = love.graphics.printf
local lgSetColor  = love.graphics.setColor
local lgDrawRec   = love.graphics.rectangle
local lgDraw      = love.graphics.draw

local camera = BGE.camera


local textSystem = {}

function textSystem:newTextBox(x, y, w, h)
  local tb = {}
  local viewS = camera:getViewSize()

  tb.fgColor = {1, 1, 1, 1}
  tb.bgColor = {1, 0, 0, 1}
  tb.borderColor = {0, 0, 0, 0}
  tb.borderSize = 8
  tb.frameWidth = w or viewS.x - 1
  tb.frameHeight = h or viewS.y - 1
  tb.frameImg = nil
  
  tb.text = t             -- A text string.
  tb.font = lgGetFont()   -- The Font object to use.
  tb.x = x or 1           -- The position on the x-axis.
  tb.y = y or 1           -- The position on the y-axis.
  tb.limit = w - 8 or viewS.x - 8     -- Wrap the line after this many horizontal pixels.
  tb.align = "left"       -- default ("left"), The alignment.
  tb.r = 0                -- default (0),  Orientation (radians).
  tb.sx = 1               -- default (1)  Scale factor (x-axis).
  tb.sy = 1               -- default (sx)  -- Scale factor (y-axis).
  tb.ox = 0               -- default (0)  -- Origin offset (x-axis).
  tb.oy = 0               -- default (0)  -- Origin offset (y-axis).
  tb.kx = 0               -- default (0)  -- Shearing factor (x-axis).
  tb.ky = 0               -- default (0)  -- Shearing factor (y-axis).

  function tb:draw()
    self:drawBoarder()
    self:drawFrame()

    lgSetColor(self.fgColor)
    lgPrintf(self.text, self.font, self.x, self.y, self.limit, self.align, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky )
    lgSetColor({1, 1, 1, 1})
  end

  function tb:drawBoarder()
    local x,y = self.x - self.borderSize, self.y - self.borderSize
    local w,h = self.frameWidth + (self.borderSize * 2), self.frameHeight + (self.borderSize * 2)
    
    lgSetColor(self.borderColor)
    lgDrawRec("fill", x, y, w, h)
    lgSetColor({1, 1, 1, 1})
  end

  function tb:drawFrame()
    local x,y = self.x, self.y
    local w,h = self.frameWidth, self.frameHeight

    lgSetColor(self.bgColor)
    lgDrawRec("fill", x, y, w, h)
    lgSetColor({1,1,1,1})

    if self.frameImg then
      lgDraw(self.frameImg, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
    end
  end

  
  -------------------------------------
  -- Setters
  -- call with not argument to reset to default values
  function tb:setText(t)
    self.text = t or ""
  end

  function tb:setFont(f)
    self.font = f or lgGetFont()
  end
  
  function tb:setLocation(x,y)
    self.x = x or 0 
    self.y = y or 0
  end
  
  function tb:setLimit(l)
    self.limit = l or 128
  end

  function tb:setAlignment(a)
    self.align = a or "left"
  end

  function tb:setRotation(r)
    self.r = r or 0
  end
  
  function tb:setScale(sx, sy)
    self.sx = sx or 1
    self.sy = sy or self.sx
  end

  function tb:setOriginOffset(ox,oy) 
    self.ox = ox or 0
    self.oy = oy or 0
  end

  function tb:setShearing(kx, ky)
    self.kx = kx or 0
    self.ky = ky or 0
  end

  function tb:setTextColor(c)
    self.fgColor = c or {1, 1, 1, 1}
  end
  
  function tb:setBackgroundColor(c)
    self.bgColor = c or {0, 0, 0, 0}
  end
  
  function tb:setBorderColor(c)
    self.borderColor = c or {0, 0, 0, 0}
  end
  
  function tb:setBorderSize(s)
    self.borderSize = s or 1
  end
  
  function tb:setFrameWidth(w)
    local viewS = camera:getViewSize()
    self.frameWidth = w or viewS.x - 1
  end
  
  function tb:setFrameHeight(h)
    local viewS = camera:getViewSize()
    self.frameHeight = h or viewS.y - 1
  end
  
  function tb:setFrameImage(i)
    self.frameImg = i or nil
  end

  return tb
end

function textSystem:newInputBox(x, y, w, h)
  local ipb = self:newTextBox(x,y,w,h)

  function ipb:onKeyPressed(k, single
  )
    local text = self.text
    text = text..k
    if single then text = k end
    self.text = text
  end

  function ipb:onReturn(text)
    -- implimented after creation
    -- is triggered when onKeyPress gets a return
  end

  return ipb
end


return textSystem