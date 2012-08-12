Level5 = class(Level)

function Level5:init()
    -- you can accept and set parameters here
    Level.init(self)
    physics.gravity(vec2(0,0))
    self:addTower(HW-150, HH, 60)
    self:addTower(HW+150, HH, 60)
    for i=1,10 do
        local p = math.sin(i*10)*10
        local m = self:addMeteor(WIDTH/2+p, HEIGHT+i*50, 40)
        m.body:applyForce(vec2(0,-500))
        m = self:addMeteor(WIDTH/2+p, -i*50, 40)
        m.body:applyForce(vec2(0,500)) 
    end
    self:addHouse(HW,HH,3)
end
