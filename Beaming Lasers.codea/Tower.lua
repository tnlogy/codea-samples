Tower = class()

function Tower:init(x,y,name,force)
    self.body = self:createCircle(x,y,50)
    self.body.type = STATIC
    self.r = -90
    self.ray = vec2(-1064,0)
    self.force = force or 30
    self.name = name
    self.soundT = ElapsedTime
end

function Tower:setTouch(id)
    if id then
        if math.random() > 0.5 then
            sound(SOUND_SHOOT, 9374)
        else
            sound(SOUND_SHOOT, 9386)
        end
    end
    self.tid = id
end

function Tower:draw()
    local x,y = self.body.x,self.body.y
    self.on = false
    local t = touches[self.tid]
    if t then
        self.on = true
        self.r = -math.deg(vec2(x-t.x, y-t.y):angleBetween(-self.ray))
    end
    local len = 1
    if self.on then len = self:collide() end
    
    pushMatrix()
    translate(x, y,-1)
    rotate(self.r)
    sprite("Tyrian Remastered:Satellite", 0, 0, 100)
    self:drawName()
    if t then
        local s = 100*math.sin(ElapsedTime*50)
        strokeWidth(8)
        stroke(191, 184+s, 48+s, 255)
        line(-50,0, self.ray.x*len,self.ray.y*len)
    end
    popMatrix()
end

function Tower:drawName()
    font("Futura-CondensedExtraBold")
    fill(246, 246, 246, 255)
    fontSize(22)
    text(self.name, 0,0)
end

function Tower:collide()
    local x,y = self.body.x, self.body.y
    local s = vec2(x,y)
    local e = self.ray:rotate(math.rad(self.r))
    result = physics.raycast(s, s+e)
    if result then
       -- sound(SOUND_EXPLODE, 47945)
     --   self:hitSound()
        sprite("Tyrian Remastered:Explosion Ball",result.point.x,result.point.y)
        result.body.type = DYNAMIC
        result.body:applyForce(e:normalize()*self.force, result.point)
        return result.fraction
    else
        return 1
    end
end

function Tower:hitSound()
    if ElapsedTime > self.soundT then 
        sound(SOUND_POWERUP, 35515)
     --   sound(SOUND_EXPLODE, 7879)
        self.soundT = ElapsedTime + math.random(0.2,1)
    end
end

function Tower:createCircle(x,y,r)
    local box = physics.body(CIRCLE, r)
    box.interpolate = true
    box.x = x
    box.y = y
    box.restitution = 0.25
    box.density = 2
    box.sleepingAllowed = false
    return box
end

function Tower:touched(touch)
    -- Codea does not automatically call this method
end
