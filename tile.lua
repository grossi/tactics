Tile = function(img, x, y)
    local tile = {}
    tile.img = img
    tile.x = x
    tile.y = y
    local function isFull(self) 
    	if (self.entity == nil) then
    		return false
    	end
    	return true
    end
    tile.entity = nil
    tile.inAttackArea = false
    tile.isFull = isFull
    return tile
end