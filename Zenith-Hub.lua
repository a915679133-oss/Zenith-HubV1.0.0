local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

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

local BtnCorner = Instance.new("UICorner", ToggleMenuBtn)
BtnCorner.CornerRadius = UDim.new(0, 12)

local BtnIcon = Instance.new("TextLabel")
BtnIcon.Size = UDim2.new(1, 0, 1, 0)
BtnIcon.BackgroundTransparency = 1
BtnIcon.Text = "🛡️"
BtnIcon.TextSize = 24
BtnIcon.Parent = ToggleMenuBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -120, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Zenith-Utility V3.0 | Blox Fruits"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local CoordsLabel = Instance.new("TextLabel")
CoordsLabel.Size = UDim2.new(0, 150, 0, 40)
CoordsLabel.Position = UDim2.new(1, -160, 0, 0)
CoordsLabel.BackgroundTransparency = 1
CoordsLabel.Text = "Pos: 0, 0, 0"
CoordsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
CoordsLabel.TextSize = 12
CoordsLabel.Font = Enum.Font.SourceSansBold
CoordsLabel.TextXAlignment = Enum.TextXAlignment.Right
CoordsLabel.Parent = MainFrame

local TabButtonContainer = Instance.new("Frame")
TabButtonContainer.Size = UDim2.new(1, -20, 0, 30)
TabButtonContainer.Position = UDim2.new(0, 10, 0, 45)
TabButtonContainer.BackgroundTransparency = 1
TabButtonContainer.Parent = MainFrame

local UIListTabLayout = Instance.new("UIListLayout", TabButtonContainer)
UIListTabLayout.FillDirection = Enum.FillDirection.Horizontal
UIListTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListTabLayout.Padding = UDim.new(0, 5)

local TabsContent = {}
local CurrentActiveTab = nil

local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 95, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Text = name
    tabBtn.Parent = TabButtonContainer
    
    local c = Instance.new("UICorner", tabBtn)
    c.CornerRadius = UDim.new(0, 6)
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -90)
    ContentFrame.Position = UDim2.new(0, 10, 0, 85)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.Visible = false
    ContentFrame.Parent = MainFrame
    
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
        for _, frame in pairs(TabsContent) do
            frame.Visible = false
        end
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

local function createToggle(tab, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSans
    btn.Text = name .. ": OFF"
    btn.Parent = tab
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(35, 35, 45)
        callback(state)
    end)
end

local function createButton(tab, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSans
    btn.Text = name
    btn.Parent = tab
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(callback)
end

local FlySpeed = 150
local IsFlying = false
local AutoQuest = false
local AutoFarm = false
local MobAura = false
local KillAura = false
local MobAuraRadius = 50
local AutoCollectFruits = false
local AutoCollectChests = false
local ESPEnabled = false
local FlyBodyVel, FlyBodyGyro
local CurrentLevel = 1

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
            CoordsLabel.Text = string.Format("Pos: %.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
        end
    end)
end)

