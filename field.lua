require "tile"

Field = function(tileImg, w, h)
    local field = {}
    field.w = w
    field.h = h
    for i = 1, w do
        field[i] = {}
        for j = 1, h do
            field[i][j] = Tile(tileImg, i, j)
        end
    end
    
    local function getTile(self, x, y)
        for i, v in ipairs(self) do
            for j, tile in ipairs(v) do
                if(math.floor(x/50) == i and math.floor(y/50) == j) then
                    return tile
                end
            end
        end
        return nil
    end

    field.getTile = getTile

    return field
end