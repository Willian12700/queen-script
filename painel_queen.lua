--[[
    Queen script - Versão 17.1 (Correção de Sintaxe)
    - Corrigido um erro de sintaxe na criação do botão "BASE" que impedia
      o script inteiro de ser executado.
    - Todas as funcionalidades, incluindo o novo ESP de Caixas, devem agora
      funcionar como esperado.
]]

-- ==================== VARIÁVEIS E SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== TABELA DE ESTILOS ====================
local Style = { Font = { Title = Enum.Font.SourceSansBold, Subtitle = Enum.Font.SourceSans, Button = Enum.Font.SourceSansBold }, TextSize = { Title = 22, Subtitle = 16, Button = 18 }, Color = { Background = Color3.fromRGB(30, 30, 30), Main = Color3.fromRGB(200, 20, 40), MainActive = Color3.fromRGB(120, 30, 40), Text = Color3.fromRGB(255, 255, 255), ButtonWhite = Color3.fromRGB(242, 242, 242), ButtonWhiteActive = Color3.fromRGB(200, 200, 200), ButtonWhiteText = Color3.fromRGB(0, 0, 0), Success = Color3.fromRGB(30, 180, 60), Neutral = Color3.fromRGB(90, 90, 90) }, Size = { MainPanel = UDim2.new(0, 240, 0, 340), SecPanel = UDim2.new(0, 240, 0, 200), Button = UDim2.new(0, 200, 0, 32) } }

-- ==================== ESTADO DAS FUNÇÕES ====================
local state = { esp_god = false, esp_secret = false, esp_base = false, esp_player = false, is_sec_panel_open = false, instant_steal_secundario = false, aimbot_teia = false, auto_kick = false, fly_platform = false }

-- ==================== FUNÇÕES UTILITÁRIAS DE UI ====================
local function makeDraggable(guiObject) local dragging, dragStart, startPos = false, nil, nil; guiObject.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, guiObject.Parent.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); UserInputService.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local delta = input.Position - dragStart; guiObject.Parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end
local function makeDraggableWithSnap(draggableObject) local dragging, dragStart, startPos = false, nil, nil; draggableObject.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, draggableObject.Position; local connection; connection = input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging, connection = false, connection:Disconnect(); local screen, screenSize, objectSize, currentPos = draggableObject.Parent, draggableObject.Parent.AbsoluteSize, draggableObject.AbsoluteSize, draggableObject.AbsolutePosition; local padding, targetX, targetY = 10; if (currentPos.X + objectSize.X / 2) < (screenSize.X / 2) then targetX = padding else targetX = screenSize.X - objectSize.X - padding end; if (currentPos.Y + objectSize.Y / 2) < (screenSize.Y / 2) then targetY = padding else targetY = screenSize.Y - objectSize.Y - padding end; local tween = TweenService:Create(draggableObject, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, targetX, 0, targetY)}); tween:Play() end end) end end); UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; draggableObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end

