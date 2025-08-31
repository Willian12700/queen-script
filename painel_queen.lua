--[[
    Queen script - Versão FINAL (Baseado no Vídeo)
    - Interface refeita do zero para ser idêntica à do vídeo de referência.
    - Remove todos os elementos extras (logo, painel secundário, etc.).
    - Contém um único painel central com os botões.
    - Inclui a lógica funcional para ESP GOD e ESP SECRET.
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
gui.Name = "PainelMiranda"
gui.ResetOnSpawn = false

-- Painel Principal
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 250, 0, 300)
main.Position = UDim2.new(0.5, -125, 0.5, -150) -- Centralizado
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderColor3 = Color3.fromRGB(255, 230, 0) -- Borda amarela
main.BorderSizePixel = 2
main.Parent = gui

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 10)
title.Text = "MIRANDA TWEEN+"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 230, 0) -- Amarelo
title.BackgroundTransparency = 1

-- Subtítulo (TikTok)
local subtitle = Instance.new("TextLabel", main)
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 35)
subtitle.Text = "TIKTOK: @mirandacalliruim"
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 16
subtitle.TextColor3 = Color3.new(1, 1, 1) -- Branco
subtitle.BackgroundTransparency = 1

-- ==================== LÓGICA E CRIAÇÃO DOS BOTÕES ====================
local state = {
    esp_god = false,
    esp_secret = false
    -- Adicione os outros estados aqui quando for implementar as funções
}

local buttonY = 70 -- Posição Y inicial para o primeiro botão

-- Função para criar os botões no estilo do vídeo
local function createButton(text, key)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 220, 0, 35)
    btn.Position = UDim2.new(0.5, -110, 0, buttonY)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    -- Define a cor com base no nome do botão
    if text == "Teleguiado" or text == "Anti Hit" then
        btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40) -- Vermelho
    elseif text == "2 Dash" or text == "Superman" then
        btn.BackgroundColor3 = Color3.fromRGB(40, 180, 40) -- Verde
    else
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Cinza para os ESPs
    end
    
    if key then
        btn.MouseButton1Click:Connect(function()
            state[key] = not state[key]
            -- Efeito de clique: muda a cor quando ativo
            btn.BackgroundColor3 = state[key] and Color3.fromRGB(30, 30, 30) or ( (text == "Teleguiado" or text == "Anti Hit") and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(40, 180, 40) )
        end)
    end
    
    buttonY = buttonY + 45 -- Incrementa a posição Y para o próximo botão
    return btn
end

-- Botões ESP (lado a lado)
local espGodBtn = createButton("ESP GOD", "esp_god")
espGodBtn.Size = UDim2.new(0, 105, 0, 35)
espGodBtn.Position = UDim2.new(0.5, -110, 0, buttonY)

local espSecretBtn = createButton("ESP SECRET", "esp_secret")
espSecretBtn.Size = UDim2.new(0, 105, 0, 35)
espSecretBtn.Position = UDim2.new(0.5, 5, 0, buttonY)

buttonY = buttonY + 45 -- Ajusta a posição para a próxima linha

-- Outros botões
createButton("Teleguiado", nil) -- nil significa que não tem função ainda
createButton("2 Dash", nil)
createButton("Superman", nil)
createButton("Anti Hit", nil)

-- ==================== LÓGICA DOS ESPs ====================
local wasEspSecretActive = false; local originalSecretProperties = {}
local wasEspGodActive = false; local originalGodProperties = {}

RunService.RenderStepped:Connect(function()
    -- Loop do ESP Secret
    if state.esp_secret ~= wasEspSecretActive then
        wasEspSecretActive = state.esp_secret
        if state.esp_secret then
            for _, descendant in ipairs(Workspace:GetDescendants()) do
                if descendant:IsA("BillboardGui") then
                    local isSecret = false
                    for _, child in ipairs(descendant:GetDescendants()) do
                        if child:IsA("TextLabel") and child.Text:lower():find("secret") then isSecret = true; break end
                    end
                    if isSecret then
                        originalSecretProperties[descendant] = { AlwaysOnTop = descendant.AlwaysOnTop, LightInfluence = descendant.LightInfluence, MaxDistance = descendant.MaxDistance, Size = descendant.Size }
                        descendant.AlwaysOnTop, descendant.LightInfluence, descendant.MaxDistance, descendant.Size = true, 0, math.huge, UDim2.new(0, 400, 0, 150)
                    end
                end
            end
        else
            for gui, props in pairs(originalSecretProperties) do
                if gui and gui.Parent then gui.AlwaysOnTop, gui.LightInfluence, gui.MaxDistance, gui.Size = props.AlwaysOnTop, props.LightInfluence, props.MaxDistance, props.Size end
            end
            originalSecretProperties = {}
        end
    end

    -- Loop do ESP God
    if state.esp_god ~= wasEspGodActive then
        wasEspGodActive = state.esp_god
        if state.esp_god then
            for _, descendant in ipairs(Workspace:GetDescendants()) do
                if descendant:IsA("BillboardGui") then
                    local isGod = false
                    for _, child in ipairs(descendant:GetDescendants()) do
                        if child:IsA("TextLabel") and child.Text:lower():find("brainrot god") then isGod = true; break end
                    end
                    if isGod then
                        originalGodProperties[descendant] = { AlwaysOnTop = descendant.AlwaysOnTop, LightInfluence = descendant.LightInfluence, MaxDistance = descendant.MaxDistance, Size = descendant.Size }
                        descendant.AlwaysOnTop, descendant.LightInfluence, descendant.MaxDistance, descendant.Size = true, 0, math.huge, UDim2.new(0, 450, 0, 180)
                    end
                end
            end
        else
            for gui, props in pairs(originalGodProperties) do
                if gui and gui.Parent then gui.AlwaysOnTop, gui.LightInfluence, gui.MaxDistance, gui.Size = props.AlwaysOnTop, props.LightInfluence, props.MaxDistance, props.Size end
            end
            originalGodProperties = {}
        end
    end
end)
