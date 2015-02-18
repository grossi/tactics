function love.load ()
	table = {}
	for i = 1,10 do
		table[i] = {}
		for j = 1,10 do
			table[i][j] = love.graphics.newImage('tile.jpg')
		end
	end
end

function love.update (dt)
	
end

function love.draw ()
	for i, k in ipairs(table) do
		for j,t in ipairs(k) do
			x = i*50
			y = j*50
			love.graphics.draw(table[i][j], x, y)
		end
	end
end
