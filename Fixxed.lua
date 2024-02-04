--made by fireztron @ v3rm

--hi telygum ik u reading this :3

repeat wait() until game:IsLoaded()

if game.gameId == 943242049 then --ant life game id
print("ok ant life v2 autofarm starting up")
--// CHARWARS SERVER HOP SCRIPT:

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

local iterations = 0 --something i added myself
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    print("getting tp id " .. iterations)
    if iterations > 10 then
        local delFile = pcall(function()
	    delfile("NotSameServers.json")
            AllIDs = {}
	    table.insert(AllIDs, actualHour)
        end)
    end
    iterations = iterations + 1
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end


function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

--// AUTO KICK WHEN MOD JOINS

game.Players.PlayerAdded:Connect(function(player)
	spawn(function()
		local success, result = pcall(function()
			if player:GetRankInGroup(4525406) > 50 then  --mod rank is 249
				Teleport()
			end
		end)
		if not success then
			warn("Error: "..result)
		end
	end)
end)

for i,v in pairs(game.Players:GetPlayers()) do
	spawn(function()
		local success, result = pcall(function()
			if v:GetRankInGroup(4525406) > 50 then --mod rank is 249
				Teleport()
			end
		end)
		if not success then
			warn("Error: "..result)
		end
	end)
end


--KILL AURA WITHOUT EGGS

repeat wait() until game:IsLoaded()
if not _G.killaura then _G.killaura = true end

--// ESSENTIAL VARS

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local humanoids = {}

--// GET HUMS TABLE (i rewrote to fix auto farm)

local function getHums()
    local hums = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Parent and plr.Character.Parent.Name ~= "Larvae" then
            table.insert(hums, plr.Character.Humanoid)
        end
    end
    return hums
end

--// KILL AURA LOOP

coroutine.wrap(function() --apparently coroutine's better
    while _G.killaura == true do
        wait()
        for _,hum in ipairs(getHums()) do
            if hum.Parent and LP.Character and not hum:IsDescendantOf(workspace.Carcasses) then
                local enemyhrp = hum.Parent:FindFirstChild("HumanoidRootPart")
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                local head = hum.Parent:FindFirstChild("Head")
                if enemyhrp and hrp and head and enemyhrp.Parent.Parent and enemyhrp.Parent.Parent.Name ~= "Larvae" and (enemyhrp.Position - hrp.Position).Magnitude < 15 then
                    local args = {
                        [1] = "heavy",
                        [2] = hum
                    }

                    game:GetService("ReplicatedStorage").Remotes.Biterzzzzzz:FireServer(unpack(args))
                    --print("firing", hum:GetFullName())
                end
            end
        end
    end
end)()

warn("loaded killaura without eggs")

--// ESSENTIAL VARS

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatRemote = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
local Remotes = ReplicatedStorage.Remotes
local SpawnRemote = Remotes.SpawnPlayer
local GrowthRemote = Remotes.Growth
local SpawnLarvaeRemote = Remotes.SpawnLarvae

local antTypes = {"Fire Ant", "Yellow Crazy Ant", "Carpenter Ant"}

--// FUNCTIONS

local function isAlive(plr)
    if plr.Character then
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        local hum = plr.Character:FindFirstChild("Humanoid")
        local head = plr.Character:FindFirstChild("Head")
        if hrp and hum and head and hrp.Position.Y + head.Position.Y < 600 then --sometimes u fling so gotta check for that
            return true
        end
    end
    return false
end

local function tpChar(cframe)
    LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
end

local function getChars(accountForTeam)
    local chars = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if isAlive(plr) and isAlive(LocalPlayer) and plr.Character.Parent and plr.Character.Parent.Name ~= "Larvae" then
	    if (accountForTeam and plr.Character.Head.Color ~= LocalPlayer.Character.Head.Color) or not accountForTeam then
            	chars[plr] = plr.Character
	    end
        end
    end
    return chars
end

local function numOfChars() --for some reason #dictionary always returns 0
	local counter = 0 
	for _, v in pairs(getChars(true)) do
		counter =counter + 1
	end
	return counter
end

local function setCam()
    pcall(function()
        workspace.Camera.CameraType = Enum.CameraType.Custom
        workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        game:GetService("Lighting").Blur.Enabled = false
        game:GetService("Players").LocalPlayer.PlayerGui.Menu.Enabled = false
    end)
end
	
--// TELEPORT IF IT TAKES TOO LONG TO GET SPAWNED IN

local spawnedIn = false
spawn(function()
    wait(30)
    if spawnedIn == false then
        Teleport()
    end
end)

--// SPAWNING LOOP

while not isAlive(LocalPlayer) do
    --print("not alive")
    for _,antType in ipairs(antTypes) do
        local args = {
            [1] = {
                ["colony"] = antType,
                ["class"] = "Ant",
                ["species"] = "Ant"
            }
        }
        coroutine.wrap(function() --spawn and wait bad blah blah blah whatever
            SpawnRemote:InvokeServer(unpack(args))
        end)()
        --print("invoked spawn")
    end
    RS.Heartbeat:Wait()
end

spawnedIn = true

repeat RS.Heartbeat:Wait() until isAlive(LocalPlayer)
setCam()
print("set cam")


