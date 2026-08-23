-- ============================================
-- ЧАСТИНА 1: ЯДРО, КЛЮЧ ТА ОСНОВНІ ЗМІННІ
-- ============================================

-- Zenith Hub V2.0 (Advanced ESP + Attack Speed Control)
-- Покращена версія з розширеним ESP та контролем швидкості атаки

local CorrectKey = "Eclipse"

-- НОВІ НАЛАШТУВАННЯ
_G.AttackSpeed = 0.08 -- Швидкість атаки (0.01 - 0.3)
_G.ESPShowDistance = true
_G.ESPShowName = true
_G.ESPPlayerColor = Color3.fromRGB(255, 50, 50) -- Червоний для гравців
_G.ESPChestColor = Color3.fromRGB(255, 215, 0) -- Жовтий для сундуків
_G.ESPFruitColor = Color3.fromRGB(200, 50, 255) -- Фіолетовий для фруктів
_G.ESPMaxDistance = 500
_G.ESPUpdateInterval = 0.3

-- СТАРІ НАЛАШТУВАННЯ
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
KeyTitle.Text = "Zenith Hub V2.0 | Advanced ESP"
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

-- ДОПОМІЖНІ ФУНКЦІЇ
local function FastTP(cframe)
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
    end
end

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

SubmitBtn.MouseButton1Click:Connect(function()
    local cleanKey = string.match(KeyInput.Text, "^%s*(.-)%s*$")
    if cleanKey == CorrectKey then
        KeyScreen:Destroy()
        CreateMainGUI()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
    end
end)
-- ============================================
-- ЧАСТИНА 2: GUI ТА ТЕЛЕПОРТИ
-- ============================================

