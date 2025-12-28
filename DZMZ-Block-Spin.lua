-- ============================================================
-- PART 1: KEY-GATED SPLASH MENU + CORE SETUP + PLAYER TAB
-- DZMZ Block-Spin Hub by DeadzModz
-- ============================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local ClipboardService = setclipboard or function(text) print("Clipboard:", text) end

-- =====================
-- KEY-GATED SPLASH MENU
-- =====================
local validKeys = {
    "A1B2C3D4E5F6G","H7I8J9K0L1M2N","O3P4Q5R6S7T8U",
    "V9W0X1Y2Z3A4B","C5D6E7F8G9H0I","J1K2L3M4N5O6P",
    "Q7R8S9T0U1V2W","X3Y4Z5A6B7C8D","E9F0G1H2I3J4K",
    "L5M6N7O8P9Q0R"
}
local attempts = 0
local MAX_ATTEMPTS = 5

local SplashGui = Instance.new("ScreenGui")
SplashGui.Name = "SplashMenu"
SplashGui.Parent = PlayerGui
SplashGui.ResetOnSpawn = false

local SplashFrame = Instance.new("Frame")
SplashFrame.Size = UDim2.new(0,500,0,300)
SplashFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
SplashFrame.BackgroundColor3 = Color3.fromRGB(25,0,0)
SplashFrame.BorderColor3 = Color3.fromRGB(255,0,0)
SplashFrame.BorderSizePixel = 3
SplashFrame.Parent = SplashGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,0,0.3,0)
TitleLabel.Position = UDim2.new(0,0,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Block-Spin by DeadzModz"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 28
TitleLabel.TextColor3 = Color3.fromRGB(255,0,0)
TitleLabel.Parent = SplashFrame

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.4,0,0.15,0)
GetKeyBtn.Position = UDim2.new(0.05,0,0.6,0)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
GetKeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
GetKeyBtn.Font = Enum.Font.Gotham
GetKeyBtn.TextSize = 22
GetKeyBtn.Parent = SplashFrame

local PasteKeyBox = Instance.new("TextBox")
PasteKeyBox.Size = UDim2.new(0.5,0,0.15,0)
PasteKeyBox.Position = UDim2.new(0.45,0,0.6,0)
PasteKeyBox.PlaceholderText = "Paste Key Here"
PasteKeyBox.Text = ""
PasteKeyBox.TextColor3 = Color3.fromRGB(255,255,255)
PasteKeyBox.BackgroundColor3 = Color3.fromRGB(50,0,0)
PasteKeyBox.Font = Enum.Font.Gotham
PasteKeyBox.TextSize = 22
PasteKeyBox.Parent = SplashFrame

GetKeyBtn.MouseButton1Click:Connect(function()
    ClipboardService("https://discord.gg/dkxFWzXk8n")
    GetKeyBtn.Text = "Copied!"
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
    wait(0.2)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
    wait(1.8)
    GetKeyBtn.Text = "Get Key"
end)

local function checkKey(inputKey)
    for _,key in ipairs(validKeys) do
        if inputKey == key then
            SplashGui:Destroy()
            return true
        end
    end
    return false
end

PasteKeyBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    if checkKey(PasteKeyBox.Text) then return end
    attempts += 1
    PasteKeyBox.Text = ""
    PasteKeyBox.PlaceholderText = (attempts>=MAX_ATTEMPTS) and "Too many attempts!" or "Invalid Key!"
    PasteKeyBox.BackgroundColor3 = Color3.fromRGB(100,0,0)
    wait(1)
    PasteKeyBox.BackgroundColor3 = Color3.fromRGB(50,0,0)
    if attempts >= MAX_ATTEMPTS then
        PasteKeyBox.TextEditable = false
        GetKeyBtn.Active = false
    end
end)

