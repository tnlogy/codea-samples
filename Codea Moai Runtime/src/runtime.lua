runtime = {}

WIDTH, HEIGHT = 1024,768
--WIDTH, HEIGHT = MOAIGfxDevice.getViewSize()

dofile('src/Class.lua')

runtime.frame = 0

runtime.start = function ()
	runtime.setup()
	runtime.step()

	MOAICoroutine.new():run(function ()
		while true do
			runtime.step()
			runtime.frame = runtime.frame + 1
			coroutine:yield()
		end
	end)
end

runtime.loadProject = function (name, files)
	for _,file in ipairs(files) do
		print("loading " .. file)
		dofile(name .. ".codea/" .. file .. ".lua")
	end
end

runtime.setup = function ()
	ElapsedTime = 0

	MOAISim.openWindow ( "test", WIDTH, HEIGHT )

	runtime.viewport = MOAIViewport.new ()
	runtime.viewport:setSize ( WIDTH, HEIGHT )
	runtime.viewport:setScale ( WIDTH, HEIGHT )
	runtime.viewport:setOffset (-1, -1)

	-- initial values
	runtime.font = MOAIFont.new()
	font("arial-rounded")
	runtime.fontSize = 14

	runtime.color = MOAIColor.new()
	fill(255, 255, 255, 255)

	runtime.imageCache = {}

	CurrentTouch = { id = 1, state = ENDED }

	if MOAIInputMgr.device.pointer then
		runtime.setupHandlers()
	end

	runtime.quadCache = {}
	runtime.quadIndex = 0

	setup()
end

runtime.setupHandlers = function ( pointerCallback, clickCallback )
	local lastFrame = -1

	local pointerCallback = function ( x, y )
		if lastFrame ~= runtime.frame then
			lastFrame = runtime.frame

	  		x, y = runtime.layer:wndToWorld ( x, y )
			CurrentTouch.deltaX = (x - (CurrentTouch.x or x))
			CurrentTouch.deltaY = (y - (CurrentTouch.y or y))
			CurrentTouch.prevX, CurrentTouch.prevY = CurrentTouch.x, CurrentTouch.y
			CurrentTouch.x, CurrentTouch.y = x, y
	
			if CurrentTouch.state == BEGAN then
				CurrentTouch.state = MOVING
			end
		end
	end
	local clickCallback = function ( down )
		if down then
			CurrentTouch.state = BEGAN
		else
			CurrentTouch.state = ENDED
		end
	end

  	if MOAIInputMgr.device.pointer then
  		MOAIInputMgr.device.pointer:setCallback ( pointerCallback )
  		MOAIInputMgr.device.mouseLeft:setCallback ( clickCallback )
  	else
  	  	MOAIInputMgr.device.touch:setCallback ( 
  	  
  	    	function ( eventType, idx, x, y, tapCount )
  		    	pointerCallback ( x, y )
  		    	CurrentTouch.tapCount = tapCount
  		    	
  		    	if eventType == MOAITouchSensor.TOUCH_DOWN then
  		    	    clickCallback ( true )
  		    	elseif eventType == MOAITouchSensor.TOUCH_UP then
  		    	    clickCallback ( false )
  		    	end
  	    	end
  	  	)
  	end
end

runtime.step = function ()
	DeltaTime, ElapsedTime = MOAISim.getStep(), MOAISim.getElapsedTime()

	MOAISim:clearRenderStack()
	runtime.layer = MOAILayer2D.new ()
	runtime.layer:setViewport ( runtime.viewport )
	MOAISim.pushRenderPass ( runtime.layer )

	runtime.transformStack = {}
	resetMatrix()

	if MOAIInputMgr.device.touch then
		runtime.updateTouchSensor()
	elseif CurrentTouch.x then touched(CurrentTouch) end		


	runtime.quadIndex = 0

	draw()
end


runtime.updateTouchSensor = function ()
	if MOAIInputMgr.device.touch:hasTouches() then
		local x, y = MOAIInputMgr.device.touch:getTouch()
		x, y = runtime.layer:wndToWorld ( x, y )

		CurrentTouch.deltaX = (x - (CurrentTouch.x or x))
		CurrentTouch.deltaY = (y - (CurrentTouch.y or y))
		CurrentTouch.x, CurrentTouch.y = x, y

		if CurrentTouch.state == ENDED then
			CurrentTouch.state = BEGAN
		else
			CurrentTouch.state = MOVING
		end
		touched(CurrentTouch)
	elseif CurrentTouch.state == MOVING or CurrentTouch.state == BEGAN then
		CurrentTouch.state = ENDED
		touched(CurrentTouch)
	end
end

runtime.getPos = function (x, y)
	local cx, cy = runtime.transform:getLoc()
	return (cx+x), (cy+y)
end

runtime.getQuad = function ( image )
	runtime.quadIndex = runtime.quadIndex + 1
	local quad = runtime.quadCache[runtime.quadIndex]
	if not quad then
		quad = MOAIGfxQuad2D.new()
		table.insert(runtime.quadCache, quad)
	end

	quad:setTexture( image )
	return quad
end


---- GRAPHICS ----
-- drawing

function background( r, g, b, a )
	MOAIGfxDevice.setClearColor( r/255, g/255, b/255, a/255 )
