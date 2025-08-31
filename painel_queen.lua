--[[
    Queen script - Versão Aprimorada
    Melhorias:
    1. Tabela de Estilos (Style): Centraliza cores, fontes e tamanhos para fácil customização.
    2. Painéis Arrastáveis: Permite que o usuário mova os painéis pela tela.
    3. Lógica de Minimizar Melhorada: Usa um frame "container" para maior robustez.
    4. Funções de UI mais genéricas e organização aprimorada.
]]

-- ==================== VARIÁVEIS E SERVIÇOS ====================
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- ==================== TABELA DE ESTILOS ====================
-- [!] MELHORIA: Centralizar todas as configurações de aparência em um só lugar.
-- Mudar uma cor ou fonte aqui atualiza a UI inteira.
local Style = {
    Font = {
        Title = Enum.Font.SourceSansBold,
        Subtitle = Enum.Font.SourceSans,
        Button = Enum.Font.SourceSansBold
    },
    TextSize = {
        Title = 22,
        Subtitle = 16,
        Button = 18
    },
    Color = {
        Background = Color3.fromRGB(30, 30, 30),
        Main = Color3.fromRGB(200, 20, 40),
        MainActive = Color3.fromRGB(120, 30, 40),
        Text = Color3.fromRGB(255, 255, 255),
        ButtonWhite = Color3.fromRGB(242, 242, 242),
        ButtonWhiteActive = Color3.fromRGB(200, 200, 200),
        ButtonWhiteText = Color3.fromRGB(0, 0, 0),
        Success = Color3.fromRGB(30, 180, 60),
        Neutral = Color3.fromRGB(90, 90, 90)
    },
    Size = {
        MainPanel = UDim2.new(0, 240, 0, 340),
        SecPanel = UDim2.new(0, 240, 0, 200),
        Button = UDim2.new(0, 200, 0, 32)
    }
}

-- ==================== ESTADO DAS FUNÇÕES ====================
local state = {
    esp_god = false,
    esp_secret = false,
    esp_base = true,
    esp_player = false,
    insta_steal_principal = false,
    instant_steal_secundario = false,
    aimbot_teia = false,
    auto_kick = false,
}

-- ==================== FUNÇÕES UTILITÁRIAS DE UI ====================

-- [!] MELHORIA: Função para tornar um frame arrastável.
local function makeDraggable(guiObject)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                guiObject.Parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end


-- ==================== CRIAÇÃO DA UI ====================
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "PainelMiranda"
gui.ResetOnSpawn = false

-- Painel Principal
local main = Instance.new("Frame", gui)
main.Name = "MainPanel"
main.BackgroundColor3 = Style.Color.Background
main.Size = Style.Size.MainPanel
main.Position = UDim2.new(0, 30, 0, 70)
main.BorderSizePixel = 0

-- [!] MELHORIA: Container para os elementos que serão minimizados.
local mainContent = Instance.new("Frame", main)
mainContent.Name = "Content"
mainContent.BackgroundTransparency = 1
mainContent.Size = UDim2.new(1, 0, 1, 0)
mainContent.Position = UDim2.new(0, 0, 0, 0)

-- Barra de Título para arrastar
local titleBar = Instance.new("TextLabel", main)
titleBar.Text = "Queen script"
titleBar.Position = UDim2.new(0, 0, 0, 10)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundTransparency = 1
titleBar.TextColor3 = Style.Color.Text
titleBar.Font = Style.Font.Title
titleBar.TextSize = Style.TextSize.Title
makeDraggable(titleBar) -- Torna o painel arrastável pelo título

local subtitle = Instance.new("TextLabel", mainContent)
subtitle.Text = "TIKTOK: @mirandacalliruim"
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Style.Color.Text
subtitle.Font = Style.Font.Subtitle
subtitle.TextSize = Style.TextSize.Subtitle

-- Painel Secundário
local sec = Instance.new("Frame", gui)
sec.Name = "SecPanel"
sec.BackgroundColor3 = Style.Color.Background
sec.Size = Style.Size.SecPanel
sec.Position = UDim2.new(0, 290, 0, 70)
sec.BorderSizePixel = 0

local secTitle = Instance.new("TextLabel", sec)
secTitle.Text = "INSTANT STEAL"
secTitle.Position = UDim2.new(0, 0, 0, 10)
secTitle.Size = UDim2.new(1, 0, 0, 30)
secTitle.BackgroundTransparency = 1
secTitle.TextColor3 = Style.Color.Text
secTitle.Font = Style.Font.Title
secTitle.TextSize = Style.TextSize.Title
makeDraggable(secTitle) -- Torna o painel secundário arrastável também

-- ==================== CRIAÇÃO DOS BOTÕES (Lógica Principal) ====================

