local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Zenith-Utility V1.1 | Blox Fruits",
   LoadingTitle = "Zenith-Utility V1.1",
   LoadingSubtitle = "by Artem",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "Zenith-Utility V1.1 Auth",
      Subtitle = "Введите ключ доступа",
      Note = "Введите ключ: Eclipse",
      FileName = "ZenithUtilityKeySave",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Eclipse"}
   }
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

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
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("Level") then
        local lvl = data.Level.Value
        if lvl >= 1500 then return 3
        elseif lvl >= 700 then return 2
        else return 1 end
    end
    return 1
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
        {Min = 875, Max = 899, QuestName = "MarineQuest2", LevelReq = 1},
        {Min = 900, Max = 949, QuestName = "MarineQuest2", LevelReq = 2},
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
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("Level") then
        local lvl = data.Level.Value
        for _, q in ipairs(seaTable) do
            if lvl >= q.Min and lvl <= q.Max then return q end
        end
    end
    return nil
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

local MainTab = Window:CreateTab("Main Farm", 4483362458)
MainTab:CreateToggle({Name = "Auto Farm (Closest Mob)", CurrentValue = false, Callback = function(Value) AutoFarm = Value end})
MainTab:CreateToggle({Name = "Mob Aura (Bring Mobs)", CurrentValue = false, Callback = function(Value) MobAura = Value end})
MainTab:CreateSlider({Name = "Mob Aura Radius (Studs)", Range = {25, 75}, Increment = 5, CurrentValue = 50, Callback = function(Value) MobAuraRadius = Value end})
MainTab:CreateToggle({Name = "Kill Aura (Auto Click)", CurrentValue = false, Callback = function(Value) KillAura = Value end})

local ItemTab = Window:CreateTab("Items & Chests", 4483362458)
ItemTab:CreateToggle({Name = "Auto Collect Fruits", CurrentValue = false, Callback = function(Value) AutoCollectFruits = Value end})
ItemTab:CreateToggle({Name = "Auto Collect Chests", CurrentValue = false, Callback = function(Value) AutoCollectChests = Value end})

local QuestTab = Window:CreateTab("Quests", 4483362458)
QuestTab:CreateToggle({Name = "Auto Accept Quest (Fixed)", CurrentValue = false, Callback = function(Value) AutoQuest = Value end})

local ESPTab = Window:CreateTab("ESP", 4483362458)
ESPTab:CreateToggle({Name = "Player & Fruit ESP", CurrentValue = false, Callback = function(Value)
    ESPEnabled = Value
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if p.Character:FindFirstChild("ZenithESP") then p.Character.ZenithESP:Destroy() end
            if ESPEnabled then
                local bg = Instance.new("Highlight", p.Character)
                bg.Name = "ZenithESP"
                bg.FillColor = Color3.fromRGB(255, 0, 0)
                bg.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end})

local TeleportTab = Window:CreateTab("Teleports", 4483362458)
TeleportTab:CreateButton({Name = "TP to Cafe (2 Sea)", Callback = function()
    pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-385.5, 73, 298.5) end)
end})
TeleportTab:CreateButton({Name = "TP to Mansion (3 Sea)", Callback = function()
    pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12474, 332, -7552) end)
end})

local TravelTab = Window:CreateTab("Movement / Fly", 4483362458)
TravelTab:CreateSlider({Name = "Fly Speed", Range = {50, 300}, Increment = 10, CurrentValue = 150, Callback = function(Value) FlySpeed = Value end})
TravelTab:CreateToggle({Name = "Toggle Flight", CurrentValue = false, Callback = function(Value)
    IsFlying = Value
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
end})
RunService.RenderStepped:Connect(function()
    if IsFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        FlyBodyGyro.CFrame = cam.CFrame
        FlyBodyVel.Velocity = cam.CFrame.LookVector * FlySpeed
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if AutoFarm then
            pcall(function()
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
                                char.HumanoidRootPart.CFrame = handle.CFrame
                                task.wait(0.5)
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

task.spawn(function()
    while task.wait(5) do
        if AutoQuest then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local mainGui = playerGui:FindFirstChild("Main")
                    local activeQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible
                    if not activeQuest then
                        local bestQuest = getBestQuestForPlayer()
                        if bestQuest then
                            acceptQuest(bestQuest.QuestName, bestQuest.LevelReq)
                        end
                    end
                end
            end)
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if ESPEnabled then
            task.wait(1)
            local bg = Instance.new("Highlight", char)
            bg.Name = "ZenithESP"
            bg.FillColor = Color3.fromRGB(255, 0, 0)
            bg.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end)
end)
