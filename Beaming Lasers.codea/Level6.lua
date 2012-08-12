Level6 = class(Level)

function Level6:init()
    -- you can accept and set parameters here
    Level.init(self)
    self.minHouses = 3
    physics.gravity(vec2(0,0))
    self:addTower(HW+200, HH-100,20)
    for i=1,10 do
        local p = math.sin(i*10)*10
        local m = self:addMeteor(WIDTH/2+p, HEIGHT+i*50, 40)
        m.body:applyForce(vec2(0,-400))
        m = self:addMeteor(i*50-1400,HH+100, 40)
        m.body:applyForce(vec2(400,0)) 
    end
    self:addHouse(HW+200,HH+100,3)
    self:addHouse(HW-200,HH-30,3)
    self:addHouse(HW,HH-300,3)
end