-- =====================
-- MAIN GUI SETUP
-- =====================
if PlayerGui:FindFirstChild("DZMZMenu") then PlayerGui.DZMZMenu:Destroy() end
if _G.DZMZHubToggles then
    for k,v in pairs(_G.DZMZHubToggles) do _G.DZMZHubToggles[k]=false end
end
_G.DZMZHubToggles = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DZMZMenu"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false -- will enable after key entered

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,400,0,600)
MainFrame.Position = UDim2.new(0,150,0.5,-300)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- DRAGGING LOGIC
local dragging, dragInput, mousePos, framePos = false
local function updateInput(input)
    local delta = input.Position - mousePos
    MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                   framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end
-- ============================================================
-- TAB FRAME
-- ============================================================
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1,0,0,40)
TabsFrame.Position = UDim2.new(0,0,0,50)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-20,1,-110)
ContentFrame.Position = UDim2.new(0,10,0,100)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function clearContent()
    for _,c in pairs(ContentFrame:GetChildren()) do c:Destroy() end
end

local function createTabButton(name,callback,index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.22,0,1,0)
    btn.Position = UDim2.new((index-1)*0.23,0,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(50,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name
    btn.Parent = TabsFrame
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(80,0,0) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50,0,0) end)
    btn.MouseButton1Click:Connect(callback)
end

-- TOGGLE UTILITY
local function createToggle(parent,name,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Position = UDim2.new(0.05,0,#parent:GetChildren()*0.12,0)
    btn.BackgroundColor3 = Color3.fromRGB(50,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 22
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    local on = _G.DZMZHubToggles[name] or false
    btn.Text = name.." : "..(on and "ON" or "OFF")
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        on = not on
        _G.DZMZHubToggles[name] = on
        btn.Text = name.." : "..(on and "ON" or "OFF")
        callback(on)
    end)
end

-- CHARACTER BINDING
local Character, Humanoid, RootPart
local JumpStateConnection, CanJump = nil, true
local function BindHumanoid()
    if JumpStateConnection then JumpStateConnection:Disconnect() JumpStateConnection=nil end
    JumpStateConnection = Humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then CanJump=true end
    end)
end
local function LoadCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    CanJump = true
    BindHumanoid()
end
LoadCharacter()
LocalPlayer.CharacterAdded:Connect(LoadCharacter)

-- PLAYER TAB
local SpeedEnabled=false
local TP_DISTANCE=0.06
local JumpHighEnabled=false
local FIXED_JUMP=70

local function createPlayerTab()
    clearContent()
    local PlayerFrame=Instance.new("Frame")
    PlayerFrame.Size=UDim2.new(1,0,1,0)
    PlayerFrame.BackgroundTransparency=1
    PlayerFrame.Parent = ContentFrame

    createToggle(PlayerFrame,"Speed",function(val) SpeedEnabled=val end)
    createToggle(PlayerFrame,"Jump High",function(val) JumpHighEnabled=val end)

    local instr=Instance.new("TextLabel")
    instr.Size=UDim2.new(0.9,0,0,40)
    instr.Position=UDim2.new(0.05,0,0.85,0)
    instr.BackgroundTransparency=1
    instr.Font=Enum.Font.Gotham
    instr.TextSize=18
    instr.TextColor3=Color3.fromRGB(255,255,255)
    instr.Text="Press K to hide/show menu"
    instr.TextWrapped=true
    instr.Parent=PlayerFrame
end

-- SPEED & JUMP LOGIC
RunService.Heartbeat:Connect(function()
    if SpeedEnabled and RootPart and Humanoid then
        local moveDir = Humanoid.MoveDirection
        if moveDir.Magnitude>0 then RootPart.CFrame = RootPart.CFrame + (moveDir*TP_DISTANCE) end
    end
end)

UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if not JumpHighEnabled then return end
    if input.KeyCode~=Enum.KeyCode.Space then return end
    if not CanJump or not RootPart then return end
    CanJump=false
    RootPart.AssemblyLinearVelocity = Vector3.new(0,FIXED_JUMP,0)
end)
-- ============================================================
-- PART 3: VISUAL TAB + AIM TAB
-- ============================================================

