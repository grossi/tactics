Button = function(imgfile, x, y, w, h, ...)
    local butt = {}
    butt.arg = arg
    butt.x = x
    butt.y = y
    butt.w = w
    butt.h = h
    butt.img = love.graphics.newImage(imgfile)
    return butt
end