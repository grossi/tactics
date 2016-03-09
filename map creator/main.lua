package.path = package.path .. ";../?.lua"

local function GetTile(field, x, y)
    for i, v in ipairs(field) do
        for j, quad in ipairs(v) do
            if(math.floor(x-DXIMG/100) == i and math.floor(y-DYIMG/100) == j) then
                return quad
            end
        end
    end
    return nil
end

function love.load()
	love.window.setMode( 1920, 1080, {borderless=true, vsync=false} )
	imgQuads = {}
	tileImg = love.graphics.newImage('dungeonTile.jpg')
	tilew = 100
	tileh = 100
	DXIMG = 1200
	DYIMG = 199
	for i = 100, tileImg:getWidth(), 100 do
		imgQuads[i/100] = {}
		for j = 100, tileImg:getHeight(), 100 do
			imgQuads[i/100][j/100] = love.graphics.newQuad(i-100, j-100, 100, 100, tileImg:getDimensions())
		end
	end
	newQuads = {}
	status = 'main'
end

function love.update (dt)
	down = love.mouse.isDown("l")
	x = love.mouse.getX()
	y = love.mouse.getY()

	quad = GetTile(imgQuads, x, y)

	if(quad) then
		status = 'moving'
		newQuad = love.graphics.newQuad(quad:getViewport(), tileImg:getDimensions())
		table.insert(newQuads, newQuad)
	else
		
	end

end

function love.draw ()
	for i, k in ipairs(imgQuads) do
		for j,quad in ipairs(k) do
			local x = (i-1)*100
			local y = (j-1)*100
			love.graphics.draw(tileImg, quad, DXIMG+i*100, DYIMG+j*100)
		end
	end
	if(newQuad~=nil) then
		love.graphics.draw(tileImg, newQuad, x, y)
	end
end