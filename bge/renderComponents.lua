-------------------------------------------------------------------------------
-- Render Components

local renSys = {}


---------------------------------------
-- Local Utility functions and framework variables
local lgDraw = love.graphics.draw
local lgSetColor = love.graphics.setColor
local lgRect = love.graphics.rectangle


-------------------------------------------------------------------------------
-- Components
function renSys:addOnDraw(ent,f)
	-- Generic function to run every draw
	ent:_addRenSys(f)
end


function renSys:addRectangle(ent, c)
	ent.color = c or {1,0.5,1}
	
	function ent:setColor(c)
		ent.color = c
	end
	
	ent:_addRenSys(
    function(e)
      lgSetColor(e.color)
      lgRect("fill", e.pos.x, e.pos.y, e.size.w, e.size.h)
      lgSetColor(1,1,1)
    end
  )
end


function renSys:addSprite(ent, sheet, width, height, quad)
  if not BGE.resourceManager then 
    love.errhand("BGE.resourceManager needs to be globally accessable!")
    love.event.quit()
  end

  local margin,spacing = 0, 0
  if _USE_BUFFERED_SPRITESHEETS then
    margin = 1
    spacing = 2
  end

	ent.sheet = sheet
  ent.frame = quad or 1
  ent.quads = BGE.resourceManager:getQuads(sheet, width, height, margin, spacing)
	ent.scale = {x = 1, y = 1}
	ent.radian = 0
  ent.orig = {x = width/2, y = height/2}
	ent.offset = {x = 0, y = 0}
	
	
	-------------------------------------
	--Setters
  function ent:setSpriteScale(x, y)
		self.scale.x = x or 1
    self.scale.y = y or x or 1
	end
	  
	function ent:setSpriteAlpha(c)
		self.colorkey = c or 0
	end
	  
	function ent:setSpriteRadian(r)
		self.radian = r or 0
	end
    
  function ent:setSpriteOffset(x,y)
		self.offset.x = x or 0
    self.offset.y = y or x or 0
	end
	
  function ent:setFrame(f)
    if f > #self.quads then f = 1 end
    self.frame = f or 1
	end
	

	-------------------------------------
	--Getters
	function ent:getSpriteScale()
		return self.scale.x, self.scale.y
	end
	  
	function ent:getSpriteAlpha()
		return self.colorkey
	end
	  
	function ent:getSpriteRadian()
		return self.radian
	end
    
  function ent:getSpriteOffset()
		return self.offset.x, self.offset.y
	end
  
  function ent:getFrame()
    return self.frame
  end
	

	-------------------------------------
	-- Drawing function
	ent:_addRenSys(function(e)
		-- drawable (quad) x y radian scaleX scaleY originX originY
    local q = e.quads[e.frame]
    local x = e.pos.x + e.size.w/2 + e.offset.x
    local y = e.pos.y + e.size.h/2 + e.offset.y
		lgDraw(e.sheet, q, x, y, e.radian, e.scale.x, e.scale.y, e.orig.x, e.orig.y)
	end)
end




return renSys