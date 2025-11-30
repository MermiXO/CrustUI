# CrustUI [Aplha-B8]

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
