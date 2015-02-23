Entity = function(img, i, j, moves, tile)
    local ent = {}
    ent.img = img
    ent.i = i
    ent.j = j
    ent.moves = moves

    ent.x = i*50
    ent.y = j*50

    ent.moving = false
    ent.moved = 0
    ent.nextTile = nil
    ent.onTop = nil

    local function MarkAttackArea(self, field)
        if(field.w >= self.i+1 ) then
            field[self.i+1][self.j].inAttackArea = true
        end
        if(self.i-1 > 0 ) then 
            field[self.i-1][self.j].inAttackArea = true
        end
        if(field.h >= self.j+1 ) then
            field[self.i][self.j+1].inAttackArea = true
        end
        if(self.j-1 > 0 ) then
            field[self.i][self.j-1].inAttackArea = true
        end
    end

    ent.MarkAttackArea = MarkAttackArea

    ent.entity = ent

    return ent
end