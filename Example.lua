local CrustUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MermiXO/CrustUI/refs/heads/main/CrustUI%20Source.lua"))()

local Window = CrustUI:CreateWindow({
    Name = "CrustUI Demo 🍞",
    Size = UDim2.new(0, 600, 0, 450)
})

local MainTab = Window:CreateTab("Main", "🏠")
local PlayerTab = Window:CreateTab("Player", "👤")
local VisualsTab = Window:CreateTab("Visuals", "👁")
local SettingsTab = Window:CreateTab("Settings", "⚙")

MainTab:AddLabel("Welcome to CrustUI! 🍞")

MainTab:AddButton("Show Notification", function()
    Window:Notify("Success!", "This is a test notification", 3)
    print("Notification shown!")
end)

MainTab:AddButton("Print Hello World", function()
    print("Hello World from CrustUI!")
end)

local toggle1 = MainTab:AddToggle("Enable Feature", false, function(value)
    print("Feature toggled:", value)
    if value then
        Window:Notify("Enabled", "Feature has been enabled", 2)
    else
        Window:Notify("Disabled", "Feature has been disabled", 2)
    end
end)

MainTab:AddLabel("Game Information")

MainTab:AddButton("Copy Game ID", function()
    setclipboard(tostring(game.PlaceId))
    Window:Notify("Copied!", "Game ID copied to clipboard", 2)
end)

MainTab:AddButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

PlayerTab:AddLabel("Player Controls")

local walkspeedSlider = PlayerTab:AddSlider("Walk Speed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("Walk Speed set to:", value)
end)

local jumpPowerSlider = PlayerTab:AddSlider("Jump Power", 50, 300, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    print("Jump Power set to:", value)
end)

local gravitySlider = PlayerTab:AddSlider("Gravity", 50, 196.2, 196.2, function(value)
    workspace.Gravity = value
    print("Gravity set to:", value)
end)

PlayerTab:AddToggle("Infinite Jump", false, function(value)
    getgenv().InfiniteJump = value
    if value then
        print("Infinite Jump enabled")
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if getgenv().InfiniteJump then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    else
        print("Infinite Jump disabled")
    end
end)

