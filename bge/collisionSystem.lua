------------------------------------------------------------------------------
-- Collision System
------------------------------------------------------------------------------
local colSys = {}


function colSys:areaInRect(x1,y1,w1,h1,x2,y2,w2,h2)
	--box to box intersection
	return x1<x2+w2 and
         x2<x1+w1 and
         y1<y2+h2 and
         y2<y1+h1
end


function colSys:getColPos(e, o)
	-- Returnes the shortest distance 
	-- to get e outside of o.
	local p = {x = 0, y = 0}

	if e.pos.x < o.pos.x then p.x = o.pos.x - e.size.w end
	if e.pos.x > o.pos.x then p.x = o.pos.x + o.size.w end
	if e.pos.y < o.pos.y then p.y = o.pos.y - e.size.h end
	if e.pos.y > o.pos.y then p.y = o.pos.y + o.size.h end

	return p
end


function colSys:ckCollison(e, entTable)
	local p
	for i = 1, #entTable do
		local o = entTable[i]
		if e ~= o and o.collidable then 
			local c = self:areaInRect(e.pos.x, e.pos.y, e.size.w, e.size.h, o.pos.x, o.pos.y, o.size.w, o.size.h)
			if c then
				if o.solid then p = self:getColPos(e,o) end
				e.onBump(e, o)
				o.onBump(o, e)
			end
		end
	end

	return p
end


function colSys:getEntityInRect(caller, x, y, w, h, entTable)
	local entity
	for i = 1, #entTable do
		local o = entTable[i]
		if o ~= caller and o.collidable then 
			local c = self:areaInRect(x, y, w, h, o.pos.x, o.pos.y, o.size.w, o.size.h)
			if c then
				entity = o
			end
		end
	end

	return entity
end


function colSys:getEntityAtPoint(caller, x, y, entTable)
	self:getEntityInRect(x,y,0,0, entTable)
end

return colSys