-- VISUAL TAB VARIABLES
local Esp, EspLoaded=nil,false
local ShowWeaponEnabled=false
local playerTags={}

local rarityPriority={Common=1,Uncommon=2,Rare=3,Epic=4,Legendary=5}
local rarityColors={Common=Color3.fromRGB(255,255,255),Uncommon=Color3.fromRGB(0,255,0),
                    Rare=Color3.fromRGB(0,0,255),Epic=Color3.fromRGB(128,0,128),Legendary=Color3.fromRGB(255,215,0)}

-- ESP LOADER
local function LoadESP()
    if EspLoaded then return end
    EspLoaded=true
    Esp=loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/x114/RobloxScripts/main/OpenSourceEsp"))()
    Esp.Box=false Esp.BoxOutline=false Esp.HealthBar=false Esp.Names=false
end
local function EnableESP() if Esp then Esp.Box=true Esp.BoxOutline=true Esp.HealthBar=true Esp.Names=true end end
local function DisableESP() if Esp then Esp.Box=false Esp.BoxOutline=false Esp.HealthBar=false Esp.Names=false end end

local function createVisualTab()
    clearContent()
    local VisualFrame=Instance.new("Frame")
    VisualFrame.Size=UDim2.new(1,0,1,0)
    VisualFrame.BackgroundTransparency=1
    VisualFrame.Parent=ContentFrame

    createToggle(VisualFrame,"ESP",function(val)
        LoadESP()
        if val then EnableESP() else DisableESP() end
    end)

    createToggle(VisualFrame,"Show Weapon Rarity",function(val)
        ShowWeaponEnabled=val
        if not val then
            for _,data in pairs(playerTags) do
                if data.billboard then data.billboard:Destroy() end
            end
            playerTags={}
        end
    end)

    local function UpdateWeaponRarity()
        for _,plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr ~= LocalPlayer then
                local tools={}
                for _,c in ipairs({plr.Backpack,plr.Character}) do
                    if c then
                        for _,tool in ipairs(c:GetChildren()) do
                            if tool:IsA("Tool") then table.insert(tools,tool) end
                        end
                    end
                end
                local highest="Common"
                local names={}
                for _,tool in ipairs(tools) do
                    table.insert(names,tool.Name)
                    local rarity=tool:GetAttribute("RarityName") or "Common"
                    if (rarityPriority[rarity] or 0) > (rarityPriority[highest] or 0) then
                        highest=rarity
                    end
                end
                local data=playerTags[plr]
                if not data then
                    local root=plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local billboard=Instance.new("BillboardGui")
                        billboard.Name="ItemTag"
                        billboard.Size=UDim2.new(0,200,0,50)
                        billboard.Adornee=root
                        billboard.AlwaysOnTop=true
                        billboard.StudsOffset=Vector3.new(0,-2,0)
                        billboard.Parent=PlayerGui
                        local label=Instance.new("TextLabel")
                        label.Size=UDim2.new(1,0,1,0)
                        label.BackgroundTransparency=1
                        label.Font=Enum.Font.SourceSansBold
                        label.TextSize=20
                        label.TextColor3=rarityColors[highest]
                        label.Text=#names>0 and table.concat(names,", ") or "None"
                        label.Parent=billboard
                        playerTags[plr]={label=label,billboard=billboard}
                        data=playerTags[plr]
                    end
                end
                if data then
                    data.label.Text=#names>0 and table.concat(names,", ") or "None"
                    data.label.TextColor3=rarityColors[highest] or Color3.fromRGB(255,255,255)
                end
            end
        end
    end

    RunService.RenderStepped:Connect(function()
        if ShowWeaponEnabled then UpdateWeaponRarity() end
    end)
    Players.PlayerAdded:Connect(function() if ShowWeaponEnabled then UpdateWeaponRarity() end end)
    Players.PlayerRemoving:Connect(function() if ShowWeaponEnabled then UpdateWeaponRarity() end end)

    -- CROSSHAIR SETUP
    local CrosshairEnabled=true
    local CrosshairStyle=1
    local CrosshairColor=Color3.fromRGB(255,255,255)
    local CrosshairObjects={}

    local function ClearCrosshair()
        for _,obj in pairs(CrosshairObjects) do obj:Remove() end
        CrosshairObjects={}
    end

    local function CreateCrosshair(style)
        ClearCrosshair()
        local size,thick=10,2
        if style==1 then
            for i=1,4 do
                local line=Drawing.new("Line")
                line.Color=CrosshairColor line.Thickness=thick line.Visible=true
                table.insert(CrosshairObjects,line)
            end
        elseif style==2 then
            local dot=Drawing.new("Circle")
            dot.Color=CrosshairColor dot.Radius=3 dot.Filled=true dot.Visible=true
            table.insert(CrosshairObjects,dot)
        elseif style==3 then
            local circle=Drawing.new("Circle")
            circle.Color=CrosshairColor circle.Radius=12 circle.Filled=false circle.Thickness=2 circle.Visible=true
            table.insert(CrosshairObjects,circle)
        elseif style==4 then
            for i=1,4 do
                local line=Drawing.new("Line")
                line.Color=CrosshairColor line.Thickness=thick line.Visible=true
                table.insert(CrosshairObjects,line)
            end
        elseif style==5 then
            for i=1,2 do
                local line=Drawing.new("Line")
                line.Color=CrosshairColor line.Thickness=thick line.Visible=true
                table.insert(CrosshairObjects,line)
            end
        end
    end

    RunService.RenderStepped:Connect(function()
        if not CrosshairEnabled then ClearCrosshair() return end
        local centerX,centerY=Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2
        local size,gap,thick=10,2,2
        if CrosshairStyle==1 and #CrosshairObjects==4 then
            CrosshairObjects[1].From=Vector2.new(centerX,centerY-size)
            CrosshairObjects[1].To=Vector2.new(centerX,centerY-gap)
            CrosshairObjects[2].From=Vector2.new(centerX,centerY+gap)
            CrosshairObjects[2].To=Vector2.new(centerX,centerY+size)
            CrosshairObjects[3].From=Vector2.new(centerX-size,centerY)
            CrosshairObjects[3].To=Vector2.new(centerX-gap,centerY)
            CrosshairObjects[4].From=Vector2.new(centerX+gap,centerY)
            CrosshairObjects[4].To=Vector2.new(centerX+size,centerY)
        elseif CrosshairStyle==2 and #CrosshairObjects==1 then
            CrosshairObjects[1].Position=Vector2.new(centerX,centerY)
        elseif CrosshairStyle==3 and #CrosshairObjects==1 then
            CrosshairObjects[1].Position=Vector2.new(centerX,centerY)
        elseif CrosshairStyle==4 and #CrosshairObjects==4 then
            local gap2=5
            CrosshairObjects[1].From=Vector2.new(centerX,centerY-size)
            CrosshairObjects[1].To=Vector2.new(centerX,centerY-gap2)
            CrosshairObjects[2].From=Vector2.new(centerX,centerY+gap2)
            CrosshairObjects[2].To=Vector2.new(centerX,centerY+size)
            CrosshairObjects[3].From=Vector2.new(centerX-size,centerY)
            CrosshairObjects[3].To=Vector2.new(centerX-gap2,centerY)
            CrosshairObjects[4].From=Vector2.new(centerX+gap2,centerY)
            CrosshairObjects[4].To=Vector2.new(centerX+size,centerY)
        elseif CrosshairStyle==5 and #CrosshairObjects==2 then
            CrosshairObjects[1].From=Vector2.new(centerX-size,centerY-size)
            CrosshairObjects[1].To=Vector2.new(centerX+size,centerY+size)
            CrosshairObjects[2].From=Vector2.new(centerX+size,centerY-size)
            CrosshairObjects[2].To=Vector2.new(centerX-size,centerY+size)
        end
    end)

    createToggle(VisualFrame,"Crosshair",function(val) CrosshairEnabled=val end)

    local dropdown=Instance.new("TextButton")
    dropdown.Size=UDim2.new(0.9,0,0,40)
    dropdown.Position=UDim2.new(0.05,0,#VisualFrame:GetChildren()*0.12,0)
    dropdown.BackgroundColor3=Color3.fromRGB(50,0,0)
    dropdown.Font=Enum.Font.Gotham
    dropdown.TextSize=20
    dropdown.TextColor3=Color3.fromRGB(255,255,255)
    dropdown.Text="Crosshair: Classic"
    dropdown.Parent=VisualFrame

    local options={"Classic","Dot","Circle","CrossGap","DiagonalX"}
    dropdown.MouseButton1Click:Connect(function()
        CrosshairStyle=CrosshairStyle+1
        if CrosshairStyle>#options then CrosshairStyle=1 end
        dropdown.Text="Crosshair: "..options[CrosshairStyle]
        CreateCrosshair(CrosshairStyle)
    end)
end

-- ============================================================
-- AIM TAB
-- ============================================================
local AimEnabled=false
local AimLocked=false
local CurrentTarget
_G.AimPart="Head"
local FOVCircle=Drawing.new("Circle")
FOVCircle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
FOVCircle.Radius=200
FOVCircle.Visible=false

local function UnlockCursor() AimLocked=false CurrentTarget=nil UIS.MouseBehavior=Enum.MouseBehavior.Default end
local function FindNearestPlayer()
    local dist=math.huge target=nil
    for _,v in ipairs(Players:GetPlayers()) do
        if v~=LocalPlayer and v.Character and v.Character:FindFirstChild(_G.AimPart) then
            local hum=v.Character:FindFirstChild("Humanoid")
            if hum and hum.Health>0 then
                local pos,vis=Camera:WorldToViewportPoint(v.Character[_G.AimPart].Position)
                if vis then
                    local mag=(Vector2.new(Mouse.X,Mouse.Y)-Vector2.new(pos.X,pos.Y)).Magnitude
                    if mag<dist and mag<FOVCircle.Radius then dist=mag target=v.Character end
                end
            end
        end
    end
    return target
end

UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode==Enum.KeyCode.LeftAlt and AimEnabled then
        AimLocked=not AimLocked
        if AimLocked then CurrentTarget=FindNearestPlayer() else UnlockCursor() end
    end
end)

