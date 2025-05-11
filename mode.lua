
---

# 📄 `ModMenu.lua` (o script principal)

```lua
--// W.W.Silva Mod Menu

local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- ESP
local espFolder = Instance.new("Folder", workspace)
espFolder.Name = "ESPFolder"

local function criarESP(target)
    if target:FindFirstChild("HumanoidRootPart") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = target.HumanoidRootPart
        billboard.Size = UDim2.new(4,0,4,0)
        billboard.AlwaysOnTop = true

        local frame = Instance.new("Frame", billboard)
        frame.Size = UDim2.new(1,0,1,0)
        frame.BackgroundColor3 = Color3.new(1,0,0)
        frame.BackgroundTransparency = 0.4

        billboard.Parent = espFolder
    end
end

local function limparESP()
    for _, obj in pairs(espFolder:GetChildren()) do
        obj:Destroy()
    end
end

-- SpeedHack
local function speedHack()
    local humanoid = player.Character:WaitForChild("Humanoid")
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        humanoid.WalkSpeed = 100
    end)
    humanoid.WalkSpeed = 100
end

-- Teleport
local function teleportarParaOutro()
    local players = game.Players:GetPlayers()
    for _, p in pairs(players) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            player.Character:MoveTo(p.Character.HumanoidRootPart.Position + Vector3.new(0,5,0))
            break
        end
    end
end

-- KillAura
local function killAura()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v ~= player.Character then
            if (v.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                v:FindFirstChildOfClass("Humanoid").Health = 0
            end
        end
    end
end

-- Aimbot
local function encontrarAlvo()
    local players = game.Players:GetPlayers()
    local closest = nil
    local minDistance = math.huge
    for _, p in pairs(players) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (camera.CFrame.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closest = p
            end
        end
    end
    return closest
end

local function aimbot()
    local target = encontrarAlvo()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
    end
end

-- Kick All
local function kickAll()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            p:Kick("W.W.Silva está na casa 🔥")
        end
    end
end

--// BOTÕES (console)
print("[Mod Menu W.W.Silva Loaded]")
print("[1] ESP Ligado")
print("[2] SpeedHack Ligado")
print("[3] Teleport para jogador")
print("[4] KillAura Ativo")
print("[5] Aimbot Ativo")
print("[6] KickAll Executado")

--// Funções ativas automáticas

-- ESP sempre on
runService.Heartbeat:Connect(function()
    limparESP()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v ~= player.Character then
            criarESP(v)
        end
    end
end)

-- SpeedHack on
speedHack()

-- KillAura loop
runService.Heartbeat:Connect(function()
    killAura()
end)

-- Aimbot loop
runService.RenderStepped:Connect(function()
    aimbot()
end)

-- Kick All (executa 1x)
kickAll()
