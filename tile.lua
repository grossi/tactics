Tile = function(img, x, y, ...) --Recebe o nome, ponteiro para o pai e os parametros do buff especifico
    local tab = {}
    tab.arg = arg
    tab.img = img
    tab.x = x
    tab.y = y
    local function isFull(self) 
    	if (self.entity == nil) then
    		return false
    	end
    	return true
    end
    tab.isFull = isFull
    return tab
end