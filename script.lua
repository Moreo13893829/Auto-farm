--[[
    ⚡⚡⚡ AUTO FARM ULTIME - TELEPORT + SPAM ⚡⚡⚡
    Se téléporte sur les joueurs et spam toutes les attaques
    Jujutsu Shenanigans
    Version: 4.0
]]

-- Attendre le chargement
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

-- Détection mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Variables
local farmEnabled = false
local minimized = false
local currentTarget = nil
local killCount = 0
local localPlayer = game.Players.LocalPlayer
local attackSpam = true
local tpDistance = 5 -- Distance de téléportation

-- Dossier ESP
local farmESP = Instance.new("Folder")
farmESP.Name = "FarmUltime_" .. tostring(math.random(1000, 9999))
farmESP.Parent = CoreGui

-- Interface magnifique
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFarmUltime_" .. tostring(math.random(1000, 9999))
gui.ResetOnSpawn = false
gui.Parent = CoreGui

--------------------------------------------------------------------
-- INTERFACE ULTRA LUXE
--------------------------------------------------------------------

-- MAIN FRAME
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

-- Animation d'apparition
mainFrame.Size = UDim2.new(0, 370, 0, 240)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 350, 0, 220)
}):Play()

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

-- Bordure néon violette (style téléportation)
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
mainBorderGradient.Rotation = 0
mainBorderGradient.Parent = mainBorder

-- Animation bordure
task.spawn(function()
    while mainFrame do
        mainBorderGradient.Rotation = (mainBorderGradient.Rotation + 1) % 360
        task.wait(0.02)
    end
end)

-- Glass effect
local mainGlass = Instance.new("Frame")
mainGlass.Size = UDim2.new(1, -4, 1, -4)
mainGlass.Position = UDim2.new(0, 2, 0, 2)
mainGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainGlass.BackgroundTransparency = 0.96
mainGlass.BorderSizePixel = 0
mainGlass.Parent = mainFrame

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 18)
glassCorner.Parent = mainGlass

-- Ombre
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(-0.05, -15, -0.05, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(40, 5, 40)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = header

-- Icône de téléportation
local tpIcon = Instance.new("TextLabel")
tpIcon.Size = UDim2.new(0, 30, 0, 30)
tpIcon.Position = UDim2.new(0, 15, 0.5, -15)
tpIcon.BackgroundTransparency = 1
tpIcon.Text = "🌀"
tpIcon.TextColor3 = Color3.fromRGB(150, 100, 255)
tpIcon.Font = Enum.Font.GothamBold
tpIcon.TextSize = 22
tpIcon.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0, 200, 1, 0)
headerTitle.Position = UDim2.new(0, 50, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "FARM ULTIME"
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 18
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = header

local headerSub = Instance.new("TextLabel")
headerSub.Size = UDim2.new(0, 200, 0, 15)
headerSub.Position = UDim2.new(0, 50, 0, 30)
headerSub.BackgroundTransparency = 1
headerSub.Text = "TP + Spam toutes les attaques"
headerSub.TextColor3 = Color3.fromRGB(180, 180, 220)
headerSub.Font = Enum.Font.Gotham
headerSub.TextSize = 10
headerSub.TextXAlignment = Enum.TextXAlignment.Left
headerSub.Parent = header

-- Bouton minimiser
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 80)
minBtn.BackgroundTransparency = 0.3
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 20
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

-- STATS CARD
local statsCard = Instance.new("Frame")
statsCard.Size = UDim2.new(1, -30, 0, 70)
statsCard.Position = UDim2.new(0, 15, 0, 65)
statsCard.BackgroundColor3 = Color3.fromRGB(30, 10, 30)
statsCard.BackgroundTransparency = 0.2
statsCard.BorderSizePixel = 0
statsCard.Parent = mainFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 12)
statsCorner.Parent = statsCard

-- Point de statut
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 14, 0, 14)
statusDot.Position = UDim2.new(0, 15, 0.5, -7)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
statusDot.BorderSizePixel = 0
statusDot.Parent = statsCard

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

local dotGlow = Instance.new("Frame")
dotGlow.Size = UDim2.new(1, 6, 1, 6)
dotGlow.Position = UDim2.new(-0.2, -3, -0.2, -3)
dotGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
dotGlow.BackgroundTransparency = 0.6
dotGlow.BorderSizePixel = 0
dotGlow.Parent = statusDot

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(1, 0)
glowCorner.Parent = dotGlow

-- Texte statut
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 100, 0, 20)
statusLabel.Position = UDim2.new(0, 40, 0, 8)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "STATUT"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statsCard

