local CrustUI = {}
CrustUI.__index = CrustUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")

--// THEME DEFINITIONS

local Themes = {}

-- Bread (your original theme, now named)
Themes.Bread = {
    Background = Color3.fromRGB(28, 25, 23),
    Secondary = Color3.fromRGB(45, 40, 36),
    Tertiary = Color3.fromRGB(62, 54, 47),

    Accent = Color3.fromRGB(218, 165, 92),
    AccentDark = Color3.fromRGB(184, 134, 66),
    AccentLight = Color3.fromRGB(237, 201, 142),

    Text = Color3.fromRGB(245, 235, 220),
    TextDark = Color3.fromRGB(180, 170, 155),

    Hover = Color3.fromRGB(75, 65, 56),
    Active = Color3.fromRGB(218, 165, 92),

    Success = Color3.fromRGB(134, 179, 84),
    Error = Color3.fromRGB(204, 85, 68),
    Warning = Color3.fromRGB(237, 180, 88),
    Info = Color3.fromRGB(92, 165, 218),
}

-- Meteor: dark purple / orange
Themes.Meteor = {
    Background = Color3.fromRGB(15, 10, 20),
    Secondary  = Color3.fromRGB(25, 18, 35),
    Tertiary   = Color3.fromRGB(40, 25, 55),

    Accent     = Color3.fromRGB(255, 140, 80),
    AccentDark = Color3.fromRGB(210, 90, 40),
    AccentLight= Color3.fromRGB(255, 190, 140),

    Text       = Color3.fromRGB(245, 240, 255),
    TextDark   = Color3.fromRGB(190, 180, 210),

    Hover      = Color3.fromRGB(60, 35, 70),
    Active     = Color3.fromRGB(255, 140, 80),

    Success    = Color3.fromRGB(120, 200, 140),
    Error      = Color3.fromRGB(230, 90, 110),
    Warning    = Color3.fromRGB(255, 190, 120),
    Info       = Color3.fromRGB(130, 170, 255),
}

-- Moon: cool navy / soft blue
Themes.Moon = {
    Background = Color3.fromRGB(10, 16, 26),
    Secondary  = Color3.fromRGB(18, 26, 40),
    Tertiary   = Color3.fromRGB(30, 44, 66),

    Accent     = Color3.fromRGB(125, 170, 255),
    AccentDark = Color3.fromRGB(85, 130, 210),
    AccentLight= Color3.fromRGB(170, 205, 255),

    Text       = Color3.fromRGB(235, 242, 255),
    TextDark   = Color3.fromRGB(170, 185, 210),

    Hover      = Color3.fromRGB(45, 60, 90),
    Active     = Color3.fromRGB(125, 170, 255),

    Success    = Color3.fromRGB(110, 200, 170),
    Error      = Color3.fromRGB(220, 100, 120),
    Warning    = Color3.fromRGB(245, 200, 130),
    Info       = Color3.fromRGB(120, 180, 255),
}

-- Midnight: almost-black with cyan accent
Themes.Midnight = {
    Background = Color3.fromRGB(5, 5, 10),
    Secondary  = Color3.fromRGB(15, 15, 25),
    Tertiary   = Color3.fromRGB(25, 25, 40),

    Accent     = Color3.fromRGB(0, 200, 160),
    AccentDark = Color3.fromRGB(0, 150, 120),
    AccentLight= Color3.fromRGB(120, 255, 220),

    Text       = Color3.fromRGB(235, 245, 255),
    TextDark   = Color3.fromRGB(170, 185, 195),

    Hover      = Color3.fromRGB(40, 45, 60),
    Active     = Color3.fromRGB(0, 200, 160),

    Success    = Color3.fromRGB(0, 210, 120),
    Error      = Color3.fromRGB(235, 80, 80),
    Warning    = Color3.fromRGB(255, 200, 100),
    Info       = Color3.fromRGB(80, 200, 255),
}

