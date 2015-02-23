require "tile"
require "entity"
require "button"

function love.load ()

	-- Creates UI
	buttons = {}
	nextTurnButton = Button('nextTurnButton.png', 450, 50, 50, 50)
	attackButton = Button('attackButton.png', 450, 125, 50, 50)
	table.insert(buttons, nextTurnButton)
	table.insert(buttons, attackButton)
	
	-- Creates Field 
	field = {}
	tileImg = love.graphics.newImage('tile.jpg')
	for i = 1,7 do
		field[i] = {}
		for j = 1,7 do
			field[i][j] = Tile(tileImg, i, j)
		end
	end

	-- Creates Entities
	ent = Entity(love.graphics.newImage('bug.png'), 50, 50, 3) -- img, x, y, moves
	ent2 = Entity(love.graphics.newImage('bug.png'), 100, 100, 2) -- img, x, y, moves
	ents = {}
	table.insert(ents, ent)
	table.insert(ents, ent2)

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
	-- NextTurnButton
	if(down) then
		if (nextTurnButton.x < x and x < nextTurnButton.x+nextTurnButton.w) then
			if (nextTurnButton.y < y and y < nextTurnButton.y+nextTurnButton.h) then
				nextTurnButton.pressed = true
			end
		end
	elseif(nextTurnButton.pressed) then
		currentEnt.moved = 0
		entI = (entI)%#ents + 1
		currentEnt = ents[entI]
		nextTurnButton.pressed = false
	end
	-- AttackButton

	if(down) then
		if (nextTurnButton.x < x and x < nextTurnButton.x+nextTurnButton.w) then
			if (nextTurnButton.y < y and y < nextTurnButton.y+nextTurnButton.h) then
				nextTurnButton.pressed = true
			end
		end
	elseif(nextTurnButton.pressed) then
		currentEnt.moved = 0
		entI = (entI)%#ents + 1
		currentEnt = ents[entI]
		nextTurnButton.pressed = false
	end
end

function love.draw ()
	-- Draw the Field
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

	-- Draw Entities
	for i, e in ipairs(ents) do
		if(e ~= currentEnt ) then
			love.graphics.draw(e.img, e.x+1, e.y+5)
		end
	end

	-- Draw the entitie target position
	if( currentEnt.moving and currentEnt.nextTile ) then
		local t = currentEnt.nextTile
		local x = t.x*50
		local y = t.y*50
		love.graphics.polygon('fill', x, y, x+50, y, x+50, y+50, x, y+50)
	end

	-- Draw the owner of the turn in a different shade
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(150, 150, 255)
	love.graphics.draw(currentEnt.img, currentEnt.x+1, currentEnt.y+5)
	love.graphics.setColor(r, g, b, a)

	-- Draw the Buttons
	for i,b in ipairs(buttons) do
		love.graphics.draw(b.img, b.x, b.y)
	end

	love.graphics.print(currentEnt.moved, 5, 5)
end
