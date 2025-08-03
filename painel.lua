local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 400)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true

-- Título
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "Painel inp77.k"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Title.TextColor3 = Color3.new(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Minimizar botão
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Text = "_"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
MinBtn.TextColor3 = Color3.new(0, 0, 0)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 20

-- Conteúdo
local Content = Instance.new("Frame", MainFrame)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.Size = UDim2.new(1, 0, 1, -30)
Content.BackgroundTransparency = 1

-- Função de botão on/off
local function createToggle(name, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = name .. ": Desativado"
	btn.AutoButtonColor = false
	local state = false

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name .. ": " .. (state and "Ativado" or "Desativado")
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 0, 0)
		callback(state)
	end)

	return btn
end

-- ESP com linhas
local function toggleESP(enabled)
	for _, obj in pairs(workspace:GetChildren()) do
		if obj:IsA("Model") and Players:FindFirstChild(obj.Name) and obj:FindFirstChild("HumanoidRootPart") then
			if not obj:FindFirstChild("ESPLine") and enabled then
				local billboard = Instance.new("BillboardGui", obj)
				billboard.Name = "ESPLine"
				billboard.Size = UDim2.new(0, 100, 0, 40)
				billboard.Adornee = obj:FindFirstChild("Head")
				billboard.AlwaysOnTop = true

				local text = Instance.new("TextLabel", billboard)
				text.Size = UDim2.new(1, 0, 1, 0)
				text.BackgroundTransparency = 1
				text.Text = obj.Name
				text.TextColor3 = Color3.new(1, 1, 1)
				text.TextScaled = true
			elseif obj:FindFirstChild("ESPLine") and not enabled then
				obj:FindFirstChild("ESPLine"):Destroy()
			end
		end
	end
end

-- Noclip
local noclipConn
local function toggleNoclip(enabled)
	if enabled then
		noclipConn = game:GetService("RunService").Stepped:Connect(function()
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	else
		if noclipConn then
			noclipConn:Disconnect()
		end
	end
end

-- Criar botões
local btn1 = createToggle("ESP", Content, toggleESP)
btn1.Position = UDim2.new(0, 10, 0, 10)

local btn2 = createToggle("Noclip", Content, toggleNoclip)
btn2.Position = UDim2.new(0, 10, 0, 60)

-- Lista de jogadores (teleporte)
local PlayerList = Instance.new("Frame", Content)
PlayerList.Position = UDim2.new(0, 10, 0, 120)
PlayerList.Size = UDim2.new(1, -20, 0, 220)
PlayerList.BackgroundColor3 = Color3.fromRGB(255, 200, 200)

local UIList = Instance.new("UIListLayout", PlayerList)
UIList.Padding = UDim.new(0, 2)

local function updatePlayerList()
	PlayerList:ClearAllChildren()
	UIList.Parent = PlayerList
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local btn = Instance.new("TextButton", PlayerList)
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
			btn.TextColor3 = Color3.new(0, 0, 0)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 16
			btn.Text = "TP: " .. plr.Name
			btn.MouseButton1Click:Connect(function()
				LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
			end)
		end
	end
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Minimizar/Maximizar
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	Content.Visible = not minimized
end)