local statusValue = Instance.new("TextLabel")
statusValue.Size = UDim2.new(0, 100, 0, 25)
statusValue.Position = UDim2.new(0, 40, 0, 28)
statusValue.BackgroundTransparency = 1
statusValue.Text = "INACTIF"
statusValue.TextColor3 = Color3.fromRGB(255, 100, 100)
statusValue.Font = Enum.Font.GothamBold
statusValue.TextSize = 16
statusValue.TextXAlignment = Enum.TextXAlignment.Left
statusValue.Parent = statsCard

-- COMPTEUR DE KILLS
local killsCard = Instance.new("Frame")
killsCard.Size = UDim2.new(0, 80, 0, 50)
killsCard.Position = UDim2.new(1, -95, 0.5, -25)
killsCard.BackgroundColor3 = Color3.fromRGB(80, 20, 80)
killsCard.BackgroundTransparency = 0.2
killsCard.BorderSizePixel = 0
killsCard.Parent = statsCard

local killsCorner = Instance.new("UICorner")
killsCorner.CornerRadius = UDim.new(0, 10)
killsCorner.Parent = killsCard

local killsIcon = Instance.new("TextLabel")
killsIcon.Size = UDim2.new(1, 0, 0, 25)
killsIcon.Position = UDim2.new(0, 0, 0, 2)
killsIcon.BackgroundTransparency = 1
killsIcon.Text = "💀"
killsIcon.TextColor3 = Color3.fromRGB(200, 100, 255)
killsIcon.Font = Enum.Font.GothamBold
killsIcon.TextSize = 20
killsIcon.Parent = killsCard

local killsNumber = Instance.new("TextLabel")
killsNumber.Size = UDim2.new(1, 0, 0, 20)
killsNumber.Position = UDim2.new(0, 0, 0, 25)
killsNumber.BackgroundTransparency = 1
killsNumber.Text = "0"
killsNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
killsNumber.Font = Enum.Font.GothamBold
killsNumber.TextSize = 16
killsNumber.Parent = killsCard

-- INFO TELEPORTATION
local tpInfo = Instance.new("TextLabel")
tpInfo.Size = UDim2.new(1, -30, 0, 20)
tpInfo.Position = UDim2.new(0, 15, 0, 145)
tpInfo.BackgroundTransparency = 1
tpInfo.Text = "🌀 Téléportation automatique sur les ennemis"
tpInfo.TextColor3 = Color3.fromRGB(180, 150, 255)
tpInfo.Font = Enum.Font.Gotham
tpInfo.TextSize = 11
tpInfo.Parent = mainFrame

-- BOUTON PRINCIPAL
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(0.8, 0, 0, 40)
mainBtn.Position = UDim2.new(0.1, 0, 0, 175)
mainBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
mainBtn.BorderSizePixel = 0
mainBtn.Text = ""
mainBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 20)
btnCorner.Parent = mainBtn

-- Effet brillant
local btnShine = Instance.new("Frame")
btnShine.Size = UDim2.new(1, 0, 0.3, 0)
btnShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btnShine.BackgroundTransparency = 0.7
btnShine.BorderSizePixel = 0
btnShine.Parent = mainBtn

local shineCorner = Instance.new("UICorner")
shineCorner.CornerRadius = UDim.new(0, 20)
shineCorner.Parent = btnShine

local btnText = Instance.new("TextLabel")
btnText.Size = UDim2.new(1, 0, 1, 0)
btnText.BackgroundTransparency = 1
btnText.Text = "ACTIVER LE FARM ULTIME"
btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
btnText.Font = Enum.Font.GothamBold
btnText.TextSize = 14
btnText.Parent = mainBtn

-- BOUTON FERMER
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 80)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- FRAME MINIMISÉ
local minFrame = Instance.new("Frame")
minFrame.Size = UDim2.new(0, 140, 0, 45)
minFrame.Position = mainFrame.Position
minFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
minFrame.BackgroundTransparency = 0.1
minFrame.BorderSizePixel = 0
minFrame.Visible = false
minFrame.Active = true
minFrame.Draggable = true
minFrame.Parent = gui

local minFrameCorner = Instance.new("UICorner")
minFrameCorner.CornerRadius = UDim.new(0, 15)
minFrameCorner.Parent = minFrame

local minFrameBorder = Instance.new("Frame")
minFrameBorder.Size = UDim2.new(1, 6, 1, 6)
minFrameBorder.Position = UDim2.new(-0.02, -3, -0.02, -3)
minFrameBorder.BackgroundTransparency = 1
minFrameBorder.Parent = minFrame

local minBorderGradient = Instance.new("UIGradient")
minBorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
})
minBorderGradient.Rotation = 0
minBorderGradient.Parent = minFrameBorder

task.spawn(function()
    while minFrame do
        minBorderGradient.Rotation = (minBorderGradient.Rotation + 1) % 360
        task.wait(0.02)
    end
end)

