Entity = function(img, x, y, moves, ...)
    local ent = {}
    ent.arg = arg
    ent.img = img
    ent.x = x
    ent.y = y
    ent.moves = moves

    ent.moving = false
    ent.moved = 0
    ent.nextTile = nil
    ent.onTop = nil
    return ent
end