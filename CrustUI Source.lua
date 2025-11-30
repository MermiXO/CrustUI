local CrustUI = {}
CrustUI.__index = CrustUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")

local DefaultTheme = {
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

local function MergeTheme(base, override)
    if not override then
        return base
    end

    local newTheme = {}
    for k, v in pairs(base) do
        newTheme[k] = v
    end
    for k, v in pairs(override) do
        newTheme[k] = v
    end
    return newTheme
end

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

function CrustUI:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "CrustUI Window"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 400)
    local theme = MergeTheme(DefaultTheme, config.Theme)

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

    local shadowGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        },
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
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
            NumberSequenceKeypoint.new(1, 1)
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

    local titleBarFix = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0,
    }, titleBar)

    local titleText = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = theme.Text,
        TextScaled = false,
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

    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil

    function window:CreateTab(tabName, icon)
        local tab = {}

        local tabButton = CreateInstance("TextButton", {
            Name = tabName,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = theme.Tertiary,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Text = "",
        }, tabList)

        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
        }, tabButton)

        local tabLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1,
            Text = (icon or "🍞") .. "  " .. tabName,
            TextColor3 = theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, tabButton)

        local tabContent = CreateInstance("ScrollingFrame", {
            Name = tabName .. "Content",
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.Accent,
            BorderSizePixel = 0,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
        }, contentContainer)

        local contentLayout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
        }, tabContent)

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Button.BackgroundTransparency = 0.7
                t.Label.TextColor3 = theme.TextDark
                t.Content.Visible = false
            end

            tabButton.BackgroundTransparency = 0.3
            tabLabel.TextColor3 = theme.Text
            tabContent.Visible = true
            window.CurrentTab = tab

            Tween(tabButton, {BackgroundColor3 = theme.Accent}, 0.2)
            task.delay(0.2, function()
                Tween(tabButton, {BackgroundColor3 = theme.Tertiary}, 0.2)
            end)
        end)

        tabButton.MouseEnter:Connect(function()
            if window.CurrentTab ~= tab then
                Tween(tabButton, {BackgroundTransparency = 0.5}, 0.2)
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if window.CurrentTab ~= tab then
                Tween(tabButton, {BackgroundTransparency = 0.7}, 0.2)
            end
        end)

        if #window.Tabs == 0 then
            tabButton.BackgroundTransparency = 0.3
            tabLabel.TextColor3 = theme.Text
            tabContent.Visible = true
            window.CurrentTab = tab
        end

        tabList.CanvasSize = UDim2.new(0, 0, 0, (#window.Tabs + 1) * 40)

        tab.Button = tabButton
        tab.Label = tabLabel
        tab.Content = tabContent

        function tab:AddLabel(text)
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = theme.Tertiary,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
            }, tabContent)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
            }, label)

            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
            }, label)

            return label
        end

        function tab:AddButton(text, callback)
            local button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = theme.Background,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
            }, tabContent)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
            }, button)

            button.MouseEnter:Connect(function()
                Tween(button, {BackgroundColor3 = theme.AccentLight}, 0.2)
            end)

            button.MouseLeave:Connect(function()
                Tween(button, {BackgroundColor3 = theme.Accent}, 0.2)
            end)

            button.MouseButton1Click:Connect(function()
                CreateRipple(button, theme.Text)
                if callback then
                    callback()
                end
            end)

            return button
        end

        function tab:AddToggle(text, default, callback)
            local toggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = theme.Tertiary,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
            }, tabContent)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
            }, toggleFrame)

            local toggleLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, toggleFrame)

            local toggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 45, 0, 22),
                Position = UDim2.new(1, -50, 0.5, -11),
                BackgroundColor3 = default and theme.Accent or theme.Background,
                BorderSizePixel = 0,
                Text = "",
            }, toggleFrame)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }, toggleButton)

            local toggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = theme.Text,
                BorderSizePixel = 0,
            }, toggleButton)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }, toggleCircle)

            local toggled = default or false

            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled

                if toggled then
                    Tween(toggleButton, {BackgroundColor3 = theme.Accent}, 0.3)
                    Tween(toggleCircle, {Position = UDim2.new(1, -20, 0.5, -9)}, 0.3)
                else
                    Tween(toggleButton, {BackgroundColor3 = theme.Background}, 0.3)
                    Tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.3)
                end

                if callback then
                    callback(toggled)
                end
            end)

            return toggleFrame
        end

        function tab:AddSlider(text, min, max, default, callback)
            default = default or min
            local sliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = theme.Tertiary,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
            }, tabContent)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
            }, sliderFrame)

            local sliderLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, sliderFrame)

            local sliderValue = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -55, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(default or min),
                TextColor3 = theme.Accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
            }, sliderFrame)

            local sliderBar = CreateInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
            }, sliderFrame)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }, sliderBar)

            local initialPercentage = math.clamp((default - min) / (max - min), 0, 1)

            local sliderFill = CreateInstance("Frame", {
                Size = UDim2.new(initialPercentage, 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
            }, sliderBar)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }, sliderFill)

            local sliderButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(initialPercentage, -6, 0.5, -6),
                BackgroundColor3 = theme.Text,
                BorderSizePixel = 0,
                Text = "",
            }, sliderBar)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }, sliderButton)

            local dragging = false

            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos.X - sliderBar.AbsolutePosition.X
                    local percentage = math.clamp(relativePos / sliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percentage)

                    sliderValue.Text = tostring(value)
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderButton.Position = UDim2.new(percentage, -6, 0.5, -6)

                    if callback then
                        callback(value)
                    end
                end
            end)

            return sliderFrame
        end

        function tab:AddDropdown(text, options, default, callback)
            local dropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = theme.Tertiary,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                ClipsDescendants = false,
            }, tabContent)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
            }, dropdownFrame)

            local dropdownLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.5, -5, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, dropdownFrame)

            local dropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(0.5, -15, 0, 25),
                Position = UDim2.new(0.5, 0, 0, 5),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Text = default or "Select...",
                TextColor3 = theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
            }, dropdownFrame)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }, dropdownButton)

            local dropdownArrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -25, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = theme.TextDark,
                TextSize = 10,
                Font = Enum.Font.Gotham,
            }, dropdownButton)

            local dropdownList = CreateInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 40),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Visible = false,
            }, dropdownFrame)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }, dropdownList)

            local listLayout = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
            }, dropdownList)

            local isOpen = false

            for _, option in ipairs(options) do
                local optionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = theme.Secondary,
                    BorderSizePixel = 0,
                    Text = option,
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                }, dropdownList)

                optionButton.MouseEnter:Connect(function()
                    Tween(optionButton, {BackgroundColor3 = theme.Accent}, 0.2)
                end)

                optionButton.MouseLeave:Connect(function()
                    Tween(optionButton, {BackgroundColor3 = theme.Secondary}, 0.2)
                end)

                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option
                    isOpen = false
                    dropdownList.Visible = false
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                    Tween(dropdownArrow, {Rotation = 0}, 0.3)

                    if callback then
                        callback(option)
                    end
                end)
            end

            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropdownList.Visible = isOpen

                if isOpen then
                    local listHeight = #options * 27
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 45 + listHeight)}, 0.3)
                    Tween(dropdownArrow, {Rotation = 180}, 0.3)
                else
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                    Tween(dropdownArrow, {Rotation = 0}, 0.3)
                end
            end)

            return dropdownFrame
        end

        function tab:AddTextbox(text, placeholder, callback)
            local textboxFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = theme.Tertiary,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
            }, tabContent)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
            }, textboxFrame)

            local textboxLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.4, -5, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, textboxFrame)

            local textbox = CreateInstance("TextBox", {
                Size = UDim2.new(0.6, -15, 0, 25),
                Position = UDim2.new(0.4, 5, 0.5, -12.5),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = placeholder or "Enter text...",
                PlaceholderColor3 = theme.TextDark,
                TextColor3 = theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
            }, textboxFrame)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }, textbox)

            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
            }, textbox)

            textbox.FocusLost:Connect(function(enterPressed)
                if callback then
                    callback(textbox.Text, enterPressed)
                end
            end)

            return textboxFrame
        end

        function tab:AddKeybind(text, default, callback)
            local keybindFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = theme.Tertiary,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
            }, tabContent)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
            }, keybindFrame)

            local keybindLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, keybindFrame)

            local keybindButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 65, 0, 22),
                Position = UDim2.new(1, -70, 0.5, -11),
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Text = default and default.Name or "None",
                TextColor3 = theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
            }, keybindFrame)

            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }, keybindButton)

            local binding = false
            local currentKey = default

            keybindButton.MouseButton1Click:Connect(function()
                binding = true
                keybindButton.Text = "..."
                keybindButton.TextColor3 = theme.Accent
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if binding and not gameProcessed then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        binding = false
                        currentKey = input.KeyCode
                        keybindButton.Text = currentKey.Name
                        keybindButton.TextColor3 = theme.Text

                        if callback then
                            callback(currentKey)
                        end
                    end
                elseif currentKey and input.KeyCode == currentKey and not gameProcessed then
                    if callback then
                        callback(currentKey, true)
                    end
                end
            end)

            return keybindFrame
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    function window:Notify(title, message, duration)
        duration = duration or 3

        local notificationFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 300, 0, 80),
            Position = UDim2.new(1, -320, 1, -100),
            BackgroundColor3 = theme.Secondary,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        }, screenGui)

        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
        }, notificationFrame)

        local accentBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
        }, notificationFrame)

        local notifTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 15, 0, 10),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = theme.Text,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, notificationFrame)

        local notifMessage = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 15, 0, 35),
            BackgroundTransparency = 1,
            Text = message,
            TextColor3 = theme.TextDark,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
        }, notificationFrame)

        notificationFrame.Position = UDim2.new(1, 0, 1, -100)
        Tween(notificationFrame, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back)

        task.wait(duration)
        Tween(notificationFrame, {Position = UDim2.new(1, 0, 1, -100)}, 0.5)
        task.wait(0.5)
        notificationFrame:Destroy()
    end

    function window:Destroy()
        screenGui:Destroy()
        self.Tabs = {}
        self.CurrentTab = nil
    end

    return window
end

return CrustUI