function CreateMainGUI()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "ZenithHubV20"
    MainGui.ResetOnSpawn = false
    MainGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UDim2.new(0, 480, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -225)
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
    Title.Text = "Zenith Hub V2.0 | Advanced ESP & Fast Attack"
    Title.TextColor3 = Color3.fromRGB(0, 255, 180)
    Title.TextSize = 14
    Title.Font = Enum.Font.SourceSansBold
    Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)

    local Scroll = Instance.new("ScrollingFrame", MainFrame)
    Scroll.Size = UDim2.new(1, -10, 1, -45)
    Scroll.Position = UDim2.new(0, 5, 0, 40)
    Scroll.BackgroundTransparency = 1
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
    Scroll.ScrollBarThickness = 5

    local UIList = Instance.new("UIListLayout", Scroll)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)

    -- ВИБІР ЗБРОЇ
    local WeaponsList = {"Melee", "Sword", "Blox Fruit", "Gun"}
    local CurrentWeaponIndex = 1

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
            _G[globalVar] = not _G[globalVar]
            if _G[globalVar] then
                Btn.Text = name .. ": ON"
                Btn.TextColor3 = Color3.fromRGB(80, 255, 120)
            else
                Btn.Text = name .. ": OFF"
                Btn.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    end

    CreateToggle("Auto Farm Level (Auto Quest)", "AutoFarm")
    CreateToggle("Fast Attack Engine", "FastAttack")
    CreateToggle("Mob Aura", "MobAura")
    CreateToggle("Kill Aura (PvP Safe)", "KillAura")
    CreateToggle("CFrame Fly Hack", "Fly")
    CreateToggle("Click TP", "ClickTP")
    CreateToggle("ESP Players", "ESP_Players")
    CreateToggle("ESP Chests", "ESP_Chests")
    CreateToggle("ESP Devil Fruits", "ESP_Fruits")

    -- НОВИЙ СЛАЙДЕР: ШВИДКІСТЬ АТАКИ
    local SpeedSliderFrame = Instance.new("Frame", Scroll)
    SpeedSliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SpeedSliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)

    local SpeedSliderTitle = Instance.new("TextLabel", SpeedSliderFrame)
    SpeedSliderTitle.Size = UDim2.new(1, 0, 0, 20)
    SpeedSliderTitle.Text = "Attack Speed: 0.08 sec"
    SpeedSliderTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
    SpeedSliderTitle.Font = Enum.Font.SourceSansBold
    SpeedSliderTitle.TextSize = 13
    SpeedSliderTitle.BackgroundTransparency = 1

    local SpeedTrack = Instance.new("Frame", SpeedSliderFrame)
    SpeedTrack.Size = UDim2.new(0.9, 0, 0, 8)
    SpeedTrack.Position = UDim2.new(0.05, 0, 0.65, 0)
    SpeedTrack.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

    local SpeedFill = Instance.new("Frame", SpeedTrack)
    SpeedFill.Size = UDim2.new((_G.AttackSpeed - 0.01) / 0.29, 0, 1, 0)
    SpeedFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)

    local SpeedSliderBtn = Instance.new("TextButton", SpeedTrack)
    SpeedSliderBtn.Size = UDim2.new(1, 0, 1, 0)
    SpeedSliderBtn.BackgroundTransparency = 1
    SpeedSliderBtn.Text = ""

    local isSpeedSliding = false
    local function UpdateSpeedSlider(input)
        local pos = math.clamp((input.Position.X - SpeedTrack.AbsolutePosition.X) / SpeedTrack.AbsoluteSize.X, 0, 1)
        SpeedFill.Size = UDim2.new(pos, 0, 1, 0)
        local val = 0.01 + (pos * 0.29)
        _G.AttackSpeed = math.floor(val * 1000) / 1000
        SpeedSliderTitle.Text = "Attack Speed: " .. string.format("%.3f", _G.AttackSpeed) .. " sec"
    end

    SpeedSliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSpeedSliding = true
            UpdateSpeedSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isSpeedSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSpeedSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSpeedSliding = false
        end
    end)

    -- СТАРИЙ СЛАЙДЕР: ДИСТАНЦІЯ АУРИ
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

    local Islands = {
        {"Starter Island", Vector3.new(1095, 16, 1420)},
        {"Jungle", Vector3.new(-1612, 36, 148)},
        {"Pirate Village", Vector3.new(-1145, 4, 3830)},
        {"Desert", Vector3.new(895, 6, 4390)},
        {"Middle Town", Vector3.new(-690, 15, 1580)},
        {"Frozen Village", Vector3.new(1150, 26, -1425)},
        {"Marine Fortress", Vector3.new(-5042, 73, 4323)},
        {"Prison", Vector3.new(4850, 5, 730)},
        {"Cafe (Sea 2)", Vector3.new(-380, 73, 298)},
        {"Mansion (Sea 3)", Vector3.new(-12460, 375, -7540)}
    }

    for _, item in ipairs(Islands) do
        local islandName = item[1]
        local coords = item[2]

        local TpBtn = Instance.new("TextButton", Scroll)
        TpBtn.Size = UDim2.new(1, -10, 0, 32)
        TpBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
        TpBtn.Text = "TP To: " .. islandName
        TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TpBtn.Font = Enum.Font.SourceSansBold
        TpBtn.TextSize = 13

        TpBtn.MouseButton1Click:Connect(function()
            FastTP(CFrame.new(coords))
        end)
    end

    -- ЗАПУСК ESP ТА ІНШИХ СИСТЕМ
    StartESP()
    StartCombatSystem()
    StartFlySystem()
    StartClickTP()
end
-- ============================================
-- ЧАСТИНА 3: ПОКРАЩЕНИЙ ESP (ВИПРАВЛЕНО)
-- ============================================

local ESPObjects = {}
local ESPLabels = {}

local function GetObjectPosition(obj)
    if not obj then return nil end
    
    -- Якщо це BasePart або Part
    if obj:IsA("BasePart") then
        return obj.Position
    end
    
    -- Якщо це Model
    if obj:IsA("Model") then
        -- Спроба взяти PrimaryPart
        if obj.PrimaryPart then
            return obj.PrimaryPart.Position
        end
        -- Спроба взяти HumanoidRootPart
        local hrp = obj:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:IsA("BasePart") then
            return hrp.Position
        end
        -- Спроба через GetPivot()
        pcall(function()
            local pivot = obj:GetPivot()
            if pivot then
                return pivot.Position
            end
        end)
        -- Остання спроба: шукаємо будь-яку частину
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("BasePart") then
                return child.Position
            end
        end
    end
    
    return nil
end

