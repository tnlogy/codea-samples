Level9= class(Level)

function Level9:init()
    -- you can accept and set parameters here
    Level.init(self)
    physics.gravity(vec2(0,0))
    self.t = self:addTower(HW-150, HH)
    for i=0,6 do
        local p = math.sin(i*10)*10
        local m = self:addMeteor(WIDTH/2+p, HEIGHT+i*400, 40)
        m.body:applyForce(vec2(0,-350))
        local m = self:addMeteor(WIDTH/2+p, 100-i*400, 40)
        m.body:applyForce(vec2(0,350))
    end
    self:addHouse(HW,HH,3)
end

function Level9:draw()
    self.t.body.y = HH + math.sin(ElapsedTime*4)*200
    Level.draw(self)
end
