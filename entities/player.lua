local ent = {}

function ent:new (x,y)
  local p = BGE.entity:new(x, y, 4, 12)
  
  local imgSheet = BGE.resourceManager:getImage("beth_normal_strip")
  p:addSprite(imgSheet, 16, 16, 3)
  
  p:addRectangle({1, 1, 0.1, 0.4})
  p:setSpriteOffset(0,-2)

  p:addCollision(true)
  p:addMovement()
  p.gravity = 400
  p.acceleration = {x = 0.1, y = 0.02}
  p.maxSpeed = {x = 130, y =200}
  p.debugMsg = ""


  p:addOnUpdate(
    function(self, dt)

      self.debugMsg = ""--tostring(self:onGround())--self:getState()
    end
  )


  p:addOnDraw(
    function(self)
      local x, y = self:getPosition()
      y = y - 8
      love.graphics.print(self.debugMsg, x, y)
    end
  )
---[[
  p:addAnimation("idle", {1,1,1,6,1}, 2)
  p:addAnimation("walk", {2,1,3,1}, .5)
  p:addAnimation("jump", {4}, 0.1)
  p:addAnimation("fall", {5}, 0.1)
  p:setAnimation("fall")
  
  p:addStates()
  
  p:newState("idle",
    --init
    function(self)
      self:setAnimation("idle")
    end,
    
    --state update
    function(self, dt)
      local nstate = "idle"
      if BGE.inputManager:isDown("left") then nstate = "walk" end
      if BGE.inputManager:isDown("right") then nstate = "walk" end
      
      if BGE.inputManager:isPressed("btnA") then nstate = "jump" end
      if not self:onGround() then nstate = "fall" end
      
      self:move(0, 0, self.acceleration.x, self.acceleration.y, dt)
      self:setState(nstate)
    end
  )
  
  
  p:newState("walk",
    --init
    function(self)
      self:setAnimation("walk")
    end,
    
    --state update
    function(self, dt)
      local speedLimitX = self.maxSpeed.x
      local speedLimitY = self.maxSpeed.y
      local xSpeed = 0
      local ySpeed = 0
      local aclX = self.acceleration.x
      local aclY = self.acceleration.y
      
      local nstate = "idle"
      
      if BGE.inputManager:isDown("left") then 
        nstate = "walk"
        self.scale.x = -1
        xSpeed = -speedLimitX
      end
      
      
      if BGE.inputManager:isDown("right") then 
        nstate = "walk"
        self.scale.x = 1
        xSpeed = speedLimitX
      end
      
      if BGE.inputManager:isPressed("btnA") then nstate = "jump" end
      if not self:onGround() then nstate = "fall" end
      
      self:move(xSpeed, ySpeed, aclX, aclY, dt)
      self:setState(nstate)
    end
  )
  
  
  p:newState("fall",
    --init
    function(self)
      self:setAnimation("fall")
    end,
    
    --state update
    function(self, dt)
      local xSpeed = 0
      local nstate = "fall"
      
      if self:onGround() then nstate = "idle" end
      
      if BGE.inputManager:isDown("left") then 
        xSpeed = -self.maxSpeed.x
      end
            
      if BGE.inputManager:isDown("right") then 
        xSpeed = self.maxSpeed.x
      end
      
      self:move(xSpeed, self.gravity, self.acceleration.x, self.acceleration.y, dt)
      self:setState(nstate)
    end
  )
  
  
  p:newState("jump",
    --init
    function(self)
      local aclX = self.acceleration.x
      local aclY = 1
      local jumpPower = -self.maxSpeed.y
      
      self:setAnimation("jump")
      self:move(0, jumpPower, aclX, aclY, dt)
    end,
    
    --state update
    function(self, dt)
      local xSpeed = 0
      local ySpeed = self.gravity
      local nstate = "jump"
      

      
      if BGE.inputManager:isDown("left") then 
        xSpeed = -self.maxSpeed.x
      end
            
      if BGE.inputManager:isDown("right") then 
        xSpeed = self.maxSpeed.x
      end
      
      self:move(xSpeed, self.gravity, self.acceleration.x, self.acceleration.y, dt)
      
      if self.vel.y > 10 then 
        nstate = "fall" 
      end
      
      self:setState(nstate)
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