local function CreateESP(target, color, name, distance)
    if not target or not target.Parent then 
        return nil 
    end
    
    -- Видалення старого ESP
    local oldEsp = target:FindFirstChild("ZenithESP")
    if oldEsp then oldEsp:Destroy() end
    
    -- BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZenithESP"
    billboard.Adornee = target
    billboard.Size = UDim2.new(0, 200, 0, 70)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Parent = target
    
    -- Фон
    local background = Instance.new("Frame", billboard)
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = color
    background.BackgroundTransparency = 0.2
    background.BorderSizePixel = 2
    background.BorderColor3 = color
    
    -- Ім'я
    if _G.ESPShowName then
        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name or "Unknown"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextStrokeTransparency = 0.3
        ESPLabels[name] = nameLabel
    end
    
    -- Відстань
    if _G.ESPShowDistance then
        local distLabel = Instance.new("TextLabel", billboard)
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = distance and tostring(math.floor(distance)) .. "m" or "?"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 12
        distLabel.Font = Enum.Font.SourceSans
        distLabel.TextStrokeTransparency = 0.3
        ESPLabels[name .. "_dist"] = distLabel
    end
    
    -- Highlight (підсвічування)
    local highlight = target:FindFirstChild("ZenithHighlight")
    if highlight then highlight:Destroy() end
    
    highlight = Instance.new("Highlight")
    highlight.Name = "ZenithHighlight"
    highlight.FillColor = color
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0.2
    highlight.Parent = target
    
    ESPObjects[target] = {billboard = billboard, highlight = highlight}
    
    return billboard
end

local function RemoveESP(target)
    if ESPObjects[target] then
        if ESPObjects[target].billboard then 
            ESPObjects[target].billboard:Destroy() 
        end
        if ESPObjects[target].highlight then 
            ESPObjects[target].highlight:Destroy() 
        end
        ESPObjects[target] = nil
    end
    
    local esp = target:FindFirstChild("ZenithESP")
    if esp then esp:Destroy() end
    
    local highlight = target:FindFirstChild("ZenithHighlight")
    if highlight then highlight:Destroy() end
end

