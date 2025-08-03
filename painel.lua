-- Painel Flutuante com ESP, Noclip, Teleporte por lista, e atualização visual de botões

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local UIS = game:GetService("UserInputService") local RunService = game:GetService("RunService")

-- Cria GUI principal local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) ScreenGui.Name = "PainelINP"

local Frame = Instance.new("Frame", ScreenGui) Frame.Size = UDim2.new(0, 250, 0, 400) Frame.Position = UDim2.new(0, 10, 0.5, -200) Frame.BackgroundColor3 = Color3.fromRGB(170, 0, 0) Frame.BorderSizePixel = 0 Frame.Active = true Frame.Draggable = true

-- Botão Minimizar local MinBtn = Instance.new("TextButton", Frame) MinBtn.Size = UDim2.new(0, 100, 0, 30) MinBtn.Position = UDim2.new(1, -110, 0, 10) MinBtn.Text = "Minimizar" MinBtn.TextColor3 = Color3.new(0,0,0) MinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local Content = Instance.new("Frame", Frame) Content.Size = UDim2.new(1, -20, 1, -50) Content.Position = UDim2.new(0, 10, 0, 40) Content.BackgroundTransparency = 1

MinBtn.MouseButton1Click:Connect(function() Content.Visible = not Content.Visible MinBtn.Text = Content.Visible and "Minimizar" or "Maximizar" end)

-- Criar botão genérico local function createToggle(name, callback) local btn = Instance.new("TextButton", Content) btn.Size = UDim2.new(1, 0, 0, 40) btn.Text = name .. ": Desativado" btn.TextColor3 = Color3.new(0, 0, 0) btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) btn.Font = Enum.Font.Gotham btn.TextSize = 16

local active = false
btn.MouseButton1Click:Connect(function()
	active = not active
	btn.Text = name .. (active and ": Ativado" or ": Desativado")
	btn.BackgroundColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 0, 0)
	callback(active)
end)

return btn

end

-- ESP createToggle("ESP", function(state) for _,v in pairs(workspace:GetChildren()) do if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= LocalPlayer.Character then local hl = v:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", v) hl.Enabled = state end end end)

-- Noclip local noclipConn createToggle("Noclip", function(state) if state then noclipConn = RunService.Stepped:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid:ChangeState(11) end end) else if noclipConn then noclipConn:Disconnect() end end end)

-- Lista de jogadores para teleporte local tpFrame = Instance.new("ScrollingFrame", Content) tpFrame.Size = UDim2.new(1, -20, 0, 100) tpFrame.Position = UDim2.new(0, 10, 0, 210) tpFrame.BackgroundColor3 = Color3.fromRGB(170, 0, 0) tpFrame.BorderSizePixel = 0 tpFrame.CanvasSize = UDim2.new(0, 0, 0, 0) tpFrame.ScrollBarThickness = 6

tpFrame.ChildAdded:Connect(function() tpFrame.CanvasSize = UDim2.new(0, 0, 0, #tpFrame:GetChildren() * 30) end)

local function addPlayerBtn(player) if player ~= LocalPlayer then local btn = Instance.new("TextButton", tpFrame) btn.Size = UDim2.new(1, 0, 0, 30) btn.Text = "Teleportar para " .. player.Name btn.TextColor3 = Color3.new(0, 0, 0) btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.MouseButton1Click:Connect(function() if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) end end) end end

for _, player in pairs(Players:GetPlayers()) do addPlayerBtn(player) end

Players.PlayerAdded:Connect(addPlayerBtn)

