require "tile"
require "entity"
require "button"
require "field"

function loadBattlefield()
	-- Creates UI
	buttons = {}
	nextTurnButton = Button('nextTurnButton.png', 450, 50, 50, 50)
	attackButton = Button('attackButton.png', 450, 125, 50, 50)
	moveButton = Button('moveButton.png', 450, 200, 50, 50)
	skillButton = Button('skillButton.png', 450, 275, 50, 50)
	table.insert(buttons, nextTurnButton)
	table.insert(buttons, attackButton)
	table.insert(buttons, moveButton)
	table.insert(buttons, skillButton)
	
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

function loadDungeon()
		-- Creates UI
	buttons = {}
	
	-- Creates Field 

	tileImg = love.graphics.newImage('dungeonTile.jpg')
	field = DungeonField(tileImg, 7, 7)

	-- Creates Entities
	ent = Entity(love.graphics.newImage('bug.png'), 1, 1, 3, field[1][1]) -- img, i, j, moves, tile
	ents = {}
	table.insert(ents, ent)
end


function love.load ()

	-- Sets inicial game state

	state = 'dungeon'

	-- Sets inicial UISTate

	UIState = 'dungeon'

	loadDungeon()
end

function love.update (dt)
	down = love.mouse.isDown("l")
	x = love.mouse.getX()
	y = love.mouse.getY()

	-- Dungeon State
	if(state == 'dungeon') then
		if(love.keyboard.isDown("w")) then
			ent.y = ent.y - 100*dt
		end
		if(love.keyboard.isDown("a")) then
			ent.x = ent.x - 100*dt
		end
		if(love.keyboard.isDown("s")) then
			ent.y = ent.y + 100*dt
		end
		if(love.keyboard.isDown("d")) then
			ent.x = ent.x + 100*dt
		end
		local tile = field:GetTile(ent.x, ent.y)
		if(tile ~= nil and tile ~= ent.nextTile) then
			local i, j  = tile.x-1, tile.y-1
			ent.x = i*100 + 45
			ent.y = j*100 + 45
			ent.i = i
			ent.j = j
			ent.nextTile = tile
			ent.nextTile.entity = ent
		end
		if(love.keyboard.isDown("return")) then
			loadBattlefield()
			state = 'battleMain'
			UIState = 'battle'
		end
	end

	-- battleMain Stage

	if(state == 'battleMain') then

	end

	-- Move Stage
	if(state == 'move') then
		if(down and not currentEnt.moving) then -- If you start draggin the ent
			if (currentEnt.x < x and x < currentEnt.x+50) then
				if (currentEnt.y < y and y < currentEnt.y+50) then
					currentEnt.moving = true
					currentEnt.x = x - 25
					currentEnt.y = y - 25
				end
			end
		end
		if(currentEnt.moving) then  
			if(not down) then -- If you stop draggin the ent		
				currentEnt.moving = false
				if(currentEnt.nextTile) then
					local i, j = currentEnt.nextTile.x, currentEnt.nextTile.y
					currentEnt.moved = currentEnt.moved + math.abs(currentEnt.i - i) + math.abs(currentEnt.j - j)
					currentEnt.x = i*50
					currentEnt.y = j*50
					currentEnt.i = i
					currentEnt.j = j
					field:Clear()
					currentEnt:MarkMoveArea(field)
					currentEnt.nextTile.entity = currentEnt
				end
			else
				currentEnt.x = x - 25
				currentEnt.y = y - 25
			end
		end
		local tile = field:GetTile(x, y)
		if(tile~= nil) then
			if(currentEnt.onTop ~= tile) then
				if(down and currentEnt.moving) then
					if(tile.inMoveArea) then
						currentEnt.nextTile = tile
					end
				end
			end
			currentEnt.onTop = tile
		end
	end


	-- Attack Stage
	if (state == 'attack') then 
		currentEnt:MarkAttackArea(field)
		if down and not currentEnt.attacking then
			currentEnt.attacking = true
		elseif currentEnt.attacking and not down then
			currentEnt.attacking = false
			local t = field:GetTile(x, y)
			if t then
				local ent = t.entity
				if( ent and t.inAttackArea ) then
					ent.hp = ent.hp - currentEnt.dmg
					currentEnt.attacked = currentEnt.attacked + 1
					if currentEnt.attacks >= currentEnt.attacked then
						state = 'battleMain'
						field:Clear()
					end
				end
			end
		end
	end

	-- Skill Stage
	if (state == 'skill') then 
		field:Clear()
		currentEnt.attackSkill.MarkAttackRange(currentEnt, field)
		currentEnt.attackSkill.MarkAttackArea(currentEnt, field)
		if down and not currentEnt.attacking then
			currentEnt.attacking = true
		elseif currentEnt.attacking and not down then
			currentEnt.attacking = false
			local t = field:GetTile(x, y)
			if t then
				local ent = t.entity
				if( ent and t.inAttackArea ) then
					ent.hp = ent.hp - currentEnt.dmg
					currentEnt.attacked = currentEnt.attacked + 1
					if currentEnt.attacks >= currentEnt.attacked then
						state = 'battleMain'
						field:Clear()
					end
				end
			end
		end
	end




	-- UI

	-- Dungeon
	if(UIState ) then

	end

	-- battle
	if(UIState == 'battle') then

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
			currentEnt.attacked = 0
			entI = (entI)%#ents + 1
			currentEnt = ents[entI]
			nextTurnButton.pressed = false

			-- Change the state to move
			state = 'battleMain'

			field:Clear()
		end

		-- MoveButton
		if(down) then
			moveButton:MouseOnTop(x, y) -- Changes the state of button.pressed if mouse is on top
		elseif(moveButton.pressed) then
			field:Clear()
			state = 'move'
			currentEnt:MarkMoveArea(field)
			moveButton.pressed = false
		end

		-- AttackButton
		if currentEnt.attacks > currentEnt.attacked then
			if down then
				attackButton:MouseOnTop(x, y) -- Changes the state of button.pressed if mouse is on top
			elseif(attackButton.pressed) then
				field:Clear()
				state = 'attack'
				currentEnt:MarkAttackArea(field)
				attackButton.pressed = false
			end
		end

		-- SkillButton
		if currentEnt.attacks > currentEnt.attacked then
			if down then
				skillButton:MouseOnTop(x, y) -- Changes the state of button.pressed if mouse is on top
			elseif(skillButton.pressed) then
				field:Clear()
				state = 'skill'
				currentEnt.attackSkill.MarkAttackRange(currentEnt, field)
				skillButton.pressed = false
			end
		end
	end
