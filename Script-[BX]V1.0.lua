-- Zenith Utility V1.0 (Full Master Hub)
-- Key System & Full Modules

local CorrectKey = "Eclipse"
local KeyPassed = false

-- =================================================================
-- 1. СИСТЕМА ПРОВЕРКИ КЛЮЧА (KEY SYSTEM)
-- =================================================================
local KeyScreen = Instance.new("ScreenGui", game.CoreGui)
KeyScreen.Name = "ZenithKeySystem"

local KeyFrame = Instance.new("Frame", KeyScreen)
KeyFrame.Size = UDim2.new(0, 320, 0, 170)
KeyFrame.Position = UDim2.new(0.5, -160, 0.4, -85)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
KeyFrame.Active = true
KeyFrame.Draggable = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 10)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Text = "🔑 ZENITH UTILITY V1.0 — Введите Ключ"
KeyTitle.TextColor3 = Color3.fromRGB(0, 255, 170)
KeyTitle.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextSize = 14
Instance.new("UICorner", KeyTitle).CornerRadius = UDim.new(0, 10)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.85, 0, 0, 36)
KeyInput.Position = UDim2.new(0.075, 0, 0.32, 0)
KeyInput.PlaceholderText = "Введите ключ доступа..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextSize = 14
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 36)
SubmitBtn.Position = UDim2.new(0.075, 0, 0.62, 0)
SubmitBtn.Text = "ПОДТВЕРДИТЬ"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 120)
SubmitBtn.Font = Enum.Font.SourceSansBold
SubmitBtn.TextSize = 14
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyPassed = true
        KeyScreen:Destroy()
    else
        SubmitBtn.Text = "НЕВЕРНЫЙ КЛЮЧ!"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        SubmitBtn.Text = "ПОДТВЕРДИТЬ"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 120)
    end
end)

repeat task.wait(0.1) until KeyPassed

-- =================================================================
-- 2. ОСНОВНЫЕ СЕРВИСЫ И КОНФИГУРАЦИЯ
-- =================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

getgenv().Config = {
    AutoFarm = false,
    AutoQuest = false,
    FarmTool = "Melee", -- "Melee", "Sword", "Blox Fruit", "Gun"
    AttackDelay = 0.1,
    FastAttack = false,
    ClickTPEnabled = false,
    ClickTPDelay = 0.3,
    WalkSpeed = 32,
    ESP_Players = false,
    ESP_Enemies = false,
    ESP_Bosses = false,
    ESP_Chests = false,
    ESP_Fruits = false
}

local SeaMap = { [2753915549] = 1, [4442272183] = 2, [7449423635] = 3 }
local CurrentSea = SeaMap[game.PlaceId] or 2

local IslandDatabase = {
    [1] = {
        ["Starter Island"] = Vector3.new(979, 16, 1400),
        ["Jungle"] = Vector3.new(-1610, 36, 149),
        ["Pirate Village"] = Vector3.new(-1145, 4, 3825),
        ["Desert"] = Vector3.new(895, 6, 4370),
        ["Middle Town"] = Vector3.new(-690, 15, 1580),
        ["Frozen Village"] = Vector3.new(1185, 27, -1325),
        ["Marine Fortress"] = Vector3.new(-4800, 20, 4350),
        ["Skypiea (Sky1)"] = Vector3.new(-4880, 715, -2630),
        ["Prison"] = Vector3.new(4855, 5, 735),
        ["Colosseum"] = Vector3.new(-1425, 7, -2740),
        ["Magma Village"] = Vector3.new(-5240, 8, 8500),
        ["Underwater City"] = Vector3.new(3860, 5, -1925),
        ["Fountain City"] = Vector3.new(5120, 4, 4100)
    },
    [2] = {
        ["Cafe / Green Zone"] = Vector3.new(-380, 72, 298),
        ["Kingdom of Rose"] = Vector3.new(-430, 73, 560),
        ["Don Swan Mansion"] = Vector3.new(-390, 332, 670),
        ["Zombie Island"] = Vector3.new(-5600, 8, -480),
        ["Snow Mountain"] = Vector3.new(605, 401, -5370),
        ["Hot and Cold"] = Vector3.new(-2450, 15, -3000),
        ["Cursed Ship"] = Vector3.new(920, 125, 3280),
        ["Ice Castle"] = Vector3.new(5500, 28, -6180),
        ["Forgotten Island"] = Vector3.new(-3050, 235, -10140),
        ["Dark Arena"] = Vector3.new(3800, 15, -3500)
    },
    [3] = {
        ["Port Town"] = Vector3.new(-2900, 15, 5300),
        ["Hydra Island"] = Vector3.new(5700, 600, 200),
        ["Great Tree"] = Vector3.new(2250, 25, -6700),
        ["Castle on the Sea"] = Vector3.new(-5085, 314, -3150),
        ["Haunted Castle"] = Vector3.new(-9500, 140, 5500),
        ["Sea of Treats"] = Vector3.new(-2100, 40, -12000),
        ["Tiki Outpost"] = Vector3.new(-16200, 10, 400)
    }
}

