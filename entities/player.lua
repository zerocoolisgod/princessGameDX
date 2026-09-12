local ent = {}

function ent:new (x,y)
  local p = BGE.entity:new(x, y, 4, 12)
  
  local imgSheet = BGE.resourceManager:getImage("beth_normal_strip")
  p:addSprite(imgSheet, 16, 16, 1)
  
  p:addRectangle({1, 1, 0.1, 0.4})
  p:setSpriteOffset(0,-1)

  p:addCollision(true)
  p:addMovement()
  p.gravity = 400
  p.acceleration = {x = 0.1, y = 0.01}
  p.maxSpeed = {x = 130, y =200}
  p.debugMsg = ""

  p:addOnUpdate(
    function(self, dt)
      local speedLimitX = self.maxSpeed.x
      local speedLimitY = self.maxSpeed.y
      local xSpeed = 0
      local ySpeed = self.gravity
      local aclX = self.acceleration.x
      local aclY = self.acceleration.y

      if self:onGround() then
        ySpeed = 0
        aclY = 0.5
      end
      
      --if BGE.inputManager:isDown("up") then ySpeed = -speedLimit end
      if BGE.inputManager:isPressed("btnA") then
        ySpeed = -speedLimitY
        aclY = 1
      end

      if BGE.inputManager:isDown("left") then xSpeed = -speedLimitX end
      if BGE.inputManager:isDown("right") then xSpeed = speedLimitX end
      
      self:move(xSpeed, ySpeed, aclX, aclY, dt)
      self.debugMsg = self.vel.y
    end
  )

  p:addOnDraw(
    function(self)
      local x,y = self:getPosition()
      y = y - 8
      --love.graphics.print(self.debugMsg, x, y)
    end
  )

  
  function p:onGround()
    local x,y = self:getPosition()
    local w,h = self:getSize()
    local entTable = BGE.entitySystem:getEnts()
    local ground = false
    y = y + h
    h = 1
    
    local obj = BGE.collisionSystem:getEntityInRect(self, x, y, w, h, entTable) or {id="none"}
    if obj.id == "wall" then
      ground = true
    end

    return ground
  end
  
  return p
end

return ent