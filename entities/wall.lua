local ent = {}

function ent:new(x,y)
  local e = BGE.entity:new(x, y, 16, 16)
  e.id = "wall"
  e:addRectangle({0.2, 1, 0.2, 1})
  e:addCollision(true)
  return e
end

return ent