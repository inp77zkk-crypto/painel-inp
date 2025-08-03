local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "PainelInp77k"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 360)
Frame.Position = UDim2.new(0.05, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- vermelho
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Title.Text = "Painel: inp77k"
Title.TextColor3 = Color3.fromRGB(0, 0, 0) -- preto
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local minimize = Instance.new("TextButton", Frame)
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -55, 0, 2)
minimize.Text = "-"
minimize.TextSize = 18
minimize.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
minimize.TextColor3 = Color3.fromRGB(0,0,0)

local fechar = Instance.new("TextButton", Frame)
fechar.Size = UDim2.new(0, 25, 0, 25)
fechar.Position = UDim2.new(1, -30, 0, 2)
fechar.Text = "X"
fechar.TextSize = 18
fechar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
fechar.TextColor3 = Color3.fromRGB(0,0,0)

local Content = Instance.new("Frame", Frame)
Content.Position = UDim2.new(0, 0, 0, 35)
Content.Size = UDim2.new(1, 0, 1, -35)
Content.BackgroundTransparency = 1

-- Minimizar (ocultar conteúdo e ajustar tamanho do frame)
minimize.MouseButton1Click:Connect(function()
	if Content.Visible then
		Content.Visible = false
		Frame.Size = UDim2.new(0, 300, 0, 35)
	else
		Content.Visible = true
		Frame.Size = UDim2.new(0, 300, 0, 360)
	end
end)

-- Fechar
fechar.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Variáveis de controle
local espAtivo = false
local aimbotAtivo = false
local noclipAtivo = false

-- ESP Tables
local espBoxes = {}
local espLines = {}

-- Criar ESP para um jogador
local function criarESP(player)
	if espBoxes[player] then return end
	if player == LocalPlayer then return end
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

	local box = Drawing.new("Square")
	box.Color = Color3.fromRGB(0, 255, 0)
	box.Thickness = 2
	box.Filled = false
	box.Visible = false

	local line = Drawing.new("Line")
	line.Color = Color3.fromRGB(255, 0, 0)
	line.Thickness = 1
	line.Visible = false

	espBoxes[player] = box
	espLines[player] = line
end

-- Atualiza ESP a cada frame
RunService.RenderStepped:Connect(function()
	for player, box in pairs(espBoxes) do
		local line = espLines[player]
		if espAtivo and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
			if onScreen then
				local size = Vector2.new(60, 120)
				box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
				box.Size = size
				box.Visible = true

				line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
				line.To = Vector2.new(pos.X, pos.Y)
				line.Visible = true
			else
				box.Visible = false
				line.Visible = false
			end
		else
			box.Visible = false
			line.Visible = false
		end
	end
end)

-- Inicializa ESP para todos jogadores
local function atualizarESP()
	for _, player in pairs(Players:GetPlayers()) do
		criarESP(player)
	end
end

atualizarESP()

Players.PlayerAdded:Connect(function(plr)
	criarESP(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
	if espBoxes[plr] then
		espBoxes[plr]:Remove()
		espBoxes[plr] = nil
	end
	if espLines[plr] then
		espLines[plr]:Remove()
		espLines[plr] = nil
	end
end)

-- Aimbot com FOV
local radius = 100

local circle = Drawing.new("Circle")
circle.Transparency = 0.5
circle.Thickness = 2
circle.Color = Color3.fromRGB(0, 170, 255)
circle.Radius = radius
circle.Visible = false
circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

RunService.RenderStepped:Connect(function()
	circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

	if aimbotAtivo then
		local closest = nil
		local dist = radius
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
				local head = player.Character.Head
				local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
					if mag < dist then
						dist = mag
						closest = head
					end
				end
			end
		end

		if closest then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
		end
	end
end)

-- Noclip toggle com on/off real
RunService.Stepped:Connect(function()
	if noclipAtivo and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	elseif LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)

-- Botões
local function criarBotao(nome, y, func)
	local btn = Instance.new("TextButton", Content)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = nome
	btn.MouseButton1Click:Connect(func)
	return btn
end

local btnESP = criarBotao("ESP: Desativado", 10, function()
	espAtivo = not espAtivo
	btnESP.Text = espAtivo and "ESP: Ativado" or "ESP: Desativado"
end)

local btnAimbot = criarBotao("Aimbot: Desativado", 60, function()
	aimbotAtivo = not aimbotAtivo
	circle.Visible = aimbotAtivo
	btnAimbot.Text = aimbotAtivo and "Aimbot: Ativado" or "Aimbot: Desativado"
end)

local btnNoclip = criarBotao("Noclip: Desativado", 110, function()
	noclipAtivo = not noclipAtivo
	btnNoclip.Text = noclipAtivo and "Noclip: Ativado" or "Noclip: Desativado"
end)

-- Lista de jogadores para Teleport
local yPos = 160
for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		local btnTP = criarBotao("TP: "..player.Name, yPos, function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
			end
		end)
		yPos = yPos + 40
	end
end

Players.PlayerAdded:Connect(function(player)
	local btnTP = criarBotao("TP: "..player.Name, yPos, function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
		end
	end)
	yPos = yPos + 40
end)

Players.PlayerRemoving:Connect(function(player)
	-- Não remove botão, poderia melhorar removendo, mas simples assim
end)