end

function love.draw ()
	--UI Dangeon state

	if(UIState == 'dungeon') then
		-- Draw the Field
		local width, height = love.graphics.getDimensions( )

		local dx, dy = ent.x - (width/2), ent.y - (height/2)

		for i, k in ipairs(field) do
			for j,tile in ipairs(k) do
				local x = (i-1)*100
				local y = (j-1)*100
				love.graphics.draw(tile.img, tile.quad, x-dx, y-dy)
			end
		end
		for i, e in ipairs(ents) do
			if(e ~= ent ) then
				love.graphics.draw(e.img, e.x+dx, e.y+dy)
			end
		end

		love.graphics.draw(ent.img, (width/2)-23, (height/2)-20)
	end

	-- UI Battle state
	if(UIState == 'battle') then
		-- Draw the Field
		for i, k in ipairs(field) do
			for j,tile in ipairs(k) do
				local x = i*50
				local y = j*50
				if(tile.inAttackArea ) then -- In attack area, red shade
					local r, g, b, a = love.graphics.getColor()
					love.graphics.setColor(200, 100, 100)
					love.graphics.draw(tile.img, x, y)
					love.graphics.setColor(r, g, b, a)
				elseif(tile.inAttackRange ) then -- In attack range, pink shade
					local r, g, b, a = love.graphics.getColor()
					love.graphics.setColor(255, 200, 200)
					love.graphics.draw(tile.img, x, y)
					love.graphics.setColor(r, g, b, a)
				elseif(tile.inMoveArea) then -- In move area, blue shade
					local r, g, b, a = love.graphics.getColor()
					love.graphics.setColor(150, 150, 255)
					love.graphics.draw(tile.img, x, y)
					love.graphics.setColor(r, g, b, a)
				else
					love.graphics.draw(tile.img, x, y)
				end
				if( down and currentEnt.moving and currentEnt.nextTile == tile) then
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

		love.graphics.print('ent1:' .. ents[1].hp .. ' ent 2:' .. ents[2].hp , 5, 5)
		if attackPressed then
			love.graphics.print('Attack!', 150, 5)
		end
	end
end
