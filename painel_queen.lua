--[[
    Queen script - Versão FINAL 2.0 (Interface Moderna + Funções do Vídeo)
    - Reintegrada a interface com logo flutuante e painéis arrastáveis.
    - O layout dos botões dentro do painel segue o estilo do vídeo.
    - Contém as funcionalidades ativas: ESP GOD, ESP SECRET e Teleguiado (Voo para a Base).
]]

-- ==================== VARIÁVEIS E SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== ESTADO DAS FUNÇÕES ====================
local state = {
    esp_god = false,
    esp_secret = false
}

-- ==================== FUNÇÕES UTILITÁRIAS DE UI ====================
local function makeDraggable(guiObject) local dragging, dragStart, startPos = false, nil, nil; guiObject.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, guiObject.Parent.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); UserInputService.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local delta = input.Position - dragStart; guiObject.Parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end
local function makeDraggableWithSnap(draggableObject) local dragging, dragStart, startPos = false, nil, nil; draggableObject.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, draggableObject.Position; local connection; connection = input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging, connection = false, connection:Disconnect(); local screen, screenSize, objectSize, currentPos = draggableObject.Parent, draggableObject.Parent.AbsoluteSize, draggableObject.AbsoluteSize, draggableObject.AbsolutePosition; local padding, targetX, targetY = 10; if (currentPos.X + objectSize.X / 2) < (screenSize.X / 2) then targetX = padding else targetX = screenSize.X - objectSize.X - padding end; if (currentPos.Y + objectSize.Y / 2) < (screenSize.Y / 2) then targetY = padding else targetY = screenSize.Y - objectSize.Y - padding end; local tween = TweenService:Create(draggableObject, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, targetX, 0, targetY)}); tween:Play() end end) end end); UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; draggableObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end

-- ==================== CRIAÇÃO DA UI ====================
local gui = Instance.new("ScreenGui", playerGui); gui.Name = "PainelMiranda"; gui.ResetOnSpawn = false

-- Logo Flutuante
local logoContainer = Instance.new("Frame", gui); logoContainer.Size = UDim2.new(0, 60, 0, 60); logoContainer.Position = UDim2.new(0, 20, 0, 250); logoContainer.BackgroundTransparency = 1
local logoButton = Instance.new("ImageButton", logoContainer); logoButton.Size = UDim2.new(1, 0, 1, 0); logoButton.Image = "rbxassetid://COLE_O_ID_DA_SUA_IMAGEM_AQUI"; logoButton.BackgroundColor3 = Color3.fromRGB(10, 150, 10); logoButton.BackgroundTransparency = 0 
local corner = Instance.new("UICorner", logoButton); corner.CornerRadius = UDim.new(0.5, 0); makeDraggableWithSnap(logoContainer)

-- Painel Principal (Estilo do Vídeo)
local main = Instance.new("Frame", gui); main.Size = UDim2.new(0, 250, 0, 300); main.Position = UDim2.new(0.5, -125, 0.5, -150); main.BackgroundColor3 = Color3.fromRGB(30, 30, 30); main.BorderColor3 = Color3.fromRGB(255, 230, 0); main.BorderSizePixel = 2; main.Visible = false
local titleBar = Instance.new("Frame", main); titleBar.Size = UDim2.new(1, 0, 0, 60); titleBar.BackgroundTransparency = 1; makeDraggable(titleBar.Parent) -- Torna o painel todo arrastável

local title = Instance.new("TextLabel", titleBar); title.Size = UDim2.new(1, 0, 0, 30); title.Position = UDim2.new(0, 0, 0, 10); title.Text = "MIRANDA TWEEN+"; title.Font = Enum.Font.SourceSansBold; title.TextSize = 22; title.TextColor3 = Color3.fromRGB(255, 230, 0); title.BackgroundTransparency = 1
local subtitle = Instance.new("TextLabel", titleBar); subtitle.Size = UDim2.new(1, 0, 0, 20); subtitle.Position = UDim2.new(0, 0, 0, 35); subtitle.Text = "TIKTOK: @mirandacalliruim"; subtitle.Font = Enum.Font.SourceSans; subtitle.TextSize = 16; subtitle.TextColor3 = Color3.new(1, 1, 1); subtitle.BackgroundTransparency = 1

-- Botão de Fechar
local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 24, 0, 24); closeBtn.Position = UDim2.new(1, -28, 0, 4); closeBtn.Text = "X"; closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.SourceSansBold

