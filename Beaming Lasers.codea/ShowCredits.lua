ShowCredits = class()

function ShowCredits:init(x)
    -- you can accept and set parameters here
    self.x = x
end

function ShowCredits:draw()
    -- Codea does not automatically call this method
    background(194, 76, 76, 255)
    text("Code and Idea - Tobias Nurmiranta",HW,HH)
    text("Sprite Graphics - Free Graphics by Daniel Cook",HW,HH-200)
end

function ShowCredits:touched(touch)
    -- Codea does not automatically call this method
    selectLevel(0)
end
