--[[
    Queen script - Versão FINAL 1.3 (Voo Teleguiado Aprimorado)
    - "Teleguiado" foi refeito com uma lógica de física mais moderna e robusta (LinearVelocity).
    - O método para encontrar a base do jogador foi aprimorado para ser mais confiável,
      procurando pela GUI que exibe o nome do jogador.
]]

-- ==================== VARIÁVEIS E SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== CRIAÇÃO DA UI (Estilo do Vídeo) ====================
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "PainelMiranda"; gui.ResetOnSpawn = false
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 250, 0, 300); main.Position = UDim2.new(0.5, -125, 0.5, -150); main.BackgroundColor3 = Color3.fromRGB(30, 30, 30); main.BorderColor3 = Color3.fromRGB(255, 230, 0); main.BorderSizePixel = 2; main.Parent = gui
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30); title.Position = UDim2.new(0, 0, 0, 10); title.Text = "MIRANDA TWEEN+"; title.Font = Enum.Font.SourceSansBold; title.TextSize = 22; title.TextColor3 = Color3.fromRGB(255, 230, 0); title.BackgroundTransparency = 1
local subtitle = Instance.new("TextLabel", main)
subtitle.Size = UDim2.new(1, 0, 0, 20); subtitle.Position = UDim2.new(0, 0, 0, 35); subtitle.Text = "TIKTOK: @mirandacalliruim"; subtitle.Font = Enum.Font.SourceSans; subtitle.TextSize = 16; subtitle.TextColor3 = Color3.new(1, 1, 1); subtitle.BackgroundTransparency = 1

-- ==================== LÓGICA E CRIAÇÃO DOS BOTÕES ====================
local state = { esp_god = false, esp_secret = false }
local isFlying = false -- Debounce para o voo teleguiado
local buttonY = 70

local function createButton(text, key, onClick)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 220, 0, 35); btn.Position = UDim2.new(0.5, -110, 0, buttonY); btn.Text = text; btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 18; btn.TextColor3 = Color3.new(1, 1, 1)
    local offColor; if text == "Teleguiado" or text == "Anti Hit" then offColor = Color3.fromRGB(180, 40, 40) elseif text == "2 Dash" or text == "Superman" then offColor = Color3.fromRGB(40, 180, 40) else offColor = Color3.fromRGB(60, 60, 60) end; btn.BackgroundColor3 = offColor
    if onClick then btn.MouseButton1Click:Connect(onClick) elseif key then btn.MouseButton1Click:Connect(function() state[key] = not state[key]; btn.BackgroundColor3 = state[key] and Color3.fromRGB(30, 30, 30) or offColor end) end
    buttonY = buttonY + 45; return btn
end

local espGodBtn = createButton("ESP GOD", "esp_god"); espGodBtn.Size = UDim2.new(0, 105, 0, 35); espGodBtn.Position = UDim2.new(0.5, -110, 0, buttonY)
local espSecretBtn = createButton("ESP SECRET", "esp_secret"); espSecretBtn.Size = UDim2.new(0, 105, 0, 35); espSecretBtn.Position = UDim2.new(0.5, 5, 0, buttonY)
buttonY = buttonY + 45

-- [!] INÍCIO DA NOVA LÓGICA DE VOO
local function findMyBasePart()
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("BillboardGui") then
            local textLabel = descendant:FindFirstChildOfClass("TextLabel", true)
            if textLabel and textLabel.Text:lower():find(LocalPlayer.Name:lower()) then
                return descendant.Adornee
            end
        end
    end
    return nil
end

local function flyToBase()
    if isFlying then return end
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    local targetPart = findMyBasePart()
    if not targetPart then
        warn("Queen Script: Base do jogador não encontrada (método aprimorado).")
        return
    end

    isFlying = true
    
    local attachment = Instance.new("Attachment", hrp)
    local linearVelocity = Instance.new("LinearVelocity", attachment)
    linearVelocity.Name = "QueenFlyVelocity"
    linearVelocity.MaxForce = math.huge
    linearVelocity.Attachment0 = attachment
    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World

    humanoid.AutoRotate = false

    local connection
    connection = RunService.Heartbeat:Connect(function()
        local targetPosition = targetPart.Position + Vector3.new(0, 10, 0) -- Mira um pouco acima da base
        local distance = (hrp.Position - Vector3.new(targetPosition.X, hrp.Position.Y, targetPosition.Z)).Magnitude

        if distance < 20 or not linearVelocity.Parent then
            linearVelocity:Destroy(); attachment:Destroy(); humanoid.AutoRotate = true; isFlying = false; connection:Disconnect()
            return
        end
        
        local direction = (targetPosition - hrp.Position).Unit
        linearVelocity.LineVelocity = direction * 120 -- Velocidade do voo
    end)
end

createButton("Teleguiado", nil, flyToBase)
-- [!] FIM DA NOVA LÓGICA

createButton("2 Dash", nil); createButton("Superman", nil); createButton("Anti Hit", nil)

-- ==================== LÓGICA DAS FUNÇÕES ====================
local wasEspSecretActive = false; local originalSecretProperties = {}; local wasEspGodActive = false; local originalGodProperties = {}

RunService.RenderStepped:Connect(function()
    -- Loop do ESP Secret
    if state.esp_secret ~= wasEspSecretActive then wasEspSecretActive = state.esp_secret; if state.esp_secret then for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BillboardGui") then local s = false; for _, c in ipairs(d:GetDescendants()) do if c:IsA("TextLabel") and c.Text:lower():find("secret") then s = true; break end end; if s then originalSecretProperties[d] = { AlwaysOnTop = d.AlwaysOnTop, LightInfluence = d.LightInfluence, MaxDistance = d.MaxDistance, Size = d.Size }; d.AlwaysOnTop, d.LightInfluence, d.MaxDistance, d.Size = true, 0, math.huge, UDim2.new(0, 400, 0, 150) end end end else for g, p in pairs(originalSecretProperties) do if g and g.Parent then g.AlwaysOnTop, g.LightInfluence, g.MaxDistance, g.Size = p.AlwaysOnTop, p.LightInfluence, p.MaxDistance, p.Size end end; originalSecretProperties = {} end end

    -- Loop do ESP God
    if state.esp_god ~= wasEspGodActive then wasEspGodActive = state.esp_god; if state.esp_god then for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BillboardGui") then local g = false; for _, c in ipairs(d:GetDescendants()) do if c:IsA("TextLabel") and c.Text:lower():find("brainrot god") then g = true; break end end; if g then originalGodProperties[d] = { AlwaysOnTop = d.AlwaysOnTop, LightInfluence = d.LightInfluence, MaxDistance = d.MaxDistance, Size = d.Size }; d.AlwaysOnTop, d.LightInfluence, d.MaxDistance, d.Size = true, 0, math.huge, UDim2.new(0, 450, 0, 180) end end end else for g, p in pairs(originalGodProperties) do if g and g.Parent then g.AlwaysOnTop, g.LightInfluence, g.MaxDistance, g.Size = p.AlwaysOnTop, p.LightInfluence, p.MaxDistance, p.Size end end; originalGodProperties = {} end end
end)
