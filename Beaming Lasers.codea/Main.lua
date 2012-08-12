
-- Use this function to perform your initial setup
function setup()
    tcount = 0
    touches = {}
    displayMode(FULLSCREEN)
    supportedOrientations(PORTRAIT_ANY)
    HW,HH = WIDTH/2,HEIGHT/2
    level = StartScreen()
end

levels = {Level1, Level2, Level3, Level4, Level5, Level6, Level7,
          Level8, Level9}
function selectLevel(l)
    print("Loading level " .. l)
    clearOutput()
    if level.cleanUp then level:cleanUp() end
    touches = {}
    tcount = 0
    if l == 0 then
        physics.pause()
        level = SelectLevel()
    else
        physics.resume()
        local lev = levels[l]
        if lev then
            level = lev()
        end
    end
end

function touched(touch)
    level:touched(touch)
end

-- This function gets called once every frame
function draw()
    level:draw()
end

function collide(contact)
    if level.collide then level:collide(contact) end
end

function txt(x, y, str)    
    font("MyriadPro-Bold")
    fontSize(22)
    text(str, x, y)
end