local minIcon = Instance.new("TextLabel")
minIcon.Size = UDim2.new(0, 30, 1, 0)
minIcon.Position = UDim2.new(0, 8, 0, 0)
minIcon.BackgroundTransparency = 1
minIcon.Text = "🌀"
minIcon.TextColor3 = Color3.fromRGB(150, 100, 255)
minIcon.Font = Enum.Font.GothamBold
minIcon.TextSize = 20
minIcon.Parent = minFrame

local minText = Instance.new("TextLabel")
minText.Size = UDim2.new(0, 60, 1, 0)
minText.Position = UDim2.new(0, 40, 0, 0)
minText.BackgroundTransparency = 1
minText.Text = "FARM"
minText.TextColor3 = Color3.fromRGB(255, 255, 255)
minText.Font = Enum.Font.GothamBold
minText.TextSize = 12
minText.TextXAlignment = Enum.TextXAlignment.Left
minText.Parent = minFrame

local minKills = Instance.new("TextLabel")
minKills.Size = UDim2.new(0, 30, 1, 0)
minKills.Position = UDim2.new(1, -30, 0, 0)
minKills.BackgroundTransparency = 1
minKills.Text = "0"
minKills.TextColor3 = Color3.fromRGB(255, 215, 0)
minKills.Font = Enum.Font.GothamBold
minKills.TextSize = 14
minKills.Parent = minFrame

local minDot = Instance.new("Frame")
minDot.Size = UDim2.new(0, 8, 0, 8)
minDot.Position = UDim2.new(1, -12, 0.5, -4)
minDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minDot.BorderSizePixel = 0
minDot.Parent = minFrame

local minDotCorner = Instance.new("UICorner")
minDotCorner.CornerRadius = UDim.new(1, 0)
minDotCorner.Parent = minDot

local restoreBtn = Instance.new("TextButton")
restoreBtn.Size = UDim2.new(1, 0, 1, 0)
restoreBtn.BackgroundTransparency = 1
restoreBtn.Text = ""
restoreBtn.Parent = minFrame

-- Rendre draggable
local function makeDraggable(frame)
    local dragging = false
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(mainFrame)
makeDraggable(minFrame)

--------------------------------------------------------------------
-- FONCTIONS DE TÉLÉPORTATION ET COMBAT
--------------------------------------------------------------------

-- Trouver tous les joueurs ennemis
local function getEnemyPlayers()
    local enemies = {}
    local character = localPlayer.Character
    if not character then return enemies end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(enemies, player.Character)
            end
        end
    end
    return enemies
end

-- Fonction de téléportation derrière la cible
local function teleportBehindTarget(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return false end
    
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    local targetRoot = target.HumanoidRootPart
    local myRoot = character.HumanoidRootPart
    
    -- Calculer la direction
    local targetPos = targetRoot.Position
    local targetForward = targetRoot.CFrame.LookVector
    
    -- Position derrière la cible (dans son dos)
    local behindPos = targetPos - targetForward * 8
    
    -- Téléportation instantanée
    myRoot.CFrame = CFrame.new(behindPos) * CFrame.Angles(0, math.rad(180), 0)
    
    -- Effet visuel (optionnel)
    local teleportEffect = Instance.new("Attachment")
    teleportEffect.Parent = myRoot
    wait(0.1)
    teleportEffect:Destroy()
    
    return true
end

-- Spam TOUTES les attaques possibles
local function spamAllAttacks()
    -- Liste de toutes les touches d'attaque dans Jujutsu Shenanigans
    local attacks = {
        -- Attaques de base
        {key = Enum.KeyCode.MouseButton1, type = "mouse"}, -- Coup de poing
        {key = Enum.KeyCode.MouseButton2, type = "mouse"}, -- Coup de pied
        
        -- Compétences principales
        {key = Enum.KeyCode.Q, type = "key"}, -- Lapse Blue / Skill 1
        {key = Enum.KeyCode.E, type = "key"}, -- Red / Skill 2
        {key = Enum.KeyCode.R, type = "key"}, -- Black Flash / Ultimate
        {key = Enum.KeyCode.T, type = "key"}, -- Rapid Punches / Skill 3
        {key = Enum.KeyCode.Y, type = "key"}, -- Reversal / Skill 4
        {key = Enum.KeyCode.F, type = "key"}, -- Parry / Skill spécial
        {key = Enum.KeyCode.G, type = "key"}, -- Skill 5 (si existe)
        {key = Enum.KeyCode.H, type = "key"}, -- Skill 6 (si existe)
        
        -- Compétences de mouvement
        {key = Enum.KeyCode.LeftShift, type = "key"}, -- Dash
        {key = Enum.KeyCode.Space, type = "key"}, -- Saut / Air combo
    }
    
    -- Spam toutes les attaques rapidement
    for i = 1, 3 do -- 3 cycles de spam
        for _, attack in ipairs(attacks) do
            if attack.type == "mouse" then
                -- Attaque souris
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, attack.key == Enum.KeyCode.MouseButton1 and 1 or 2)
                wait(0.02)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, attack.key == Enum.KeyCode.MouseButton1 and 1 or 2)
            else
                -- Attaque clavier
                VirtualInputManager:SendKeyEvent(true, attack.key, false, game)
                wait(0.02)
                VirtualInputManager:SendKeyEvent(false, attack.key, false, game)
            end
            wait(0.03)
        end
        wait(0.1)
    end
