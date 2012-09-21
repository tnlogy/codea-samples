-- Urban Explorer
tiles = {}
function loadTile(x, y)
    local url = "Documents:gmap" .. x .. "-" .. y
    local im = readImage(url)
    if im then
        tiles[x .. "-" .. y] = im
        return
    end
    
    local lat,long = 58.592, 16.189
    local ts = 300
    long = long + x*3.86/ts
    lat = lat + y*2/ts
    http.get( 
        "http://maps.googleapis.com/maps/api/staticmap?"..
 --       "center=norrkoping" ..
        "center="..lat..","..long..
        "&maptype=hybrid&zoom=15&size="..
        ts.."x".. ts.."&maptype=satellite&sensor=true", 
        function (tile)
            saveImage(url, tile)
            tiles[x .. "-" .. y] = tile
        end
    )
end

-- Use this function to perform your initial setup
function setup()
    saveProjectInfo("Author", "Tobias Nurmiranta")
    saveProjectInfo("Description", "3D City")
    
    
    displayMode(FULLSCREEN)
    currentTest = Test2
    currentTest:init()
    parameter("Size",50,500,150)
    parameter("CamHeight", 0, 1000, 250)
    parameter("Angle",-360, 360, 0)
    parameter("FieldOfView", 10, 140, 45)
    parameter("Distance", 10, 1000, 300)
    parameter("X", -100,100,0)
    parameter("Z", -100,100,0)
    parameter("S", 2, 5, 3.87)
    
    the3DViewMatrix = viewMatrix()
    watch("the3DViewMatrix")
    
    watch("viewMatrix()")
    watch("modelMatrix()")
    watch("projectionMatrix()")
    
    touches = {}
end

function draw()
    perspective(FieldOfView, WIDTH/HEIGHT)
 
    r = Angle*math.pi/180
    camera(X+math.sin(r)*Distance,CamHeight, Z - math.cos(r)*Distance,
           X,0,Z, 0,1,0)
    
    the3DViewMatrix = viewMatrix()
    background(40, 40, 50)
    currentTest:draw()        
    ortho()
    
    -- Restore the view matrix to the identity
    viewMatrix(matrix())
    
    -- Draw a label at the top of the screen
    fill(255)
    font("MyriadPro-Bold")
    fontSize(30)
    
    text(currentTest:name(), WIDTH/2, HEIGHT - 30)
    renderTouches()
end

function touched(touch)
    if not multitouch(touch) then
        if touch.state == MOVING then
            local s = .5*math.max(CamHeight,250)/250
            local dx,dz = touch.deltaX*s,touch.deltaY*s
            X = X + math.cos(r)*dx + math.sin(r)*dz
            Z = Z - math.cos(r)*dz + math.sin(r)*dx
        end
    end
end

function multitouch(touch)
    if touch.state == ENDED then
        touches[touch.id] = nil
    else
        touches[touch.id] = touch
    end 
    
    local first, second
    for k,touch in pairs(touches) do
        if not first then first = touch
        elseif not second then second = touch end
    end
    
    if first and second then
        local v1 = vec2(first.x-second.x, first.y-second.y)
        local v2 = vec2(first.prevX-second.prevX,
                        first.prevY-second.prevY)
        local squeeze = (v1:len() - v2:len())

        if math.abs(squeeze) < 5 then
            local s = .25*Distance/500 
            Angle = Angle + first.deltaX*s

        end
 --       CamHeight = CamHeight - first.deltaY  
        CamHeight = math.max(50, CamHeight-squeeze)
  --      Distance = math.max(Distance - squeeze, 5)
        
        
        return true
    end
end

function renderTouches()
    for k,touch in pairs(touches) do
        math.randomseed(touch.id)
        fill(math.random(255),math.random(255),math.random(255),150)
        ellipse(touch.x, touch.y, 100, 100)
    end
end

function saveMesh(name, vertices, texcoords)
    local h = 1
    if texcoords then h = 2 end
    local im = image(#vertices, h)
    local max = vec3(-math.huge, -math.huge, -math.huge)
    local min = vec3(math.huge, math.huge, math.huge)
    for i,v in ipairs(vertices) do
        max = vec3(math.max(v.x,max.x),
                   math.max(v.y,max.y),
                   math.max(v.z,max.z))
        min = vec3(math.min(v.x,min.x),
                   math.min(v.y,min.y),
                   math.min(v.z,min.z))
    end
    local span = math.max(math.abs(max.x - min.x),
                          math.abs(max.y - min.y),
                          math.abs(max.z - min.z))

    for i,v in ipairs(vertices) do
        v = (v - min) / span * 255
        im:set(i,1, v.x,v.y,v.z)
        if h == 2 then
            local uv = texcoords[i]*255
            im:set(i,2, uv.x, uv.y, 0)
        end
    end
    saveImage("Documents:" .. name, im)
end

function loadMesh(name, origin, scl)
    local im = readImage("Documents:" .. name)
    if not im then return nil end
    local w,h = spriteSize(im)
    local vertices = {}
    local texs = {}

    for i = 1,w do
        local r,g,b = im:get(i,1)
        local v = origin + (vec3(r,g,b) * scl) / 255
        table.insert(vertices, v)
        if h == 2 then
            local r,g,b = im:get(i,2)
            table.insert(texs, vec2(r,g)/255)
        elseif (i-1)%3 == 0 then
            table.insert(texs, vec2(0,0))
            table.insert(texs, vec2(1,0))
            table.insert(texs, vec2(0,1))            
        end
    end

    return vertices, texs
end