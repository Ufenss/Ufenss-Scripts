local Players = game.Players local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService")
local player = Players.LocalPlayer local mouse = player:GetMouse() local camera = workspace.CurrentCamera
local selectedTarget = nil local lockEnabled = false
-- GUI oluşturma local screenGui = Instance.new("ScreenGui") screenGui.Name = "UfenssHub" screenGui.ResetOnSpawn = false screenGui.Parent = game.CoreGui
local mainFrame = Instance.new("Frame") mainFrame.Size = UDim2.new(0, 170, 0, 55) mainFrame.Position = UDim2.new(1, -180, 1, -65) mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) mainFrame.BorderSizePixel = 0 mainFrame.Parent = screenGui
local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 8) corner.Parent = mainFrame
local titleLabel = Instance.new("TextLabel") titleLabel.Size = UDim2.new(1, 0, 0, 22) titleLabel.BackgroundTransparency = 1 titleLabel.Text = "Ufenss HUB" titleLabel.TextColor3 = Color3.fromRGB(170, 90, 255) titleLabel.TextSize = 17 titleLabel.Font = Enum.Font.GothamBold titleLabel.Parent = mainFrame
local infoLabel = Instance.new("TextLabel") infoLabel.Size = UDim2.new(1, 0, 0, 28) infoLabel.Position = UDim2.new(0, 0, 0, 22) infoLabel.BackgroundTransparency = 1 infoLabel.Text = "T → TP | L → LOCK" infoLabel.TextColor3 = Color3.fromRGB(210, 210, 230) infoLabel.TextSize = 13 infoLabel.Font = Enum.Font.Gotham infoLabel.Parent = mainFrame
-- ─── SÜRÜKLEME SİSTEMİ ────────────────────────────────────────
local dragging = false local dragStart = nil local startPos = nil
local function updateInput(input) if not dragging then return end
    local delta = input.Position - dragStart local newPositionX = startPos.X.Offset + delta.X local newPositionY = startPos.Y.Offset + delta.Y
    mainFrame.Position = UDim2.new( startPos.X.Scale, newPositionX, startPos.Y.Scale, newPositionY ) end
titleLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then updateInput(input) end end)
-- ─── MEVCUT FONKSİYONLAR ──────────────────────────────────────
local function getClosestPlayerToMouse() local closest = nil local minDist = 160
    for _, plr in Players:GetPlayers() do if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then local root = plr.Character.HumanoidRootPart local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen then local mousePos = Vector2.new(mouse.X, mouse.Y) local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if distance < minDist then minDist = distance closest = plr end end end end
    return closest end
UserInputService.InputBegan:Connect(function(input, gameProcessed) if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T then if mouse.Hit then local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = mouse.Hit + Vector3.new(0, 3, 0) end end
    elseif input.KeyCode == Enum.KeyCode.L then lockEnabled = not lockEnabled
        if lockEnabled then selectedTarget = getClosestPlayerToMouse() if selectedTarget then infoLabel.Text = "T → TP | L → LOCK (AKTİF)" infoLabel.TextColor3 = Color3.fromRGB(90, 255, 130) else lockEnabled = false infoLabel.Text = "T → TP | L → LOCK" infoLabel.TextColor3 = Color3.fromRGB(210, 210, 230) end else selectedTarget = nil infoLabel.Text = "T → TP | L → LOCK" infoLabel.TextColor3 = Color3.fromRGB(210, 210, 230) end end end)
RunService.RenderStepped:Connect(function() if lockEnabled and selectedTarget and selectedTarget.Character then local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart") if targetRoot then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position + Vector3.new(0, 1.5, 0)) else lockEnabled = false selectedTarget = nil infoLabel.Text = "T → TP | L → LOCK" infoLabel.TextColor3 = Color3.fromRGB(210, 210, 230) end end end)