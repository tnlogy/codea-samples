Level7 = class(Level)

function Level7:init()
    -- you can accept and set parameters here
    Level.init(self)
    
    physics.gravity(vec2(0,0))
    local t = self:addTower(HW+250, HEIGHT,60)
    t.body.type = DYNAMIC
    t.body:applyForce(vec2(0,-4500))
    
    for i=1,5 do
        local p = math.sin(i*10)*10
        local m = self:addMeteor(-i*100, HH+p, 40)
        m.body:applyForce(vec2(400,0)) 
    end
    self:addHouse(HW,HH+300,3)
    self:addHouse(HW+100,HH,3)
    self:addHouse(HW,HH-300,3)
    self:saveAll()
end
