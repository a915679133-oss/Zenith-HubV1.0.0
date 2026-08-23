-- Zenith Utility V1.2 (Full Master Hub)
-- Key System, Fixed Mobile Drag, Auto Farm & New Combat Modules

local CorrectKey = "Eclipse"
local KeyPassed = false

-- ==========================================
-- 1. СИСТЕМА ПРОВЕРКИ КЛЮЧА
-- ==========================================
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

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyPassed = true
        KeyScreen:Destroy()
        
        -- ==========================================
        -- 2. ОСНОВНОЙ ИНТЕРФЕЙС V1.2
        -- ==========================================
        local MainGui = Instance.new("ScreenGui")
        MainGui.Name = "ZenithHubV12"
        MainGui.ResetOnSpawn = false
        MainGui.Parent = game.CoreGui

        local MainFrame = Instance.new("Frame", MainGui)
        MainFrame.Size = UDim2.new(0, 420, 0, 280)
        MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        MainFrame.Active = true

        -- ФИКС ДРАГА ДЛЯ МОБИЛОК (Touch & Mouse Drag)
        local UserInputService = game:GetService("UserInputService")
        local dragging, dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
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
                update(input)
            end
        end)

        local Title = Instance.new("TextLabel", MainFrame)
        Title.Size = UDim2.new(1, 0, 0, 35)
        Title.Text = "Zenith Hub V1.2 | Blox Fruits"
        Title.TextColor3 = Color3.fromRGB(0, 255, 180)
        Title.TextSize = 16
        Title.Font = Enum.Font.SourceSansBold
        Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)

        -- ==========================================
        -- 3. ГЛОБАЛЬНЫЕ НАСТРОЙКИ И ФУНКЦИИ
        -- ==========================================
        _G.AuraDistance = 50
        _G.WeaponType = "Melee" -- "Melee", "Sword", "Blox Fruit"
        _G.MobAura = false
        _G.KillAura = false
        _G.AutoDodge = false
        _G.ClickTP = false
        _G.Fly = false

        local LocalPlayer = game.Players.LocalPlayer

        -- Авто-выбор и взятие оружия
        local function EquipWeapon()
            if LocalPlayer.Character then
                for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.ToolTip == _G.WeaponType or item.Name:find(_G.WeaponType)) then
                        LocalPlayer.Character.Humanoid:EquipTool(item)
                    end
                end
            end
        end

        -- Моб Аура & Килл Аура
        task.spawn(function()
            while task.wait(0.1) do
                if (_G.MobAura or _G.KillAura) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    EquipWeapon()
                    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

                    -- MOB AURA
                    if _G.MobAura and workspace:FindFirstChild("Enemies") then
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                local dist = (enemy.HumanoidRootPart.Position - myPos).Magnitude
                                if dist <= _G.AuraDistance then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                                end
                            end
                        end
                    end

                    -- KILL AURA (Игнорирует клан)
                    if _G.KillAura then
                        for _, p in pairs(game.Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local myClan = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Clan") and LocalPlayer.Data.Clan.Value
                                local targetClan = p:FindFirstChild("Data") and p.Data:FindFirstChild("Clan") and p.Data.Clan.Value
                                local isSameClan = (myClan and targetClan and myClan ~= "" and myClan == targetClan)

                                if not isSameClan then
                                    local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                                    if dist <= _G.AuraDistance then
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        -- AUTO DODGE
        task.spawn(function()
            while task.wait(0.3) do
                if _G.AutoDodge then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Dodge")
                    end)
                end
            end
        end)

        -- CLICK TP (Телепорт по тапу/клику)
        local Mouse = LocalPlayer:GetMouse()
        Mouse.Button1Down:Connect(function()
            if _G.ClickTP and Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)

        print("Zenith Hub V1.2 is fully active!")
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
    end
end)
