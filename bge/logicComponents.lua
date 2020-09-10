
---------------------------------------
-- Logic Componants

-----------------------------
-- Localized Globals
local gameStateManager  = BGE.gameStateManager
local entitySystem      = BGE.entitySystem
local collisionSystem   = BGE.collisionSystem
local camera            = BGE.camera
local resourceManager   = BGE.resourceManager
local gameData          = BGE.gameData
local overWorld         = BGE.overWorld
local inputs						= BGE.inputManager

local logSys = {}

function logSys:addOnUpdate(ent, f)
	-- Generic function to run every update
	ent:_addLogSys(f)
end


function logSys:addInputs(ent)
end


function logSys:addAnimation(ent, aId, frms, dly)
	if not ent.anms then ent.anms={} end
	ent.anms[aId] = {
		frames = frms,
		delay = dly,
		len = #frms
	}
	
	ent.anmTimer=0
	ent.frameNum = 1
	ent.cAnm = aId
	ent.nAnm = aId
	

	-------------------------------------
	-- Setters
	ent.setAnimation = function(self,a)
		self.nAnm = a
	end


	-------------------------------------
	-- Getters
	ent.getAnimation = function(self,a)
		return self.cAnm
	end
	
	-------------------------------------
	--Update Function
	ent:_addLogSys(function(self, dt)
		local anm
		local sprt
		
		if self.cAnm ~= self.nAnm then
			self.cAnm = self.nAnm
			self.frameNum = 1
		end
		
		anm = self.anms[self.cAnm]
		
		self.anmTimer = self.anmTimer + dt
		if self.anmTimer > anm.delay then
			self.anmTimer = 0
			self.frameNum = self.frameNum + 1
    end
		
		if self.frameNum > anm.len then self.frameNum = 1 end
		
    self:setFrame(anm.frames[self.frameNum])
	end)
end


function logSys:addCollision(ent, solid)
	-- Solid objects repell objects 
	-- attempting to move into their 
	-- space. non solids do not, they 
	-- still get onBump() response.
	ent.collidable = true
	ent.solid = solid
	
	function ent:setSolid(bin)
		self.solid = bin
	end

	function ent:onBump (self, other) end
end


function logSys:addMovement(ent)
	-- spdX = spdX or 100
	-- spdY = spdY or 100
	ent._framAcum = 0
	ent.vel = {x = 0, y = 0}
	ent.dir = {x = 1, y = 0}
	


	function ent:move(tgtSpdX, tgtSpdY, accelX, accelY, dt)
		-- Takes target_speed, a rate of acceleration and delta time
		-- a linear interpolation between the current velocity and the target
		-- velocity by an acceleration percentage accel of 1 changes immediately,
		-- 0 is never, .5 half's the difference each tick.
		
		local tfps = (1/60)
		self._framAcum = self._framAcum + dt
		-- normalize the time step. With a fluxuating dt
		-- accels get wierd.
		if self._framAcum >= tfps then
			self._framAcum = self._framAcum - tfps
			local curSpeedX = self.vel.x
			local curSpeedY = self.vel.y
			local threshold = 1   -- Lower to make more 'floaty'
	
			curSpeedX = accelX * tgtSpdX + (1 - accelX) * curSpeedX
			curSpeedY = accelY * tgtSpdY + (1 - accelY) * curSpeedY
			if (math.abs(curSpeedX)) < threshold then
				curSpeedX = 0
			end
	
			if (math.abs(curSpeedY)) < threshold then
				curSpeedY = 0
			end
	
			self.vel.x = curSpeedX
			self.vel.y = curSpeedY
		end
	end

	
	ent:_addLogSys(function(self, dt)
		local px, py
		
		self.pos.x = self.pos.x + (self.vel.x * dt)
		if self.collidable then 
			px = collisionSystem:ckCollison(self, entitySystem:getEnts())
		end
		if px then self.pos.x = px.x end	
	
    self.pos.y = self.pos.y + (self.vel.y * dt)
		if self.collidable then 
			py = collisionSystem:ckCollison(self, entitySystem:getEnts())
		end
		if py then self.pos.y = py.y end

	end)
end


function logSys:addState(ent, id, init, state)
	if not ent.stateInits then ent.stateInits={} end
	ent.stateInits[id] = init

	if not ent.states then ent.states={} end
	ent.states[id] = state
	
	ent.cState = id -- Current State
	ent.nState = id -- Next State
		
	ent.setState = function(self,s)
		self.nState = s
	end
	
	ent:_addLogSys(function(e, dt)
		-- Check for state change, run initial
		if e.cState ~= e.nState then
			e.cState = e.nState
			e.stateInits[e.cState](e) 
		end
		
		e.states[e.cState](e, dt)
	end)	
end


return logSys                     