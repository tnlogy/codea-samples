Level3 = class(Level)

function Level3:init()
    -- you can accept and set parameters here
    Level.init(self)
    local y = 200
    self:addTower(100, y)
    self:addTower(601, y)
    self:addMeteor(WIDTH/2-100, 900, 180)
    self:addMeteor(WIDTH/2+50, 800, 180)
    self:addPlanet()
end
