Button = class()

function Button:init(str,substr,x,y)
    -- you can accept and set parameters here
    self.x,self.y,self.text,self.subtext = x,y,str,substr
    self.w,self.h = 150,180
    self.pressed = false
end

function Button:draw()
    local x,y = self.x, self.y
    if self.pressed then
        tint(214, 62, 62, 255)
    end
    sprite("Planet Cute:Wood Block",x,y,self.w)
    fill(242, 241, 242, 255)
    fontSize(42)
    text(self.text, x,y)
    fontSize(16)
    textAlign(CENTER)
    textWrapWidth(140)
    text(self.subtext or "",x,y-50)
    textWrapWidth(0)
    noTint()
end

function Button:touched(touch)
    local inside = math.abs(touch.x-self.x)<self.w/2 and 
                    math.abs(touch.y-self.y)<self.h/2
    if inside then
        if touch.state ~= ENDED then
            self.pressed = true
        else
            if self.pressed then
                sound(SOUND_POWERUP, 15903)
                self.callback() 
            end
            self.pressed = false
        end
    else
        self.pressed = false
    end 
end

RotatedButton = class(Button)
function RotatedButton:init(str,substr,x,y)
    Button.init(self,str,substr,x,y)
end
function RotatedButton:draw()
    local x,y = self.x, self.y
    if self.pressed then
        tint(214, 62, 62, 255)
    end
    pushMatrix()
    translate(x, y)
    rotate(90)
    fontSize(22)
    sprite("Planet Cute:Brown Block",0,0)
    textWrapWidth(80)
    text(self.text,0,0)
    textWrapWidth(0)
    popMatrix()
    noTint()
end


