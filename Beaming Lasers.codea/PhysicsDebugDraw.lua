PhysicsDebugDraw = class()

function PhysicsDebugDraw:init()
    self.bodies = {}
    self.joints = {}
    self.touchMap = {}
    self.contacts = {}
end

function PhysicsDebugDraw:addBody(body)
    table.insert(self.bodies,body)
end

function PhysicsDebugDraw:addJoint(joint)
    table.insert(self.joints,joint)
end

function PhysicsDebugDraw:clear()
    -- deactivate all bodies
    
    for i,body in ipairs(self.bodies) do
        body:destroy()
    end
  
    for i,joint in ipairs(self.joints) do
        joint:destroy()
    end      
    
    self.bodies = {}
    self.joints = {}
    self.contacts = {}
    self.touchMap = {}
end

function PhysicsDebugDraw:draw()
    
    pushStyle()
    smooth()
    strokeWidth(5)
    stroke(128,0,128)
    
    local gain = 2.0
    local damp = 0.5
    for k,v in pairs(self.touchMap) do
        local worldAnchor = v.body:getWorldPoint(v.anchor)
        local touchPoint = v.tp
        local diff = touchPoint - worldAnchor
        local vel = v.body:getLinearVelocityFromWorldPoint(worldAnchor)
        v.body:applyForce( (1/1) * diff * gain - vel * damp, worldAnchor)
        
        line(touchPoint.x, touchPoint.y, worldAnchor.x, worldAnchor.y)
    end
    
    stroke(0,255,0,255)
    strokeWidth(5)
    for k,joint in pairs(self.joints) do
        local a = joint.anchorA
        local b = joint.anchorB
        line(a.x,a.y,b.x,b.y)
    end
    
    stroke(255,255,255,255)
    noFill()
    
    
    for i,body in ipairs(self.bodies) do
        pushMatrix()
        translate(body.x, body.y)
        rotate(body.angle)
    
        if body.type == STATIC then
            stroke(255,255,255,255)
        elseif body.type == DYNAMIC then
            stroke(150,255,150,255)
        elseif body.type == KINEMATIC then
            stroke(150,150,255,255)
        end
    
        if body.shapeType == POLYGON then
            strokeWidth(5.0)
            local points = body.points
            for j = 1,#points do
                a = points[j]
                b = points[(j % #points)+1]
                line(a.x, a.y, b.x, b.y)
            end
        elseif body.shapeType == CHAIN or body.shapeType == EDGE then
            strokeWidth(5.0)
            local points = body.points
            for j = 1,#points-1 do
                a = points[j]
                b = points[j+1]
                line(a.x, a.y, b.x, b.y)
            end      
        elseif body.shapeType == CIRCLE then
            strokeWidth(5.0)
            line(0,0,body.radius-3,0)
            strokeWidth(2.5)
            ellipse(0,0,body.radius*2)
        end
        
        popMatrix()
    end 
    
    stroke(255, 0, 0, 255)
    fill(255, 0, 0, 255)

    for k,v in pairs(self.contacts) do
        for m,n in ipairs(v.points) do
            ellipse(n.x, n.y, 10, 10)
        end
    end
    
    popStyle()
end

function PhysicsDebugDraw:touched(touch)
    local touchPoint = vec2(touch.x, touch.y)
    if touch.state == BEGAN then
        for i,body in ipairs(self.bodies) do
            if body.type == DYNAMIC and body:testPoint(touchPoint) then
                self.touchMap[touch.id] = {tp = touchPoint, body = body, anchor = body:getLocalPoint(touchPoint)} 
                return true
            end
        end
    elseif touch.state == MOVING and self.touchMap[touch.id] then
        self.touchMap[touch.id].tp = touchPoint
        return true
    elseif touch.state == ENDED and self.touchMap[touch.id] then
        self.touchMap[touch.id] = nil
        return true;
    end
    return false
end

function PhysicsDebugDraw:collide(contact)
    if contact.state == BEGAN then
        self.contacts[contact.id] = contact
        sound(SOUND_HIT, 2643)
    elseif contact.state == MOVING then
        self.contacts[contact.id] = contact
    elseif contact.state == ENDED then
        self.contacts[contact.id] = nil
    end
end