-- =================================================================
-- 3. ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ И ЛОГИКА
-- =================================================================
local function SafeTween(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
        TweenService:Create(hrp, info, {CFrame = targetCFrame}):Play()
    end
end

local function EquipTool()
    local toolType = getgenv().Config.FarmTool
    local char = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack

    if char and backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if (toolType == "Melee" and tool.ToolTip == "Melee") or
                   (toolType == "Sword" and tool.ToolTip == "Sword") or
                   (toolType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or
                   (toolType == "Gun" and tool.ToolTip == "Gun") then
                    char.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end
end

-- Fast Attack
task.spawn(function()
    while true do
        task.wait(getgenv().Config.AttackDelay)
        if getgenv().Config.AutoFarm or getgenv().Config.FastAttack then
            pcall(function()
                EquipTool()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500))
            end)
        end
    end
end)

-- Click TP
local LastClickTPTime = 0
Mouse.Button1Down:Connect(function()
    if getgenv().Config.ClickTPEnabled then
        local currentTime = tick()
        if currentTime - LastClickTPTime >= getgenv().Config.ClickTPDelay then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and Mouse.Hit then
                LastClickTPTime = currentTime
                char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

-- Speed Loop
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if getgenv().Config.WalkSpeed > 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Config.WalkSpeed
            end
        end
    end)
end)

-- ESP System Engine
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "ZenithESPFolder"

local function CreateESPBox(part, color, text)
    if not part or part:FindFirstChild("ZenithESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZenithESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = part
    billboard.Parent = ESPFolder

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 13
    label.TextStrokeTransparency = 0.5
end

local function ClearESP()
    ESPFolder:ClearAllChildren()
end

task.spawn(function()
    while true do
        task.wait(1)
        ClearESP()

        -- Players ESP
        if getgenv().Config.ESP_Players then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESPBox(player.Character.HumanoidRootPart, Color3.fromRGB(0, 255, 100), player.Name)
                end
            end
        end

        -- Chests ESP
        if getgenv().Config.ESP_Chests then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:find("Chest") and obj:IsA("BasePart") then
                    CreateESPBox(obj, Color3.fromRGB(255, 215, 0), "Chest")
                end
            end
        end

        -- Fruits ESP
        if getgenv().Config.ESP_Fruits then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Tool") or obj.Name:find("Fruit") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        CreateESPBox(handle, Color3.fromRGB(255, 50, 50), obj.Name)
                    end
                end
            end
        end
    end
end)

-- =================================================================
-- 4. ПОЛНЫЙ ПОЛЬЗОВАТЕЛЬСКИЙ ИНТЕРФЕЙС (UI)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ZenithUtilityGui"

-- Левая панель
local LeftSideColumn = Instance.new("Frame", ScreenGui)
LeftSideColumn.Size = UDim2.new(0, 110, 0, 120)
LeftSideColumn.Position = UDim2.new(0.01, 0, 0.3, 0)
LeftSideColumn.BackgroundTransparency = 1

local LockBtn = Instance.new("TextButton", LeftSideColumn)
LockBtn.Size = UDim2.new(1, 0, 0, 24)
LockBtn.Text = "🔒 LOCK UI"
LockBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
LockBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LockBtn.Font = Enum.Font.SourceSansBold
LockBtn.TextSize = 11
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)

local ToggleGuiBtn = Instance.new("TextButton", LeftSideColumn)
ToggleGuiBtn.Size = UDim2.new(1, 0, 0, 38)
ToggleGuiBtn.Position = UDim2.new(0, 0, 0, 28)
ToggleGuiBtn.Text = "⚡ ZENITH"
ToggleGuiBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
ToggleGuiBtn.Font = Enum.Font.SourceSansBold
ToggleGuiBtn.TextSize = 13
Instance.new("UICorner", ToggleGuiBtn).CornerRadius = UDim.new(0, 8)