-- ==================== LÓGICA E CRIAÇÃO DOS BOTÕES ====================
local buttonY = 70
local function createButton(text, key, onClick)
    local btn = Instance.new("TextButton", main); btn.Size = UDim2.new(0, 220, 0, 35); btn.Position = UDim2.new(0.5, -110, 0, buttonY); btn.Text = text; btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 18; btn.TextColor3 = Color3.new(1, 1, 1)
    local offColor; if text == "Teleguiado" or text == "Anti Hit" then offColor = Color3.fromRGB(180, 40, 40) elseif text == "2 Dash" or text == "Superman" then offColor = Color3.fromRGB(40, 180, 40) else offColor = Color3.fromRGB(60, 60, 60) end; btn.BackgroundColor3 = offColor
    if onClick then btn.MouseButton1Click:Connect(onClick) elseif key then btn.MouseButton1Click:Connect(function() state[key] = not state[key]; btn.BackgroundColor3 = state[key] and Color3.fromRGB(30, 30, 30) or offColor end) end
    buttonY = buttonY + 45; return btn
end

local espGodBtn = createButton("ESP GOD", "esp_god"); espGodBtn.Size = UDim2.new(0, 105, 0, 35); espGodBtn.Position = UDim2.new(0.5, -110, 0, buttonY)
local espSecretBtn = createButton("ESP SECRET", "esp_secret"); espSecretBtn.Size = UDim2.new(0, 105, 0, 35); espSecretBtn.Position = UDim2.new(0.5, 5, 0, buttonY)
buttonY = buttonY + 45

local function flyToBase()
    local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local plots = Workspace:FindFirstChild("Plots") or Workspace; local base = plots:FindFirstChild(LocalPlayer.Name)
    if base and base.PrimaryPart then
        local targetPos = base.PrimaryPart.Position
        if hrp:FindFirstChild("QueenFlyVelocity") then hrp.QueenFlyVelocity:Destroy() end
        local flyVel = Instance.new("BodyVelocity", hrp); flyVel.Name = "QueenFlyVelocity"; flyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge); flyVel.P = 5000
        local conn; conn = RunService.Heartbeat:Connect(function()
            if (hrp.Position - targetPos).Magnitude < 15 or not flyVel.Parent then flyVel:Destroy(); conn:Disconnect(); return end
            flyVel.Velocity = ((targetPos - hrp.Position).Unit * 100) + Vector3.new(0, 5, 0)
        end)
    else warn("Base não encontrada.") end
end
createButton("Teleguiado", nil, flyToBase)
createButton("2 Dash", nil); createButton("Superman", nil); createButton("Anti Hit", nil)

-- ==================== LÓGICA DAS FUNÇÕES ====================
local wasEspSecretActive = false; local originalSecretProperties = {}; local wasEspGodActive = false; local originalGodProperties = {}

RunService.RenderStepped:Connect(function()
    -- Loop do ESP Secret
    if state.esp_secret ~= wasEspSecretActive then wasEspSecretActive = state.esp_secret; if state.esp_secret then for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BillboardGui") then local s = false; for _, c in ipairs(d:GetDescendants()) do if c:IsA("TextLabel") and c.Text:lower():find("secret") then s = true; break end end; if s then originalSecretProperties[d] = { AlwaysOnTop = d.AlwaysOnTop, LightInfluence = d.LightInfluence, MaxDistance = d.MaxDistance, Size = d.Size }; d.AlwaysOnTop, d.LightInfluence, d.MaxDistance, d.Size = true, 0, math.huge, UDim2.new(0, 400, 0, 150) end end end else for g, p in pairs(originalSecretProperties) do if g and g.Parent then g.AlwaysOnTop, g.LightInfluence, g.MaxDistance, g.Size = p.AlwaysOnTop, p.LightInfluence, p.MaxDistance, p.Size end end; originalSecretProperties = {} end end

    -- Loop do ESP God
    if state.esp_god ~= wasEspGodActive then wasEspGodActive = state.esp_god; if state.esp_god then for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BillboardGui") then local g = false; for _, c in ipairs(d:GetDescendants()) do if c:IsA("TextLabel") and c.Text:lower():find("brainrot god") then g = true; break end end; if g then originalGodProperties[d] = { AlwaysOnTop = d.AlwaysOnTop, LightInfluence = d.LightInfluence, MaxDistance = d.MaxDistance, Size = d.Size }; d.AlwaysOnTop, d.LightInfluence, d.MaxDistance, d.Size = true, 0, math.huge, UDim2.new(0, 450, 0, 180) end end end else for g, p in pairs(originalGodProperties) do if g and g.Parent then g.AlwaysOnTop, g.LightInfluence, g.MaxDistance, g.Size = p.AlwaysOnTop, p.LightInfluence, p.MaxDistance, p.Size end end; originalGodProperties = {} end end
end)

-- ==================== LÓGICA DE ABERTURA/FECHAMENTO ====================
logoButton.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)
