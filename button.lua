Button = function(imgfile, x, y, w, h)
    local butt = {}
    butt.x = x
    butt.y = y
    butt.w = w
    butt.h = h
    butt.img = love.graphics.newImage(imgfile)

    local function MouseOnTop(self, x, y) -- Changes the state of button.pressed if mouse is on top
        if (self.x < x and x < self.x+self.w) then
            if (self.y < y and y < self.y+self.h) then
                self.pressed = true
            end
        end
    end

    butt.MouseOnTop = MouseOnTop

    return butt
end