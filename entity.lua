Entity = function(img, i, j, moves, tile)
    local ent = {}
    ent.img = img
    ent.i = i
    ent.j = j
    ent.moves = moves
    ent.attacks = 1

    ent.x = i*50
    ent.y = j*50

    ent.hp = 5
    ent.dmg = 2
    ent.moving = false
    ent.attacking = false
    ent.moved = 0
    ent.attacked = 0
    ent.nextTile = nil
    ent.onTop = nil
    ent.inMoveArea = false
    ent.inAttackArea = false

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

    local function MarkMoveArea(self, field)
        local ms = self.moves - self.moved
        for i = 0, ms do
            for j = 0, ms-i do
                if (field.h >= self.i + i and field.w >= self.j + j) then
                    field[self.i + i][self.j + j].inMoveArea = true
                end
                if (self.i - i > 0 and field.w >= self.j + j) then
                    field[self.i - i][self.j + j].inMoveArea = true
                end
                if (field.h >= self.i + i and self.j - j > 0) then
                    field[self.i + i][self.j - j].inMoveArea = true
                end
                if (self.i - i > 0 and self.j - j > 0) then
                    field[self.i - i][self.j - j].inMoveArea = true
                end
            end
        end
    end

    ent.MarkAttackArea = MarkAttackArea
    ent.MarkMoveArea = MarkMoveArea    

    return ent
end