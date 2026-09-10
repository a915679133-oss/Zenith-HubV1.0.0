local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- // UI Creation \\
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenithUtilityUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleMenuBtn = Instance.new("ImageButton")
ToggleMenuBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleMenuBtn.BorderSizePixel = 0
ToggleMenuBtn.Draggable = true
ToggleMenuBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleMenuBtn).CornerRadius = UDim.new(0, 12)

local BtnIcon = Instance.new("TextLabel", ToggleMenuBtn)
BtnIcon.Size = UDim2.new(1, 0, 1, 0)
BtnIcon.BackgroundTransparency = 1
BtnIcon.Text = "🛡️"
BtnIcon.TextSize = 24
BtnIcon.TextColor3 = Color3.fromRGB(255, 255, 255)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, -120, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Zenith-Utility V1.3 | Blox Fruits"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CoordsLabel = Instance.new("TextLabel", MainFrame)
CoordsLabel.Size = UDim2.new(0, 150, 0, 40)
CoordsLabel.Position = UDim2.new(1, -160, 0, 0)
CoordsLabel.BackgroundTransparency = 1
CoordsLabel.Text = "Pos: 0, 0, 0"
CoordsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
CoordsLabel.TextSize = 12
CoordsLabel.Font = Enum.Font.SourceSansBold
CoordsLabel.TextXAlignment = Enum.TextXAlignment.Right

local TabButtonContainer = Instance.new("Frame", MainFrame)
TabButtonContainer.Size = UDim2.new(1, -20, 0, 30)
TabButtonContainer.Position = UDim2.new(0, 10, 0, 45)
TabButtonContainer.BackgroundTransparency = 1
local UIListTabLayout = Instance.new("UIListLayout", TabButtonContainer)
UIListTabLayout.FillDirection = Enum.FillDirection.Horizontal
UIListTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListTabLayout.Padding = UDim.new(0, 5)

local TabsContent = {}
local CurrentActiveTab = nil

