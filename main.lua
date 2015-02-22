require "tile"
require "entity"
require "button"

function love.load ()
	button = Button(450, 50, 50, 100)
	ent = Entity(love.graphics.newImage('bug.png'), 50, 50, 3) -- img, x, y, moves
	ent2 = Entity(love.graphics.newImage('bug.png'), 100, 100, 2) -- img, x, y, moves
	field = {}
	ents = {}
	table.insert(ents, ent)
	table.insert(ents, ent2)
	tileImg = love.graphics.newImage('tile.jpg')
	for i = 1,7 do
		field[i] = {}
		for j = 1,7 do
			field[i][j] = Tile(tileImg, i, j)
		end
	end
	field[2][3].entity = ent

	entI = 1
	currentEnt = ents[entI]
end

function love.update (dt)
	down = love.mouse.isDown("l")
	x = love.mouse.getX()
	y = love.mouse.getY()

	-- Entity mouse movement

	if(down and not currentEnt.moving) then
		if (currentEnt.x < x and x < currentEnt.x+50) then
			if (currentEnt.y < y and y < currentEnt.y+50) then
				currentEnt.moving = true
				currentEnt.x = x - 25
				currentEnt.y = y - 25
			end
		end
	end
	if(currentEnt.moving) then
		if(not down) then
			currentEnt.moving = false
			if(currentEnt.nextTile) then
				currentEnt.x = currentEnt.nextTile.x*50
				currentEnt.y = currentEnt.nextTile.y*50
			end
		else
			currentEnt.x = x - 25
			currentEnt.y = y - 25
		end
	end
	for i,v in ipairs(field) do
		for j,tile in ipairs(v) do
			if(math.floor(x/50) == i and math.floor(y/50) == j) then
				if(currentEnt.onTop ~= tile) then
					if(down and currentEnt.moving) then
						if(currentEnt.moves > currentEnt.moved) then
							currentEnt.nextTile = tile
							currentEnt.moved = currentEnt.moved + 1
						end
					end
				end
				tile.mouseOnTop = true
				currentEnt.onTop = tile
			else
				tile.mouseOnTop = false
			end
		end
	end


	-- UI mouse movement
	if(down) then
		if (button.x < x and x < button.x+button.w) then
			if (button.y < y and y < button.y+button.h) then
				button.pressed = true
			end
		end
	elseif(button.pressed) then
		currentEnt.moved = 0
		entI = (entI)%#ents + 1
		currentEnt = ents[entI]
		button.pressed = false
	end

	
end

function love.draw ()
	for i, k in ipairs(field) do
		for j,tile in ipairs(k) do
			local x = i*50
			local y = j*50
			love.graphics.draw(tile.img, x, y)
			if( tile.mouseOnTop and down and currentEnt.moving and currentEnt.nextTile == tile) then
				love.graphics.polygon('fill', x, y, x+50, y, x+50, y+50, x, y+50)
			end
		end
	end
	for i, e in ipairs(ents) do
		if(e ~= currentEnt ) then
			love.graphics.draw(e.img, e.x+1, e.y+5)
		end
	end

	if( currentEnt.moving and currentEnt.nextTile ) then
		local t = currentEnt.nextTile
		local x = t.x*50
		local y = t.y*50
		love.graphics.polygon('fill', x, y, x+50, y, x+50, y+50, x, y+50)
	end

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(100, 150, 100)
	love.graphics.polygon('fill', 450, 50, 500, 50, 500, 150, 450, 150)
	love.graphics.setColor(r, g, b, a)

	love.graphics.setColor(150, 150, 255)
	love.graphics.draw(currentEnt.img, currentEnt.x+1, currentEnt.y+5)
	love.graphics.setColor(r, g, b, a)

	love.graphics.print(currentEnt.moved, 5, 5)
end