-- Função genérica para criar botões de toggle
local function createToggleButton(props)
    local btn = Instance.new("TextButton")
    btn.Parent = props.Parent
    btn.Text = props.Text
    btn.Position = props.Position
    btn.Size = props.Size or Style.Size.Button
    btn.Font = Style.Font.Button
    btn.TextSize = Style.TextSize.Button
    btn.TextColor3 = props.TextColor or Style.Color.Text
    btn.BorderSizePixel = 0
    
    local stateKey = props.StateKey
    local onColor = props.OnColor or Style.Color.MainActive
    local offColor = props.OffColor or Style.Color.Main
    
    -- Função para atualizar a aparência do botão com base no estado
    local function updateVisuals()
        local isActive = state[stateKey]
        btn.BackgroundColor3 = isActive and onColor or offColor
        if props.UpdateText then -- Permite atualizar o texto do botão
            btn.Text = props.Text .. (isActive and ": ON" or ": OFF")
        end
    end

    btn.MouseButton1Click:Connect(function()
        state[stateKey] = not state[stateKey]
        updateVisuals()
        if props.Callback then -- Executa uma função adicional se fornecida
            props.Callback(state[stateKey])
        end
    end)
    
    updateVisuals() -- Define o estado visual inicial
    return btn
end

-- Adicionar botões ao painel principal dinamicamente
local btn_y_start = 70
local btn_y_offset = 36
local mainButtons = {
    {Text = "ESP GOD", Key = "esp_god"},
    {Text = "ESP SECRET", Key = "esp_secret"},
    {Text = "ESP BASE", Key = "esp_base"},
    {Text = "ESP PLAYER", Key = "esp_player"},
    {Text = "Miranda Insta Steal", Key = "insta_steal_principal"},
}

for i, btnData in ipairs(mainButtons) do
    createToggleButton({
        Parent = mainContent,
        Text = btnData.Text,
        StateKey = btnData.Key,
        Position = UDim2.new(0, 20, 0, btn_y_start + (i - 1) * btn_y_offset),
    })
end

-- Adicionar botões ao painel secundário
createToggleButton({
    Parent = sec,
    Text = "Instant Steal",
    StateKey = "instant_steal_secundario",
    UpdateText = true, -- Esta opção fará o texto mudar para "ON/OFF"
    Position = UDim2.new(0, 20, 0, 50),
    Size = UDim2.new(0, 200, 0, 34)
})

createToggleButton({
    Parent = sec,
    Text = "Aimbot Teia",
    StateKey = "aimbot_teia",
    Position = UDim2.new(0, 20, 0, 90),
    OnColor = Style.Color.ButtonWhiteActive,
    OffColor = Style.Color.ButtonWhite,
    TextColor = Style.Color.ButtonWhiteText
})

-- Botão de Auto Kick (layout especial)
local ak_label = Instance.new("TextLabel", sec)
ak_label.Text = "AUTO KICK"
ak_label.Position = UDim2.new(0, 20, 0, 133)
ak_label.Size = UDim2.new(0, 100, 0, 26)
ak_label.BackgroundTransparency = 1
ak_label.TextColor3 = Style.Color.Text
ak_label.Font = Style.Font.Subtitle
ak_label.TextSize = Style.TextSize.Subtitle

createToggleButton({
    Parent = sec,
    Text = "", -- O texto será ON/OFF
    StateKey = "auto_kick",
    Position = UDim2.new(0, 120, 0, 133),
    Size = UDim2.new(0, 60, 0, 26),
    OnColor = Style.Color.Success,
    OffColor = Style.Color.Neutral,
    UpdateText = true
}):GetPropertyChangedSignal("Text"):Connect(function(prop) -- Pequeno ajuste para ON/OFF simples
    local btn = script:FindFirstChild("TextButton") -- Assume que o botão é o último criado. Uma referência mais robusta seria melhor.
    if btn then
        btn.Text = state.auto_kick and "ON" or "OFF"
    end
end)


-- ==================== FUNCIONALIDADES EXTRAS ====================

-- Botão de Minimizar
local minBtn = Instance.new("TextButton", main)
minBtn.Text = "-"
minBtn.Position = UDim2.new(1, -32, 0, 4)
minBtn.Size = UDim2.new(0, 28, 0, 24)
minBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
minBtn.TextColor3 = Style.Color.Text
minBtn.Font = Style.Font.Title
minBtn.TextSize = Style.TextSize.Title
minBtn.BorderSizePixel = 0

local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    -- [!] MELHORIA: Apenas alterna a visibilidade do container.
    mainContent.Visible = not isMinimized
    minBtn.Text = isMinimized and "+" or "-"
end)