local function tweenTo(targetCFrame, customSpeed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local speed = customSpeed or FlySpeed
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local time = distance / speed
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
        {Min = 1, Max = 9, QuestName = "BanditQuest1", LevelReq = 1},
        {Min = 10, Max = 14, QuestName = "JungleQuest", LevelReq = 1},
        {Min = 15, Max = 29, QuestName = "JungleQuest", LevelReq = 2},
        {Min = 30, Max = 39, QuestName = "BuggyQuest1", LevelReq = 1},
        {Min = 40, Max = 59, QuestName = "BuggyQuest1", LevelReq = 2},
        {Min = 60, Max = 74, QuestName = "DesertQuest", LevelReq = 1},
        {Min = 75, Max = 89, QuestName = "DesertQuest", LevelReq = 2},
        {Min = 90, Max = 99, QuestName = "SnowQuest", LevelReq = 1},
        {Min = 100, Max = 119, QuestName = "SnowQuest", LevelReq = 2},
        {Min = 120, Max = 129, QuestName = "MarineQuest", LevelReq = 1},
        {Min = 130, Max = 149, QuestName = "MarineQuest", LevelReq = 2},
        {Min = 150, Max = 174, QuestName = "ImpelQuest", LevelReq = 1},
        {Min = 175, Max = 189, QuestName = "ImpelQuest", LevelReq = 2},
        {Min = 190, Max = 209, QuestName = "SkyQuest", LevelReq = 1},
        {Min = 210, Max = 249, QuestName = "SkyQuest", LevelReq = 2},
        {Min = 250, Max = 274, QuestName = "PrisonQuest", LevelReq = 1},
        {Min = 275, Max = 299, QuestName = "PrisonQuest", LevelReq = 2},
        {Min = 300, Max = 324, QuestName = "ColosseumQuest", LevelReq = 1},
        {Min = 325, Max = 374, QuestName = "ColosseumQuest", LevelReq = 2},
        {Min = 375, Max = 399, QuestName = "MagmaQuest", LevelReq = 1},
        {Min = 400, Max = 449, QuestName = "MagmaQuest", LevelReq = 2},
        {Min = 450, Max = 474, QuestName = "FishmanQuest", LevelReq = 1},
        {Min = 475, Max = 524, QuestName = "FishmanQuest", LevelReq = 2},
        {Min = 525, Max = 549, QuestName = "HopQuest", LevelReq = 1},
        {Min = 550, Max = 624, QuestName = "HopQuest", LevelReq = 2},
        {Min = 625, Max = 700, QuestName = "FountainQuest", LevelReq = 1},
    },
    [2] = {
        {Min = 700, Max = 724, QuestName = "Area1Quest", LevelReq = 1},
        {Min = 725, Max = 774, QuestName = "Area1Quest", LevelReq = 2},
        {Min = 775, Max = 799, QuestName = "Area2Quest", LevelReq = 1},
        {Min = 800, Max = 874, QuestName = "Area2Quest", LevelReq = 2},
        {Min = 875, Max = 899, QuestName = "MarineQuest3", LevelReq = 1},
        {Min = 900, Max = 949, QuestName = "MarineQuest3", LevelReq = 2},
        {Min = 950, Max = 974, QuestName = "FairyQuest", LevelReq = 1},
        {Min = 975, Max = 999, QuestName = "FairyQuest", LevelReq = 2},
        {Min = 1000, Max = 1049, QuestName = "IceSideQuest", LevelReq = 1},
        {Min = 1050, Max = 1099, QuestName = "IceSideQuest", LevelReq = 2},
        {Min = 1100, Max = 1149, QuestName = "FireSideQuest", LevelReq = 1},
        {Min = 1150, Max = 1199, QuestName = "FireSideQuest", LevelReq = 2},
        {Min = 1200, Max = 1249, QuestName = "ShipQuest1", LevelReq = 1},
        {Min = 1250, Max = 1299, QuestName = "ShipQuest2", LevelReq = 1},
        {Min = 1300, Max = 1349, QuestName = "SnowMountainQuest", LevelReq = 1},
        {Min = 1350, Max = 1424, QuestName = "SnowMountainQuest", LevelReq = 2},
        {Min = 1425, Max = 1500, QuestName = "KokoQuest", LevelReq = 1},
    },
    [3] = {
        {Min = 1500, Max = 1574, QuestName = "PiratePortQuest", LevelReq = 1},
        {Min = 1575, Max = 1624, QuestName = "PiratePortQuest", LevelReq = 2},
        {Min = 1625, Max = 1699, QuestName = "AmazonQuest", LevelReq = 1},
        {Min = 1700, Max = 1749, QuestName = "AmazonQuest", LevelReq = 2},
        {Min = 1750, Max = 1824, QuestName = "MarineTreeQuest", LevelReq = 1},
        {Min = 1825, Max = 1899, QuestName = "MarineTreeQuest", LevelReq = 2},
        {Min = 1900, Max = 1974, QuestName = "DeepForestQuest", LevelReq = 1},
        {Min = 1975, Max = 2049, QuestName = "DeepForestQuest", LevelReq = 2},
        {Min = 2050, Max = 2124, QuestName = "DeepForestIslandQuest", LevelReq = 1},
        {Min = 2125, Max = 2199, QuestName = "DeepForestIslandQuest", LevelReq = 2},
        {Min = 2200, Max = 2274, QuestName = "HauntedQuest1", LevelReq = 1},
        {Min = 2275, Max = 2349, QuestName = "HauntedQuest2", LevelReq = 1},
        {Min = 2350, Max = 2449, QuestName = "NutsIslandQuest", LevelReq = 1},
        {Min = 2450, Max = 2525, QuestName = "IceCreamQuest", LevelReq = 1},
        {Min = 2526, Max = 2600, QuestName = "CandyQuest1", LevelReq = 1},
        {Min = 2601, Max = 3000, QuestName = "TikiQuest1", LevelReq = 1},
    }
}