PlayerTab:AddToggle("Noclip", false, function(value)
    getgenv().Noclip = value
    if value then
        print("Noclip enabled")
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().Noclip and game.Players.LocalPlayer.Character then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        print("Noclip disabled")
        if game.Players.LocalPlayer.Character then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

PlayerTab:AddButton("Reset Character", function()
    game.Players.LocalPlayer.Character:BreakJoints()
    Window:Notify("Reset", "Character has been reset", 2)
end)

VisualsTab:AddLabel("Visual Settings")

local fovSlider = VisualsTab:AddSlider("Field of View", 30, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
    print("FOV set to:", value)
end)

local brightnessSlider = VisualsTab:AddSlider("Brightness", 0, 5, 1, function(value)
    game.Lighting.Brightness = value
    print("Brightness set to:", value)
end)

local timeDropdown = VisualsTab:AddDropdown("Time of Day", {
    "Morning",
    "Noon", 
    "Evening",
    "Night",
    "Custom"
}, "Noon", function(option)
    local times = {
        ["Morning"] = "06:00:00",
        ["Noon"] = "12:00:00",
        ["Evening"] = "18:00:00",
        ["Night"] = "00:00:00",
        ["Custom"] = "14:00:00"
    }
    game.Lighting.TimeOfDay = times[option]
    print("Time set to:", option)
    Window:Notify("Time Changed", "Time of day set to " .. option, 2)
end)

local weatherDropdown = VisualsTab:AddDropdown("Weather", {
    "Clear",
    "Cloudy",
    "Rainy",
    "Foggy"
}, "Clear", function(option)
    if option == "Clear" then
        game.Lighting.FogEnd = 100000
        game.Lighting.FogStart = 100000
    elseif option == "Cloudy" then
        game.Lighting.FogEnd = 5000
        game.Lighting.FogStart = 100
        game.Lighting.FogColor = Color3.fromRGB(150, 150, 150)
    elseif option == "Rainy" then
        game.Lighting.FogEnd = 1000
        game.Lighting.FogStart = 0
        game.Lighting.FogColor = Color3.fromRGB(100, 100, 120)
    elseif option == "Foggy" then
        game.Lighting.FogEnd = 300
        game.Lighting.FogStart = 0
        game.Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    end
    print("Weather set to:", option)
end)

VisualsTab:AddToggle("Fullbright", false, function(value)
    if value then
        game.Lighting.Brightness = 2
        game.Lighting.GlobalShadows = false
        game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        print("Fullbright enabled")
    else
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = true
        game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        print("Fullbright disabled")
    end
end)

VisualsTab:AddToggle("ESP Boxes", false, function(value)
    getgenv().ESPEnabled = value
    if value then
        print("ESP enabled")
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
            end
        end
    else
        print("ESP disabled")
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

SettingsTab:AddLabel("Configuration")

local usernameTextbox = SettingsTab:AddTextbox("Username", "Enter username...", function(text, enterPressed)
    if enterPressed then
        print("Username set to:", text)
        Window:Notify("Username", "Username changed to: " .. text, 3)
    end
end)

local prefixTextbox = SettingsTab:AddTextbox("Command Prefix", "Enter prefix...", function(text, enterPressed)
    if text ~= "" then
        print("Prefix set to:", text)
        getgenv().CommandPrefix = text
    end
end)

SettingsTab:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(key, isPressed)
    if isPressed then
        print("UI Toggle key pressed:", key.Name)
    end
end)

SettingsTab:AddKeybind("Panic Key", Enum.KeyCode.End, function(key, isPressed)
    if isPressed then
        print("Panic key pressed! Destroying UI...")
        Window:Notify("Panic!", "Panic key pressed!", 2)
    end
end)

SettingsTab:AddLabel("Theme Settings")

local themeDropdown = SettingsTab:AddDropdown("UI Theme", {
    "Bread Crust (Default)",
    "Dark Mode",
    "Light Mode",
    "Ocean Blue",
    "Forest Green"
}, "Bread Crust (Default)", function(option)
    print("Theme selected:", option)
    Window:Notify("Theme", "Theme changed to: " .. option, 3)
end)

SettingsTab:AddToggle("Rainbow UI", false, function(value)
    getgenv().RainbowUI = value
    if value then
        print("Rainbow UI enabled")
        Window:Notify("Rainbow", "Rainbow mode activated! 🌈", 3)
    else
        print("Rainbow UI disabled")
    end
end)

SettingsTab:AddToggle("Sound Effects", true, function(value)
    getgenv().SoundEffects = value
    print("Sound effects:", value and "enabled" or "disabled")
end)

SettingsTab:AddButton("Reset All Settings", function()
    print("Resetting all settings to default...")
    Window:Notify("Reset", "All settings have been reset to default", 3)
end)

SettingsTab:AddButton("Export Settings", function()
    local settings = {
        WalkSpeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed,
        JumpPower = game.Players.LocalPlayer.Character.Humanoid.JumpPower,
        FOV = workspace.CurrentCamera.FieldOfView,
        Brightness = game.Lighting.Brightness
    }
    local json = game:GetService("HttpService"):JSONEncode(settings)
    setclipboard(json)
    Window:Notify("Exported", "Settings copied to clipboard!", 3)
    print("Settings exported:", json)
end)

SettingsTab:AddLabel("Credits")
SettingsTab:AddLabel("CrustUI by BinaryZero")
SettingsTab:AddLabel("Version ALPHA-A1")

Window:Notify("Welcome!", "CrustUI loaded successfully! 🍞", 5)
print("CrustUI Example loaded successfully!")
