--[[
    ⚡⚡⚡ AUTO FARM ULTIME - TELEPORT + SPAM (V4.2) ⚡⚡⚡
    Jujutsu Shenanigans - Mêlée & Full Spam Edition
]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local localPlayer = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Variables
local farmEnabled = false
local minimized = false
local currentTarget = nil
local killCount = 0
local stickConnection = nil

-- Nettoyage ancien GUI
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name:find("AutoFarmUltime_") or v.Name:find("FarmUltime_") then
        v:Destroy()
    end
end

local farmESP = Instance.new("Folder")
farmESP.Name = "FarmUltime_" .. tostring(math.random(1000, 9999))
farmESP.Parent = CoreGui

local gui = Instance.new("ScreenGui")
gui.Name = "AutoFarmUltime_" .. tostring(math.random(1000, 9999))
gui.ResetOnSpawn = false
gui.Parent = CoreGui

--------------------------------------------------------------------
-- INTERFACE ULTRA LUXE
--------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.8, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

local mainBorder = Instance.new("Frame")
mainBorder.Size = UDim2.new(1, 10, 1, 10)
mainBorder.Position = UDim2.new(-0.02, -5, -0.02, -5)
mainBorder.BackgroundTransparency = 1
mainBorder.Parent = mainFrame

local mainBorderGradient = Instance.new("UIGradient")
mainBorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(100, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
})
mainBorderGradient.Parent = mainBorder

task.spawn(function()
    while mainFrame do
        mainBorderGradient.Rotation = (mainBorderGradient.Rotation + 1) % 360
        task.wait(0.02)
    end
end)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(40, 5, 40)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 20)

local tpIcon = Instance.new("TextLabel", header)
tpIcon.Size = UDim2.new(0, 30, 0, 30); tpIcon.Position = UDim2.new(0, 15, 0.5, -15)
tpIcon.BackgroundTransparency = 1; tpIcon.Text = "🌀"; tpIcon.TextColor3 = Color3.fromRGB(150, 100, 255)
tpIcon.Font = Enum.Font.GothamBold; tpIcon.TextSize = 22

local headerTitle = Instance.new("TextLabel", header)
headerTitle.Size = UDim2.new(0, 200, 1, 0); headerTitle.Position = UDim2.new(0, 50, 0, 0)
headerTitle.BackgroundTransparency = 1; headerTitle.Text = "FARM ULTIME (V4.2)"
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255); headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 16; headerTitle.TextXAlignment = Enum.TextXAlignment.Left

local headerSub = Instance.new("TextLabel", header)
headerSub.Size = UDim2.new(0, 200, 0, 15); headerSub.Position = UDim2.new(0, 50, 0, 30)
headerSub.BackgroundTransparency = 1; headerSub.Text = "Corps-à-corps + Full Spam"
headerSub.TextColor3 = Color3.fromRGB(180, 180, 220); headerSub.Font = Enum.Font.Gotham
headerSub.TextSize = 10; headerSub.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 30, 0, 30); minBtn.Position = UDim2.new(1, -40, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 80); minBtn.BackgroundTransparency = 0.3
minBtn.Text = "−"; minBtn.TextColor3 = Color3.fromRGB(255, 255, 255); minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 20
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

local statsCard = Instance.new("Frame", mainFrame)
statsCard.Size = UDim2.new(1, -30, 0, 70); statsCard.Position = UDim2.new(0, 15, 0, 65)
statsCard.BackgroundColor3 = Color3.fromRGB(30, 10, 30); statsCard.BackgroundTransparency = 0.2; statsCard.BorderSizePixel = 0
Instance.new("UICorner", statsCard).CornerRadius = UDim.new(0, 12)

local statusDot = Instance.new("Frame", statsCard)
statusDot.Size = UDim2.new(0, 14, 0, 14); statusDot.Position = UDim2.new(0, 15, 0.5, -7)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0); statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel", statsCard)
statusLabel.Size = UDim2.new(0, 100, 0, 20); statusLabel.Position = UDim2.new(0, 40, 0, 8)
statusLabel.BackgroundTransparency = 1; statusLabel.Text = "STATUT"; statusLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
statusLabel.Font = Enum.Font.Gotham; statusLabel.TextSize = 11; statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local statusValue = Instance.new("TextLabel", statsCard)
statusValue.Size = UDim2.new(0, 100, 0, 25); statusValue.Position = UDim2.new(0, 40, 0, 28)
statusValue.BackgroundTransparency = 1; statusValue.Text = "INACTIF"; statusValue.TextColor3 = Color3.fromRGB(255, 100, 100)
statusValue.Font = Enum.Font.GothamBold; statusValue.TextSize = 16; statusValue.TextXAlignment = Enum.TextXAlignment.Left

local killsCard = Instance.new("Frame", statsCard)
killsCard.Size = UDim2.new(0, 80, 0, 50); killsCard.Position = UDim2.new(1, -95, 0.5, -25)
killsCard.BackgroundColor3 = Color3.fromRGB(80, 20, 80); killsCard.BackgroundTransparency = 0.2; killsCard.BorderSizePixel = 0
Instance.new("UICorner", killsCard).CornerRadius = UDim.new(0, 10)