RunService.RenderStepped:Connect(function()
    if AimEnabled and AimLocked and CurrentTarget and CurrentTarget:FindFirstChild(_G.AimPart) then
        Camera.CFrame=CFrame.lookAt(Camera.CFrame.Position,CurrentTarget[_G.AimPart].Position)
        UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
        FOVCircle.Visible=true
    else FOVCircle.Visible=false end
end)

local function createAimTab()
    clearContent()
    local AimFrame=Instance.new("Frame")
    AimFrame.Size=UDim2.new(1,0,1,0)
    AimFrame.BackgroundTransparency=1
    AimFrame.Parent=ContentFrame

    createToggle(AimFrame,"AimLock",function(val) AimEnabled=val end)

    local AimInstr = Instance.new("TextLabel")
    AimInstr.Size = UDim2.new(0.9,0,0,40)
    AimInstr.Position = UDim2.new(0.05,0,0.85,0)
    AimInstr.BackgroundTransparency = 1
    AimInstr.Font = Enum.Font.Gotham
    AimInstr.TextSize = 16
    AimInstr.TextColor3 = Color3.fromRGB(255,255,255)
    AimInstr.Text = "Use Left Alt to lock/unlock AimLock."
    AimInstr.TextWrapped = true
    AimInstr.Parent = AimFrame
