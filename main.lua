local Players = game:GetService("Players")  
local VirtualInputManager = game:GetService("VirtualInputManager")  
local RunService = game:GetService("RunService")  
local UserInputService = game:GetService("UserInputService")  
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer  
  
-- ==========================================
--          CONFIGURACIÓN DE TU TEMA GUI
-- ==========================================
local T_ACCENT = Color3.fromRGB(160, 0, 255) -- Tu morado neón  
local T_BG = Color3.fromRGB(10, 0, 20)       -- Tu fondo oscuro
local T_CARD = Color3.fromRGB(20, 0, 40)     -- Paneles secundarios

local C = {  
    bg = T_BG,  
    card = T_CARD,  
    border = T_ACCENT,  
    green = Color3.fromRGB(45, 210, 110),  
    red = Color3.fromRGB(215, 60, 60),  
    text = Color3.fromRGB(220, 225, 245),  
    muted = Color3.fromRGB(150, 120, 180),  
}  

getgenv().AbuseActive = false  
getgenv().SafeZoneActive = false 
getgenv().SwordActive = false
getgenv().AutoZResetActive = false
getgenv().RespawnAbuseActive = false

local posicionOriginal = nil
local targetPos = CFrame.new(923.2, 3000000000000000000000, 32852.8) -- Coordenada 3e21

-- Nombres de Equipamiento para Blox Fruits (Tus tablas intactas)
local MeleeNames = {
    "Godhuman", "Sanguine Art", "Superhuman", "Death Step", 
    "Sharkman Karate", "Electric Claw", "Dragon Talon", 
    "Dragon Breath", "Dark Step", "Water Kung Fu", "Electric", "Combat"
}

local SwordNames = {
    "Cursed Dual Katana", "Shark Anchor", "Dark Blade", "Tushita", 
    "Yama", "Soul Guitar", "Hallow Scythe", "Canvander", "Spikey Trident"
}

-- Funciones Auxiliares estéticas de la Nueva GUI
local function addStroke(p, color, thick, trans)  
    local s = Instance.new('UIStroke', p)  
    s.Color = color or C.border  
    s.Thickness = thick or 1  
    s.Transparency = trans or 0  
    return s  
end  

local function mkFrame(parent, size, pos, bg)  
    local f = Instance.new('Frame', parent)  
    f.Size = size  
    f.Position = pos or UDim2.new(0, 0, 0, 0)  
    f.BackgroundColor3 = bg or C.card  
    f.BorderSizePixel = 0  
    Instance.new('UICorner', f).CornerRadius = UDim.new(0, 8)  
    return f  
end  

local function mkLabel(parent, size, pos, text, font, textSize, color, xAlign)  
    local l = Instance.new('TextLabel', parent)  
    l.Size = size  
    l.Position = pos or UDim2.new(0, 0, 0, 0)  
    l.BackgroundTransparency = 1  
    l.Text = text or ''  
    l.Font = font or Enum.Font.Gotham  
    l.TextSize = textSize or 11  
    l.TextColor3 = color or C.text  
    l.TextXAlignment = xAlign or Enum.TextXAlignment.Center  
    l.TextTruncate = Enum.TextTruncate.AtEnd  
    return l  
end  

-- Limpieza de GUIs viejas
for _, parent in ipairs({lp.PlayerGui, game:GetService('CoreGui')}) do  
    pcall(function()  
        local old = parent:FindFirstChild('AloneFalseExploitUI')  
        if old then old:Destroy() end  
    end)  
end  

-- ==========================================
--        CONSTRUCCIÓN INTERFAZ PREMIUM
-- ==========================================
local ScreenGui = Instance.new('ScreenGui', game:GetService('CoreGui'))  
ScreenGui.Name = 'AloneFalseExploitUI'  
ScreenGui.ResetOnSpawn = false  

