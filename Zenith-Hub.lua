-- ============================================
-- ЧАСТИНА 1: ЯДРО ТА СИСТЕМА КЛЮЧА
-- ============================================

-- Zenith Hub V1.2 (Full & Fixed Engine)
-- Auto Space Trim Key System, Original CFrame Teleports, Level Quests & Mob Aura

local CorrectKey = "Eclipse"

-- 1. KEY SYSTEM
local KeyScreen = Instance.new("ScreenGui")
KeyScreen.Name = "ZenithKeySystem"
KeyScreen.ResetOnSpawn = false

if gethui then
    KeyScreen.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(KeyScreen)
    KeyScreen.Parent = game.CoreGui
else
    KeyScreen.Parent = game.CoreGui
end

local KeyFrame = Instance.new("Frame", KeyScreen)
KeyFrame.Size = UDim2.new(0, 320, 0, 170)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -85)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Text = "Zenith Hub | Key System"
KeyTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
KeyTitle.TextSize = 16
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.BackgroundColor3 = Color3.fromRGB(15, 15, 20)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 35)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
SubmitBtn.Text = "Submit Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)

-- ГЛОБАЛЬНІ НАЛАШТУВАННЯ
_G.WeaponType = "Melee"
_G.AuraDistance = 50
_G.AutoFarm = false
_G.FastAttack = true
_G.MobAura = false
_G.KillAura = false
_G.Fly = false
_G.FlySpeed = 2
_G.ClickTP = false
_G.ESP_Players = false
_G.ESP_Chests = false
_G.ESP_Fruits = false

-- НОВІ НАЛАШТУВАННЯ
_G.AttackSettings = {
    Cooldown = 0.15,
    Range = 50,
    SafeMode = false,
    AutoEquip = true,
    TargetLock = false,
    RotationSpeed = 1
}

_G.FlySettings = {
    Speed = 2,
    VerticalSpeed = 1,
    Smoothness = 0.5,
    AutoHover = false
}

_G.CollectionSettings = {
    CollectFruits = false,
    CollectChests = false,
    CollectMaterials = false,
    CollectRange = 150,
    Priority = "Fruits",
    AutoSell = false,
    CollectDelay = 0.3,
    IgnoreTeam = true
}

_G.ESPSettings = {
    Players = false,
    Fruits = false,
    Chests = false,
    Materials = false,
    TeamColor = true,
    ShowDistance = true,
    ShowName = true,
    UpdateInterval = 0.5,
    MaxDistance = 500,
    DrawLines = false,
    GlowEffect = false
}

local WeaponsList = {"Melee", "Sword", "Blox Fruit", "Gun"}
local CurrentWeaponIndex = 1
local LastAttackTime = 0
local CurrentTarget = nil
local FlyControls = {
    Forward = false, Backward = false, Left = false, Right = false,
    Up = false, Down = false, Sprint = false
}

local Keybinds = {
    Fly = Enum.KeyCode.F,
    Sprint = Enum.KeyCode.LeftShift,
    Up = Enum.KeyCode.E,
    Down = Enum.KeyCode.Q,
    Forward = Enum.KeyCode.W,
    Backward = Enum.KeyCode.S,
    Left = Enum.KeyCode.A,
    Right = Enum.KeyCode.D
}

SubmitBtn.MouseButton1Click:Connect(function()
    local cleanKey = string.match(KeyInput.Text, "^%s*(.-)%s*$")
    if cleanKey == CorrectKey then
        KeyScreen:Destroy()
        -- Запускаємо основне GUI
        CreateMainGUI()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
    end
end)

-- ДОПОМІЖНІ ФУНКЦІЇ
local function FastTP(cframe)
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function AutoEquip()
    local LocalPlayer = game.Players.LocalPlayer
    if LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not tool then
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") then
                    if item.ToolTip == _G.WeaponType or item.Name:lower():find(_G.WeaponType:lower()) or _G.WeaponType == "Melee" then
                        LocalPlayer.Character.Humanoid:EquipTool(item)
                        break
                    end
                end
            end
        end
    end
