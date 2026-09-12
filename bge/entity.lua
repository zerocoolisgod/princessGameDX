-------------------------------------------------------------------------------
-- New Ent
-------------------------------------------------------------------------------
local logicComponents   = BGE.logicComponents
local renderComponents  = BGE.renderComponents

entity = {}

function entity:new(x,y,w,h)
	local e = {}
	e.id = "new ent"
	
	e.pos = {
		x = x or 0,
		y = y or 0
	}
	
	e.size = {
		w = w or 8,
		h = h or 8
	}
	
	e.logSys = {}
	e.renSys = {}
	
	-------------------------------------
	-- Methods
	function e:update(dt)
	  for i = 1, #self.logSys do
			self.logSys[i](self, dt)
		end
	end
	

	function e:draw()
		for i = 1, #self.renSys do
			self.renSys[i](self)
		end
	end
	
	
	function e:_addLogSys(sys)
    -- used by the logic components
		table.insert(self.logSys, sys)
	end
	

	function e:_addRenSys(sys)
		-- used by the Render components
		table.insert(self.renSys, sys)
	end
	
  -----------------------------------------------------------------------------
	-- Setters
	function e:setId(id)
		self.id = id
	end
	

	function e:setGroup(group)
		self.group = group
	end
  
  function e:setPosition(x, y)
		self.pos.x = x
    self.pos.y = y
	end
	
	-----------------------------------------------------------------------------
	-- Getters
	function e:getPosition()
		return self.pos.x, self.pos.y
	end

	
	function e:getSize()
		return self.size.w, self.size.h
	end
  
  -----------------------------------------------------------------------------
	-- Componants
  function e:addOnUpdate(func)
    logicComponents:addOnUpdate(self, func)
  end
  
  
  function e:addInputs()
    logicComponents:addInputs(self)
  end
  
  
  function e:addAnimation(animationID, frames, delay)
    logicComponents:addAnimation(self, animationID, frames, delay)
  end
  
  
  function e:addCollision(solid)
    logicComponents:addCollision(self, solid)
  end
  
  
  function e:addMovement()
    logicComponents:addMovement(self)
  end
  
  
  function e:addState(id, init, state)
    logicComponents:addState(self, id, init, state)
  end
  
  
  function e:addOnDraw(func)
    renderComponents:addOnDraw(self, func)
  end
  
  
  function e:addRectangle(color)
    renderComponents:addRectangle(self, color)
  end
  
  
  function e:addSprite(sheet, width, height, quad)
    renderComponents:addSprite(self, sheet, width, height, quad)
  end
  
  
  return e
end

return entity