local function createTab(name)
    local tabBtn = Instance.new("TextButton", TabButtonContainer)
    tabBtn.Size = UDim2.new(0, 95, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Text = name
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local ContentFrame = Instance.new("ScrollingFrame", MainFrame)
    ContentFrame.Size = UDim2.new(1, -20, 1, -90)
    ContentFrame.Position = UDim2.new(0, 10, 0, 85)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 650)
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.Visible = false
    local UIListLayout = Instance.new("UIListLayout", ContentFrame)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    
    TabsContent[name] = ContentFrame
    
    if not CurrentActiveTab then
        CurrentActiveTab = ContentFrame
        ContentFrame.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabsContent) do frame.Visible = false end
        for _, btn in pairs(TabButtonContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        ContentFrame.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return ContentFrame
end

local TabFarm = createTab("Farm")
local TabItems = createTab("Items")
local TabTeleports = createTab("Teleports")
local TabESP = createTab("ESP & Fly")

-- // Variables \\
local SelectedWeapon = "Melee"
local FlySpeed = 150
local IsFlying = false
local AutoFarm = false
local MobAura = false
local KillAura = false
local SmartCombat = false
local GodMode = false
local FragmentFarm = false
local MobAuraRadius = 60
local AutoCollectFruits = false
local AutoCollectChests = false
local ESPEnabled = false
local FlyBodyVel, FlyBodyGyro
local CurrentLevel = 1

-- // SMART DELAY SYSTEM \\
local FruitDelays = {
    ["Magma"] = {Z = 1.2, X = 0.8, C = 1.0, V = 1.5},
    ["Magma V2"] = {Z = 1.2, X = 0.8, C = 1.0, V = 1.5},
    ["Dragon"] = {Z = 0.9, X = 1.3, C = 0.8, V = 1.4},
    ["Dragon V2"] = {Z = 0.9, X = 1.3, C = 0.8, V = 1.4},
    ["Leopard"] = {Z = 0.7, X = 0.9, C = 0.8, V = 1.2},
    ["Leopard V2"] = {Z = 0.7, X = 0.9, C = 0.8, V = 1.2},
    ["Dough"] = {Z = 0.8, X = 0.9, C = 1.0, V = 1.3},
    ["Dough V2"] = {Z = 0.8, X = 0.9, C = 1.0, V = 1.3},
    ["Buddha"] = {Z = 0.6, X = 0.7, C = 0.8, V = 1.0},
    ["Buddha V2"] = {Z = 0.6, X = 0.7, C = 0.8, V = 1.0},
    ["Venom"] = {Z = 0.9, X = 1.0, C = 1.1, V = 1.4},
    ["Venom V2"] = {Z = 0.9, X = 1.0, C = 1.1, V = 1.4},
    ["Spirit"] = {Z = 0.8, X = 0.9, C = 1.0, V = 1.3},
    ["T-Rex"] = {Z = 0.9, X = 1.1, C = 0.9, V = 1.3},
    ["Default"] = {Z = 0.5, X = 0.6, C = 0.7, V = 1.0}
}

-- // Helper Functions \\
local function createWeaponSelector(tab)
    local frame = Instance.new("Frame", tab)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = "Select Weapon Type:"
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.SourceSansBold
    
    local btnContainer = Instance.new("Frame", frame)
    btnContainer.Size = UDim2.new(1, -10, 0, 22)
    btnContainer.Position = UDim2.new(0, 5, 0, 18)
    btnContainer.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", btnContainer)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 4)
    
    local weapons = {"Melee", "Sword", "Blox Fruit", "Gun"}
    local btns = {}
    
    for _, w in ipairs(weapons) do
        local b = Instance.new("TextButton", btnContainer)
        b.Size = UDim2.new(0.24, 0, 1, 0)
        b.BackgroundColor3 = (w == SelectedWeapon) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(40, 40, 50)
        b.Text = w
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 11
        b.Font = Enum.Font.SourceSansBold
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        btns[w] = b
        
        b.MouseButton1Click:Connect(function()
            SelectedWeapon = w
            for name, button in pairs(btns) do
                button.BackgroundColor3 = (name == SelectedWeapon) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(40, 40, 50)
            end
        end)
    end
end
createWeaponSelector(TabFarm)

local function createToggle(tab, name, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSans
    btn.Text = name .. ": OFF"
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(35, 35, 45)
        callback(state)
    end)
end

local function createButton(tab, name, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSans
    btn.Text = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

local function createSectionLabel(tab, text)
    local label = Instance.new("TextLabel", tab)
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(0, 200, 255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
end
-- // GOD MODE SYSTEM \\
local function enableGodMode()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end)
end

local function disableGodMode()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100 + (CurrentLevel * 10)
            humanoid.Health = math.min(humanoid.Health, humanoid.MaxHealth)
        end
    end)
end

-- // FRAGMENT FARM SYSTEM \\
local function enterMirage()
    pcall(function()
        local commF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
        commF:InvokeServer("SetSpawnPoint", "Mirage")
        task.wait(0.5)
        commF:InvokeServer("EnterMirage")
    end)
end

local function exitMirage()
    pcall(function()
        local commF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
        commF:InvokeServer("ExitMirage")
    end)
end

-- // SMART COMBAT SYSTEM WITH DELAYS \\
local function getEquippedFruitName()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("ToolTip") and tool.ToolTip == "Blox Fruit" then
                return tool.Name
            end
        end
    end
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("ToolTip") and tool.ToolTip == "Blox Fruit" then
                return tool.Name
            end
        end
    end
    return nil
end

local function getFruitDelays(fruitName)
    if FruitDelays[fruitName] then
        return FruitDelays[fruitName]
    end
    
    for name, delays in pairs(FruitDelays) do
        if string.find(fruitName, name) or string.find(name, fruitName) then
            return delays
        end
    end
    
    return FruitDelays["Default"]
end

local function pressKey(key, delay)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(delay or 0.08)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

local function clickM1()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(0.05)
        VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

local function executeSmartCombo()
    local fruitName = getEquippedFruitName()
    local isAwakened = CurrentLevel >= 1500
    local delays = getFruitDelays(fruitName or "Default")

    if not fruitName then
        clickM1()
        return
    end

    pressKey("Z", delays.Z)
    task.wait(delays.Z)
    clickM1()
    task.wait(0.1)
    
    pressKey("X", delays.X)
    task.wait(delays.X)
    clickM1()
    task.wait(0.1)
    
    pressKey("C", delays.C)
    task.wait(delays.C)
    clickM1()
    task.wait(0.1)
    
    if isAwakened or math.random(1, 3) == 1 then
        pressKey("V", delays.V)
        task.wait(delays.V)
    end
    
    for i = 1, 3 do
        clickM1()
        task.wait(0.05)
    end
end

-- // Game Logic \\
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local data = LocalPlayer:FindFirstChild("Data")
            if data and data:FindFirstChild("Level") then
                CurrentLevel = data.Level.Value
            end
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            CoordsLabel.Text = string.format("Pos: %.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
        end
    end)
end)