end

-- ФУНКЦІЯ ВИЗНАЧЕННЯ МОРЯ
local function GetCurrentSea()
    local LocalPlayer = game.Players.LocalPlayer
    local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not playerPos then return "First Sea" end
    
    local pos = playerPos.Position
    if pos.X < -10000 then 
        return "Third Sea"
    elseif pos.Y > 100 then 
        return "Second Sea" 
    else 
        return "First Sea" 
    end
end
-- ============================================
-- ЧАСТИНА 2: GUI ТА ТЕЛЕПОРТИ
-- ============================================

function CreateMainGUI()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "ZenithHubV12"
    MainGui.ResetOnSpawn = false
    MainGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 460, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -230, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.Active = true

    local OpenBtn = Instance.new("TextButton", MainGui)
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
    OpenBtn.Text = "Z"
    OpenBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
    OpenBtn.TextSize = 24
    OpenBtn.Font = Enum.Font.SourceSansBold
    OpenBtn.Active = true
    OpenBtn.Draggable = true

    local UICorner = Instance.new("UICorner", OpenBtn)
    UICorner.CornerRadius = UDim.new(1, 0)

    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- DRAG SYSTEM
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Text = "Zenith Hub V1.2 | Fixed Key & Auto Farm"
    Title.TextColor3 = Color3.fromRGB(0, 255, 180)
    Title.TextSize = 15
    Title.Font = Enum.Font.SourceSansBold
    Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)

    local Scroll = Instance.new("ScrollingFrame", MainFrame)
    Scroll.Size = UDim2.new(1, -10, 1, -45)
    Scroll.Position = UDim2.new(0, 5, 0, 40)
    Scroll.BackgroundTransparency = 1
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 1400)
    Scroll.ScrollBarThickness = 5

    local UIList = Instance.new("UIListLayout", Scroll)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)

    -- ВИБІР ЗБРОЇ
    local WeaponBtn = Instance.new("TextButton", Scroll)
    WeaponBtn.Size = UDim2.new(1, -10, 0, 35)
    WeaponBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    WeaponBtn.Text = "Selected Weapon: Melee"
    WeaponBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
    WeaponBtn.Font = Enum.Font.SourceSansBold
    WeaponBtn.TextSize = 14

    WeaponBtn.MouseButton1Click:Connect(function()
        CurrentWeaponIndex = (CurrentWeaponIndex % #WeaponsList) + 1
        _G.WeaponType = WeaponsList[CurrentWeaponIndex]
        WeaponBtn.Text = "Selected Weapon: " .. _G.WeaponType
    end)

    -- ФУНКЦІЯ СТВОРЕННЯ ТОГЛІВ
    local function CreateToggle(name, globalVar)
        local Btn = Instance.new("TextButton", Scroll)
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Btn.Text = name .. ": OFF"
        Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
        Btn.Font = Enum.Font.SourceSansBold
        Btn.TextSize = 14

        Btn.MouseButton1Click:Connect(function()
            local varParts = {}
            for part in string.gmatch(globalVar, "[^%.]+") do
                table.insert(varParts, part)
            end
            
            local current = _G
            for i = 1, #varParts - 1 do
                current = current[varParts[i]]
            end
            current[varParts[#varParts]] = not current[varParts[#varParts]]
            
            if current[varParts[#varParts]] then
                Btn.Text = name .. ": ON"
                Btn.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                Btn.Text = name .. ": OFF"
                Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    end

    -- ОСНОВНІ ТОГЛИ
    CreateToggle("Auto Farm Level", "_G.AutoFarm")
    CreateToggle("Fast Attack Engine", "_G.FastAttack")
    CreateToggle("Mob Aura", "_G.MobAura")
    CreateToggle("Kill Aura (PvP Safe)", "_G.KillAura")
    CreateToggle("CFrame Fly Hack", "_G.Fly")
    CreateToggle("Click TP", "_G.ClickTP")

    -- СЛАЙДЕР ДЛЯ АУРИ
    local SliderFrame = Instance.new("Frame", Scroll)
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)

    local SliderTitle = Instance.new("TextLabel", SliderFrame)
    SliderTitle.Size = UDim2.new(1, 0, 0, 20)
    SliderTitle.Text = "Aura Distance: 50 studs"
    SliderTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
    SliderTitle.Font = Enum.Font.SourceSansBold
    SliderTitle.TextSize = 13
    SliderTitle.BackgroundTransparency = 1

    local Track = Instance.new("Frame", SliderFrame)
    Track.Size = UDim2.new(0.9, 0, 0, 8)
    Track.Position = UDim2.new(0.05, 0, 0.65, 0)
    Track.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new(0.5, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 180)

    local SliderBtn = Instance.new("TextButton", Track)
    SliderBtn.Size = UDim2.new(1, 0, 1, 0)
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Text = ""

    local isSliding = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(25 + (pos * 50))
        _G.AuraDistance = val
        SliderTitle.Text = "Aura Distance: " .. tostring(val) .. " studs"
    end

    SliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            UpdateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)

    -- ТЕЛЕПОРТИ
    local TPHeader = Instance.new("TextLabel", Scroll)
    TPHeader.Size = UDim2.new(1, -10, 0, 25)
    TPHeader.Text = "-- Island Teleports --"
    TPHeader.TextColor3 = Color3.fromRGB(0, 255, 180)
    TPHeader.Font = Enum.Font.SourceSansBold
    TPHeader.BackgroundTransparency = 1

    local SeaTeleports = {
        ["First Sea"] = {
            {"Starter Island", Vector3.new(1095, 16, 1420)},
            {"Jungle", Vector3.new(-1612, 36, 148)},
            {"Pirate Village", Vector3.new(-1145, 4, 3830)},
            {"Desert", Vector3.new(895, 6, 4390)},
            {"Middle Town", Vector3.new(-690, 15, 1580)},
            {"Frozen Village", Vector3.new(1150, 26, -1425)},
            {"Marine Fortress", Vector3.new(-5042, 73, 4323)},
            {"Prison", Vector3.new(4850, 5, 730)},
            {"Sky Island", Vector3.new(-4850, 750, 850)}
        },
        ["Second Sea"] = {
            {"Kingdom of Rose", Vector3.new(-380, 73, 298)},
            {"Cafe", Vector3.new(-380, 73, 298)},
            {"Mansion", Vector3.new(-380, 73, 298)},
            {"Factory", Vector3.new(50, 73, 298)},
            {"Pirate Island", Vector3.new(380, 73, 298)}
        },
        ["Third Sea"] = {
            {"Tiki Outpost", Vector3.new(-12460, 375, -7540)},
            {"Mansion (Sea 3)", Vector3.new(-12460, 375, -7540)},
            {"Castle", Vector3.new(-12460, 375, -7540)},
            {"Port Town", Vector3.new(-12460, 375, -7540)},
            {"Hydra Island", Vector3.new(-12460, 375, -7540)}
        }
    }

    local function UpdateTeleports()
        local currentSea = GetCurrentSea()
        local teleports = SeaTeleports[currentSea] or SeaTeleports["First Sea"]
        
        for _, child in pairs(Scroll:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChild("IsTeleport") then
                child:Destroy()
            end
        end
        
        for _, item in ipairs(teleports) do
            local islandName = item[1]
            local coords = item[2]
            
            local TpBtn = Instance.new("TextButton", Scroll)
            TpBtn.Size = UDim2.new(1, -10, 0, 32)
            TpBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
            TpBtn.Text = "TP To: " .. islandName .. " 🌊"
            TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TpBtn.Font = Enum.Font.SourceSansBold
            TpBtn.TextSize = 13
            
            local marker = Instance.new("BoolValue", TpBtn)
            marker.Name = "IsTeleport"
            
            TpBtn.MouseButton1Click:Connect(function()
                FastTP(CFrame.new(coords))
            end)
        end
    end

    UpdateTeleports()

    -- АВТО-ОНОВЛЕННЯ ТЕЛЕПОРТІВ
    task.spawn(function()
        while true do
            task.wait(5)
            local currentSea = GetCurrentSea()
            if currentSea ~= _G.LastSea then
                _G.LastSea = currentSea
                UpdateTeleports()
            end
        end
    end)

    -- ВИКЛИК ДОДАТКОВИХ GUI
    CreateCollectionUI(Scroll)
    CreateESPUI(Scroll)
    CreateSettingsUI(Scroll)
end
-- ============================================
-- ЧАСТИНА 3: АВТО-ЗБІР ТА ESP
-- ============================================

-- КЕШ ДЛЯ ОБ'ЄКТІВ
local CollectionCache = {
    Fruits = {},
    Chests = {},
    Materials = {},
    LastUpdate = 0,
    UpdateInterval = 0.5
}

-- ПОШУК ОБ'ЄКТІВ
local function FindCollectables()
    local LocalPlayer = game.Players.LocalPlayer
    local currentTime = tick()
    if currentTime - CollectionCache.LastUpdate < CollectionCache.UpdateInterval then
        return CollectionCache
    end
    
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return end
    
    local position = myPos.Position
    local collectables = {Fruits = {}, Chests = {}, Materials = {}}
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            
            if _G.CollectionSettings.CollectFruits and (
                name:find("fruit") or name:find("devil") or name:find("dragon") or 
                name:find("venom") or name:find("buddha") or obj:FindFirstChild("Handle")
            ) then
                local distance = (obj.Position - position).Magnitude
                if distance <= _G.CollectionSettings.CollectRange then
                    table.insert(collectables.Fruits, {Object = obj, Distance = distance, Position = obj.Position})
                end
            end
            
            if _G.CollectionSettings.CollectChests and (
                name:find("chest") or name:find("box") or name:find("crate") or obj:IsA("Chest")
            ) then
                local distance = (obj.Position - position).Magnitude
                if distance <= _G.CollectionSettings.CollectRange then
                    table.insert(collectables.Chests, {Object = obj, Distance = distance, Position = obj.Position})
                end
            end
            
            if _G.CollectionSettings.CollectMaterials and (
                name:find("rock") or name:find("stone") or name:find("tree") or name:find("ore")
            ) then
                local distance = (obj.Position - position).Magnitude
                if distance <= _G.CollectionSettings.CollectRange then
                    table.insert(collectables.Materials, {Object = obj, Distance = distance, Position = obj.Position})
                end
            end
        end
    end
    
    for _, list in pairs(collectables) do
        table.sort(list, function(a, b) return a.Distance < b.Distance end)
    end
    
    CollectionCache = collectables
    CollectionCache.LastUpdate = currentTime
    return collectables
end

-- АВТО-ЗБІР
local function CollectItems()
    local LocalPlayer = game.Players.LocalPlayer
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local collectables = FindCollectables()
    local priorityOrder = {}
    
    if _G.CollectionSettings.Priority == "Fruits" then
        priorityOrder = {collectables.Fruits, collectables.Chests, collectables.Materials}
    elseif _G.CollectionSettings.Priority == "Chests" then
        priorityOrder = {collectables.Chests, collectables.Fruits, collectables.Materials}
    else
        priorityOrder = {collectables.Materials, collectables.Fruits, collectables.Chests}
    end
    
    for _, itemList in ipairs(priorityOrder) do
        if #itemList > 0 then
            local item = itemList[1]
            if item and item.Object and item.Object.Parent then
                FastTP(CFrame.new(item.Object.Position + Vector3.new(0, 2, 0)))
                task.wait(_G.CollectionSettings.CollectDelay)
                
                pcall(function()
                    local clickable = item.Object:FindFirstChild("ClickDetector")
                    if clickable then clickable:FireClick() end
                    
                    local remote = item.Object:FindFirstChild("RemoteEvent")
                    if remote then remote:FireServer() end
                    
                    local tool = item.Object:FindFirstChildOfClass("Tool")
                    if tool then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                        tool:Activate()
                    end
                end)
                return true
            end
        end
    end
    return false
end

-- GUI ДЛЯ ЗБОРУ
function CreateCollectionUI(parent)
    local CollectionHeader = Instance.new("TextLabel", parent)
    CollectionHeader.Size = UDim2.new(1, -10, 0, 25)
    CollectionHeader.Text = "-- Auto Collection --"
    CollectionHeader.TextColor3 = Color3.fromRGB(255, 215, 0)
    CollectionHeader.Font = Enum.Font.SourceSansBold
    CollectionHeader.BackgroundTransparency = 1
    
    local CollectButtons = {
        {"Collect Fruits", "_G.CollectionSettings.CollectFruits"},
        {"Collect Chests", "_G.CollectionSettings.CollectChests"},
        {"Collect Materials", "_G.CollectionSettings.CollectMaterials"},
        {"Auto Sell", "_G.CollectionSettings.AutoSell"}
    }
    
    for _, btn in ipairs(CollectButtons) do
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Btn.Text = btn[1] .. ": OFF"
        Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
        Btn.Font = Enum.Font.SourceSansBold
        Btn.TextSize = 14
        
        Btn.MouseButton1Click:Connect(function()
            local varParts = {}
            for part in string.gmatch(btn[2], "[^%.]+") do
                table.insert(varParts, part)
            end
            
            local current = _G
            for i = 1, #varParts - 1 do
                current = current[varParts[i]]
            end
            current[varParts[#varParts]] = not current[varParts[#varParts]]
            
            if current[varParts[#varParts]] then
                Btn.Text = btn[1] .. ": ON"
                Btn.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                Btn.Text = btn[1] .. ": OFF"
                Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    end
end

-- ESP СИСТЕМА
local ESPSystem = {Objects = {}}

function CreateESPUI(parent)
    local ESPHeader = Instance.new("TextLabel", parent)
    ESPHeader.Size = UDim2.new(1, -10, 0, 25)
    ESPHeader.Text = "-- ESP Settings --"
    ESPHeader.TextColor3 = Color3.fromRGB(0, 255, 180)
    ESPHeader.Font = Enum.Font.SourceSansBold
    ESPHeader.BackgroundTransparency = 1
    
    local ESPButtons = {
        {"ESP Players", "_G.ESPSettings.Players"},
        {"ESP Fruits", "_G.ESPSettings.Fruits"},
        {"ESP Chests", "_G.ESPSettings.Chests"},
        {"ESP Materials", "_G.ESPSettings.Materials"},
        {"Show Names", "_G.ESPSettings.ShowName"},
        {"Show Distance", "_G.ESPSettings.ShowDistance"},
        {"Team Color", "_G.ESPSettings.TeamColor"},
        {"Draw Lines", "_G.ESPSettings.DrawLines"},
        {"Glow Effect", "_G.ESPSettings.GlowEffect"}
    }
    
    for _, btn in ipairs(ESPButtons) do
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Btn.Text = btn[1] .. ": OFF"
        Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
        Btn.Font = Enum.Font.SourceSansBold
        Btn.TextSize = 14
        
        Btn.MouseButton1Click:Connect(function()
            local varParts = {}
            for part in string.gmatch(btn[2], "[^%.]+") do
                table.insert(varParts, part)
            end
            
            local current = _G
            for i = 1, #varParts - 1 do
                current = current[varParts[i]]
            end
            current[varParts[#varParts]] = not current[varParts[#varParts]]
            
            if current[varParts[#varParts]] then
                Btn.Text = btn[1] .. ": ON"
                Btn.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                Btn.Text = btn[1] .. ": OFF"
                Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    end
end

local function CreateESPObject(target, color, name, distance)
    if not target or not target.Parent then return end
    
    local espGui = target:FindFirstChild("ZenithESP")
    if espGui then espGui:Destroy() end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZenithESP"
    billboard.Adornee = target
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Parent = target
    
    local background = Instance.new("Frame", billboard)
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = color
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 2
    background.BorderColor3 = color
    
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name or "Unknown"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextStrokeTransparency = 0.5
    
    if _G.ESPSettings.ShowDistance then
        local distLabel = Instance.new("TextLabel", billboard)
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = distance and tostring(math.floor(distance)) .. "m" or "?"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 12
        distLabel.Font = Enum.Font.SourceSans
        distLabel.TextStrokeTransparency = 0.5
    end
    
    return billboard
end

local function UpdateESP()
    local LocalPlayer = game.Players.LocalPlayer
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local maxDist = _G.ESPSettings.MaxDistance
    
    if _G.ESPSettings.Players then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                if distance <= maxDist then
                    local color = _G.ESPSettings.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 50, 50)
                    local name = _G.ESPSettings.ShowName and player.Name or "Player"
                    CreateESPObject(player.Character, color, name, distance)
                end
            end
        end
    end
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            local distance = (obj.Position - myPos).Magnitude
            
            if distance <= maxDist then
                local isFruit = _G.ESPSettings.Fruits and (
                    name:find("fruit") or name:find("devil") or name:find("dragon") or 
                    obj:FindFirstChild("Handle")
                )
                local isChest = _G.ESPSettings.Chests and (
                    name:find("chest") or name:find("box") or name:find("crate") or obj:IsA("Chest")
                )
                local isMaterial = _G.ESPSettings.Materials and (
                    name:find("rock") or name:find("stone") or name:find("tree") or name:find("ore")
                )
                
                if isFruit or isChest or isMaterial then
                    local color = isFruit and Color3.fromRGB(255, 150, 50) or 
                                  isChest and Color3.fromRGB(255, 215, 0) or 
                                  Color3.fromRGB(100, 200, 255)
                    local espName = (isFruit and "🍎 " or isChest and "📦 " or "💎 ") .. obj.Name
                    CreateESPObject(obj, color, espName, distance)
                end
            end
        end
    end
end

-- ОСНОВНІ ЦИКЛИ
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.CollectionSettings.CollectFruits or _G.CollectionSettings.CollectChests or _G.CollectionSettings.CollectMaterials then
            pcall(CollectItems)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(_G.ESPSettings.UpdateInterval)
        pcall(UpdateESP)
    end
end)
-- ============================================
-- ЧАСТИНА 4: БОЙОВА СИСТЕМА, FLY ТА КЕРУВАННЯ-- ============================================

-- ФУНКЦІЯ АТАКИ
local function Attack()
    local LocalPlayer = game.Players.LocalPlayer
    AutoEquip()
    if LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            pcall(function()
                local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
                if net and net:FindFirstChild("RE/RegisterAttack") then
                    net["RE/RegisterAttack"]:FireServer()
                end
            end)
        end
    end
end

-- ВИЗНАЧЕННЯ КВЕСТУ
local function GetQuestByLevel()
    local LocalPlayer = game.Players.LocalPlayer
    local level = 1
    pcall(function() level = LocalPlayer.Data.Level.Value end)

    if level >= 1 and level < 10 then
        return "BanditQuest1", 1, "Bandit", CFrame.new(1060, 16, 1548), CFrame.new(1145, 17, 1634)
    elseif level >= 10 and level < 15 then
        return "JungleQuest", 1, "Monkey", CFrame.new(-1600, 37, 153), CFrame.new(-1620, 37, 140)
    elseif level >= 15 and level < 30 then
        return "JungleQuest", 2, "Gorilla", CFrame.new(-1600, 37, 153), CFrame.new(-1240, 6, -490)
    elseif level >= 30 and level < 40 then
        return "PirateQuest", 1, "Pirate", CFrame.new(-1140, 4, 3828), CFrame.new(-1215, 4, 3915)
    elseif level >= 40 and level < 60 then
        return "PirateQuest", 2, "Brute", CFrame.new(-1140, 4, 3828), CFrame.new(-1145, 14, 4300)
    elseif level >= 60 and level < 90 then
        return "DesertQuest", 1, "Desert Bandit", CFrame.new(896, 6, 4390), CFrame.new(930, 6, 4480)
    elseif level >= 90 and level < 100 then
        return "DesertQuest", 2, "Desert Officer", CFrame.new(896, 6, 4390), CFrame.new(1580, 6, 4370)
    elseif level >= 100 and level < 120 then
        return "SnowQuest", 1, "Snow Bandit", CFrame.new(1385, 87, -1298), CFrame.new(1280, 105, -1430)
    else
        return "BanditQuest1", 1, "Bandit", CFrame.new(1060, 16, 1548), CFrame.new(1145, 17, 1634)
    end
end

-- ПОКРАЩЕНА СИСТЕМА АТАКИ
local function SmartAttack()
    local LocalPlayer = game.Players.LocalPlayer
    local currentTime = tick()
    if currentTime - LastAttackTime < _G.AttackSettings.Cooldown then return end
    LastAttackTime = currentTime
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    if _G.AttackSettings.AutoEquip then
        AutoEquip()
    end
    
    local targets = {}
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local myClan = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Clan") and LocalPlayer.Data.Clan.Value
    
    if _G.KillAura then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetClan = player:FindFirstChild("Data") and player.Data:FindFirstChild("Clan") and player.Data.Clan.Value
                local isSameClan = (myClan and targetClan and myClan ~= "" and myClan == targetClan)
                
                if not isSameClan and player.Character.Humanoid.Health > 0 then
                    local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                    if dist <= _G.AttackSettings.Range then
                        table.insert(targets, {Object = player.Character, Distance = dist, Type = "Player"})
                    end
                end
            end
        end
    end
    
    if _G.MobAura then
        local enemyFolders = {"Enemies", "Monsters", "Mobs", "NPCs"}
        for _, folderName in ipairs(enemyFolders) do
            local folder = workspace:FindFirstChild(folderName)
            if folder then
                for _, enemy in pairs(folder:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        local dist = (enemy.HumanoidRootPart.Position - myPos).Magnitude
                        if dist <= _G.AttackSettings.Range then
                            table.insert(targets, {Object = enemy, Distance = dist, Type = "Mob"})
                        end
                    end
                end
            end
        end
    end
    
    if #targets > 0 then
        table.sort(targets, function(a, b) return a.Distance < b.Distance end)
        local target = targets[1]
        CurrentTarget = target.Object
        
        local targetPos = target.Object.HumanoidRootPart.Position
        FastTP(CFrame.new(targetPos + Vector3.new(0, 0, 3)))
        
        if _G.AttackSettings.RotationSpeed > 0 then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local lookAt = CFrame.lookAt(hrp.Position, targetPos)
            hrp.CFrame = hrp.CFrame:Lerp(lookAt, _G.AttackSettings.RotationSpeed)
        end
        
        Attack()
    end
end

-- AUTO FARM
task.spawn(function()
    while true do
        task.wait(0.01)
        if _G.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local questTitle, questId, mobName, questCFrame, mobCFrame = GetQuestByLevel()
                local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                local questFrame = mainGui and mainGui:FindFirstChild("Quest")
                local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

                if not (questFrame and questFrame.Visible) then
                    FastTP(questCFrame)
                    task.wait(0.3)
                    CommF:InvokeServer("StartQuest", questTitle, questId)
                else
                    local mobFound = false
                    if workspace:FindFirstChild("Enemies") then
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy.Name == mobName and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                mobFound = true
                                FastTP(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                                if _G.FastAttack then Attack() end
                                break
                            end
                        end
                    end
                    if not mobFound then
                        FastTP(mobCFrame)
                    end
                end
            end)
        end
    end
end)

-- БОЙОВІ АУРИ
task.spawn(function()
    while true do
        task.wait(0.01)
        if (_G.MobAura or _G.KillAura) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(SmartAttack)
        end
    end
end)

-- CLICK TP
local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if _G.ClickTP and Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        FastTP(CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)))
    end
end)

-- FLY HACK
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode
    
    if key == Keybinds.Fly then
        _G.Fly = not _G.Fly
        if not _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
        return
    end
    
    if not _G.Fly then return end
    
    if key == Keybinds.Forward then FlyControls.Forward = true end
    if key == Keybinds.Backward then FlyControls.Backward = true end
    if key == Keybinds.Left then FlyControls.Left = true end
    if key == Keybinds.Right then FlyControls.Right = true end
    if key == Keybinds.Up then FlyControls.Up = true end
    if key == Keybinds.Down then FlyControls.Down = true end
    if key == Keybinds.Sprint then FlyControls.Sprint = true end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode
    if not _G.Fly then return end
    
    if key == Keybinds.Forward then FlyControls.Forward = false end
    if key == Keybinds.Backward then FlyControls.Backward = false end
    if key == Keybinds.Left then FlyControls.Left = false end
    if key == Keybinds.Right then FlyControls.Right = false end
    if key == Keybinds.Up then FlyControls.Up = false end
    if key == Keybinds.Down then FlyControls.Down = false end
    if key == Keybinds.Sprint then FlyControls.Sprint = false end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if not _G.Fly or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
            task.wait(0.1)
            continue 
        end
        
        pcall(function()
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
            
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            
            if FlyControls.Forward then moveVector = moveVector + forward end
            if FlyControls.Backward then moveVector = moveVector - forward end
            if FlyControls.Left then moveVector = moveVector - right end
            if FlyControls.Right then moveVector = moveVector + right end
            if FlyControls.Up then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if FlyControls.Down then moveVector = moveVector - Vector3.new(0, 1, 0) end
            
            local speed = _G.FlySettings.Speed * (FlyControls.Sprint and 2 or 1)
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * speed
            end
            
            if _G.FlySettings.AutoHover and moveVector.Y == 0 then
                moveVector = moveVector + Vector3.new(0, 0.1, 0)
            end
            
            local targetPos = hrp.Position + moveVector
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), _G.FlySettings.Smoothness)
            hrp.Velocity = Vector3.new(0, 0, 0)
        end)
    end
end)

-- GUI НАЛАШТУВАНЬ
function CreateSettingsUI(parent)
    local SettingsHeader = Instance.new("TextLabel", parent)
    SettingsHeader.Size = UDim2.new(1, -10, 0, 25)
    SettingsHeader.Text = "-- Advanced Settings --"
    SettingsHeader.TextColor3 = Color3.fromRGB(0, 255, 180)
    SettingsHeader.Font = Enum.Font.SourceSansBold
    SettingsHeader.BackgroundTransparency = 1
    
    local SettingsToggles = {
        {"Safe Mode", "_G.AttackSettings.SafeMode"},
        {"Auto Equip", "_G.AttackSettings.AutoEquip"},
        {"Target Lock", "_G.AttackSettings.TargetLock"},
        {"Auto Hover", "_G.FlySettings.AutoHover"}
    }
    
    for _, btn in ipairs(SettingsToggles) do
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Btn.Text = btn[1] .. ": OFF"
        Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
        Btn.Font = Enum.Font.SourceSansBold
        Btn.TextSize = 14
        
        Btn.MouseButton1Click:Connect(function()
            local varParts = {}
            for part in string.gmatch(btn[2], "[^%.]+") do
                table.insert(varParts, part)
            end
            
            local current = _G
            for i = 1, #varParts - 1 do
                current = current[varParts[i]]
            end
            current[varParts[#varParts]] = not current[varParts[#varParts]]
            
            if current[varParts[#varParts]] then
                Btn.Text = btn[1] .. ": ON"
                Btn.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                Btn.Text = btn[1] .. ": OFF"
                Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    end
end

print("Zenith Hub V1.2 Loaded Successfully!")
print("Key: Eclipse | Fly Controls: WASD + E/Q + Shift")
