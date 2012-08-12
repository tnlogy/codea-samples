Level4 = class(Level2)

function Level4:init(x)
    -- you can accept and set parameters here
    Level2.init(self)
    physics.gravity(vec2(0,-50))
end

function Level4:draw()
    Level.draw(self)
end