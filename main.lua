--// KRUTAX MODIX | FINAL STABLE SCRIPT
--// Developer: xrrp018 | discord.gg/HW8pERrffm

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ================= SETTINGS =================
local ESP_ON = true
local TRACER_ON = true
local AIM_ON = true
local SPEED_ON = false
local TP_ON = false

local AIM_FOV = 150
local SPEED_VALUE = 26
local NORMAL_SPEED = 16

local TEAM_COLOR = Color3.fromRGB(0,120,255)
local ENEMY_COLOR = Color3.fromRGB(255,80,80)
local ENEMY_HIGHLIGHT = Color3.fromRGB(255,120,120)
local TEAM_HIGHLIGHT  = Color3.fromRGB(120,170,255)

-- ================= UI =================
local gui = Instance.new("ScreenGui")
gui.Name = "KrutaxUI"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,400)
frame.Position = UDim2.fromScale(0.05,0.25)
frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- Header
local header = Instance.new("Frame", frame)
header.Size = UDim2.fromOffset(260,52)
header.BackgroundColor3 = Color3.fromRGB(40,40,55)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,16)

local grad = Instance.new("UIGradient", header)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120,80,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(80,140,255))
}

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "KRUTAX MODIX"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)

-- Developer + Discord Label
local sub = Instance.new("TextLabel", frame)
sub.Position = UDim2.fromOffset(0,54)
sub.Size = UDim2.fromOffset(260,16)
sub.BackgroundTransparency = 1
sub.Text = "Developer: xrrp018  |  discord.gg/HW8pERrffm"
sub.Font = Enum.Font.Gotham
sub.TextSize = 11
sub.TextColor3 = Color3.fromRGB(200,200,200)

-- Buttons helper
local function mkBtn(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromOffset(220,36)
	b.Position = UDim2.fromOffset(20,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(50,50,60)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

-- Feature Buttons
local discordBtn = mkBtn("Join Discord",75)
local espBtn    = mkBtn("ESP: ON",120)
local aimBtn    = mkBtn("Aimbot: ON",165)
local tracerBtn = mkBtn("Tracers: ON",210)
local speedBtn  = mkBtn("Speed: OFF",255)
local tpBtn     = mkBtn("TP Player: OFF",300)
local closeBtn  = mkBtn("Close Menu",345)

-- Open Menu Button (immer sichtbar wenn geschlossen)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(140,36)
openBtn.Position = UDim2.fromScale(0.85,0.93)
openBtn.Text = "Open Menu"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
Instance.new("UICorner", openBtn)
openBtn.Visible = false

-- ================= BUTTON LOGIC =================
espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = "ESP: "..(ESP_ON and "ON" or "OFF")
end)

aimBtn.MouseButton1Click:Connect(function()
	AIM_ON = not AIM_ON
	aimBtn.Text = "Aimbot: "..(AIM_ON and "ON" or "OFF")
end)

tracerBtn.MouseButton1Click:Connect(function()
	TRACER_ON = not TRACER_ON
	tracerBtn.Text = "Tracers: "..(TRACER_ON and "ON" or "OFF")
end)

speedBtn.MouseButton1Click:Connect(function()
	SPEED_ON = not SPEED_ON
	speedBtn.Text = "Speed: "..(SPEED_ON and "ON" or "OFF")
end)

tpBtn.MouseButton1Click:Connect(function()
	TP_ON = not TP_ON
	tpBtn.Text = "TP Player: "..(TP_ON and "ON" or "OFF")
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

discordBtn.MouseButton1Click:Connect(function()
	-- öffnet Discord Link im Browser
	setclipboard("discord.gg/HW8pERrffm")
end)

-- ================= HELPERS =================
local function isEnemy(p)
	return not LP.Team or not p.Team or p.Team ~= LP.Team
end

local function hpColor(p)
	if p > 0.6 then return Color3.fromRGB(80,255,80)
	elseif p > 0.3 then return Color3.fromRGB(255,180,80)
	else return Color3.fromRGB(255,80,80) end
end

-- ================= ESP =================
local espCache = {}

local function createESP(p)
	if espCache[p] or not p.Character then return end
	local char = p.Character
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	local hl = Instance.new("Highlight", char)
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.FillTransparency = 0.45
	hl.OutlineTransparency = 1

	local bb = Instance.new("BillboardGui", char)
	bb.Adornee = hrp
	bb.Size = UDim2.fromOffset(180,45)
	bb.StudsOffset = Vector3.new(0,3,0)
	bb.AlwaysOnTop = true
	bb.MaxDistance = math.huge

	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 14

	espCache[p] = {hl=hl, txt=txt, hum=hum, hrp=hrp}
end

-- ================= TRACERS =================
local tracerCache = {}

local function removeTracer(char)
	if tracerCache[char] then
		tracerCache[char]:Remove()
		tracerCache[char] = nil
	end
end

-- ================= AIMBOT =================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Color = Color3.new(1,1,1)

local function getTarget()
	local center = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
	local best, dist = nil, AIM_FOV
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and isEnemy(p) then
			local h = p.Character:FindFirstChild("Head")
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if h and hum and hum.Health > 0 then
				local pos,on = Camera:WorldToViewportPoint(h.Position)
				if on then
					local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
					if d < dist then
						dist = d
						best = h
					end
				end
			end
		end
	end
	return best
end

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
	-- Speed
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = SPEED_ON and SPEED_VALUE or NORMAL_SPEED
	end

	-- FOV
	FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
	FOVCircle.Radius = AIM_FOV
	FOVCircle.Visible = AIM_ON

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			createESP(p)
			local d = espCache[p]
			if d and d.hum.Health > 0 then
				local dist = math.floor((Camera.CFrame.Position - d.hrp.Position).Magnitude)
				d.hl.Enabled = ESP_ON
				d.hl.FillColor = isEnemy(p) and ENEMY_HIGHLIGHT or TEAM_HIGHLIGHT
				d.txt.Visible = ESP_ON
				d.txt.TextColor3 = hpColor(d.hum.Health / d.hum.MaxHealth)
				d.txt.Text = ("HP: %d%% | %dm"):format(
					math.floor((d.hum.Health/d.hum.MaxHealth)*100), dist
				)
			end

			if TRACER_ON then
				local hrp = p.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local t = tracerCache[p.Character] or Drawing.new("Line")
					tracerCache[p.Character] = t
					local pos,on = Camera:WorldToViewportPoint(hrp.Position)
					if on then
						t.Visible = true
						t.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
						t.To = Vector2.new(pos.X,pos.Y)
						t.Thickness = 2
						t.Transparency = 1
						t.Color = isEnemy(p) and ENEMY_COLOR or TEAM_COLOR
					else
						t.Visible = false
					end
				end
			else
				removeTracer(p.Character)
			end
		end
	end

	if AIM_ON then
		local t = getTarget()
		if t then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
		end
	end

	if TP_ON then
		local lpHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if lpHRP then
			local closest, dist = nil, math.huge
			for _,p in ipairs(Players:GetPlayers()) do
				if p ~= LP and p.Character and isEnemy(p) then
					local hrp = p.Character:FindFirstChild("HumanoidRootPart")
					local hum = p.Character:FindFirstChildOfClass("Humanoid")
					if hrp and hum and hum.Health > 0 then
						local d = (lpHRP.Position - hrp.Position).Magnitude
						if d < dist then
							dist = d
							closest = hrp
						end
					end
				end
			end
			if closest then
				lpHRP.CFrame = CFrame.new(
					closest.Position - closest.CFrame.LookVector * 3 + Vector3.new(0,1.5,0)
				)
			end
		end
	end
end)
