Level1 = class(Level)

function Level1:init(x)
    -- you can accept and set parameters here
    Level.init(self)
    local y = 200
    self:addTower(WIDTH/2, y)

    for i=1,10 do
        local x,y = math.random(WIDTH),
                    math.random(y+300,HEIGHT)
        self:addMeteor(x,y, math.random(30,60))
    end
    
    self:addPlanet()
    physics.gravity(vec2(0,-15))
end

function Level1:draw()
    Level.draw(self)
    translate(0,0,10)
    font("AmericanTypewriter-Bold")
    fontSize(18)
    textWrapWidth(400)
    text("Touch the screen to control the laser beam and save the city",
         WIDTH/2, HEIGHT/2 - 200)
    textWrapWidth(0)
end