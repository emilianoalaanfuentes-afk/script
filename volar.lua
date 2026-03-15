local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 50

local bv
local bg
local flyConnection

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,200,0,140)
frame.Position = UDim2.new(0.5,-100,0.5,-70)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.Text = "Fly Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local toggle = Instance.new("TextButton")
toggle.Parent = frame
toggle.Size = UDim2.new(0.8,0,0,30)
toggle.Position = UDim2.new(0.1,0,0,40)
toggle.Text = "Activar Fly"

local speedBox = Instance.new("TextBox")
speedBox.Parent = frame
speedBox.Size = UDim2.new(0.8,0,0,30)
speedBox.Position = UDim2.new(0.1,0,0,80)
speedBox.PlaceholderText = "Velocidad (ej: 50)"

local function startFly()

	if flying then return end
	flying = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(100000,100000,100000)
	bv.Velocity = Vector3.new(0,0,0)
	bv.Parent = root

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(100000,100000,100000)
	bg.CFrame = root.CFrame
	bg.Parent = root

	flyConnection = RunService.RenderStepped:Connect(function()

		if flying then
			bg.CFrame = workspace.CurrentCamera.CFrame

			local move = Vector3.new()

			if UIS:IsKeyDown(Enum.KeyCode.W) then
				move = move + workspace.CurrentCamera.CFrame.LookVector
			end

			if UIS:IsKeyDown(Enum.KeyCode.S) then
				move = move - workspace.CurrentCamera.CFrame.LookVector
			end

			if UIS:IsKeyDown(Enum.KeyCode.A) then
				move = move - workspace.CurrentCamera.CFrame.RightVector
			end

			if UIS:IsKeyDown(Enum.KeyCode.D) then
				move = move + workspace.CurrentCamera.CFrame.RightVector
			end

			if UIS:IsKeyDown(Enum.KeyCode.Space) then
				move = move + Vector3.new(0,1,0)
			end

			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
				move = move - Vector3.new(0,1,0)
			end

			bv.Velocity = move * speed
		end

	end)

end

local function stopFly()

	flying = false

	if flyConnection then
		flyConnection:Disconnect()
	end

	if bv then
		bv:Destroy()
	end

	if bg then
		bg:Destroy()
	end

end

toggle.MouseButton1Click:Connect(function()

	local num = tonumber(speedBox.Text)
	if num then
		speed = num
	end

	if flying then
		stopFly()
		toggle.Text = "Activar Fly"
	else
		startFly()
		toggle.Text = "Desactivar Fly"
	end

end)
