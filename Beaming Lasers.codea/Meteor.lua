Meteor = class()

function Meteor:init(x,y,size)
    -- you can accept and set parameters here
    self.x,self.y = x, y
    self.size = size or 50
    self.body = self:createBox(x, y, self.size)
end

function Meteor:createBox(x,y,size)
    local box = physics.body(CIRCLE, size/2)
    box.interpolate = true
    box.x = x
    box.y = y
    box.restitutions = 0.25
    box.density = 1
    box.sleepingAllowed = false
    return box
end

function Meteor:draw()
    -- Codea does not automatically call this method
    pushMatrix()
    translate(self.body.x, self.body.y)
    rotate(self.body.angle)
    sprite("Tyrian Remastered:Rock 3",0,0,self.size)
    popMatrix()
end

function Meteor:active()
    local x,y = self.body.x,self.body.y
    local m = 100
    local onScreen = (x > -m and x < WIDTH+m) and
                     (y > -m and y < HEIGHT+m)
    return onScreen
end

function Meteor:touched(touch)
    -- Codea does not automatically call this method
end