end
function backingMode( mode ) end
function ellipse( x, y, width, height ) end
function line( x1, y1, x2, y2 ) end
function rect( x, y, width, height )
	local r, g, b, a = unpack(runtime.rgba)
	local onDraw = function (index, xOff, yOff, xFlip, yFlip)
		MOAIGfxDevice.setPenColor( r, g, b, a )
		MOAIDraw.fillRect(0, 0, width, height)
	end

	local scriptDeck = MOAIScriptDeck.new ()
	local hw, hh = width/2, height/2
	scriptDeck:setRect ( -hw, -hh, hw, hh )
	scriptDeck:setDrawCallback ( onDraw )

	local prop = MOAIProp2D.new ()
	prop:setDeck ( scriptDeck )
	prop:setLoc( runtime.getPos(x, y) )
  	runtime.layer:insertProp ( prop )
end
function sprite( name, x, y, width, height )
	local i = string.find(name, ":")
	local spritePack = string.sub(name, 1, i-1)
	local file = string.sub(name, i+1)

	local image = runtime.imageCache[name]

	if not image then
		image = MOAIImage.new()
		runtime.imageCache[name] = image
		image:load(spritePack .. ".spritePack/" .. file .. ".png", MOAIImage.PREMULTIPLY_ALPHA)
	end
	local iw,ih = image:getSize()

	local gfxQuad = runtime.getQuad( image )

	local hw,hh = (width or iw) / 2, (height or ih) / 2

	gfxQuad:setRect ( -hw, -hh, hw, hh )
	gfxQuad:setUVRect ( 0, 1, 1, 0 )
	
	local prop = MOAIProp2D.new ()
	prop:setDeck ( gfxQuad )
	prop:setLoc( runtime.getPos(x or 0, y or 0) )
	runtime.layer:insertProp ( prop )
end

function text( string, x, y ) 
	local textbox = MOAITextBox.new()
  textbox:setString( "" .. string )
	textbox:setFont( runtime.font )
	textbox:setColor( 1, 1, 1, 1) -- runtime.color )
	textbox:setTextSize( runtime.fontSize )
 	textbox:setRect( 0, -50, 200, 0 )
	textbox:setYFlip( true )
	textbox:setLoc( runtime.getPos(x, y) )
  runtime.layer:insertProp( textbox )
end

-- transform

function rotate( angle )
	runtime.transform:addRot( angle )
end
function scale( x, y )
	runtime.transform:setScl(x, y)
end
function translate(	x, y )
	runtime.transform:addLoc(x, y)
end
function zLevel( z ) end

-- advanced transform
function applyMatrix( matrix ) end
function camera( eyeX, eyeY, eyeZ, cX, cY, cZ, upX, upY, upZ) end
function modelMatrix() end
function ortho( left, right, bottom, top ) end
function perspective( fov, aspect, near, far ) end
function projectionMatrix() end
function viewMatrix() end

-- style

function fill( r, g, b, a )
	r, g, b, a = r/255, g/255, b/255, (a or 255)/255
	runtime.rgba = {r, g, b, a}
	runtime.color:setColor( r, g, b, a)
end
function ellipseMode( mode ) end
function font( name )
	if name ~= "arial-rounded" then return end
	print("loading font " .. name)
	local charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖabcdefghijklmnopqrstuvwxyzåäö0123456789 .,:;!?()&/-'
	runtime.font:load( "src/" .. name .. ".TTF" )
	runtime.font:preloadGlyphs( charcodes, 42 )
end
function fontMetrics() end
function fontSize( size )
	runtime.fontSize = size
end
function lineCapMode( mode ) end
function noFill() end
function noSmooth() end
function noStroke() end
function noTint() end
function rectMove( mode ) end
function smooth() end
function spriteMode( mode ) end
function spriteSize( name ) end
function stroke( r, g, b, a) end
function strokeWidth( width ) end
function textAlign( align ) end
function textMode( mode ) end
function textWrapWidth( width ) end
function tint( r, g, b, a) end

-- text metrics
function textSize( string ) end

-- transform management
function pushMatrix()
	table.insert(runtime.transformStack, runtime.transform)
	local nt = MOAITransform.new()
	nt:setLoc(runtime.transform:getLoc())
	nt:setScl(runtime.transform:getScl())
	nt:setRot(runtime.transform:getRot())
	runtime.transform = nt
end
function popMatrix()
	runtime.transform = table.remove(runtime.transformStack)
end
function resetMatrix()
	runtime.transform = MOAITransform.new()
end

-- style management
function pushStyle() end
function popStyle() end
function resetStyle() end

---- TOUCH ----
BEGAN, MOVING, ENDED = 1, 2, 3

---- DISPLAY & KEYBOARD ----

-- display

FULLSCREEN, FULLSCREEN_NO_BUTTONS, STANDARD = 1, 2, 3

function displayMode( mode ) end

ANY, LANDSCAPE_ANY, LANDSCAPE_LEFT, LANDSCAPE_RIGHT = 1, 2, 3
PORTRAIT, PORTRAIT_ANY, PORTRAIT_UPSIDE_DOWN = 4, 5, 6

function supportedOrientations( orientation ) end

-- keyboard

function showKeyboard() end
function hideKeyboard() end
function keyboardBuffer() end
BACKSPACE = 1





