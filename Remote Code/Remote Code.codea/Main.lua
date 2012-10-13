-- Remote Code
local url = "http://10.0.1.2:3000/"
function updateRemoteCode()
    print("downloading code")
    lastUpdate = false
    http.request(url, function (code)
        lastUpdate = ElapsedTime
        if currentCode and currentCode == code then return end
        print("updating code")
        currentCode = code;
        code = code:gsub("function setup", "function remoteSetup")
        code = code:gsub("function draw", "function remoteDraw")
        print(code)
        assert(loadstring(code))()
        remoteSetup()
    end)
end

-- Use this function to perform your initial setup
function setup()
    updateRemoteCode()
end

function draw()
    if remoteDraw then remoteDraw() end
    if lastUpdate and ElapsedTime - lastUpdate > 2 then
        updateRemoteCode()
    end        
end


