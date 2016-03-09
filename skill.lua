AttackSkill = function()
    local skill = {}

    local function MarkAttackRange(ent, field)
        for i = -2, 2 do
            for j = -2, 2 do
                if( math.abs(i)+math.abs(j) < 3 and 
                field.w >= ent.i+i and 
                ent.i+i > 0  and
                field.h >= ent.j+j  and
                ent.j+j > 0 and
                field.w >= ent.i+i ) then
                    field[ent.i+i][ent.j+j].inAttackRange = true
                end
            end
        end
    end

    local function MarkAttackArea(ent, field)
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        local tile = field:GetTile(x, y)
        if( tile ~= nil and tile.inAttackRange ) then
            field[tile.x][tile.y].inAttackArea = true
            if(field.w >= tile.x+1 ) then
                field[tile.x+1][tile.y].inAttackArea = true
            end
            if(tile.x-1 > 0 ) then 
                field[tile.x-1][tile.y].inAttackArea = true
            end
            if(field.h >= tile.y+1 ) then
                field[tile.x][tile.y+1].inAttackArea = true
            end
            if(tile.y-1 > 0 ) then
                field[tile.x][tile.y-1].inAttackArea = true
            end
        end
    end

    skill.MarkAttackArea = MarkAttackArea
    skill.MarkAttackRange = MarkAttackRange    

    return skill
end