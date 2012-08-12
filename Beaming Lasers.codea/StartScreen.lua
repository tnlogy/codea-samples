StartScreen = class(Level)

function StartScreen:init(x)
    -- you can accept and set parameters here
    Level.init(self)
    self:addTower(HW,HH+190,600)
    self.m = self:addMeteor(200,200,120)
    self.m.body:applyTorque(1000)
    physics.gravity(vec2(0,0))
    self.b = RotatedButton("Credits","",WIDTH-40,200)
    self.b.callback = function ()
        level:cleanUp()
        level = ShowCredits()
    end
end

function StartScreen:failed()
    return false
end
function StartScreen:completed()
    return false
end

function StartScreen:touched(touch)
    Level.touched(self,touch)
    self.b:touched(touch)
end

function StartScreen:draw()
    Level.draw(self)
  --  background(0, 0, 0, 255)
    fill(54, 33, 33, 255)
    textWrapWidth(0)
    font("Futura-CondensedExtraBold")
    fontSize(60)
    text("- welcome to -",HW,HEIGHT-50)
    fontSize(190)
    local s = math.sin(ElapsedTime*2)*10
    textAlign(CENTER)
    local ty = HH+150+190
    strokeWidth(60)
    stroke(210, 154, 13, 255)
    line(0,ty,WIDTH,ty)
    text("BEAMING",HW+s,ty)
    fontSize(260)
    ty = HH-150+140
    strokeWidth(80)
    line(0,ty,WIDTH,ty)
    text("LASERS",HW-s,ty)
    
    self.m.body.y = self.m.body.y + math.sin(ElapsedTime*10)*0.5
    self.m.body.x = self.m.body.x + math.sin(ElapsedTime*6)*1
    
    local x,y = self.m.body.x+100, self.m.body.y+100
    sprite("Planet Cute:SpeechBubble",x,y)
    fontSize(26)
    textWrapWidth(100)
    font("MarkerFelt-Wide")
    if y < 250 then
        text("oh yes! hit me!",x+5,y-25)
    else
        text("start?",x+5,y-20)
    end
    
    self.b:draw()
    
    if self.meteorCount == 0 then
        selectLevel(0)
    end
end

