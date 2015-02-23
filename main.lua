require "tile"
require "entity"
require "button"
require "field"

function love.load ()

	-- Create States

	state = 'move'

	-- Creates UI
	buttons = {}
	nextTurnButton = Button('nextTurnButton.png', 450, 50, 50, 50)
	attackButton = Button('attackButton.png', 450, 125, 50, 50)
	table.insert(buttons, nextTurnButton)
	table.insert(buttons, attackButton)
	
	-- Creates Field 

	tileImg = love.graphics.newImage('tile.jpg')
	field = Field(tileImg, 7, 7)

	-- Creates Entities
	ent = Entity(love.graphics.newImage('bug.png'), 1, 1, 3, field[1][1]) -- img, i, j, moves, tile
	ent2 = Entity(love.graphics.newImage('bug.png'), 6, 1, 2, field[6][1]) -- img, i, j, moves, tile
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
	if(state == 'move') then
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
					currentEnt.i = currentEnt.nextTile.x
					currentEnt.j = currentEnt.nextTile.y
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
		-- AttackButton

		if(down) then
			if (attackButton.x < x and x < attackButton.x+attackButton.w) then
				if (attackButton.y < y and y < attackButton.y+attackButton.h) then
					attackButton.pressed = true
				end
			end
		elseif(attackButton.pressed) then
			state = 'attack'
			attackButton.pressed = false
		end
	elseif (state == 'attack') then
		-- Attack Phase 
		local attackPressed = false
		currentEnt:MarkAttackArea(field)
		if down then
			attackPressed = true
		elseif attackPressed then
			attackPressed = false
			if( field:getTile(x, y).entity ) then

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
		-- Changes the currentEnt
		currentEnt.moved = 0
		entI = (entI)%#ents + 1
		currentEnt = ents[entI]
		nextTurnButton.pressed = false

		-- Change the state to move
		state = 'move'

		-- Reset the state of tiles 
		for i, k in ipairs(field) do
			for j,tile in ipairs(k) do
				tile.inAttackArea = false 
			end
		end
	end
end

function love.draw ()
	-- Draw the Field
	for i, k in ipairs(field) do
		for j,tile in ipairs(k) do
			local x = i*50
			local y = j*50
			if(tile.inAttackArea) then
				local r, g, b, a = love.graphics.getColor()
				love.graphics.setColor(255, 150, 150)
				love.graphics.draw(tile.img, x, y)
				love.graphics.setColor(r, g, b, a)
			else
				love.graphics.draw(tile.img, x, y)
			end
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

	love.graphics.print(field.w .. ', ' .. field.h , 5, 5)
end
