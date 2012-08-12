SelectLevel = class()

function SelectLevel:init(startLevel)
    self.buttons = {}
    self.names = {
        "One Armed Introduction",
        "Two is better than one",
        "Big Rocks",
        "High Gravity",
        "Ups and Downs",
        "What goes Left must go Up",
        "Drive By",
        "Sacrifice",
        "Timing",
        
        "Please",
        "Fund",
        "This",
        "Game"
    }
    
    local l = startLevel or 1
    for i=1,-1,-1 do
        for j=-1,1 do
            local x,y=WIDTH/2+j*200,HEIGHT/2+i*200
            local b = Button(l,self.names[l],x,y)
            b.callback = self:runLevel(l)
            table.insert(self.buttons, b)
            l = l + 1
        end
    end
    
    local btext = "Level 1-9"
    if startLevel ~= 10 then btext = "Level 10-18" end
    local r = RotatedButton(btext,"", WIDTH-40,100)
    r.callback = function ()
        if startLevel == 10 then
            self:nextLevels(1)
        else 
            self:nextLevels(10)
        end
    end
    table.insert(self.buttons, r)
end

function SelectLevel:runLevel(i)
    return function ()
        selectLevel(i)
    end
end

function SelectLevel:nextLevels(i)
    self:init(i)
end

function SelectLevel:draw()
    -- Codea does not automatically call this method
    background(185, 160, 32, 255)
    font("AmericanTypewriter-Bold")
    fill(0, 0, 0, 255)
    fontSize(72)
    text("Select Level", WIDTH/2,HEIGHT-80)
    fontSize(42)
    text("- Easy -", WIDTH/2, HEIGHT-140)
    for i,t in ipairs(self.buttons) do
        t:draw()
    end
end

function SelectLevel:touched(touch)
    for i,t in ipairs(self.buttons) do
        t:touched(touch)
    end
end
