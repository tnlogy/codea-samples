Test2 = class()

function Test2:name()
    return "Norrköping Accurate 3D Map"
end

function Test2:getMesh(name,mn)
    local m = self.meshes[name .. mn]
    if not m then
        m = mesh()
        m.vertices, m.texCoords = loadMesh(name, vec3(0,0,0), 1)
        m.texture = ({"Documents:House", "Documents:Wall",
                     "Documents:Wall2"})[mn]  
        m:setColors(255,255,255,255)
        self.meshes[name..mn] = m
    end
    return m
end

function Test2:getTile(x,y)
    local t = tiles[x .. "-" .. y]
    if not t then
        tiles[x .. "-" .. y] = true
        loadTile(x,y)
    elseif t ~= true then
        return t
    end
    return "SpaceCute:Background"
end

function Test2:init()
    self.meshes = {}

    -- disable scene for now.
    self.scene = {}
    a={    {name="cube2", x=0, z=0, scale=vec3(1,1,1)},
        {name="cube2", x=-3, z=3, scale=vec3(1,2,1)}, 
        {name="cube2", x=-5, z=0, scale=vec3(2,1,4)},
        {name="cylinder", x=3, z=3},
        {name="cylinder2", x=2,z=-4},
        {name="cylinder3", x=4, z=2,scale=vec3(2,2,2)}
    }
end

function Test2:draw()
    pushMatrix()
    pushStyle()
    
    -- Make a floor
    translate(0,0,0)
    rotate(-90,1,0,0)
    local q = 3
    for x=-q,q do
        for y=-q,q do
            sprite(self:getTile(x,y), x*300, y*300, 300, 300)
        end
    end

    -- show center position
    --    translate(10,0,50)
    --    fill(184, 148, 41, 106)
    --    ellipse(X, -Z, 100, 100)
    popStyle()
    popMatrix()

    for i, item in ipairs(self.scene) do
        pushMatrix()                
        local s = (item.scale or vec3(1,1,1)) * Size*.25
        scale(s.x,s.y,s.z)       
        translate(item.x,0,item.z)
        self:getMesh(item.name):draw()
        popMatrix()
    end
    
    math.randomseed(100)
    for i = -10,10 do
        for j = -10,10 do
            pushMatrix()
            local s = (vec3(1,.5+math.random()*2,1)) * Size*.25
            scale(s.x,s.y,s.z)       
            translate(i*2,0,j*2)
            local n = {"cube2","cylinder","cylinder2","cylinder3"}
            local name = n[math.floor(math.random()*4)+1]
            local mn = math.floor(math.random()*3)+1
            local m = self:getMesh(name,mn)
            m:draw()
            popMatrix()
        end
    end
    
    popStyle()
    popMatrix()
end