-- Botón Flotante para Minimizar/Maximizar completo
local ToggleBtn = Instance.new('TextButton', ScreenGui)  
ToggleBtn.Size = UDim2.new(0, 38, 0, 38)  
ToggleBtn.Position = UDim2.new(0, 8, 0, 8)  
ToggleBtn.BackgroundColor3 = T_BG  
ToggleBtn.Text = ''  
ToggleBtn.BorderSizePixel = 0  
Instance.new('UICorner', ToggleBtn).CornerRadius = UDim.new(0, 10)  
addStroke(ToggleBtn, T_ACCENT, 1, 0.3)  

local toggleLogoImg = Instance.new('ImageLabel', ToggleBtn)  
toggleLogoImg.Size = UDim2.new(1, -6, 1, -6)  
toggleLogoImg.Position = UDim2.new(0, 3, 0, 3)  
toggleLogoImg.BackgroundTransparency = 1  
toggleLogoImg.Image = 'rbxassetid://125174382377001'  
toggleLogoImg.ImageColor3 = T_ACCENT  

-- Ventana Principal
local Main = Instance.new('Frame', ScreenGui)  
Main.Name = 'AloneMain'  
Main.Size = UDim2.new(0, 580, 0, 410)  
Main.Position = UDim2.new(0, 52, 0, 8)  
Main.BackgroundColor3 = T_BG  
Main.BorderSizePixel = 0  
Main.Active = true  
Main.Draggable = true  
Instance.new('UICorner', Main).CornerRadius = UDim.new(0, 10)  
local mainStroke = addStroke(Main, T_ACCENT, 1, 0.45)  

-- Efecto Respiración en el Borde Neón
task.spawn(function()  
    local t = 0  
    while true do  
        task.wait(0.06)  
        t += 0.06  
        if mainStroke and mainStroke.Parent then  
            mainStroke.Transparency = 0.45 + 0.3 * math.abs(math.sin(t * 0.8))  
        end  
    end  
end)  

-- Panel Izquierdo (Info de Usuario)
local left = Instance.new('Frame', Main)  
left.Size = UDim2.new(0, 168, 1, 0)  
left.BackgroundColor3 = T_CARD  
left.BackgroundTransparency = 0.3  
left.BorderSizePixel = 0  
Instance.new('UICorner', left).CornerRadius = UDim.new(0, 10)  
addStroke(left, T_ACCENT, 1, 0.55)  

local logoFrame = Instance.new('Frame', left)  
logoFrame.Size = UDim2.new(0, 70, 0, 70)  
logoFrame.Position = UDim2.new(0.5, -35, 0, 15)  
logoFrame.BackgroundTransparency = 1  

local logoImg = Instance.new('ImageLabel', logoFrame)  
logoImg.Size = UDim2.new(1, 0, 1, 0)  
logoImg.BackgroundTransparency = 1  
logoImg.Image = 'rbxassetid://125174382377001'  
logoImg.ImageColor3 = T_ACCENT  

local nameLbl = mkLabel(left, UDim2.new(1, -8, 0, 15), UDim2.new(0, 4, 0, 95), "AloneFalseExploit", Enum.Font.GothamBlack, 13, C.text)  
local subNameLbl = mkLabel(left, UDim2.new(1, -8, 0, 12), UDim2.new(0, 4, 0, 112), "https://discord.gg/vggTR35SRh", Enum.Font.Gotham, 8, C.muted)  

-- Stats básicas agregadas en el lateral (Estilo Premium)
local statusHeader = mkLabel(left, UDim2.new(1, 0, 0, 10), UDim2.new(0, 12, 0, 145), "MONITOR DE RED", Enum.Font.GothamBold, 8, C.muted, Enum.TextXAlignment.Left)
local pingBg = mkFrame(left, UDim2.new(0.86, 0, 0, 26), UDim2.new(0.07, 0, 0, 160), T_BG)
addStroke(pingBg, T_ACCENT, 1, 0.6)
local pingLbl = mkLabel(pingBg, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Cargando ping...", Enum.Font.GothamBold, 11, T_ACCENT)

local fpsHeader = mkLabel(left, UDim2.new(1, 0, 0, 10), UDim2.new(0, 12, 0, 200), "RENDIMIENTO FPS", Enum.Font.GothamBold, 8, C.muted, Enum.TextXAlignment.Left)
local fpsBg = mkFrame(left, UDim2.new(0.86, 0, 0, 26), UDim2.new(0.07, 0, 0, 215), T_BG)
addStroke(fpsBg, T_ACCENT, 1, 0.6)
local fpsLbl = mkLabel(fpsBg, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "--- FPS", Enum.Font.GothamBold, 11, Color3.fromRGB(240, 185, 55))

local creditLbl = mkLabel(left, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 1, -25), "Spectral Series", Enum.Font.GothamBold, 10, C.muted)

