Level2 = class(Level)

function Level2:init()
    Level.init(self)
    local y = 200
    self:addTower(100, y)
    self:addTower(601, y)
  --  math.randomseed(5)
    for i=1,10 do
        local x,y = math.random(WIDTH),
                    math.random(y+300,HEIGHT)
        self:addMeteor(x,y, math.random(30,60))
    end
    
    self:addPlanet()
    physics.gravity(vec2(0,-30))
end

function Level2:draw()
    Level.draw(self)
    translate(0,0,10)
    font("AmericanTypewriter-Bold")
    fontSize(18)
    textWrapWidth(200)
    text("First touch controls laser 1, second touch controls laser 2.",
         WIDTH/2, HEIGHT/2 - 200)
    textWrapWidth(0)
end

