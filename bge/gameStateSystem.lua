------------------------------------------------------------------------------
-- Game states
------------------------------------------------------------------------------
local gsm = {}
gsm.currentState = ""
gsm.nextState = ""
gsm.states = {}


function gsm:updateState(dt)
	if self.currentState ~= self.nextState then 
		self.currentState = self.nextState
		self.states[self.currentState]:init()
	end
	
	self.states[self.currentState]:update(dt)
end


function gsm:drawState()
	self.states[self.currentState]:draw()
end


function gsm:setState(state)
	self.nextState = state
end


function gsm:getState()
	return self.currentState
end


function gsm:addState(id, state)
	self.states[id] = state
end

function gsm:keypressed(key, isrepeat)
	self.states[self.currentState]:keypressed(key, isrepeat)
end


function gsm:joystickpressed(joystick, button)
	self.states[self.currentState]:joystickpressed(joystick, button)
end


function gsm:joystickaxis(joystick, axis, value)
	self.states[self.currentState]:joystickaxis(joystick, axis, value)
end

return gsm