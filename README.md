# CrustUI [W.I.P]

## Getting Started

### Booting library:

```lua
local CrustUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SquidGurr/CrustUI/refs/heads/main/CrustUI%20Source.lua"))()
```
## Creating a Window

```lua
local Window = CrustUI:CreateWindow({
    Name = "CrustUI Demo 🍞",
    Size = UDim2.new(0, 600, 0, 450)
})
```

## Creating Tabs

```lua
local MainTab = Window:CreateTab("Main", "🏠")
local PlayerTab = Window:CreateTab("Player", "👤")
local VisualsTab = Window:CreateTab("Visuals", "👁")
local SettingsTab = Window:CreateTab("Settings", "⚙")
```

## Creating UI Elements
### Label
```lua
MainTab:AddLabel("Label")
```
### Button
```lua
MainTab:AddButton("Print Hello World", function()
    print("Hello World from CrustUI!")
end)
```
### Toggle
```lua
local toggle1 = MainTab:AddToggle("Enable Feature", false, function(value)
    print("Feature toggled:", value)
    if value then
        Window:Notify("Enabled", "Feature has been enabled", 2)
    else
        Window:Notify("Disabled", "Feature has been disabled", 2)
    end
```
### Slider
```lua
local walkspeedSlider = PlayerTab:AddSlider("Walk Speed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("Walk Speed set to:", value)
end)
```
### Dropdown
```lua
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
```
### Textbox
```Lua
local usernameTextbox = SettingsTab:AddTextbox("Username", "Enter username...", function(text, enterPressed)
    if enterPressed then
        print("Username set to:", text)
        Window:Notify("Username", "Username changed to: " .. text, 3)
    end
end)
```
### Keybind
```lua
SettingsTab:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(key, isPressed)
    if isPressed then
        print("UI Toggle key pressed:", key.Name)
    end
end)
```