local function StartESP()
    task.spawn(function()
        local LocalPlayer = game.Players.LocalPlayer
        
        while true do
            task.wait(_G.ESPUpdateInterval or 0.3)
            
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                continue
            end
            
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            local maxDist = _G.ESPMaxDistance or 500
            
            -- ОЧИЩЕННЯ СТАРИХ ESP (для об'єктів які зникли)
            local toRemove = {}
            for obj, data in pairs(ESPObjects) do
                if not obj or not obj.Parent then
                    toRemove[#toRemove + 1] = obj
                end
            end
            for _, obj in ipairs(toRemove) do
                ESPObjects[obj] = nil
            end
            
            -- 1. ГРАВЦІ
            if _G.ESP_Players then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                        if distance <= maxDist then
                            local color = _G.ESPPlayerColor or Color3.fromRGB(255, 50, 50)
                            local teamColor = player.TeamColor and player.TeamColor.Color
                            if teamColor and player.Team then
                                color = teamColor
                            end
                            local name = _G.ESPShowName and player.Name or "Player"
                            CreateESP(player.Character, color, name, distance)
                        else
                            RemoveESP(player.Character)
                        end
                    end
                end
            end
            
            -- 2. СУНДУКИ ТА ФРУКТИ (ВИПРАВЛЕНО)
            if _G.ESP_Chests or _G.ESP_Fruits then
                pcall(function()
                    for _, obj in pairs(workspace:GetChildren()) do
                        -- Перевірка чи об'єкт все ще існує
                        if not obj or not obj.Parent then 
                            continue 
                        end
                        
                        -- Отримання позиції об'єкта
                        local objPos = GetObjectPosition(obj)
                        if not objPos then 
                            continue 
                        end
                        
                        local objNameLower = obj.Name:lower()
                        local distance = (objPos - myPos).Magnitude
                        
                        if distance <= maxDist then
                            local isChest = _G.ESP_Chests and (
                                objNameLower:find("chest") or 
                                objNameLower:find("box") or 
                                objNameLower:find("crate") or
                                objNameLower:find("supply")
                            )
                            
                            local isFruit = _G.ESP_Fruits and (
                                objNameLower:find("fruit") or 
                                objNameLower:find("devil") or 
                                objNameLower:find("dragon") or
                                objNameLower:find("venom") or
                                objNameLower:find("buddha") or
                                obj:FindFirstChild("Handle") or
                                obj:FindFirstChild("Fruit")
                            )
                            
                            if isChest then
                                CreateESP(obj, _G.ESPChestColor or Color3.fromRGB(255, 215, 0), "📦 " .. obj.Name, distance)
                            elseif isFruit then
                                CreateESP(obj, _G.ESPFruitColor or Color3.fromRGB(200, 50, 255), "🍎 " .. obj.Name, distance)
                            else
                                RemoveESP(obj)
                            end
                        else
                            RemoveESP(obj)
                        end
                    end
                end)
            end
            
            -- 3. ДОДАТКОВЕ ОЧИЩЕННЯ ESP ДЛЯ ЗНИКЛИХ ОБ'ЄКТІВ
            for obj, data in pairs(ESPObjects) do
                if not obj or not obj.Parent then
                    ESPObjects[obj] = nil
                end
            end
        end
    end)
end
-- ============================================
-- ЧАСТИНА 4: БОЙОВА СИСТЕМА, FLY ТА CLICK TP
-- ============================================

local function StartCombatSystem()
    local LocalPlayer = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LastAttackTime = 0
    
    local function AutoEquip()
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
    
    -- ПОКРАЩЕНА АТАКА З АНІМАЦІЇЙ КЕНСЕЛ
    local function Attack()
        AutoEquip()
        if LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                -- Кенсел анімації для швидкої атаки
                if _G.FastAttack then
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        local animTrack = humanoid:FindFirstChild("Animator")
                        if animTrack then
                            for _, track in pairs(animTrack:GetPlayingAnimationTracks()) do
                                track:Stop()
                            end
                        end
                    end
                end
                
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
    
    -- ПОКРАЩЕНИЙ SMART ATTACK
    local function SmartAttack()
        local currentTime = tick()
        if currentTime - LastAttackTime < (_G.AttackSpeed or 0.08) then return end
        LastAttackTime = currentTime
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        local targets = {}
        
        -- Пошук мобів
        if _G.MobAura then
            local enemyFolders = {"Enemies", "Monsters", "Mobs", "NPCs"}
            for _, folderName in ipairs(enemyFolders) do
                local folder = workspace:FindFirstChild(folderName)
                if folder then
                    for _, enemy in pairs(folder:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            local dist = (enemy.HumanoidRootPart.Position - myPos).Magnitude
                            if dist <= _G.AuraDistance then
                                table.insert(targets, {Object = enemy, Distance = dist, Type = "Mob"})
                            end
                        end
                    end
                end
            end
        end
        
        -- Пошук гравців для KillAura
        if _G.KillAura then
            local myClan = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Clan") and LocalPlayer.Data.Clan.Value
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetClan = player:FindFirstChild("Data") and player.Data:FindFirstChild("Clan") and player.Data.Clan.Value
                    local isSameClan = (myClan and targetClan and myClan ~= "" and myClan == targetClan)
                    
                    if not isSameClan and player.Character.Humanoid.Health > 0 then
                        local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                        if dist <= _G.AuraDistance then
                            table.insert(targets, {Object = player.Character, Distance = dist, Type = "Player"})
                        end
                    end
                end
            end
        end
        
        -- Атака найближчої цілі
        if #targets > 0 then
            table.sort(targets, function(a, b) return a.Distance < b.Distance end)
            local target = targets[1]
            local targetPos = target.Object.HumanoidRootPart.Position
            
            FastTP(CFrame.new(targetPos + Vector3.new(0, 0, 3)))
            Attack()
        end
    end
    
    -- ОСНОВНИЙ ЦИКЛ
    task.spawn(function()
        while true do
            task.wait(0.01)
            if (_G.MobAura or _G.KillAura) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                pcall(SmartAttack)
            end
        end
    end)
    
    -- AUTO FARM
    local function GetQuestByLevel()
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
end

-- FLY SYSTEM
local function StartFlySystem()
    local LocalPlayer = game.Players.LocalPlayer
    local FlyControls = {
        Forward = false, Backward = false, Left = false, Right = false,
        Up = false, Down = false
    }
    
    local Keybinds = {
        Fly = Enum.KeyCode.F,
        Forward = Enum.KeyCode.W,
        Backward = Enum.KeyCode.S,
        Left = Enum.KeyCode.A,
        Right = Enum.KeyCode.D,
        Up = Enum.KeyCode.E,
        Down = Enum.KeyCode.Q
    }
    
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
                
                local speed = _G.FlySpeed or 2
                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit * speed
                end
                
                local targetPos = hrp.Position + moveVector
                hrp.CFrame = CFrame.new(targetPos)
                hrp.Velocity = Vector3.new(0, 0, 0)
            end)
        end
    end)
end

-- CLICK TP
local function StartClickTP()
    local LocalPlayer = game.Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    
    Mouse.Button1Down:Connect(function()
        if _G.ClickTP and Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            FastTP(CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)))
        end
    end)
end