local function equipSelectedWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not char or not backpack then return end
        
        local heldTool = char:FindFirstChildOfClass("Tool")
        if heldTool and heldTool:FindFirstChild("ToolTip") and heldTool.ToolTip == SelectedWeapon then return end
        
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("ToolTip") then
                if tool.ToolTip == SelectedWeapon or (SelectedWeapon == "Melee" and tool.ToolTip == "Melee") then
                    char.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end)
end

local function tweenTo(targetCFrame, customSpeed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local speed = customSpeed or FlySpeed
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local time = math.max(distance / speed, 0.5)
    
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local function acceptQuest(questName, levelReq)
    pcall(function()
        local commF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
        commF:InvokeServer("StartQuest", questName, levelReq or 1)
    end)
end

local function getCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1
    elseif placeId == 4442272183 then return 2
    elseif placeId == 7449423635 then return 3 end
    if CurrentLevel >= 1500 then return 3
    elseif CurrentLevel >= 700 then return 2
    else return 1 end
end

local QuestsAllSeas = {
    [1] = {
        {Min = 1, Max = 9, QuestName = "BanditQuest1", LevelReq = 1, MobName = "Bandit"},
        {Min = 10, Max = 14, QuestName = "JungleQuest", LevelReq = 1, MobName = "Monkey"},
        {Min = 15, Max = 29, QuestName = "JungleQuest", LevelReq = 2, MobName = "Gorilla"},
        {Min = 30, Max = 39, QuestName = "BuggyQuest1", LevelReq = 1, MobName = "Pirate"},
        {Min = 40, Max = 59, QuestName = "BuggyQuest1", LevelReq = 2, MobName = "Brute"},
        {Min = 60, Max = 74, QuestName = "DesertQuest", LevelReq = 1, MobName = "Desert Bandit"},
        {Min = 75, Max = 89, QuestName = "DesertQuest", LevelReq = 2, MobName = "Desert Officer"},
        {Min = 90, Max = 99, QuestName = "SnowQuest", LevelReq = 1, MobName = "Snow Trooper"},
        {Min = 100, Max = 119, QuestName = "SnowQuest", LevelReq = 2, MobName = "Winter Warrior"},
        {Min = 120, Max = 129, QuestName = "MarineQuest", LevelReq = 1, MobName = "Chief Petty Officer"},
        {Min = 130, Max = 149, QuestName = "MarineQuest", LevelReq = 2, MobName = "Petty Officer"},
        {Min = 150, Max = 174, QuestName = "ImpelQuest", LevelReq = 1, MobName = "Prisoner"},
        {Min = 175, Max = 189, QuestName = "ImpelQuest", LevelReq = 2, MobName = "Dangerous Prisoner"},
        {Min = 190, Max = 209, QuestName = "SkyQuest", LevelReq = 1, MobName = "Toga Warrior"},
        {Min = 210, Max = 249, QuestName = "SkyQuest", LevelReq = 2, MobName = "Gladiator"},
        {Min = 250, Max = 274, QuestName = "PrisonQuest", LevelReq = 1, MobName = "Military Soldier"},
        {Min = 275, Max = 299, QuestName = "PrisonQuest", LevelReq = 2, MobName = "Military Spy"},
        {Min = 300, Max = 324, QuestName = "ColosseumQuest", LevelReq = 1, MobName = "God's Guard"},
        {Min = 325, Max = 374, QuestName = "ColosseumQuest", LevelReq = 2, MobName = "Shanda"},
        {Min = 375, Max = 399, QuestName = "MagmaQuest", LevelReq = 1, MobName = "Military Subordinate"},
        {Min = 400, Max = 449, QuestName = "MagmaQuest", LevelReq = 2, MobName = "Warrior"},
        {Min = 450, Max = 474, QuestName = "FishmanQuest", LevelReq = 1, MobName = "Fishman Warrior"},
        {Min = 475, Max = 524, QuestName = "FishmanQuest", LevelReq = 2, MobName = "Fishman Commando"},
        {Min = 525, Max = 549, QuestName = "HopQuest", LevelReq = 1, MobName = "God's Guard"},
        {Min = 550, Max = 624, QuestName = "HopQuest", LevelReq = 2, MobName = "Shanda"},
        {Min = 625, Max = 700, QuestName = "FountainQuest", LevelReq = 1, MobName = "Galley Pirate"},
    },
    [2] = {
        {Min = 700, Max = 724, QuestName = "Area1Quest", LevelReq = 1, MobName = "Raider"},
        {Min = 725, Max = 774, QuestName = "Area1Quest", LevelReq = 2, MobName = "Mercenary"},
        {Min = 775, Max = 799, QuestName = "Area2Quest", LevelReq = 1, MobName = "Swan Pirate"},
        {Min = 800, Max = 874, QuestName = "Area2Quest", LevelReq = 2, MobName = "Factory Staff"},
        {Min = 875, Max = 899, QuestName = "MarineQuest3", LevelReq = 1, MobName = "Marine Lieutenant"},
        {Min = 900, Max = 949, QuestName = "MarineQuest3", LevelReq = 2, MobName = "Marine Captain"},
        {Min = 950, Max = 974, QuestName = "FairyQuest", LevelReq = 1, MobName = "Zombie"},
        {Min = 975, Max = 999, QuestName = "FairyQuest", LevelReq = 2, MobName = "Vampire"},
        {Min = 1000, Max = 1049, QuestName = "IceSideQuest", LevelReq = 1, MobName = "Snow Raider"},
        {Min = 1050, Max = 1099, QuestName = "IceSideQuest", LevelReq = 2, MobName = "Winter SK"},
        {Min = 1100, Max = 1149, QuestName = "FireSideQuest", LevelReq = 1, MobName = "Lab Subordinate"},
        {Min = 1150, Max = 1199, QuestName = "FireSideQuest", LevelReq = 2, MobName = "Horned Warrior"},
        {Min = 1200, Max = 1249, QuestName = "ShipQuest1", LevelReq = 1, MobName = "Deckhand"},
        {Min = 1250, Max = 1299, QuestName = "ShipQuest2", LevelReq = 1, MobName = "Engineer"},
        {Min = 1300, Max = 1349, QuestName = "SnowMountainQuest", LevelReq = 1, MobName = "Snow Lurker"},
        {Min = 1350, Max = 1424, QuestName = "SnowMountainQuest", LevelReq = 2, MobName = "Jade Warrior"},
        {Min = 1425, Max = 1500, QuestName = "KokoQuest", LevelReq = 1, MobName = "Rebellion Soldier"},
    },
    [3] = {
        {Min = 1500, Max = 1574, QuestName = "PiratePortQuest", LevelReq = 1, MobName = "Pirate Millionaire"},
        {Min = 1575, Max = 1624, QuestName = "PiratePortQuest", LevelReq = 2, MobName = "Pistol Billionaire"},
        {Min = 1625, Max = 1699, QuestName = "AmazonQuest", LevelReq = 1, MobName = "Dragon Crew Warrior"},
        {Min = 1700, Max = 1749, QuestName = "AmazonQuest", LevelReq = 2, MobName = "Dragon Crew Archer"},
        {Min = 1750, Max = 1824, QuestName = "MarineTreeQuest", LevelReq = 1, MobName = "Female Islander"},
        {Min = 1825, Max = 1899, QuestName = "MarineTreeQuest", LevelReq = 2, MobName = "Giant Islander"},
        {Min = 1900, Max = 1974, QuestName = "DeepForestQuest", LevelReq = 1, MobName = "Forest Pirate"},
        {Min = 1975, Max = 2049, QuestName = "DeepForestQuest", LevelReq = 2, MobName = "Mythological Pirate"},
        {Min = 2050, Max = 2124, QuestName = "DeepForestIslandQuest", LevelReq = 1, MobName = "Jungle Pirate"},
        {Min = 2125, Max = 2199, QuestName = "DeepForestIslandQuest", LevelReq = 2, MobName = "Musketeer Pirate"},
        {Min = 2200, Max = 2274, QuestName = "HauntedQuest1", LevelReq = 1, MobName = "Reborn Skeleton"},
        {Min = 2275, Max = 2349, QuestName = "HauntedQuest2", LevelReq = 1, MobName = "Living Zombie"},
        {Min = 2350, Max = 2449, QuestName = "NutsIslandQuest", LevelReq = 1, MobName = "Peanut Scout"},
        {Min = 2450, Max = 2525, QuestName = "IceCreamQuest", LevelReq = 1, MobName = "Ice Cream Chef"},
        {Min = 2526, Max = 2600, QuestName = "CandyQuest1", LevelReq = 1, MobName = "Candy Rebel"},
        {Min = 2601, Max = 3000, QuestName = "TikiQuest1", LevelReq = 1, MobName = "Island Boy"},
    }
}

local function isMobSpawned(mobName)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return false end
    for _, enemy in pairs(enemies:GetChildren()) do
        if string.find(enemy.Name, mobName) then
            local hum = enemy:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then return true end
        end
    end
    return false
end

local function getBestAvailableQuest()
    local currentSea = getCurrentSea()
    local seaTable = QuestsAllSeas[currentSea]
    if not seaTable then return nil end
    
    local eligibleQuests = {}
    for _, q in ipairs(seaTable) do
        if CurrentLevel >= q.Min and CurrentLevel <= q.Max then
            table.insert(eligibleQuests, q)
        end
    end
    
    for i = #eligibleQuests, 1, -1 do
        local q = eligibleQuests[i]
        if isMobSpawned(q.MobName) then return q end
    end
    return eligibleQuests[#eligibleQuests]
end

local function getQuestMobForFarm()
    local q = getBestAvailableQuest()
    return q and q.MobName or nil
end

local function getClosestQuestEnemy()
    local targetMobName = getQuestMobForFarm()
    local closest, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, enemy in pairs(enemies:GetChildren()) do
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        local hum = enemy:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            if not targetMobName or string.find(enemy.Name, targetMobName) then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist then dist = d; closest = enemy end
            end
        end
    end
    return closest
end

-- // UI Bindings \\
createToggle(TabFarm, "Auto Farm", function(v) AutoFarm = v end)
createToggle(TabFarm, "Mob Aura", function(v) MobAura = v end)
createToggle(TabFarm, "Kill Aura", function(v) KillAura = v end)
createToggle(TabFarm, "Smart Fruit Combat (Z,X,C,V)", function(v) SmartCombat = v end)
createToggle(TabFarm, "God Mode (Immortal)", function(v)
    GodMode = v
    if v then
        enableGodMode()
    else
        disableGodMode()
    end
end)
createToggle(TabFarm, "Fragment Farm (Mirage)", function(v) FragmentFarm = v end)

createToggle(TabItems, "Auto Collect Fruits", function(v) AutoCollectFruits = v end)
createToggle(TabItems, "Auto Collect Chests", function(v) AutoCollectChests = v end)

-- // TELEPORTS BY SEA \\
TabTeleports:ClearAllChildren()
Instance.new("UIListLayout", TabTeleports).SortOrder = Enum.SortOrder.LayoutOrder
Instance.new("UIPadding", TabTeleports).PaddingBottom = UDim.new(0, 8)

createSectionLabel(TabTeleports, "🌊 SEA 1")
createButton(TabTeleports, "Starter Island", function() tweenTo(CFrame.new(-1100, 15, 3800), 300) end)
createButton(TabTeleports, "Jungle", function() tweenTo(CFrame.new(-1600, 30, 150), 300) end)
createButton(TabTeleports, "Marine Fortress", function() tweenTo(CFrame.new(-2500, 70, 200), 300) end)
createButton(TabTeleports, "Skylands", function() tweenTo(CFrame.new(-4800, 700, -1500), 300) end)
createButton(TabTeleports, "Prison", function() tweenTo(CFrame.new(-5300, 40, 900), 300) end)
createButton(TabTeleports, "Colosseum", function() tweenTo(CFrame.new(-1400, 50, -1000), 300) end)
createButton(TabTeleports, "Magma Village", function() tweenTo(CFrame.new(-5000, 30, -3000), 300) end)
createButton(TabTeleports, "Fishman Island", function() tweenTo(CFrame.new(61163, 11.5, 1819), 300) end)

createSectionLabel(TabTeleports, "🌊 SEA 2")
createButton(TabTeleports, "Kingdom of Rose", function() tweenTo(CFrame.new(-8500, 140, 6200), 300) end)
createButton(TabTeleports, "Green Zone", function() tweenTo(CFrame.new(-2400, 70, -3200), 300) end)
createButton(TabTeleports, "Graveyard", function() tweenTo(CFrame.new(-8650, 140, 6150), 300) end)
createButton(TabTeleports, "Snow Mountain", function() tweenTo(CFrame.new(1000, 150, -4800), 300) end)
createButton(TabTeleports, "Hot and Cold", function() tweenTo(CFrame.new(5500, 80, 6600), 300) end)
createButton(TabTeleports, "Cafe", function() tweenTo(CFrame.new(-385, 73, 298), 300) end)

createSectionLabel(TabTeleports, "🌊 SEA 3")
createButton(TabTeleports, "Port Town", function() tweenTo(CFrame.new(-290, 40, 5300), 300) end)
createButton(TabTeleports, "Hydra Island", function() tweenTo(CFrame.new(5500, 600, 200), 300) end)
createButton(TabTeleports, "Floating Turtle", function() tweenTo(CFrame.new(-13000, 450, -8000), 300) end)
createButton(TabTeleports, "Mansion", function() tweenTo(CFrame.new(-12474, 332, -7552), 300) end)
createButton(TabTeleports, "Castle on the Sea", function() tweenTo(CFrame.new(5000, 300, 700), 300) end)
createButton(TabTeleports, "Haunted Castle", function() tweenTo(CFrame.new(-9500, 160, 5500), 300) end)
-- // ESP & Fly \\
createToggle(TabESP, "ESP (Players & Fruits)", function(v) ESPEnabled = v end)
createToggle(TabESP, "Toggle Flight", function(v)
    IsFlying = v
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    if IsFlying then
        FlyBodyVel = Instance.new("BodyVelocity", hrp)
        FlyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        FlyBodyVel.Velocity = Vector3.zero
        FlyBodyGyro = Instance.new("BodyGyro", hrp)
        FlyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        FlyBodyGyro.CFrame = hrp.CFrame
    else
        if FlyBodyVel then FlyBodyVel:Destroy() end
        if FlyBodyGyro then FlyBodyGyro:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if IsFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        FlyBodyGyro.CFrame = cam.CFrame
        FlyBodyVel.Velocity = cam.CFrame.LookVector * FlySpeed
    end
end)

-- // ESP Loop \\
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                local hrp = char.HumanoidRootPart
                local highlight = char:FindFirstChild("ZenithESPHighlight")
                local billboard = char:FindFirstChild("ZenithESPBillboard")
                
                if ESPEnabled then
                    if not highlight then
                        highlight = Instance.new("Highlight", char)
                        highlight.Name = "ZenithESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                    if not billboard then
                        billboard = Instance.new("BillboardGui", char)
                        billboard.Name = "ZenithESPBillboard"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        local textLabel = Instance.new("TextLabel", billboard)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextSize = 14
                        textLabel.Font = Enum.Font.SourceSansBold
                    end
                    if billboard and billboard:FindFirstChild("TextLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        billboard.TextLabel.Text = p.Name .. "\n[" .. dist .. " studs]"
                    end
                else
                    if highlight then highlight:Destroy() end
                    if billboard then billboard:Destroy() end
                end
            end
        end

        for _, obj in pairs(workspace:GetChildren()) do
            if string.find(obj.Name, "Fruit") and (obj:IsA("Tool") or obj:IsA("Model")) then
                local handle = obj:FindFirstChild("Handle") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local billboard = obj:FindFirstChild("ZenithFruitESP")
                    if ESPEnabled then
                        if not billboard then
                            billboard = Instance.new("BillboardGui", obj)
                            billboard.Name = "ZenithFruitESP"
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 2, 0)
                            billboard.AlwaysOnTop = true
                            local textLabel = Instance.new("TextLabel", billboard)
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                            textLabel.TextStrokeTransparency = 0
                            textLabel.TextSize = 14
                            textLabel.Font = Enum.Font.SourceSansBold
                        end
                        if billboard and billboard:FindFirstChild("TextLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - handle.Position).Magnitude)
                            billboard.TextLabel.Text = "🍎 " .. obj.Name .. "\n[" .. dist .. " studs]"
                        end
                    else
                        if billboard then billboard:Destroy() end
                    end
                end
            end
        end
    end
end)

-- // GOD MODE LOOP \\
task.spawn(function()
    while task.wait(0.1) do
        if GodMode then
            enableGodMode()
        end
    end
end)

-- // COMBAT LOOP WITH GOD MODE & SMART DELAYS \\
task.spawn(function()
    while task.wait(0.05) do
        if AutoFarm or KillAura or MobAura or FragmentFarm then
            pcall(function()
                if GodMode then
                    enableGodMode()
                end
                
                equipSelectedWeapon()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                local closestEnemy, closestDist = nil, math.huge
                local enemies = workspace:FindFirstChild("Enemies")
                
                if FragmentFarm then
                    enemies = workspace:FindFirstChild("Mirage") or enemies
                end
                
                if enemies then
                    local targetMob = (AutoFarm or MobAura) and getQuestMobForFarm() or nil
                    for _, enemy in pairs(enemies:GetChildren()) do
                        local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                        local eHum = enemy:FindFirstChild("Humanoid")
                        if eHrp and eHum and eHum.Health > 0 then
                            if not targetMob or string.find(enemy.Name, targetMob) then
                                local dist = (hrp.Position - eHrp.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestEnemy = enemy
                                end
                            end
                        end
                    end
                end

                if closestEnemy and closestEnemy:FindFirstChild("HumanoidRootPart") then
                    local eHrp = closestEnemy.HumanoidRootPart
                    local auraRadius = MobAura and MobAuraRadius or 15
                    
                    if closestDist <= auraRadius + 5 then
                        hrp.CFrame = eHrp.CFrame * CFrame.new(0, 2, 2)
                        
                        if SmartCombat then
                            executeSmartCombo()
                        else
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    elseif (AutoFarm or FragmentFarm) and closestDist > 15 and closestDist < 400 then
                        hrp.CFrame = CFrame.lerp(hrp.CFrame, eHrp.CFrame * CFrame.new(0, 5, 0), 0.2)
                    end
                end
            end)
        end
    end
end)

-- // FRAGMENT FARM LOOP \\
task.spawn(function()
    while task.wait(2) do
        if FragmentFarm then
            pcall(function()
                local inMirage = workspace:FindFirstChild("Mirage") ~= nil
                if not inMirage then
                    enterMirage()
                    task.wait(3)
                end
            end)
        end
    end
end)

-- // AUTO QUEST ACCEPT LOOP \\
task.spawn(function()
    while task.wait(1) do
        if AutoFarm and not FragmentFarm then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local mainGui = playerGui:FindFirstChild("Main")
                    local activeQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible
                    if not activeQuest then
                        local bestQuest = getBestAvailableQuest()
                        if bestQuest then
                            acceptQuest(bestQuest.QuestName, bestQuest.LevelReq)
                        end
                    end
                end
            end)
        end
    end
end)

-- // AUTO COLLECT FRUITS \\
task.spawn(function()
    while task.wait(0.2) do
        if AutoCollectFruits then
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if string.find(obj.Name, "Fruit") and (obj:IsA("Tool") or obj:IsA("Model")) then
                        local handle = obj:FindFirstChild("Handle") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local hrp = char.HumanoidRootPart
                                local savedPos = hrp.CFrame
                                hrp.CFrame = handle.CFrame
                                local timeout = 0
                                while obj and obj.Parent == workspace and timeout < 30 do
                                    task.wait(0.1)
                                    timeout = timeout + 1
                                    if handle and hrp then hrp.CFrame = handle.CFrame end
                                end
                                if savedPos then
                                    hrp.CFrame = savedPos
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- // AUTO COLLECT CHESTS \\
task.spawn(function()
    while task.wait(0.5) do
        if AutoCollectChests then
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if string.find(obj.Name, "Chest") and (obj:IsA("Model") or obj:IsA("BasePart")) then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                        if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                            task.wait(0.3)
                        end
                    end
                end
            end)
        end
    end
end)