end
-- ============================================================
-- PART 4: SERVER TAB + DISCORD + K TOGGLE
-- ============================================================

-- SERVER TAB VARIABLES
local Spectating=false
local OriginalCamera
local SelectedPlayer

local function createServerTab()
    clearContent()
    local ServerFrame = Instance.new("Frame")
    ServerFrame.Size = UDim2.new(1,0,1,0)
    ServerFrame.BackgroundTransparency = 1
    ServerFrame.Parent = ContentFrame

    local UIList = Instance.new("ScrollingFrame")
    UIList.Size = UDim2.new(1,-20,1,-60)
    UIList.Position = UDim2.new(0,10,0,10)
    UIList.CanvasSize = UDim2.new(0,0,0,0)
    UIList.ScrollBarThickness = 8
    UIList.BackgroundTransparency = 1
    UIList.Parent = ServerFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = UIList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0,5)

    local BackBtn = Instance.new("TextButton")
    BackBtn.Size = UDim2.new(0.9,0,0,40)
    BackBtn.Position = UDim2.new(0.05,0,0.9,0)
    BackBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
    BackBtn.Font = Enum.Font.Gotham
    BackBtn.TextSize = 22
    BackBtn.TextColor3 = Color3.fromRGB(255,255,255)
    BackBtn.Text = "Back to Server List"
    BackBtn.Visible = false
    BackBtn.Parent = ServerFrame

    local function UpdateServerList()
        if Spectating then return end
        for _,child in pairs(UIList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,40)
                btn.BackgroundColor3 = Color3.fromRGB(50,0,0)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 20
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.Text = plr.Name
                btn.Parent = UIList

                btn.MouseButton1Click:Connect(function()
                    Spectating = true
                    SelectedPlayer = plr
                    OriginalCamera = Camera.CFrame
                    BackBtn.Visible = true
                end)
            end
        end
        UIList.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
    end

    RunService.RenderStepped:Connect(function()
        if Spectating and SelectedPlayer and SelectedPlayer.Character then
            local hrp = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                Camera.CFrame = CFrame.new(hrp.Position + Vector3.new(0,5,10), hrp.Position)
            end
        end
    end)

    BackBtn.MouseButton1Click:Connect(function()
        Spectating = false
        SelectedPlayer = nil
        if OriginalCamera then Camera.CFrame = OriginalCamera end
        BackBtn.Visible = false
    end)

    Players.PlayerAdded:Connect(UpdateServerList)
    Players.PlayerRemoving:Connect(UpdateServerList)
    UpdateServerList()
