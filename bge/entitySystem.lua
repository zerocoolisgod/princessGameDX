------------------------------------------------------------------------------
-- Entity System
------------------------------------------------------------------------------
local entSys = {}

entSys.ents = {}

-------------------------------------------------------------------------------
-- Entity Table Managment
-------------------------------------------------------------------------------
function entSys:clearEnts()
	self.ents = {}
end

function entSys:registerEntityTable(entTable)
	self.ents = entTable
end

function entSys:getEnts()
	return self.ents
end


function entSys:addEntity(e)
	table.insert(self.ents, e)
end


-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------
function entSys:updateEnts(dt)
	for i = #self.ents, 1, -1 do
		if self.ents[i].remove then 
			table.remove(self.ents, i)
		end
	end
	
	for i = 1, #self.ents do
		self.ents[i]:update(dt)
		
	end
end


function entSys:drawEnts()
	for i = 1, #self.ents do
		self.ents[i]:draw()
	end
end


return entSys