Level8 = class(Level)

function Level8:init()
    -- you can accept and set parameters here
    Level.init(self)
    self.t = self:addTower(HW-100,600)
    self:addTower(601,400)
    local m = self:addMeteor(HW-80, 900, 50)
    m.body:applyForce(vec2(0,-2000))
    self:addMeteor(HW,1500,60)
    self:addMeteor(HW,1400,70)
    
    
    self:addPlanet()
    self:saveAll()
end

function Level8:completed()
    return Level.completed(self) and self.t.body.y < -10
end
