-- Zenith Utility V1.2 (Full GUI + Mobile Touch Slider)
-- Key System, Mobile Drag, Dynamic Slider (25-75 studs)

local CorrectKey = "Eclipse"

-- 1. СИСТЕМА КЛЮЧА
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
        KeyScreen:Destroy()
        
        -- 2. ОСНОВНОЙ ГРАФИЧЕСКИЙ ИНТЕРФЕЙС
        local MainGui = Instance.new("ScreenGui")
        MainGui.Name = "ZenithHubV12"
        MainGui.ResetOnSpawn = false
        MainGui.Parent = game.CoreGui

        local MainFrame = Instance.new("Frame", MainGui)
        MainFrame.Size = UDim2.new(0, 420, 0, 280)
        MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        MainFrame.Active = true

        -- КНОПКА СВОРАЧИВАНИЯ (TOGGLE BUTTON "Z")
        local OpenBtn = Instance.new("TextButton", MainGui)
        OpenBtn.Size = UDim2.new(0, 50, 0, 50)
        OpenBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
        OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
        OpenBtn.Text = "Z"
        OpenBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
        OpenBtn.TextSize = 22
        OpenBtn.Font = Enum.Font.SourceSansBold
        OpenBtn.Active = true
        OpenBtn.Draggable = true

        local UICorner = Instance.new("UICorner", OpenBtn)
        UICorner.CornerRadius = UDim.new(1, 0)

        OpenBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
        end)

        -- МОБИЛЬНЫЙ ДРАГ ОКНА
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
        Title.Text = "Zenith Hub V1.2 | Blox Fruits"
        Title.TextColor3 = Color3.fromRGB(0, 255, 180)
        Title.TextSize = 16
        Title.Font = Enum.Font.SourceSansBold
        Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)

        -- СПИСОК ФУНКЦИЙ
        local Scroll = Instance.new("ScrollingFrame", MainFrame)
        Scroll.Size = UDim2.new(1, -10, 1, -45)
        Scroll.Position = UDim2.new(0, 5, 0, 40)
        Scroll.BackgroundTransparency = 1
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 350)
        Scroll.ScrollBarThickness = 4

        local UIList = Instance.new("UIListLayout", Scroll)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Padding = UDim.new(0, 8)

        -- НАСТРОЙКИ
        _G.AuraDistance = 50
        _G.MobAura = false
        _G.KillAura = false
        _G.AutoDodge = false
        _G.ClickTP = false

        -- TOGGLES (Переключатели)
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

        CreateToggle("Mob Aura (NPCs & Bosses)", "MobAura")
        CreateToggle("Kill Aura (Players - Clan Safe)", "KillAura")
        CreateToggle("Auto Dodge", "AutoDodge")
        CreateToggle("Click TP", "ClickTP")

        -- ==========================================
        -- МОБИЛЬНЫЙ СЛАЙДЕР ДИСТАНЦИИ (25-75 STUDS)
        -- ==========================================
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
        Fill.Size = UDim2.new(0.5, 0, 1, 0) -- 50% по умолчанию (50 studs)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 180)

        local SliderBtn = Instance.new("TextButton", Track)
        SliderBtn.Size = UDim2.new(1, 0, 1, 0)
        SliderBtn.BackgroundTransparency = 1
        SliderBtn.Text = ""

        local isSliding = false

        local function UpdateSlider(input)
            local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(25 + (pos * 50)) -- От 25 до 75 studs
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

        -- ЛОГИКА АТАКИ И АУРЫ
        local LocalPlayer = game.Players.LocalPlayer
        task.spawn(function()
            while task.wait(0.1) do
                if (_G.MobAura or _G.KillAura) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

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

        -- CLICK TP
        local Mouse = LocalPlayer:GetMouse()
        Mouse.Button1Down:Connect(function()
            if _G.ClickTP and Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
    end
end)
