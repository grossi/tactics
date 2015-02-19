require "tile"

function love.load ()
	ent = {}
	ent.img = love.graphics.newImage('bug.png')
	ent.x = 50
	ent.y = 50
	table = {}
	tileImg = love.graphics.newImage('tile.jpg')
	for i = 1,7 do
		table[i] = {}
		for j = 1,7 do
			table[i][j] = Tile(tileImg, i, j)
		end
	end
	table[2][3].entity = ent
end

function love.update (dt)
	down = love.mouse.isDown("l")
	x = love.mouse.getX()
	y = love.mouse.getY()
	if(down and not ent.moving) then
		if (ent.x < x and x < ent.x+50) then
			if (ent.y < y and y < ent.y+50) then
				ent.moving = true
				ent.x = x - 25
				ent.y = y - 25
			end
		end
	end
	if(ent.moving) then
		if(not down) then
			ent.moving = false
			ent.x = ent.onTop.x*50
			ent.y = ent.onTop.y*50
		else
			ent.x = x - 25
			ent.y = y - 25
		end
	end
	for i,v in ipairs(table) do
		for j,tile in ipairs(v) do
			if(math.floor(x/50) == i and math.floor(y/50) == j) then
				tile.mouseOnTop = true
				ent.onTop = tile
			else
				tile.mouseOnTop = false
			end
		end
	end
end

function love.draw ()
	for i, k in ipairs(table) do
		for j,tile in ipairs(k) do
			x = i*50
			y = j*50
			love.graphics.draw(tile.img, x, y)
			if( tile:isFull() ) then
				--love.graphics.draw(tile.entity.img, x+1, y+5)
			end
			if( tile.mouseOnTop ) then
				love.graphics.polygon('line', x, y, x+50, y, x+50, y+50, x, y+50)
			end
		end
	end
	love.graphics.draw(ent.img, ent.x+1, ent.y+5)
end