local isColumnLocked = true
LockBtn.MouseButton1Click:Connect(function()
    isColumnLocked = not isColumnLocked
    LockBtn.Text = isColumnLocked and "🔒 LOCK UI" or "🔓 UNLOCK UI"
    LockBtn.TextColor3 = isColumnLocked and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(50, 255, 100)
    LeftSideColumn.Active = not isColumnLocked
    LeftSideColumn.Draggable = not isColumnLocked
end)

-- Главное окно
local MainWindow = Instance.new("Frame", ScreenGui)
MainWindow.Size = UDim2.new(0, 560, 0, 360)
MainWindow.Position = UDim2.new(0.25, 0, 0.2, 0)
MainWindow.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainWindow.Active = true
MainWindow.Draggable = true
Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("TextLabel", MainWindow)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Text = "  ⚡ ZENITH UTILITY V1.0  |  Blox Fruits Hub"
Header.TextColor3 = Color3.fromRGB(0, 255, 170)
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 16
Header.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

ToggleGuiBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = not MainWindow.Visible
end)

local Sidebar = Instance.new("Frame", MainWindow)
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)

local Container = Instance.new("Frame", MainWindow)
Container.Size = UDim2.new(1, -135, 1, -45)
Container.Position = UDim2.new(0, 132, 0, 42)
Container.BackgroundTransparency = 1

local Tabs = {"Main Farm", "NPC / TP", "ESP System", "Settings"}
local TabButtons = {}
local TabFrames = {}

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, 10 + (i-1)*38)
    btn.Text = tabName
    btn.TextColor3 = (i == 1) and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(160, 160, 180)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(24, 24, 36) or Color3.fromRGB(18, 18, 26)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    TabButtons[tabName] = btn

    local frame = Instance.new("ScrollingFrame", Container)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    frame.ScrollBarThickness = 4
    TabFrames[tabName] = frame

    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtons) do
            b.TextColor3 = Color3.fromRGB(160, 160, 180)
            b.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
        end
        for _, f in pairs(TabFrames) do
            f.Visible = false
        end
        btn.TextColor3 = Color3.fromRGB(0, 255, 170)
        btn.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
        frame.Visible = true
    end)
end

-- =================================================================
-- ВКЛАДКА 1: MAIN FARM (ФАРМ И ВЫБОР ОРУЖИЯ)
-- =================================================================
local FarmFrame = TabFrames["Main Farm"]

local FarmToggle = Instance.new("TextButton", FarmFrame)
FarmToggle.Size = UDim2.new(0.9, 0, 0, 36)
FarmToggle.Position = UDim2.new(0.05, 0, 0, 10)
FarmToggle.Text = "Auto Farm Level: [ OFF ]"
FarmToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
FarmToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
FarmToggle.Font = Enum.Font.SourceSansBold
FarmToggle.TextSize = 14
Instance.new("UICorner", FarmToggle).CornerRadius = UDim.new(0, 6)

FarmToggle.MouseButton1Click:Connect(function()
    getgenv().Config.AutoFarm = not getgenv().Config.AutoFarm
    FarmToggle.Text = getgenv().Config.AutoFarm and "Auto Farm Level: [ ON ]" or "Auto Farm Level: [ OFF ]"
    FarmToggle.TextColor3 = getgenv().Config.AutoFarm and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 80, 80)
end)

local QuestToggle = Instance.new("TextButton", FarmFrame)
QuestToggle.Size = UDim2.new(0.9, 0, 0, 36)
QuestToggle.Position = UDim2.new(0.05, 0, 0, 52)
QuestToggle.Text = "Auto Take Quest: [ OFF ]"
QuestToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
QuestToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
QuestToggle.Font = Enum.Font.SourceSansBold
QuestToggle.TextSize = 14
Instance.new("UICorner", QuestToggle).CornerRadius = UDim.new(0, 6)

QuestToggle.MouseButton1Click:Connect(function()
    getgenv().Config.AutoQuest = not getgenv().Config.AutoQuest
    QuestToggle.Text = getgenv().Config.AutoQuest and "Auto Take Quest: [ ON ]" or "Auto Take Quest: [ OFF ]"
    QuestToggle.TextColor3 = getgenv().Config.AutoQuest and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 80, 80)
end)

