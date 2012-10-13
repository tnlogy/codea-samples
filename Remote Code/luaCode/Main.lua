local x,y = 0,0
local scale = 1

function setup()
  print("Setting up")
  displayMode(FULLSCREEN)
  hw, hh = WIDTH/2, HEIGHT/2
end

function draw()
  background(255, 255, 0)
  fill(255, 0, 0, 128)
  rect(hw + math.sin(ElapsedTime*5)*200, hh + math.cos(ElapsedTime*3)*200, 100, 100)
  rect(hw + math.sin(ElapsedTime*3)*200, hh + math.cos(ElapsedTime*4)*200, 100, 100)
  rect(hw + math.sin(ElapsedTime*8)*200, hh + math.cos(ElapsedTime*7)*200, 100, 100)
  sprite("Planet Cute:Brown Block", x, y, 100*scale)  
end

function touched(touch)
  x,y = touch.x, touch.y
  if touch.state ~= ENDED then
    scale = 2
  else
    scale = 1
  end
end
