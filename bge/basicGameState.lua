-------------------------------------------------------------------------------
-- Basic Game State Template
local state={}


function state:init()
end


function state:update(dt)
end


function state:draw()
end

function state:keypressed(key, isrepeat)
end


function state:joystickpressed(joystick, button)
end


function state:joystickaxis(joystick, axis, value)
end

return state