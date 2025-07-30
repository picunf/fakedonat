- UNIVERSAL FAKE DONATE SCRIPT (Keyless, Scrollable)
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 220)
Frame.Position = UDim2.new(0.5, -150, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true

-- Заголовок
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Fake Donate"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextScaled = true

-- Поле суммы
local AmountBox = Instance.new("TextBox", Frame)
AmountBox.Size = UDim2.new(1, -20, 0, 30)
AmountBox.Position = UDim2.new(0, 10, 0, 50)
AmountBox.PlaceholderText = "Введите сумму Robux"
AmountBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AmountBox.TextColor3 = Color3.new(1, 1, 1)

-- Скроллинг-список игроков
local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Size = UDim2.new(1, -20, 0, 90)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 90)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local Layout = Instance.new("UIListLayout", ScrollingFrame)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.SortOrder = Enum.SortOrder.Name

-- Заполнение списка игроков
local function RefreshPlayers()
    for _, item in ipairs(ScrollingFrame:GetChildren()) do
        if item:IsA("TextButton") then item:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local Btn = Instance.new("TextButton", ScrollingFrame)
            Btn.Size = UDim2.new(1, -5, 0, 25)
            Btn.Text = plr.Name
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextScaled = true
            Btn.MouseButton1Click:Connect(function()
                AmountBox.PlaceholderText = "Донат для: " .. plr.Name
                AmountBox:SetAttribute("Target", plr.Name)
            end)
        end
    end
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
end

RefreshPlayers()
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

-- Кнопка запуска
local DonateButton = Instance.new("TextButton", Frame)
DonateButton.Size = UDim2.new(1, -20, 0, 40)
DonateButton.Position = UDim2.new(0, 10, 0, 185)
DonateButton.Text = "Запустить Fake Donate"
DonateButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
DonateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DonateButton.TextScaled = true

DonateButton.MouseButton1Click:Connect(function()
    local target = AmountBox:GetAttribute("Target")
    local amount = tonumber(AmountBox.Text) or 0
    if not target then return end

    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = string.format("[GLOBAL]: @%s donated %d Robux to @%s!", LocalPlayer.Name, amount, target),
        Color = Color3.fromRGB(0, 255, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })

    StarterGui:SetCore("SendNotification", {
        Title = "💸 Donation Successful!";
        Text = string.format("You donated %d Robux to @%s!", amount, target),
        Duration = 5
    })
end)