-- Panel Derecho (Controles y Botones)
local right = Instance.new('Frame', Main)  
right.Size = UDim2.new(1, -170, 1, 0)  
right.Position = UDim2.new(0, 170, 0, 0)  
right.BackgroundTransparency = 1  

local headerBar = mkFrame(right, UDim2.new(1, -6, 0, 35), UDim2.new(0, 3, 0, 4), T_CARD)  
addStroke(headerBar, T_ACCENT, 1, 0.6)  

local statusDot = Instance.new('Frame', headerBar)  
statusDot.Size = UDim2.new(0, 7, 0, 7)  
statusDot.Position = UDim2.new(0, 10, 0.5, -3.5)  
statusDot.BackgroundColor3 = C.green  
statusDot.BorderSizePixel = 0  
Instance.new('UICorner', statusDot).CornerRadius = UDim.new(1, 0)  

mkLabel(headerBar, UDim2.new(0, 200, 1, 0), UDim2.new(0, 24, 0, 0), 'CONSOLE CONTROL PANEL', Enum.Font.GothamBlack, 12, C.text, Enum.TextXAlignment.Left)  

local minBtn = Instance.new('TextButton', headerBar)  
minBtn.Size = UDim2.new(0, 28, 0, 22)  
minBtn.Position = UDim2.new(1, -34, 0.5, -11)  
minBtn.BackgroundColor3 = Color3.fromRGB(50, 10, 10)  
minBtn.Text = '−'  
minBtn.TextColor3 = Color3.new(1, 1, 1)  
minBtn.Font = Enum.Font.GothamBlack  
minBtn.TextSize = 14  
Instance.new('UICorner', minBtn).CornerRadius = UDim.new(0, 5)  
addStroke(minBtn, Color3.fromRGB(200, 50, 50), 1, 0.4)  

-- Contenedor de Botones Interactivos Grandes
local ControlFrame = Instance.new("Frame", right)
ControlFrame.Size = UDim2.new(1, -6, 1, -50)
ControlFrame.Position = UDim2.new(0, 3, 0, 45)
ControlFrame.BackgroundTransparency = 1

local function MakePremiumButton(parent, text, yPos, baseColor, height)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.96, 0, 0, height or 46)
    btn.Position = UDim2.new(0.02, 0, 0, yPos)
    btn.BackgroundColor3 = baseColor
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 12
    Instance.new('UICorner', btn).CornerRadius = UDim.new(0, 8)
    addStroke(btn, T_ACCENT, 1, 0.5)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    
    return btn
end

-- Distribución Armoniosa de Botones
local Abuse1Btn     = MakePremiumButton(ControlFrame, "MELEE ATTACK", 10, Color3.fromRGB(40, 5, 70))
local SwordBtn      = MakePremiumButton(ControlFrame, "SWORD ATTACK", 64, Color3.fromRGB(60, 5, 100))
local AutoZBtn      = MakePremiumButton(ControlFrame, "MELEE AUTO Z + RESET: OFF", 118, Color3.fromRGB(45, 10, 85))
local RespawnBtn    = MakePremiumButton(ControlFrame, "RESPAWN ABUSE: OFF", 172, Color3.fromRGB(25, 35, 65))
local VoidBtn       = MakePremiumButton(ControlFrame, "SAFE ZONE: OFF", 226, Color3.fromRGB(20, 5, 40))
local FixBtn        = MakePremiumButton(ControlFrame, "FIX CAMERA & RESET", 285, Color3.fromRGB(30, 0, 20), 40)
FixBtn.TextColor3 = T_ACCENT