--[[ dont need
local feedMeMessages = {
    "MOTHER WE ALL REQUIRE SUSTANCE THIS INSTANT",
    "IF YOU DONT GIVE US FOOD WE WILL DIE",
    "FOOD PLZZZZ",
    "FEED US PLZZ"
}

math.randomseed(tick()) 
-- Amount of seconds to wait between each message.
local DelayTime = 5

-- Have a function ready to shuffle the chat list.
local function shuffle(t) --Fisher-Yates shuffle method
	local j, temp
	for i = #t, 1, -1 do
		j = math.random(i)
		temp = t[i]
		t[i] = t[j]
		t[j] = temp
	end
end

--// RANDOMLY CHAT

spawn(function()
    while isAlive(LocalPlayer) and LocalPlayer.Character.Parent.Name == "Larvae" and not LocalPlayer.Character.Parent:FindFirstChild("Cocoon") do
        wait(1)
        while (#feedMeMessages > 0) do
            shuffle(feedMeMessages)
            -- Go through each message in order.
            for index, chat in ipairs(feedMeMessages) do
                if isAlive(LocalPlayer) and LocalPlayer.Character.Parent.Name == "Larvae" and not LocalPlayer.Character.Parent:FindFirstChild("Cocoon") then
                    local args = {
                        [1] = chat,
                        [2] = "All"
                    }
                    ChatRemote:FireServer(unpack(args))

                    wait(DelayTime)
                end
            end
            print("end of messages reached.")
        end
    end
end)

--]]

--// TELEPORT IF IT TAKES TOO LONG TO GET FED	

local cocooned = false
spawn(function()
    wait(30)
    if cocooned == false then
        Teleport()
    end
end)
	
--// HATCHING LOOP

while isAlive(LocalPlayer) and LocalPlayer.Character.Parent and LocalPlayer.Character.Parent.Name == "Larvae" and not LocalPlayer.Character:FindFirstChild("Cocoon") do
    wait()
    setCam() --incase camera glitches lol
    for plr, char in pairs(getChars(false)) do
        if isAlive(plr) and char.Parent and char.Parent.Name ~= "Larvae" and char:FindFirstChild("Carrier") then

            --// EGG GROWTH
            local args = {
                [1] = char.Carrier
            }
            GrowthRemote:FireServer(unpack(args))
        end
    end
    
    --// BECOME CACOON
    local args = {
        [1] = "Worker"
    }
    SpawnLarvaeRemote:FireServer(unpack(args))
    print("ooh ooh ahh ahh")
end
cocooned = true

--// noclip
if isAlive(LocalPlayer) then
	LP.Character.Humanoid:ChangeState(11)
end

--// go underground

print("done waiting ok we should go underground now")
if LocalPlayer.Character and LocalPlayer.Character.Parent and LocalPlayer.Character:FindFirstChild("Cocoon") then
	print("GOING UNDERGROUND")
	LocalPlayer.Character.HumanoidRootPart.Anchored = true
	tpChar(CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position.X , -100, LocalPlayer.Character.HumanoidRootPart.Position.Z))
	repeat RS.Heartbeat:Wait()
	until not isAlive(LocalPlayer) or not LocalPlayer.Character:FindFirstChild("Cocoon")
	print("OKIE NO LONGER COCOOON")
	if isAlive(LocalPlayer) then
		LocalPlayer.Character.HumanoidRootPart.Anchored = false	
	end
end
	
--// TELEPORTING LOOP

while numOfChars() > 1 and isAlive(LocalPlayer) do --one to account for black carpenter queen
    warn("---")
    local LPChar = LocalPlayer.Character
    for plr, char in pairs(getChars(true)) do
        while isAlive(plr) and isAlive(LocalPlayer) and not char:IsDescendantOf(workspace.Carcasses) and char.Parent and char.Parent.Name ~= "Larvae" and LPChar.Parent and LPChar.Parent.Name ~= "Larvae" and char.Head.Color ~= LPChar.Head.Color do
            --LocalPlayer.Character.HumanoidRootPart.Anchored = true
            local offset = CFrame.new(0,0,1)
            local distanceUnder = 0
            if char.Parent.Parent.Name == "Carpenter Ant" then --carpenter ants are bigger
                offset = offset * CFrame.new(0,0,2)
                --distanceUnder = distanceUnder + 1
            end
            if LPChar.Parent.Name == "Queen" then
                offset = offset * CFrame.new(0,0,.3)
                --distanceUnder = distanceUnder + 3
            end
	    if char.Parent.Name == "Queen" then
                offset = CFrame.new(0,0,.1)
                --distanceUnder = distanceUnder - 6.5
            end
            if not(char.Parent.Name == "Queen" and char.Parent.Name == "Carpenter Ant") then
                tpChar(CFrame.new((char.HumanoidRootPart.CFrame * offset).Position - Vector3.new(0,distanceUnder,0), char.HumanoidRootPart.Position))
	    end
            setCam() --incase camera glitches lol
            RS.Heartbeat:Wait()
            --LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end
    RS.Heartbeat:Wait()
end

print('yuh')

--go underground while tryna teleport
	
if isAlive(LocalPlayer) then
	print("GOING UNDERGROUND")
	LocalPlayer.Character.HumanoidRootPart.Anchored = true
	tpChar(CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position.X , -50, LocalPlayer.Character.HumanoidRootPart.Position.Z)) --could be shorter but i changed my mind
end
	
-- //teleport da fuck outta there dood thers no more ants left
Teleport()
end