-- ==================== CRIAÇÃO DA UI ====================
local gui = Instance.new("ScreenGui", playerGui); gui.Name = "PainelMiranda"; gui.ResetOnSpawn = false
local logoContainer = Instance.new("Frame", gui); logoContainer.Size = UDim2.new(0, 60, 0, 60); logoContainer.Position = UDim2.new(0, 20, 0, 250); logoContainer.BackgroundTransparency = 1
local logoButton = Instance.new("ImageButton", logoContainer); logoButton.Size = UDim2.new(1, 0, 1, 0); logoButton.Image = "rbxassetid://COLE_O_ID_DA_SUA_IMAGEM_AQUI"; logoButton.BackgroundColor3 = Color3.fromRGB(10, 150, 10); logoButton.BackgroundTransparency = 0 
local corner = Instance.new("UICorner", logoButton); corner.CornerRadius = UDim.new(0.5, 0); makeDraggableWithSnap(logoContainer)
local main = Instance.new("Frame", gui); main.Name = "MainPanel"; main.BackgroundColor3 = Style.Color.Background; main.Size = Style.Size.MainPanel; main.Position = UDim2.new(0.5, -120, 0.5, -170); main.BorderSizePixel = 0; main.Visible = false
local mainContent = Instance.new("Frame", main); mainContent.Name = "Content"; mainContent.BackgroundTransparency = 1; mainContent.Size = UDim2.new(1, 0, 1, 0)
local titleBar = Instance.new("TextLabel", main); titleBar.Text = "Queen script"; titleBar.Position = UDim2.new(0, 0, 0, 10); titleBar.Size = UDim2.new(1, 0, 0, 30); titleBar.BackgroundTransparency = 1; titleBar.TextColor3 = Style.Color.Text; titleBar.Font = Style.Font.Title; titleBar.TextSize = Style.TextSize.Title; makeDraggable(titleBar)
local subtitle = Instance.new("TextLabel", mainContent); subtitle.Text = "TIKTOK: @mirandacalliruim"; subtitle.Position = UDim2.new(0, 0, 0, 40); subtitle.Size = UDim2.new(1, 0, 0, 20); subtitle.BackgroundTransparency = 1; subtitle.TextColor3 = Style.Color.Text; subtitle.Font = Style.Font.Subtitle; subtitle.TextSize = Style.TextSize.Subtitle
local sec = Instance.new("Frame", gui); sec.Name = "SecPanel"; sec.BackgroundColor3 = Style.Color.Background; sec.Size = Style.Size.SecPanel; sec.Position = UDim2.new(0.5, -120, 0.5, -100); sec.BorderSizePixel = 0; sec.Visible = false
local secTitle = Instance.new("TextLabel", sec); secTitle.Text = "INSTANT STEAL"; secTitle.Position = UDim2.new(0, 0, 0, 10); secTitle.Size = UDim2.new(1, 0, 0, 30); secTitle.BackgroundTransparency = 1; secTitle.TextColor3 = Style.Color.Text; secTitle.Font = Style.Font.Title; secTitle.TextSize = Style.TextSize.Title; makeDraggable(secTitle)
local secPanelToggleButton; local function createToggleButton(props) local btn = Instance.new("TextButton"); btn.Parent, btn.Text, btn.Position, btn.Size, btn.Font, btn.TextSize, btn.TextColor3, btn.BorderSizePixel = props.Parent, props.Text, props.Position, props.Size or Style.Size.Button, Style.Font.Button, Style.TextSize.Button, props.TextColor or Style.Color.Text, 0; local stateKey, onColor, offColor = props.StateKey, props.OnColor or Style.Color.MainActive, props.OffColor or Style.Color.Main; local function updateVisuals() local isActive = state[stateKey]; btn.BackgroundColor3 = isActive and onColor or offColor; if props.UpdateText then btn.Text = (props.Text or "") .. (isActive and ": ON" or ": OFF") end end; btn.MouseButton1Click:Connect(function() state[stateKey] = not state[stateKey]; updateVisuals(); if props.Callback then props.Callback(state[stateKey]) end end); updateVisuals(); return btn end
local btn_y_start, btn_y_offset = 70, 36; local mainButtons = { {Text = "ESP GOD", Key = "esp_god"}, {Text = "ESP SECRET", Key = "esp_secret"}, {Text = "ESP BASE", Key = "esp_base"}, {Text = "ESP PLAYER", Key = "esp_player"}, {Text = "Plataforma Voadora", Key = "fly_platform"} }
for i, btnData in ipairs(mainButtons) do createToggleButton({ Parent = mainContent, Text = btnData.Text, StateKey = btnData.Key, Position = UDim2.new(0, 20, 0, btn_y_start + (i - 1) * btn_y_offset) }) end
secPanelToggleButton = createToggleButton({ Parent = mainContent, Text = "Miranda Insta Steal", StateKey = "is_sec_panel_open", Position = UDim2.new(0, 20, 0, btn_y_start + #mainButtons * btn_y_offset), Callback = function(isActive) sec.Visible = isActive end })
createToggleButton({ Parent = sec, Text = "Instant Steal", StateKey = "instant_steal_secundario", UpdateText = true, Position = UDim2.new(0, 20, 0, 50), Size = UDim2.new(0, 200, 0, 34) }); createToggleButton({ Parent = sec, Text = "Aimbot Teia", StateKey = "aimbot_teia", Position = UDim2.new(0, 20, 0, 90), OnColor = Style.Color.ButtonWhiteActive, OffColor = Style.Color.ButtonWhite, TextColor = Style.Color.ButtonWhiteText })
local ak_label = Instance.new("TextLabel", sec); ak_label.Text = "AUTO KICK"; ak_label.Position = UDim2.new(0, 20, 0, 133); ak_label.Size = UDim2.new(0, 100, 0, 26); ak_label.BackgroundTransparency = 1; ak_label.TextColor3 = Style.Color.Text; ak_label.Font = Style.Font.Subtitle; ak_label.TextSize = Style.TextSize.Subtitle
local autoKickBtn = createToggleButton({ Parent = sec, Text = "OFF", StateKey = "auto_kick", Position = UDim2.new(0, 120, 0, 133), Size = UDim2.new(0, 60, 0, 26), OnColor = Style.Color.Success, OffColor = Style.Color.Neutral }); autoKickBtn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function() autoKickBtn.Text = state.auto_kick and "ON" or "OFF" end)

-- [!] CÓDIGO CORRIGIDO
local returnButton = Instance.new("TextButton", gui)
returnButton.Size = UDim2.new(0, 80, 0, 80)
returnButton.Position = UDim2.new(1, -100, 1, -180)
returnButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
returnButton.TextColor3 = Color3.new(1, 1, 1)
returnButton.Text = "BASE"
returnButton.Font = Enum.Font.SourceSansBold
returnButton.TextSize = 24
returnButton.Visible = false
local rbCorner = Instance.new("UICorner", returnButton); rbCorner.CornerRadius = UDim.new(0.5, 0)
local function teleportToBase() local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end; local plots = Workspace:FindFirstChild("Plots") or Workspace; local base = plots:FindFirstChild(LocalPlayer.Name); if base and base.PrimaryPart then hrp.CFrame = base.PrimaryPart.CFrame * CFrame.new(0, 5, 0) else warn("Base não encontrada.") end end
returnButton.MouseButton1Click:Connect(teleportToBase)
-- FIM DA CORREÇÃO

-- ==================== LÓGICA DO ESP DE JOGADOR ====================
local playerEspInstances = {}; local function criarEspParaJogador(player) if not player.Character or not player.Character:FindFirstChild("Head") then return end; local head = player.Character.Head; if playerEspInstances[player] then playerEspInstances[player]:Destroy() end; local espGui = Instance.new("BillboardGui"); espGui.Name, espGui.AlwaysOnTop, espGui.Size, espGui.MaxDistance, espGui.Adornee, espGui.StudsOffset, espGui.Enabled = "PlayerEspGui", true, UDim2.new(0, 150, 0, 70), math.huge, head, Vector3.new(0, 2.5, 0), false; local layout = Instance.new("UIListLayout", espGui); layout.SortOrder, layout.HorizontalAlignment, layout.Padding = Enum.SortOrder.LayoutOrder, Enum.HorizontalAlignment.Center, UDim.new(0, -5); local nameLabel = Instance.new("TextLabel", espGui); nameLabel.LayoutOrder, nameLabel.BackgroundTransparency, nameLabel.Size, nameLabel.Text, nameLabel.Font, nameLabel.TextColor3, nameLabel.TextSize, nameLabel.TextStrokeTransparency = 1, 1, UDim2.new(1, 0, 0, 20), player.Name, Enum.Font.SourceSans, Color3.new(1, 1, 1), 18, 0.5; local xLabel = Instance.new("TextLabel", espGui); xLabel.LayoutOrder, xLabel.BackgroundTransparency, xLabel.Size, xLabel.Text, xLabel.Font, xLabel.TextColor3, xLabel.TextSize, xLabel.TextStrokeTransparency = 2, 1, UDim2.new(1, 0, 0, 40), "X", Enum.Font.SourceSansBold, Color3.fromRGB(0, 255, 0), 40, 0; espGui.Parent, playerEspInstances[player] = head, espGui end
local function setupJogador(player) if player == LocalPlayer then return end; player.CharacterAdded:Connect(function(character) if character:WaitForChild("Head", 10) then criarEspParaJogador(player) end end); if player.Character then criarEspParaJogador(player) end end
for _, player in ipairs(Players:GetPlayers()) do setupJogador(player) end; Players.PlayerAdded:Connect(setupJogador)

-- ==================== LÓGICA DA PLATAFORMA VOADORA ====================
local flyPlatformPart = nil; local FLY_SPEED = 0.5

-- ==================== LÓGICA DOS ESPs DE ITENS ====================
local wasEspSecretActive = false; local originalSecretProperties = {}; local wasEspGodActive = false; local originalGodProperties = {}
local wasEspBaseActive = false; local originalBaseProperties = {} 

-- ==================== LOOP PRINCIPAL (RenderStepped) ====================
RunService.RenderStepped:Connect(function()
    -- Loop do ESP de Jogador
    for player, espGui in pairs(playerEspInstances) do if espGui and espGui.Parent then if player.Character and player.Character.Parent then espGui.Enabled = state.esp_player else espGui:Destroy(); playerEspInstances[player] = nil end else playerEspInstances[player] = nil end end

    -- Loop da Plataforma Voadora
    if state.fly_platform then local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); if hrp then if not flyPlatformPart then flyPlatformPart = Instance.new("Part"); flyPlatformPart.Name, flyPlatformPart.Size, flyPlatformPart.Color, flyPlatformPart.Material, flyPlatformPart.Anchored, flyPlatformPart.CanCollide, flyPlatformPart.Position, flyPlatformPart.Parent = "QueenFlyPlatform", Vector3.new(8, 1, 8), Color3.fromRGB(0, 255, 0), Enum.Material.Neon, true, true, hrp.Position - Vector3.new(0, 4, 0), Workspace end; local pos = hrp.Position; local newY = flyPlatformPart.Position.Y + FLY_SPEED; flyPlatformPart.CFrame = CFrame.new(pos.X, newY, pos.Z) end else if flyPlatformPart then flyPlatformPart:Destroy(); flyPlatformPart = nil end end

    -- Loops de ESP de Itens
    if state.esp_secret ~= wasEspSecretActive then wasEspSecretActive = state.esp_secret; if state.esp_secret then for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BillboardGui") then local s = false; for _, c in ipairs(d:GetDescendants()) do if c:IsA("TextLabel") and c.Text:lower():find("secret") then s = true; break end end; if s then originalSecretProperties[d] = { AlwaysOnTop = d.AlwaysOnTop, LightInfluence = d.LightInfluence, MaxDistance = d.MaxDistance, Size = d.Size }; d.AlwaysOnTop, d.LightInfluence, d.MaxDistance, d.Size = true, 0, math.huge, UDim2.new(0, 400, 0, 150) end end end else for g, p in pairs(originalSecretProperties) do if g and g.Parent then g.AlwaysOnTop, g.LightInfluence, g.MaxDistance, g.Size = p.AlwaysOnTop, p.LightInfluence, p.MaxDistance, p.Size end end; originalSecretProperties = {} end end
    if state.esp_god ~= wasEspGodActive then wasEspGodActive = state.esp_god; if state.esp_god then for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BillboardGui") then local g = false; for _, c in ipairs(d:GetDescendants()) do if c:IsA("TextLabel") and c.Text:lower():find("brainrot god") then g = true; break end end; if g then originalGodProperties[d] = { AlwaysOnTop = d.AlwaysOnTop, LightInfluence = d.LightInfluence, MaxDistance = d.MaxDistance, Size = d.Size }; d.AlwaysOnTop, d.LightInfluence, d.MaxDistance, d.Size = true, 0, math.huge, UDim2.new(0, 450, 0, 180) end end end else for g, p in pairs(originalGodProperties) do if g and g.Parent then g.AlwaysOnTop, g.LightInfluence, g.MaxDistance, g.Size = p.AlwaysOnTop, p.LightInfluence, p.MaxDistance, p.Size end end; originalGodProperties = {} end end
    if state.esp_base ~= wasEspBaseActive then wasEspBaseActive = state.esp_base; if state.esp_base then for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BillboardGui") then local isCollectable = false; for _, c in ipairs(d:GetDescendants()) do if c:IsA("TextLabel") and c.Text:lower():find("coletar") then isCollectable = true; break end end; if isCollectable then originalBaseProperties[d] = { AlwaysOnTop = d.AlwaysOnTop, LightInfluence = d.LightInfluence, MaxDistance = d.MaxDistance, Size = d.Size }; d.AlwaysOnTop, d.LightInfluence, d.MaxDistance, d.Size = true, 0, math.huge, UDim2.new(0, 300, 0, 100) end end end else for g, p in pairs(originalBaseProperties) do if g and g.Parent then g.AlwaysOnTop, g.LightInfluence, g.MaxDistance, g.Size = p.AlwaysOnTop, p.LightInfluence, p.MaxDistance, p.Size end end; originalBaseProperties = {} end end

    -- Loop para mostrar/esconder o botão de teleporte para a base
    returnButton.Visible = state.instant_steal_secundario
end)
-- =======================================================

-- ==================== LÓGICA DE ABERTURA/FECHAMENTO ====================
local closeBtn = Instance.new("TextButton", main); closeBtn.Text = "X"; closeBtn.Position = UDim2.new(1, -32, 0, 4); closeBtn.Size = UDim2.new(0, 28, 0, 24); closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); closeBtn.TextColor3 = Style.Color.Text; closeBtn.Font = Style.Font.Title; closeBtn.TextSize = Style.TextSize.Title; closeBtn.BorderSizePixel = 0
local function closeAllPanels() main.Visible, sec.Visible = false, false; if state.is_sec_panel_open then state.is_sec_panel_open = false; secPanelToggleButton.BackgroundColor3 = Style.Color.Main end end
closeBtn.MouseButton1Click:Connect(closeAllPanels)
logoButton.MouseButton1Click:Connect(function() if main.Visible then closeAllPanels() else main.Visible = true end end)