-- ==========================================
--        SISTEMA DE MINIMIZADO AVANZADO
-- ==========================================
local minimized = false  
local function openMain()  
    minimized = false  
    minBtn.Text = '−'  
    Main.Visible = true  
    TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {  
        Size = UDim2.new(0, 580, 0, 410),  
        BackgroundTransparency = 0,  
    }):Play()  
end  

local function closeMain()  
    TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {  
        Size = UDim2.new(0, 580, 0, 0),  
        BackgroundTransparency = 1,  
    }):Play()  
    task.wait(0.18)  
    Main.Visible = false  
end  

minBtn.MouseButton1Click:Connect(function()  
    minimized = not minimized  
    if minimized then minBtn.Text = '+' closeMain() else openMain() end  
end)  

ToggleBtn.MouseButton1Click:Connect(function()  
    if Main.Visible then minimized = true minBtn.Text = '+' closeMain() else openMain() end  
end)  

-- Loops de Rendimiento en los labels laterales
local _fc, _fv, _fl = 0, 0, tick()  
RunService.RenderStepped:Connect(function()  
    _fc += 1  
    local n = tick()  
    if n - _fl >= 1 then _fv = _fc _fc = 0 _fl = n end  
end)  

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            local ping = math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())  
            pingLbl.Text = ping .. " ms"
            fpsLbl.Text = _fv .. " FPS"
        end)
    end
end)

-- ==========================================
--            LÓGICA DEL ENTORNO
-- ==========================================

local function Press(key)  
    VirtualInputManager:SendKeyEvent(true, key, false, game)  
    task.wait(0.01)  
    VirtualInputManager:SendKeyEvent(false, key, false, game)  
end  
  
local function DisableEverything()
    getgenv().AbuseActive = false  
    getgenv().SwordActive = false
    getgenv().SafeZoneActive = false
    getgenv().AutoZResetActive = false
    getgenv().RespawnAbuseActive = false
    Abuse1Btn.BackgroundColor3 = Color3.fromRGB(40, 5, 70)
    SwordBtn.BackgroundColor3 = Color3.fromRGB(60, 5, 100)
    AutoZBtn.BackgroundColor3 = Color3.fromRGB(45, 10, 85)
    AutoZBtn.Text = "MELEE AUTO Z + RESET: OFF"
    RespawnBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 65)
    RespawnBtn.Text = "RESPAWN ABUSE: OFF"
    VoidBtn.BackgroundColor3 = Color3.fromRGB(20, 5, 40)
    VoidBtn.Text = "SAFE ZONE: OFF"
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then  
            workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid  
            lp.Character.HumanoidRootPart.Anchored = false  
        end  
    end)
end

-- BUCLE DE CORRECCIÓN CONTINUA PARA EL SAFE ZONE PERMANENTE
task.spawn(function()
    while true do
        task.wait(0.02)
        if getgenv().SafeZoneActive then
            pcall(function()
                local character = lp.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Anchored = true
                    hrp.CFrame = targetPos
                    workspace.CurrentCamera.CFrame = targetPos
                end
            end)
        end
    end
end)

-- SISTEMA RESPAWN ABUSE AUTOMÁTICO
lp.CharacterAdded:Connect(function(newCharacter)
    if getgenv().RespawnAbuseActive then
        local hrp = newCharacter:WaitForChild("HumanoidRootPart", 5)
        local hum = newCharacter:WaitForChild("Humanoid", 5)
        if hrp and hum then
            task.wait(0.2)
            if not getgenv().SafeZoneActive then
                posicionOriginal = hrp.CFrame
            end
        end
    end
end)