end

-- ============================================================
-- CREATE TAB BUTTONS
-- ============================================================
createTabButton("Player",createPlayerTab,1)
createTabButton("Visual",createVisualTab,2)
createTabButton("Aim",createAimTab,3)
createTabButton("Server",createServerTab,4)
createPlayerTab() -- default tab

-- ============================================================
-- DISCORD BUTTON
-- ============================================================
local DiscordBtn=Instance.new("TextButton")
DiscordBtn.Size=UDim2.new(0.9,0,0,40)
DiscordBtn.Position=UDim2.new(0.05,0,0,550)
DiscordBtn.BackgroundColor3=Color3.fromRGB(80,0,0)
DiscordBtn.Font=Enum.Font.Gotham
DiscordBtn.TextSize=22
DiscordBtn.TextColor3=Color3.fromRGB(255,255,255)
DiscordBtn.Text="Join Discord"
DiscordBtn.Parent=MainFrame

RunService.RenderStepped:Connect(function()
    DiscordBtn.Visible = not Spectating
end)

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/dkxFWzXk8n")
    DiscordBtn.Text="Copied to clipboard!"
    wait(2)
    DiscordBtn.Text="Join Discord"
end)

-- ============================================================
-- K TOGGLE FOR MENU
-- ============================================================
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode==Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
