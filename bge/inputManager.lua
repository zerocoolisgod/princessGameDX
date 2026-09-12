local ipm = {}
local joysticks = love.joystick.getJoysticks()
ipm.joystick = joysticks[1]

ipm.inputs = {
  up    = {key = "w", btn = "dpup", axis = "lefty", held = false, pressed = false, released = false},
  down  = {key = "s", btn = "dpdown", axis = "lefty", held = false, pressed = false, released = false},
  left  = {key = "a", btn = "dpleft", axis = "leftx", held = false, pressed = false, released = false},
  right = {key = "d", btn = "dpright", axis = "leftx", held = false, pressed = false, released = false},
  btnA  = {key = "l", btn = "a", held = false, pressed = false, released = false},
  btnB  = {key = "k", btn = "b", held = false, pressed = false, released = false},
  btnX  = {key = "o", btn = "x", held = false, pressed = false, released = false},
  btnY  = {key = "i", btn = "y", held = false, pressed = false, released = false},
  start = {key = "space", btn = "start", held = false, pressed = false, released = false},
  back  = {key = "backspace", btn = "back", held = false, pressed = false, released = false}
}


function ipm:setInput(id, key)
  self.inputs[id].key = key
end


function ipm:isDown(ip)
  return self.inputs[ip]["held"]
end


function ipm:isPressed(ip)
  return self.inputs[ip]["pressed"]
end


function ipm:isReleased(ip)
  return self.inputs[ip]["released"]
end

function ipm:getGamepadAxis(ip)
  local axis = 0
  if self.joystick and self.inputs[ip].axis then
    axis = self.joystick:getGamepadAxis(self.inputs[ip].axis)
  end

  return axis
end


function ipm:update(dt)
  if not self.joystick then
    local joysticks = love.joystick.getJoysticks()
    self.joystick = joysticks[1]
  end

  for k,v in pairs(self.inputs) do
    local nowState = love.keyboard.isDown(self.inputs[k].key)
    local held = self.inputs[k].held

    if self.joystick then
      local axis 
      
      nowState = nowState or self.joystick:isGamepadDown(self.inputs[k].btn)
      
      if self.inputs[k].axis then axis = self.joystick:getGamepadAxis(self.inputs[k].axis) end
      if axis and axis ~= 0 then
        local dz = .5 -- Dead zone
        if k == "up"    then nowState = nowState or axis < -dz end
        if k == "down"  then nowState = nowState or axis > dz end
        if k == "left"  then nowState = nowState or axis < -dz end
        if k == "right" then nowState = nowState or axis > dz end
      end
    end

    self.inputs[k].pressed = nowState and not held
    self.inputs[k].released = held and not nowState
    self.inputs[k].held = nowState
  end
end
  
return ipm