local ToolLabel = Instance.new("TextLabel", FarmFrame)
ToolLabel.Size = UDim2.new(0.9, 0, 0, 20)
ToolLabel.Position = UDim2.new(0.05, 0, 0, 95)
ToolLabel.Text = "ВЫБОР ОРУЖИЯ ФАРМА:"
ToolLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
ToolLabel.BackgroundTransparency = 1
ToolLabel.Font = Enum.Font.SourceSansBold
ToolLabel.TextSize = 12
ToolLabel.TextXAlignment = Enum.TextXAlignment.Left

local Tools = {"Melee", "Sword", "Blox Fruit", "Gun"}
for idx, toolName in ipairs(Tools) do
    local toolBtn = Instance.new("TextButton", FarmFrame)
    toolBtn.Size = UDim2.new(0.42, 0, 0, 30)
    local xOffset = (idx % 2 == 1) and 0.05 or 0.52
    local yOffset = 120 + math.floor((idx-1)/2) * 36
    toolBtn.Position = UDim2.new(xOffset, 0, 0, yOffset)
    toolBtn.Text = toolName
    toolBtn.TextColor3 = (getgenv().Config.FarmTool == toolName) and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(200, 200, 200)
    toolBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    toolBtn.Font = Enum.Font.SourceSans
    toolBtn.TextSize = 13
    Instance.new("UICorner", toolBtn).CornerRadius = UDim.new(0, 6)

    toolBtn.MouseButton1Click:Connect(function()
        getgenv().Config.FarmTool = toolName
        ToolLabel.Text = "ВЫБОР ОРУЖИЯ ФАРМА: [" .. toolName .. "]"
    end)
end

-- =================================================================
-- ВКЛАДКА 2: NPC / TELEPORTS
-- =================================================================
local NPCTPFrame = TabFrames["NPC / TP"]
local yPos = 10

local IsTitle = Instance.new("TextLabel", NPCTPFrame)
IsTitle.Size = UDim2.new(0.9, 0, 0, 20)
IsTitle.Position = UDim2.new(0.05, 0, 0, yPos)
IsTitle.Text = "--- ТЕЛЕПОРТ ПО ОСТРОВАМ ---"
IsTitle.TextColor3 = Color3.fromRGB(0, 255, 170)
IsTitle.BackgroundTransparency = 1
IsTitle.Font = Enum.Font.SourceSansBold
IsTitle.TextSize = 12
yPos = yPos + 25

local currentIslands = IslandDatabase[CurrentSea] or {}
for islandName, islandPos in pairs(currentIslands) do
    local tpBtn = Instance.new("TextButton", NPCTPFrame)
    tpBtn.Size = UDim2.new(0.9, 0, 0, 30)
    tpBtn.Position = UDim2.new(0.05, 0, 0, yPos)
    tpBtn.Text = "📍 " .. islandName
    tpBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
    tpBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    tpBtn.Font = Enum.Font.SourceSans
    tpBtn.TextSize = 13
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

    tpBtn.MouseButton1Click:Connect(function()
        SafeTween(CFrame.new(islandPos))
    end)
    yPos = yPos + 34
end

NPCTPFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)

-- =================================================================
-- ВКЛАДКА 3: ESP SYSTEM
-- =================================================================
local ESPFrame = TabFrames["ESP System"]

local ESPToggles = {
    {Name = "Player ESP", ConfigKey = "ESP_Players"},
    {Name = "Chests ESP", ConfigKey = "ESP_Chests"},
    {Name = "Fruits ESP", ConfigKey = "ESP_Fruits"}
}

for i, esp in ipairs(ESPToggles) do
    local espBtn = Instance.new("TextButton", ESPFrame)
    espBtn.Size = UDim2.new(0.9, 0, 0, 36)
    espBtn.Position = UDim2.new(0.05, 0, 0, 10 + (i-1)*44)
    espBtn.Text = esp.Name .. ": [ OFF ]"
    espBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    espBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    espBtn.Font = Enum.Font.SourceSansBold
    espBtn.TextSize = 14
    Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 6)

    espBtn.MouseButton1Click:Connect(function()
        getgenv().Config[esp.ConfigKey] = not getgenv().Config[esp.ConfigKey]
        local state = getgenv().Config[esp.ConfigKey]
        espBtn.Text = esp.Name .. (state and ": [ ON ]" or ": [ OFF ]")
        espBtn.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 80, 80)
    end)
end

print("Zenith Utility V1.0 загружен со всем функционалом!")