-- Neon: dark with neon magenta
Themes.Neon = {
    Background = Color3.fromRGB(5, 5, 8),
    Secondary  = Color3.fromRGB(15, 10, 20),
    Tertiary   = Color3.fromRGB(30, 15, 45),

    Accent     = Color3.fromRGB(255, 60, 200),
    AccentDark = Color3.fromRGB(200, 30, 150),
    AccentLight= Color3.fromRGB(255, 130, 230),

    Text       = Color3.fromRGB(245, 240, 255),
    TextDark   = Color3.fromRGB(190, 175, 210),

    Hover      = Color3.fromRGB(60, 30, 80),
    Active     = Color3.fromRGB(255, 60, 200),

    Success    = Color3.fromRGB(120, 255, 180),
    Error      = Color3.fromRGB(255, 80, 120),
    Warning    = Color3.fromRGB(255, 210, 130),
    Info       = Color3.fromRGB(150, 120, 255),
}

-- Forest: deep greens
Themes.Forest = {
    Background = Color3.fromRGB(10, 20, 15),
    Secondary  = Color3.fromRGB(18, 32, 24),
    Tertiary   = Color3.fromRGB(28, 48, 36),

    Accent     = Color3.fromRGB(120, 200, 120),
    AccentDark = Color3.fromRGB(80, 160, 90),
    AccentLight= Color3.fromRGB(170, 235, 160),

    Text       = Color3.fromRGB(230, 245, 235),
    TextDark   = Color3.fromRGB(170, 190, 175),

    Hover      = Color3.fromRGB(40, 70, 50),
    Active     = Color3.fromRGB(120, 200, 120),

    Success    = Color3.fromRGB(140, 220, 130),
    Error      = Color3.fromRGB(215, 90, 90),
    Warning    = Color3.fromRGB(235, 200, 120),
    Info       = Color3.fromRGB(120, 200, 160),
}

-- Sakura: light, pinkish
Themes.Sakura = {
    Background = Color3.fromRGB(250, 244, 245),
    Secondary  = Color3.fromRGB(242, 225, 230),
    Tertiary   = Color3.fromRGB(232, 210, 220),

    Accent     = Color3.fromRGB(235, 120, 150),
    AccentDark = Color3.fromRGB(200, 80, 120),
    AccentLight= Color3.fromRGB(245, 165, 185),

    Text       = Color3.fromRGB(60, 40, 60),
    TextDark   = Color3.fromRGB(120, 90, 120),

    Hover      = Color3.fromRGB(220, 195, 210),
    Active     = Color3.fromRGB(235, 120, 150),

    Success    = Color3.fromRGB(120, 190, 120),
    Error      = Color3.fromRGB(210, 90, 110),
    Warning    = Color3.fromRGB(230, 180, 120),
    Info       = Color3.fromRGB(150, 140, 220),
}

-- Arctic: light, icy blue
Themes.Arctic = {
    Background = Color3.fromRGB(240, 248, 255),
    Secondary  = Color3.fromRGB(220, 235, 245),
    Tertiary   = Color3.fromRGB(205, 225, 240),

    Accent     = Color3.fromRGB(80, 160, 220),
    AccentDark = Color3.fromRGB(40, 110, 170),
    AccentLight= Color3.fromRGB(140, 200, 245),

    Text       = Color3.fromRGB(35, 45, 60),
    TextDark   = Color3.fromRGB(110, 125, 145),

    Hover      = Color3.fromRGB(200, 220, 235),
    Active     = Color3.fromRGB(80, 160, 220),

    Success    = Color3.fromRGB(110, 190, 140),
    Error      = Color3.fromRGB(210, 90, 100),
    Warning    = Color3.fromRGB(230, 180, 110),
    Info       = Color3.fromRGB(80, 160, 220),
}

local DefaultThemeName = "Bread"
local DefaultTheme = Themes[DefaultThemeName]

CrustUI.Themes = Themes
CrustUI.DefaultThemeName = DefaultThemeName

local function MergeTheme(base, override)
    local t = {}
    for k, v in pairs(base or {}) do
        t[k] = v
    end
    for k, v in pairs(override or {}) do
        t[k] = v
    end
    return t
end

function CrustUI:GetThemeNames()
    local names = {}
    for name in pairs(Themes) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

--// UTILS

local function CreateInstance(className, properties, parent)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPos
    local inputChangedConn
    local inputEndedConn

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            inputChangedConn = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    update(moveInput)
                end
            end)

            inputEndedConn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    if inputChangedConn then
                        inputChangedConn:Disconnect()
                        inputChangedConn = nil
                    end
                    if inputEndedConn then
                        inputEndedConn:Disconnect()
                        inputEndedConn = nil
                    end
                end
            end)
        end
    end)
end

