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
    
    local function GetTile(self, x, y)
        for i, v in ipairs(self) do
            for j, tile in ipairs(v) do
                if(math.floor(x/50) == i and math.floor(y/50) == j) then
                    return tile
                end
            end
        end
        return nil
    end

    local function Clear(self)
        for i, v in ipairs(self) do
            for j, tile in ipairs(v) do
                tile.inAttackArea = false
                tile.inMoveArea = false
                tile.inAttackRange = false
            end
        end
    end

    field.Clear = Clear
    field.GetTile = GetTile

    return field
end

DungeonField = function(tileImg, w, h)
    local field = {}
    field.w = w
    field.h = h
    for i = 1, w do
        field[i] = {}
        for j = 1, h do
            field[i][j] = DungeonTile(tileImg, i, j, 300, 300, 100, 100)
        end
    end
    
    local function GetTile(self, x, y)
        for i, v in ipairs(self) do
            for j, tile in ipairs(v) do
                if(math.floor(x/100) == i-1 and math.floor(y/100) == j-1) then
                    return tile
                end
            end
        end
        return nil
    end

    field.GetTile = GetTile

    return field
end