-- Script para Roblox - Celular
-- Painel flutuante com ESP, Aimbot, Noclip e Teleporte
-- Criado por inp77.k

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Criação do Painel
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local Panel = Instance.new("Frame", ScreenGui)
Panel.Size = UDim2.new(0, 250, 0, 350)
Panel.Position = UDim2.new(0.05, 0, 0.2, 0)
Panel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Panel.Active = true
Panel.Draggable = true

local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Painel inp77.k"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Minimizar
local MinButton = Instance.new("TextButton", Panel)
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -35, 0, 0)
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local isMinimized = false
MinButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	for _, child in pairs(Panel:GetChildren()) do
		if child ~= Title and child ~= MinButton then
			child.Visible = not isMinimized
		end
	end
end)

-- Função para criar botão com toggle
local function createToggle(name, posY, callback)
	local btn = Instance.new("TextButton", Panel)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 16

	local state = false
	local function updateText()
		btn.Text = name .. ": " .. (state and "Ativado" or "Desativado")
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
	end

	btn.MouseButton1Click:Connect(function()
		state = not state
		updateText()
		callback(state)
	end)

	updateText()
	return btn
end

-- ESP
local espEnabled = false
local espObjects = {}

local function updateESP()
	for _, v in pairs(espObjects) do
		if v and v.Box then v.Box:Destroy() end
	end
	espObjects = {}

	if espEnabled then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local box = Drawing.new("Square")
				box.Color = Color3.fromRGB(255, 255, 255)
				box.Thickness = 1
				box.Filled = false
				espObjects[player] = {Box = box, HRP = player.Character.HumanoidRootPart}
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if espEnabled then
		for player, data in pairs(espObjects) do
			local pos, onscreen = Camera:WorldToViewportPoint(data.HRP.Position)
			if onscreen then
				data.Box.Size = Vector2.new(60, 100)
				data.Box.Position = Vector2.new(pos.X - 30, pos.Y - 50)
				data.Box.Visible = true
			else
				data.Box.Visible = false
			end
		end
	end
end)

createToggle("ESP", 40, function(state)
	espEnabled = state
	updateESP()
end)

-- Aimbot
local aimbotEnabled = false
local fov = 100

createToggle("Aimbot", 80, function(state)
	aimbotEnabled = state
end)

RunService.RenderStepped:Connect(function()
	if not aimbotEnabled then return end

	local closest, dist = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local pos, onscreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
			if onscreen then
				local mouse = UIS:GetMouseLocation()
				local mag = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
				if mag < fov and mag < dist then
					closest = player.Character.Head
					dist = mag
				end
			end
		end
	end

	if closest then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
	end
end)

-- Noclip
local noclipEnabled = false
createToggle("Noclip", 120, function(state)
	noclipEnabled = state
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Teleporte
local tpFrame = Instance.new("Frame", Panel)
tpFrame.Position = UDim2.new(0, 10, 0, 160)
tpFrame.Size = UDim2.new(1, -20, 0, 160)
tpFrame.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", tpFrame)
layout.Padding = UDim.new(0, 2)

for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		local btn = Instance.new("TextButton", tpFrame)
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.Text = "Teleportar para " .. player.Name
		btn.TextColor3 = Color3.new(0, 0, 0)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

		btn.MouseButton1Click:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
				LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
			end
		end)
	end
end