local function getBestQuestForPlayer()
    local currentSea = getCurrentSea()
    local seaTable = QuestsAllSeas[currentSea]
    if not seaTable then return nil end
    local bestMatch = nil
    for _, q in ipairs(seaTable) do
        if CurrentLevel >= q.Min then
            bestMatch = q
        end
    end
    return bestMatch
end

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, enemy in pairs(enemies:GetChildren()) do
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        local hum = enemy:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then dist = d closest = enemy end
        end
    end
    return closest
end

createToggle(TabFarm, "Auto Farm", function(v) AutoFarm = v end)
createToggle(TabFarm, "Mob Aura", function(v) MobAura = v end)
createToggle(TabFarm, "Kill Aura", function(v) KillAura = v end)
createToggle(TabFarm, "Auto Quest", function(v) AutoQuest = v end)

createToggle(TabItems, "Auto Collect Fruits", function(v) AutoCollectFruits = v end)
createToggle(TabItems, "Auto Collect Chests", function(v) AutoCollectChests = v end)

createButton(TabTeleports, "TP to Cafe (2 Sea)", function()
    tweenTo(CFrame.new(-385.5, 73, 298.5), 300)
end)
createButton(TabTeleports, "TP to Mansion (3 Sea)", function()
    tweenTo(CFrame.new(-12474, 332, -7552), 300)
end)

createToggle(TabESP, "ESP (Players & Fruits)", function(v) ESPEnabled = v end)
createToggle(TabESP, "Toggle Flight", function(v)
    IsFlying = v
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    if IsFlying then
        FlyBodyVel = Instance.new("BodyVelocity")
        FlyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        FlyBodyVel.Velocity = Vector3.zero
        FlyBodyVel.Parent = hrp
        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        FlyBodyGyro.CFrame = hrp.CFrame
        FlyBodyGyro.Parent = hrp
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

task.spawn(function()
    while task.wait(0.3) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                local hrp = char.HumanoidRootPart
                local billboard = char:FindFirstChild("ZenithESPBillboard")
                local highlight = char:FindFirstChild("ZenithESPHighlight")
                
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
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if AutoFarm then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local mainGui = playerGui:FindFirstChild("Main")
                    local activeQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible
                    if not activeQuest and AutoQuest then
                        local bestQuest = getBestQuestForPlayer()
                        if bestQuest then
                            acceptQuest(bestQuest.QuestName, bestQuest.LevelReq)
                        end
                    end
                end
                
                local enemy = getClosestEnemy()
                if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if KillAura or AutoFarm then
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(0.02)
                VirtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if MobAura then
            pcall(function()
                local enemies = workspace:FindFirstChild("Enemies")
                local char = LocalPlayer.Character
                if enemies and char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    for _, enemy in pairs(enemies:GetChildren()) do
                        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                        local enemyHum = enemy:FindFirstChild("Humanoid")
                        if enemyHrp and enemyHum and enemyHum.Health > 0 then
                            local distance = (hrp.Position - enemyHrp.Position).Magnitude
                            if distance <= MobAuraRadius then
                                enemyHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
                                enemyHrp.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
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
                                
                                task.spawn(function()
                                    task.wait(1.5)
                                end)
                                
                                hrp.CFrame = handle.CFrame
                                task.wait(0.5)
                                hrp.CFrame = savedPos
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if AutoCollectChests then
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if string.find(obj.Name, "Chest") then
                        local chestPart = obj:FindFirstChildWhichIsA("BasePart")
                        if chestPart then
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CFrame = chestPart.CFrame
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