-- BUCLE EXCLUSIVO: AUTO Z + RESET (MELEE ONLY) - CON DELAYS MECÁNICOS ACTUALIZADOS
task.spawn(function()
    while true do
        task.wait(0.05)
        if getgenv().AutoZResetActive and not getgenv().SafeZoneActive then
            local character = lp.Character
            local backpack = lp:FindFirstChild("Backpack")
            if character and backpack then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local hum = character:FindFirstChild("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    pcall(function()
                        local meleeTool = nil
                        for _, name in ipairs(MeleeNames) do
                            meleeTool = backpack:FindFirstChild(name) or character:FindFirstChild(name)
                            if meleeTool then break end
                        end
                        
                        if meleeTool then
                            -- 1. Equipar Melee
                            if meleeTool.Parent == backpack then
                                hum:EquipTool(meleeTool)
                            end
                            
                            -- Espera crítica para que el motor asimile que la tool está en mano antes del teletransporte
                            task.wait(0.06)
                            
                            -- 2. Congelar y parpadear a zona remota
                            hrp.Anchored = true
                            hrp.CFrame = targetPos
                            workspace.CurrentCamera.CFrame = targetPos
                            
                            -- Espera física para posicionamiento óptimo del motor antes del input
                            task.wait(0.05)
                            
                            -- 3. Envío limpio de la tecla Z
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)  
                            task.wait(0.06)  -- Duración de pulsación extendida para registro de Roblox
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)  
                            
                            -- Click complementario por si el Melee requiere activación
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.01)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            
                            -- Retraso de confirmación del daño transmitido al servidor
                            task.wait(0.18) 
                            
                            -- 4. Ejecución del suicide-reset automático
                            hum.Health = 0
                            task.wait(0.1)
                        end
                    end)
                end
            end
        end
    end
end)

-- BUCLE PRINCIPAL DE COMBATE (PARPADEO Y ATAQUE NORMAL)
task.spawn(function()
    task.wait(0.5) 
    while true do
        task.wait(0.05) 
        if (getgenv().AbuseActive or getgenv().SwordActive) and not getgenv().SafeZoneActive and not getgenv().AutoZResetActive then
            local character = lp.Character  
            local backpack = lp:FindFirstChild("Backpack")  
            
            if character and backpack then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local hum = character:FindFirstChild("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    pcall(function()
                        local weapon = nil
                        if getgenv().AbuseActive then
                            for _, name in ipairs(MeleeNames) do
                                weapon = backpack:FindFirstChild(name) or character:FindFirstChild(name)
                                if weapon then break end
                            end
                        elseif getgenv().SwordActive then
                            for _, name in ipairs(SwordNames) do
                                weapon = backpack:FindFirstChild(name) or character:FindFirstChild(name)
                                if weapon then break end
                            end
                        end
                        
                        if not weapon then
                            for _, item in ipairs(backpack:GetChildren()) do
                                if item:IsA("Tool") and not item:FindFirstChildOfClass("ScreenGui") then
                                    weapon = item
                                    break
                                end
                            end
                        end
                        
                        if weapon and weapon.Parent == backpack then
                            hum:EquipTool(weapon)
                        end
                        
                        local posicionSuelo = hrp.CFrame
                        hrp.Anchored = true  
                        hrp.CFrame = targetPos  
                        workspace.CurrentCamera.CFrame = targetPos  
                        task.wait(0.02)
                        
                        Press(Enum.KeyCode.Z)  
                        task.wait(0.01)
                        
                        for i = 1, 3 do
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)  
                            task.wait(0.01)  
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)  
                        end  
                        
                        hrp.CFrame = posicionSuelo
                        hrp.Anchored = false
                        workspace.CurrentCamera.CameraSubject = hum
                        
                        local s = tick()  
                        while tick() - s < 0.4 do RunService.Heartbeat:Wait() end
                    end)
                end
            end
        end
    end
end)