local killsNumber = Instance.new("TextLabel", killsCard)
killsNumber.Size = UDim2.new(1, 0, 1, 0); killsNumber.BackgroundTransparency = 1
killsNumber.Text = "💀 0"; killsNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
killsNumber.Font = Enum.Font.GothamBold; killsNumber.TextSize = 16

local mainBtn = Instance.new("TextButton", mainFrame)
mainBtn.Size = UDim2.new(0.8, 0, 0, 40); mainBtn.Position = UDim2.new(0.1, 0, 0, 150)
mainBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150); mainBtn.BorderSizePixel = 0
mainBtn.Text = "ACTIVER LE FARM ULTIME"; mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainBtn.Font = Enum.Font.GothamBold; mainBtn.TextSize = 14
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 20)

--------------------------------------------------------------------
-- FONCTIONS OPTIMISÉES (SPAM + DISTANCE)
--------------------------------------------------------------------

-- Vérifie si la cible est valide (En vie ET pas de ForceField)
local function isValidTarget(targetChar)
    if not targetChar then return false end
    local hum = targetChar:FindFirstChildOfClass("Humanoid")
    local root = targetChar:FindFirstChild("HumanoidRootPart")
    local ff = targetChar:FindFirstChildOfClass("ForceField")
    
    return hum and hum.Health > 0 and root and not ff
end

-- Trouver l'ennemi le plus proche valide
local function getBestEnemy()
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myPos = char.HumanoidRootPart.Position
    local bestTarget = nil
    local bestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and isValidTarget(player.Character) then
            local dist = (myPos - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestTarget = player.Character
            end
        end
    end
    return bestTarget
end

-- Spam ABSOLUMENT TOUTES les attaques (NOUVEAU)
local function spamAttacks()
    -- Clics souris (Attaques de base / Brise garde)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1) -- Clic Gauche
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 2) -- Clic Droit
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 2)
    
    -- Toutes les touches possibles dans JJS
    local keys = {
        Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, -- Compétences 1,2,3,4
        Enum.KeyCode.Q, Enum.KeyCode.E, Enum.KeyCode.R, Enum.KeyCode.T,            -- Anciennes touches
        Enum.KeyCode.F, Enum.KeyCode.G, Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C -- Garde, Ulti, Dash
    }
    
    for _, key in ipairs(keys) do
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.005) -- Très rapide pour spammer sans tout bloquer
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end
end

-- Boucle Principale
local function farmLoop()
    while farmEnabled do
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        -- Si on est mort, on met en pause
        if not hum or hum.Health <= 0 then
            statusValue.Text = "EN ATTENTE..."
            task.wait(2)
            continue
        end
        
        if statusValue.Text == "EN ATTENTE..." then statusValue.Text = "ACTIF" end

        -- Chercher une cible
        if not currentTarget or not isValidTarget(currentTarget) then
            currentTarget = getBestEnemy()
            
            if currentTarget then
                farmESP:ClearAllChildren()
                local hl = Instance.new("Highlight", farmESP)
                hl.Adornee = currentTarget; hl.FillColor = Color3.fromRGB(200, 0, 255)
            end
        end

        -- Combat
        if currentTarget and isValidTarget(currentTarget) then
            spamAttacks()
            task.wait(0.05) -- Tire encore plus vite !
        else
            farmESP:ClearAllChildren()
            task.wait(0.5)
        end
    end
end

--------------------------------------------------------------------
-- CONTRÔLES DU GUI
--------------------------------------------------------------------

local function toggleFarm()
    farmEnabled = not farmEnabled
    
    if farmEnabled then
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        statusValue.Text = "ACTIF"
        statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        mainBtn.Text = "DÉSACTIVER LE FARM"
        mainBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 200)
        
        -- AUTO-LOCK : Maintient le perso à 1.5 mètre dans le dos de la cible (Très proche)
        stickConnection = RunService.Heartbeat:Connect(function()
            if farmEnabled and currentTarget and isValidTarget(currentTarget) then
                local myChar = localPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local myRoot = myChar.HumanoidRootPart
                    local tRoot = currentTarget.HumanoidRootPart
                    
                    -- CHANGEMENT ICI : Distance 1.5 au lieu de 4
                    local behindPos = tRoot.Position - (tRoot.CFrame.LookVector * 1.5)
                    myRoot.CFrame = CFrame.lookAt(behindPos, tRoot.Position)
                end
            end
        end)
        
        task.spawn(farmLoop)
    else
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        statusValue.Text = "INACTIF"
        statusValue.TextColor3 = Color3.fromRGB(255, 100, 100)
        mainBtn.Text = "ACTIVER LE FARM ULTIME"
        mainBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
        
        if stickConnection then stickConnection:Disconnect(); stickConnection = nil end
        farmESP:ClearAllChildren()
        currentTarget = nil
    end
end

mainBtn.MouseButton1Click:Connect(toggleFarm)

-- Raccourci V
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        toggleFarm()
    end
end)

print("🌀 FARM ULTIME v4.2 Chargé !")
print("✅ Corps-à-corps (1.5 studs) + Tous les clics/touches spammés.")