end

-- Vérifier si la cible est morte
local function isTargetDead(target)
    if not target then return true end
    local humanoid = target:FindFirstChildOfClass("Humanoid")
    return not humanoid or humanoid.Health <= 0
end

-- Boucle principale de farm
local function farmLoop()
    while farmEnabled do
        local enemies = getEnemyPlayers()
        
        if #enemies > 0 then
            -- Choisir une cible (la plus proche)
            local character = localPlayer.Character
            local bestTarget = nil
            local bestDist = math.huge
            
            if character and character:FindFirstChild("HumanoidRootPart") then
                local myPos = character.HumanoidRootPart.Position
                
                for _, enemy in ipairs(enemies) do
                    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                        local dist = (myPos - enemy.HumanoidRootPart.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            bestTarget = enemy
                        end
                    end
                end
            end
            
            if bestTarget then
                currentTarget = bestTarget
                
                -- Mettre un ESP sur la cible
                for _, v in pairs(farmESP:GetChildren()) do v:Destroy() end
                
                local highlight = Instance.new("Highlight")
                highlight.Adornee = bestTarget
                highlight.FillColor = Color3.fromRGB(200, 0, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.3
                highlight.Parent = farmESP
                
                -- Se téléporter derrière la cible
                teleportBehindTarget(bestTarget)
                wait(0.1)
                
                -- Spam toutes les attaques
                spamAllAttacks()
                wait(0.2)
                
                -- Vérifier si la cible est morte
                if isTargetDead(bestTarget) then
                    killCount = killCount + 1
                    killsNumber.Text = tostring(killCount)
                    minKills.Text = tostring(killCount)
                    
                    -- Effet de kill
                    for i = 1, 3 do
                        statusDot.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        dotGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        wait(0.05)
                        statusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
                        dotGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
                        wait(0.05)
                    end
                    
                    -- Chercher directement une nouvelle cible
                    wait(0.1)
                end
            else
                wait(0.1)
            end
        else
            -- Pas d'ennemis, attendre
            for _, v in pairs(farmESP:GetChildren()) do v:Destroy() end
            currentTarget = nil
            wait(0.5)
        end
    end
    
    -- Nettoyage
    for _, v in pairs(farmESP:GetChildren()) do v:Destroy() end
end

-- Toggle farm
local function toggleFarm()
    farmEnabled = not farmEnabled
    
    if farmEnabled then
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        dotGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        statusValue.Text = "ACTIF"
        statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        minDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        btnText.Text = "DÉSACTIVER LE FARM"
        mainBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 200)
        
        -- Démarrer le farm
        task.spawn(farmLoop)
    else
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        dotGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        statusValue.Text = "INACTIF"
        statusValue.TextColor3 = Color3.fromRGB(255, 100, 100)
        minDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        btnText.Text = "ACTIVER LE FARM ULTIME"
        mainBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
        
        -- Nettoyer
        for _, v in pairs(farmESP:GetChildren()) do v:Destroy() end
        currentTarget = nil
    end
end

-- Minimiser/Restaurer
local function toggleMinimize()
    minimized = not minimized
    if minimized then
        minFrame.Position = mainFrame.Position
        mainFrame.Visible = false
        minFrame.Visible = true
        minBtn.Text = "□"
    else
        mainFrame.Position = minFrame.Position
        minFrame.Visible = false
        mainFrame.Visible = true
        minBtn.Text = "−"
    end
end

minBtn.MouseButton1Click:Connect(toggleMinimize)
restoreBtn.MouseButton1Click:Connect(function()
    minimized = false
    mainFrame.Position = minFrame.Position
    minFrame.Visible = false
    mainFrame.Visible = true
    minBtn.Text = "−"
end)

mainBtn.MouseButton1Click:Connect(toggleFarm)
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.8, 0),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(minFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.8, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.3)
    gui:Destroy()
    farmESP:Destroy()
end)

-- Raccourci V
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        toggleFarm()
    end
end)

-- Effets de survol
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 60, 120)}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 40, 80)}):Play()
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 60, 120)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 40, 80)}):Play()
end)

print("🌀 FARM ULTIME chargé !")
print("⚔️ Téléportation + Spam de toutes les attaques")
print("💀 Change automatiquement de cible après chaque kill")
print("⌨️ Raccourci: V")