-- ACCIONES DE LOS BOTONES INTERACTIVOS
Abuse1Btn.MouseButton1Click:Connect(function()  
    getgenv().AbuseActive = not getgenv().AbuseActive  
    if getgenv().AbuseActive then 
        getgenv().SwordActive = false 
        getgenv().AutoZResetActive = false
        AutoZBtn.BackgroundColor3 = Color3.fromRGB(45, 10, 85)
        AutoZBtn.Text = "MELEE AUTO Z + RESET: OFF"
    end 
    Abuse1Btn.BackgroundColor3 = getgenv().AbuseActive and T_ACCENT or Color3.fromRGB(40, 5, 70)  
    SwordBtn.BackgroundColor3 = Color3.fromRGB(60, 5, 100)
end)  

SwordBtn.MouseButton1Click:Connect(function()  
    getgenv().SwordActive = not getgenv().SwordActive  
    if getgenv().SwordActive then 
        getgenv().AbuseActive = false 
        getgenv().AutoZResetActive = false
        AutoZBtn.BackgroundColor3 = Color3.fromRGB(45, 10, 85)
        AutoZBtn.Text = "MELEE AUTO Z + RESET: OFF"
    end 
    SwordBtn.BackgroundColor3 = getgenv().SwordActive and T_ACCENT or Color3.fromRGB(60, 5, 100)  
    Abuse1Btn.BackgroundColor3 = Color3.fromRGB(40, 5, 70)
end)  

AutoZBtn.MouseButton1Click:Connect(function()
    getgenv().AutoZResetActive = not getgenv().AutoZResetActive
    if getgenv().AutoZResetActive then
        getgenv().AbuseActive = false
        getgenv().SwordActive = false
        Abuse1Btn.BackgroundColor3 = Color3.fromRGB(40, 5, 70)
        SwordBtn.BackgroundColor3 = Color3.fromRGB(60, 5, 100)
        AutoZBtn.Text = "MELEE AUTO Z + RESET: ON"
        AutoZBtn.BackgroundColor3 = C.green
    else
        AutoZBtn.Text = "MELEE AUTO Z + RESET: OFF"
        AutoZBtn.BackgroundColor3 = Color3.fromRGB(45, 10, 85)
    end
end)

RespawnBtn.MouseButton1Click:Connect(function()
    getgenv().RespawnAbuseActive = not getgenv().RespawnAbuseActive
    if getgenv().RespawnAbuseActive then
        RespawnBtn.Text = "RESPAWN ABUSE: ON"
        RespawnBtn.BackgroundColor3 = C.green
    else
        RespawnBtn.Text = "RESPAWN ABUSE: OFF"
        RespawnBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 65)
    end
end)
  
VoidBtn.MouseButton1Click:Connect(function()
    local char = lp.Character  
    local hrp = char and char:FindFirstChild("HumanoidRootPart")  
    
    if not hrp then return end
    
    getgenv().SafeZoneActive = not getgenv().SafeZoneActive
    
    if getgenv().SafeZoneActive then
        posicionOriginal = hrp.CFrame
        VoidBtn.Text = "SAFE ZONE: ON"
        VoidBtn.BackgroundColor3 = C.green
        
        hrp.Anchored = true
        hrp.CFrame = targetPos
        workspace.CurrentCamera.CFrame = targetPos
    else
        VoidBtn.Text = "SAFE ZONE: OFF"
        VoidBtn.BackgroundColor3 = Color3.fromRGB(20, 5, 40)
        
        pcall(function()
            hrp.Anchored = false
            if posicionOriginal then
                hrp.CFrame = posicionOriginal
                workspace.CurrentCamera.CameraSubject = char.Humanoid
            end
        end)
    end
end)  
  
FixBtn.MouseButton1Click:Connect(DisableEverything)  
  
-- Sistema de Arrastre Avanzado de Ventana (Compatibilidad Total)
local d, ds, sp  
headerBar.InputBegan:Connect(function(i)  
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then  
        d = true ds = i.Position sp = Main.Position  
    end  
end)  
UserInputService.InputChanged:Connect(function(i)  
    if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then  
        local delta = i.Position - ds  
        Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)  
    end  
end)  
UserInputService.InputEnded:Connect(function(i)  
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end  
end)
