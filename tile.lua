Tile = function(img, x, y)
    local tile = {}
    tile.img = img
    tile.x = x
    tile.y = y
    local function IsFull(self) 
    	if (self.entity == nil) then
    		return false
    	end
    	return true
    end
    tile.entity = nil
    tile.inAttackArea = false
    tile.inAttackRange = false
    tile.IsFull = IsFull
    return tile
end

DungeonTile = function(img, x, y, imgx, imgy, imgw, imgh)
    local tile = {}
    tile.img = img
    tile.quad = love.graphics.newQuad(imgx, imgy, imgw, imgh, img:getDimensions())
    tile.x = x
    tile.y = y
    local function IsFull(self) 
        if (self.entity == nil) then
            return false
        end
        return true
    end
    tile.entity = nil
    tile.inAttackArea = false
    tile.IsFull = IsFull
    return tile
end

