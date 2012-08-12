Level = class()

function Level:init()
    physics.gravity(vec2(0,-30))
    self.bodies = {}
    self.towers = {}
    self.meteors = {}
    self.houses = {}
    self.grounds = {}
    self.houseCount = 0
    self.minHouses = 1
end

function Level:addTower(x,y,force)
    local i = #self.towers + 1
    local t = Tower(x,y,i,force)
    table.insert(self.towers,t)
    table.insert(self.bodies, t.body)
    return t
end

function Level:addMeteor(x,y,size)
    local m = Meteor(x,y,size)
    table.insert(self.meteors,m)
    table.insert(self.bodies, m.body)
    self.meteorCount = #self.meteors
    return m
end

function Level:addGround(x,y)
    local g = self:createBox(x,y,70,70)
    g.type = STATIC
    table.insert(self.grounds, g)
end

function Level:addHouse(x,y,type)
    local g = self:createBox(x,y,70,70)
    g.type = STATIC
    table.insert(self.houses, {g,type})
    self.houseCount = #self.houses
end

function Level:saveAll()
    self.minHouses = #self.houses
end

function Level:addPlanet()
    for i=1,6 do
        self:addGround(i*101,0)
    end
    self:addHouse(235,50,1)
    self:addHouse(550,50,2)
    self:addHouse(168,50)
    self:addHouse(480,50)
end

function Level:draw()
    background(179, 219, 169, 255)
    for i,t in ipairs(self.towers) do
        t:draw()
    end
    
    -- Meteors
    self.meteorCount = 0
    for i,m in ipairs(self.meteors) do
        m:draw()
        if m:active() then
            self.meteorCount = self.meteorCount + 1
        end
    end
    pushMatrix()
    translate(0,0,-10)
    self:drawbg()
    popMatrix()
    if self:failed() then
        font("AmericanTypewriter-Bold")
        fontSize(72)
        text("Failed! Try again :)", WIDTH/2, HEIGHT/2)
    elseif self:completed() then
        font("AmericanTypewriter-Bold")
        fontSize(72)
        text("Level Completed", WIDTH/2, HEIGHT/2)
    end
end

function Level:failed()
    return self.houseCount < self.minHouses
end
function Level:completed()
    return self.meteorCount == 0
end
function Level:done()
    return self:failed() or self:completed()
end

function Level:drawbg()
    for i,t in ipairs(self.grounds) do
        sprite("Planet Cute:Grass Block",t.x,t.y)
    end
    for i,t in ipairs(self.houses) do
        local x,y = t[1].x,t[1].y
        if t[2] == 1 then
            sprite("Small World:House White",x,y-10)
        elseif t[2] == 2 then
            sprite("Small World:Store Medium",x,y-10)
        elseif t[2] == 3 then
            sprite("SpaceCute:Planet",x,y,100)
        else
            sprite("Small World:Tree Apple",x,y-10)
        end
        if t[1].type == DYNAMIC then
            sprite("Tyrian Remastered:Flame 2",x,y,30)
        end
    end
end

function Level:updateHouseCount()
    self.houseCount = 0
    for i,t in ipairs(self.houses) do
        if t[1].type == STATIC then
            self.houseCount = self.houseCount + 1
        end
    end      
end

function Level:touched(touch)
    if tcount == 0 and touch.state == BEGAN then
        if self:done() then
            return selectLevel(0)
        end
    end
    
    if touch.state == ENDED then
        touches[touch.id] = nil
        if tcount > 0 then
            tcount = tcount - 1
        end
        if tcount == 0 then self:clearTouches() end
        self:updateHouseCount()
    else
        touches[touch.id] = touch
    end
    if touch.state == BEGAN then
        tcount = tcount + 1
        print("add touch " .. tcount)
        local t = self.towers[tcount]
        if t then
            t:setTouch(touch.id)
        end
    end
end

function Level:clearTouches()
    for i,t in ipairs(self.towers) do
        t:setTouch(nil)
    end
end

function Level:createBox(x,y,w,h)
    local box = physics.body(POLYGON, vec2(-w/2,h/2), vec2(-w/2,-h/2), vec2(w/2,-h/2), vec2(w/2,h/2))
    box.interpolate = true
    box.x = x
    box.y = y
    table.insert(self.bodies, box)
    return box
end

function Level:cleanUp()
    for i,t in ipairs(self.bodies) do
        t:destroy()
    end
end

function Level:collide(contact)
    if contact.state == BEGAN then
    --    self.contacts[contact.id] = contact
        sound(SOUND_HIT, 2643)
        if contact.bodyA then
            contact.bodyA.type = DYNAMIC
        end
        if contact.bodyB then
            contact.bodyB.type = DYNAMIC
        end
        self:updateHouseCount()
    end
end
