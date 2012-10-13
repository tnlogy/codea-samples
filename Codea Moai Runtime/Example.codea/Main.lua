function setup()
end

local x,y = 100,100

function draw()
  sprite("Example:Bird", WIDTH/2 + math.sin(ElapsedTime*5)*100, HEIGHT/2)
  fontSize(42)
  fill(255, 255, 0)
  text("Hello World", x, y)
end

function touched(touch)
  if touch.state ~= ENDED then
    x, y = touch.x, touch.y
  end
end