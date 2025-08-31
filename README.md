-- Painel Miranda Teteus (simples, funcional no Delta/Roblox)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PainelMiranda"
gui.ResetOnSpawn = false

local function createFrame(props)
    local f = Instance.new("Frame")
    for k,v in pairs(props) do f[k]=v end
    f.Parent = gui
    return f
end

local function createButton(parent, text, pos, size, callback)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(200,20,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18
    b.BorderSizePixel = 0
    b.Parent = parent
    b.MouseButton1Click:Connect(callback)
    return b
end

local main = createFrame{
    Name="MainPanel", BackgroundColor3=Color3.fromRGB(30,30,30), Size=UDim2.new(0,240,0,340),
    Position=UDim2.new(0,30,0,70)
}
local sec = createFrame{
    Name="SecPanel", BackgroundColor3=Color3.fromRGB(30,30,30), Size=UDim2.new(0,240,0,200),
    Position=UDim2.new(0,290,0,70)
}

local title = Instance.new("TextLabel", main)
title.Text = "MIRANDA TETEUS*"
title.Position = UDim2.new(0,0,0,10)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local subtitle = Instance.new("TextLabel", main)
subtitle.Text = "TIKTOK: @mirandacalliruim"
subtitle.Position = UDim2.new(0,0,0,40)
subtitle.Size = UDim2.new(1,0,0,20)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.new(1,1,1)
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 16

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

local btn_y = 70
local function addToggle(name, statekey)
    local btn = createButton(main, name, UDim2.new(0,20,0,btn_y), UDim2.new(0,200,0,32), function()
        state[statekey] = not state[statekey]
        btn.BackgroundColor3 = state[statekey] and Color3.fromRGB(120,30,40) or Color3.fromRGB(200,20,40)
    end)
    btn.BackgroundColor3 = state[statekey] and Color3.fromRGB(120,30,40) or Color3.fromRGB(200,20,40)
    btn_y = btn_y + 36
end

addToggle("ESP GOD", "esp_god")
addToggle("ESP SECRET", "esp_secret")
addToggle("ESP BASE", "esp_base")
addToggle("ESP PLAYER", "esp_player")
addToggle("Miranda Insta Steal", "insta_steal_principal")

local sec_title = Instance.new("TextLabel", sec)
sec_title.Text = "INSTANT STEAL"
sec_title.Position = UDim2.new(0,0,0,10)
sec_title.Size = UDim2.new(1,0,0,30)
sec_title.BackgroundTransparency = 1
sec_title.TextColor3 = Color3.new(1,1,1)
sec_title.Font = Enum.Font.SourceSansBold
sec_title.TextSize = 20

-- Instant Steal status button
local inst_btn = createButton(sec, "Instant Steal: OFF", UDim2.new(0,20,0,50), UDim2.new(0,200,0,34), function()
    state.instant_steal_secundario = not state.instant_steal_secundario
    inst_btn.Text = "Instant Steal: "..(state.instant_steal_secundario and "ON" or "OFF")
    inst_btn.BackgroundColor3 = state.instant_steal_secundario and Color3.fromRGB(120,30,40) or Color3.fromRGB(200,20,40)
end)
inst_btn.BackgroundColor3 = Color3.fromRGB(200,20,40)

-- Aimbot Teia (branco)
local aim_btn = Instance.new("TextButton", sec)
aim_btn.Text = "Aimbot Teia"
aim_btn.Position = UDim2.new(0,20,0,90)
aim_btn.Size = UDim2.new(0,200,0,32)
aim_btn.BackgroundColor3 = Color3.new(0.95,0.95,0.95)
aim_btn.TextColor3 = Color3.new(0,0,0)
aim_btn.Font = Enum.Font.SourceSansBold
aim_btn.TextSize = 18
aim_btn.BorderSizePixel = 0
aim_btn.MouseButton1Click:Connect(function()
    state.aimbot_teia = not state.aimbot_teia
    aim_btn.BackgroundColor3 = state.aimbot_teia and Color3.new(0.8,0.8,0.8) or Color3.new(0.95,0.95,0.95)
end)

-- Auto Kick linha
local ak_label = Instance.new("TextLabel", sec)
ak_label.Text = "AUTO KICK"
ak_label.Position = UDim2.new(0,20,0,133)
ak_label.Size = UDim2.new(0,100,0,26)
ak_label.BackgroundTransparency = 1
ak_label.TextColor3 = Color3.new(1,1,1)
ak_label.Font = Enum.Font.SourceSans
ak_label.TextSize = 16

local ak_btn = Instance.new("TextButton", sec)
ak_btn.Text = "OFF"
ak_btn.Position = UDim2.new(0,120,0,133)
ak_btn.Size = UDim2.new(0,60,0,26)
ak_btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
ak_btn.TextColor3 = Color3.new(1,1,1)
ak_btn.Font = Enum.Font.SourceSansBold
ak_btn.TextSize = 16
ak_btn.BorderSizePixel = 0
ak_btn.MouseButton1Click:Connect(function()
    state.auto_kick = not state.auto_kick
    ak_btn.Text = state.auto_kick and "ON" or "OFF"
    ak_btn.BackgroundColor3 = state.auto_kick and Color3.fromRGB(30,180,60) or Color3.fromRGB(90,90,90)
end)
