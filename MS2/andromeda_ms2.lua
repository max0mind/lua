--[[
█████╗ ███╗   ██╗██████╗ ██████╗  ██████╗ ███╗   ███╗███████╗██████╗  █████╗ 
██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗████╗ ████║██╔════╝██╔══██╗██╔══██╗
███████║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██╔████╔██║█████╗  ██║  ██║███████║
██╔══██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║╚██╔╝██║██╔══╝  ██║  ██║██╔══██║
██║  ██║██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗██████╔╝██║  ██║
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝
                                                                              
]]--


-- API CALLS
local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/max0mind/lua/main/API/andromeda_api.lua"))()
local library = api.returncode("https://raw.githubusercontent.com/max0mind/lua/main/API/bracketv3.lua")

local temptable = {
    version = "1.0.0",
    allMinesFunc = {
        "Default",
        "Mouse"
    },
    ores = {}
}

local andromeda = {
    toggles = {
        xray = false,
        disable3drender = false,
        automine = false,
        mineDefault = false
    },
    vars = {
        selected_mine = "",
        selected_ore = ""
    }
}

local andromedaDefault = andromeda

local ChunkUtil = require(game:GetService("ReplicatedStorage").LoadModule)("ChunkUtil")
local Constants = require(game:GetService("ReplicatedStorage").LoadModule)("Constants")

for i,egg in next, game:GetService("ReplicatedStorage").Assets.Eggs:GetChildren() do table.insert(temptable.allEggs, egg.Name) end
for i,ore in next, game:GetService("ReplicatedStorage").Assets.ViewportItems:GetChildren() do table.insert(temptable.ores, ore.Name) end    
-- Functions
function mineDefault()
    local target = game.Players.LocalPlayer.Character.HumanoidRootPart
    local pos = ChunkUtil.worldToCell(target.Position)+Vector3.new(0,1,0)
    
    game:GetService("ReplicatedStorage").Events.MineBlock:FireServer(pos)
end
function mineMouse()
    local a = game.Players.LocalPlayer:GetMouse().Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position * math.random(0.1, 0.001)
    local pos = require(game:GetService("ReplicatedStorage").LoadModule)("ChunkUtil").worldToCell(a - Vector3.new(0,-1,0))

    game:GetService("ReplicatedStorage").Events.MineBlock:FireServer(pos)
end

-- Library
local Config = { WindowName = "🌌  andromeda | "..temptable.version, Color = Color3.fromRGB(82, 52, 151), Keybind = Enum.KeyCode.Semicolon}
local Window = library:CreateWindow(Config, game:GetService("CoreGui"))

local infotab = Window:CreateTab("Information")
local farmtab = Window:CreateTab("Farm")
local misctab = Window:CreateTab("Misc")


local infoSection = infotab:CreateSection("Information")
infoSection:CreateLabel("Thanks you for using our script, "..api.nickname)
infoSection:CreateLabel("Script version: "..temptable.version)
infoSection:CreateLabel("Place version: "..game.PlaceVersion)
infoSection:CreateLabel("⚙ - Configurable Function")
infoSection:CreateLabel("Place version: "..game.PlaceVersion)
infoSection:CreateLabel("Script by max0mind, .anon and a10b")
infoSection:CreateButton("Discord Invite", function() setclipboard("https://discord.gg/gGHEDdTvH7") end)
infoSection:CreateButton("Donation", function() setclipboard("https://qiwi.com/n/MAX0MIND") end)

local mineSection = farmtab:CreateSection("Auto Mine")
mineSection:CreateToggle("Mine", nil, function(State) andromeda.toggles.automine = State end)
local minedropdown = mineSection:CreateDropdown("Select Mode", temptable.allMinesFunc, function(String) andromeda.vars.selected_mine = String end ) minedropdown:SetOption(temptable.allMinesFunc[1])

local oreSection = farmtab:CreateSection("Ore Functions")
oreSection:CreateToggle("Xray", nil, function(State) andromeda.toggles.xray = State end)
local oredropdown = oreSection:CreateDropdown("Select Ore", temptable.ores, function(String) andromeda.vars.selected_ore = String end ) oredropdown:SetOption(temptable.ores[1])

local miscSection = misctab:CreateSection("Misc")
miscSection:CreateToggle("Disable Rendering when tabbing out", nil, function(State) andromeda.toggles.disable3drender = State end)


task.spawn(function() while task.wait(.01) do -- main
    if andromeda.toggles.xray then
        -- Xray
        for i,v in next, game:GetService("Workspace").Chunks:GetDescendants() do
            if v.ClassName ~= "Folder" and v.ClassName == "Part" then
                if v.Name:lower() == andromeda.vars.selected_ore and not v:FindFirstChild("a esp") then
                    local bill = Instance.new("BillboardGui", v)
                    bill.AlwaysOnTop = true
                    bill.Name = 'a esp'
                    bill.Size = UDim2.new(4,0,4,0)
                    local fram = Instance.new("Frame", bill)
                    fram.Size = UDim2.new(1,0, 1,0)
                    fram.BackgroundTransparency = 1
                    fram.BorderSizePixel = 1
                    local tlab = Instance.new('TextLabel', fram)
                    tlab.Size = UDim2.new(1,0,1,1)
                    tlab.BorderSizePixel = 0
                    tlab.TextSize = 15
                    tlab.Text = v.Name
                    tlab.TextColor3 = Color3.fromRGB(255, 0, 0)
                    tlab.BackgroundTransparency = 1
            end
            end
    end
    else
        for i,v in next, game:GetService("Workspace").Chunks:GetDescendants() do
            if v.Name == "a esp" then
                v:Destroy()
            end
        end
    end
    if andromeda.toggles.automine then
        -- Auto Mine
        if andromeda.vars.selected_mine == "Default" then
            mineDefault()
        elseif andromeda.vars.selected_mine == "Mouse" then
            mineMouse()
        end
    end
end end)


-- Anti Lag
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
	if andromeda.toggles.disable3drender then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end
end)
game:GetService("UserInputService").WindowFocused:Connect(function()
	if andromeda.toggles.disable3drender then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)


-- Anti AFK
local vu = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)task.wait(1)vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