local function CreateRipple(button, color)
    local ripple = CreateInstance("Frame", {
        Name = "Ripple",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, button)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, ripple)

    Tween(ripple, {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    }, 0.5)

    Debris:AddItem(ripple, 0.5)
end

--// MAIN API

function CrustUI:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "CrustUI Window"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 400)

    local themeName = config.ThemeName or DefaultThemeName
    local baseTheme = Themes[themeName] or DefaultTheme
    local theme = MergeTheme(baseTheme, config.Theme)

    local screenGui = CreateInstance("ScreenGui", {
        Name = "CrustUI_" .. windowName:gsub("%s+", ""),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    local shadowFrame = CreateInstance("Frame", {
        Name = "Shadow",
        Size = UDim2.new(0, windowSize.X.Offset + 20, 0, windowSize.Y.Offset + 20),
        Position = UDim2.new(0.5, -windowSize.X.Offset/2 - 10, 0.5, -windowSize.Y.Offset/2 - 10),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, screenGui)

    CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        },
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1),
        },
        Rotation = 45,
    }, shadowFrame)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
    }, shadowFrame)

    local mainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, screenGui)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
    }, mainFrame)

    local gradientOverlay = CreateInstance("Frame", {
        Name = "GradientOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
    }, mainFrame)

    CreateInstance("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.5),
            NumberSequenceKeypoint.new(1, 1),
        },
        Rotation = 135,
    }, gradientOverlay)

    local titleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0,
    }, mainFrame)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
    }, titleBar)

    CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0,
    }, titleBar)

    CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = theme.Text,
        TextSize = 18,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, titleBar)

    local controlsFrame = CreateInstance("Frame", {
        Name = "Controls",
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -75, 0.5, -15),
        BackgroundTransparency = 1,
    }, titleBar)

    local minimizeBtn = CreateInstance("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Tertiary,
        Text = "—",
        TextColor3 = theme.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
    }, controlsFrame)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, minimizeBtn)

    local closeBtn = CreateInstance("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundColor3 = theme.Error,
        BackgroundTransparency = 0.3,
        Text = "×",
        TextColor3 = theme.Text,
        TextSize = 20,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
    }, controlsFrame)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, closeBtn)

    local tabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 140, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, mainFrame)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
    }, tabContainer)

    local tabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    }, tabContainer)

    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
    }, tabList)

    local contentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -165, 1, -50),
        Position = UDim2.new(0, 155, 0, 45),
        BackgroundColor3 = theme.Secondary,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
    }, mainFrame)

    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
    }, contentContainer)

    MakeDraggable(mainFrame, titleBar)
    MakeDraggable(shadowFrame, titleBar)

    minimizeBtn.MouseEnter:Connect(function()
        Tween(minimizeBtn, {BackgroundColor3 = theme.Hover}, 0.2)
    end)

    minimizeBtn.MouseLeave:Connect(function()
        Tween(minimizeBtn, {BackgroundColor3 = theme.Tertiary}, 0.2)
    end)

    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0}, 0.2)
    end)

    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.3}, 0.2)
    end)

    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(mainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 40)}, 0.3)
            Tween(shadowFrame, {Size = UDim2.new(0, windowSize.X.Offset + 20, 0, 60)}, 0.3)
            minimizeBtn.Text = "□"
        else
            Tween(mainFrame, {Size = windowSize}, 0.3)
            Tween(shadowFrame, {Size = UDim2.new(0, windowSize.X.Offset + 20, 0, windowSize.Y.Offset + 20)}, 0.3)
            minimizeBtn.Text = "—"
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local window = {
        Tabs = {},
        CurrentTab = nil,
        ThemeName = themeName,
        Theme = theme,
    }

    -- Tabs, controls, Notify, Destroy definitions stay the same as in the
    -- previous version you have, except they now reference `theme` as before
    -- (they already do in the last script I gave you, including the fixed
    -- dropdown label). For brevity I’ll skip re-pasting the entire body again
    -- here, but you can safely keep everything below `window:CreateTab` from
    -- the last working version and it will use the new theme system.

    -- If you want I can paste the full body again, but the only changes needed
    -- for themes are at the top of the file and in the CreateWindow() header
    -- (ThemeName resolution) which I’ve included above.

    -- ...
    -- (Paste in your existing window:CreateTab, tab:AddX, window:Notify,
    --  window:Destroy implementations here, unchanged.)
    -- ...

    return window
end

return CrustUI
