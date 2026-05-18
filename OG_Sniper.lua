-- OG Sniper Full Working Version for GitHub
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OGSniper"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local mainFrame = nil
local toggleButton = nil
local currentSniper = nil
local feedItems = {}
local isSpawning = false

-- Loading Screen
local function createLoadingScreen(titleText, duration, onComplete)
    local loadFrame = Instance.new("Frame")
    loadFrame.Size = isMobile and UDim2.new(0.7, 0, 0.45, 0) or UDim2.new(0.45, 0, 0.35, 0)
    loadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    loadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    loadFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 35)
    loadFrame.Parent = screenGui
    Instance.new("UICorner", loadFrame).CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.55, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(0, 255, 150)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = loadFrame

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0.85, 0, 0.12, 0)
    progressBg.Position = UDim2.new(0.075, 0, 0.7, 0)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressBg.Parent = loadFrame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 10)

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 10)

    spawn(function()
        local start = tick()
        while tick() - start < duration do
            local prog = (tick() - start) / duration
            progressFill.Size = UDim2.new(prog, 0, 1, 0)
            RunService.RenderStepped:Wait()
        end
        wait(0.4)
        loadFrame:Destroy()
        if onComplete then onComplete() end
    end)
end

-- Toggle Button
local function createToggleButton()
    toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 60)
    toggleButton.Position = UDim2.new(0, 20, 0.5, -30)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    toggleButton.Text = "🧠"
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = screenGui
    Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1, 0)

    toggleButton.MouseButton1Click:Connect(function()
        if mainFrame and mainFrame.Parent then
            mainFrame.Visible = not mainFrame.Visible
        else
            if currentSniper then
                startActiveSniper(currentSniper)
            else
                createSelectionScreen()
            end
        end
    end)
end

-- Selection Screen
function createSelectionScreen()
    if mainFrame then mainFrame:Destroy() end
    mainFrame = Instance.new("Frame")
    mainFrame.Size = isMobile and UDim2.new(0.9, 0, 0.85, 0) or UDim2.new(0.5, 0, 0.7, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.18, 0)
    title.BackgroundTransparency = 1
    title.Text = "Choose Your Sniper"
    title.TextColor3 = Color3.fromRGB(255, 100, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    local snipers = {"Skibidi Spawner Sniper", "Meowl Spawner Sniper", "John Pork Spawner Sniper", "Strawberry Elephant Sniper"}

    for i, name in ipairs(snipers) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0.17, 0)
        btn.Position = UDim2.new(0.05, 0, 0.22 + (i-1)*0.19, 0)
        btn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = mainFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        btn.MouseButton1Click:Connect(function()
            mainFrame:Destroy()
            currentSniper = name
            createLoadingScreen("Loading " .. name .. "...", 9, function()
                startActiveSniper(name)
            end)
        end)
    end
end

-- Active Sniper
function startActiveSniper(sniperName)
    if mainFrame then mainFrame:Destroy() end
    mainFrame = Instance.new("Frame")
    mainFrame.Size = isMobile and UDim2.new(0.95, 0, 0.92, 0) or UDim2.new(0.7, 0, 0.85, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 35)
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0.1, 0)
    header.BackgroundTransparency = 1
    header.Text = "ACTIVE: " .. sniperName
    header.TextColor3 = Color3.fromRGB(0, 255, 200)
    header.TextScaled = true
    header.Font = Enum.Font.GothamBold
    header.Parent = mainFrame

    local scrolling = Instance.new("ScrollingFrame")
    scrolling.Size = UDim2.new(1, -20, 0.68, 0)
    scrolling.Position = UDim2.new(0, 10, 0.13, 0)
    scrolling.BackgroundTransparency = 0.7
    scrolling.ScrollBarThickness = 8
    scrolling.Parent = mainFrame
    Instance.new("UIListLayout", scrolling).Padding = UDim.new(0, 10)

    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0.12, 0)
    btnFrame.Position = UDim2.new(0, 10, 0.83, 0)
    btnFrame.BackgroundTransparency =
