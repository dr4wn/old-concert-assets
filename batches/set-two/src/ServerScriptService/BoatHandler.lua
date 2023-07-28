local boat = game.Workspace:WaitForChild("_IMPORTANT_BOAT").PrimaryPart
if not boat then return "no boat :(" end

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local boatEvent = ReplicatedStorage:WaitForChild("_main_boat")

local highIntensityLogger = _G.logger
local BOAT_TRANSITION_TIME = 60 -- approved time
local BOAT_ALREADY_ROTATING = false
local DEFAULT_INTENSITY = 1

local steppingValue = 0
local connection

local rotationSettings = {
	intensityX = 1,
	intensityY = 1,
	intensityZ = 1,
	speed = .05,
	intensityXwave = "sin",
	intensityYwave = "cos",
	intensityZwave = "cos",
}

local admins = { ["draaawn"] = true, ["MR_BL"] = true, ["not_pdox"] = true, ["1asthma"] = true, ["clr_spc"] = true, ["rossloika"] = true, }
script.Value.Value = CFrame.new(0, 36.206, 294.95)
local positions = { 
	["stage1"] = CFrame.new(-0, 34.605, 301.9),
	["stage2"] = CFrame.new(-0, 34.605, 206.2),
	["middle"] = CFrame.new(-0, 34.605, 258.9),
	["stage1-middle"] = CFrame.new(-0, 34.605, 286.5),
	["stage2-middle"] = CFrame.new(-0, 34.605, 229.3),
	["hidden"] = CFrame.new(0, 34.605, 326.8),
}


boatEvent.OnServerEvent:Connect(function(player, args)
	if not admins[player.Name] then highIntensityLogger.log(player, args, "boatEvent") return player:Kick("go away") end
	
	local switchTable = {
		["moveBoat"] = function()
			-- solution, create multiple stopping points throughout stage a ---- b transition
			local selectedPosition = positions[args.position] or positions["stageOne"]
			
			local boatTrans = TweenService:Create(boat, TweenInfo.new(BOAT_TRANSITION_TIME), { CFrame = selectedPosition })
			local dummyValue = TweenService:Create(script.Value, TweenInfo.new(BOAT_TRANSITION_TIME), { Value = selectedPosition})
			boatTrans:Play()
			dummyValue:Play()
			
			boatTrans.Completed:Connect(function()
				--highIntensityLogger.log("boat transition complete to", args.position)
			end)
		end,
		["startRotatingBoat"] = function()
			if BOAT_ALREADY_ROTATING then return end
			BOAT_ALREADY_ROTATING = true
			
			connection = RunService.Heartbeat:Connect(function(deltaTime)
				steppingValue += rotationSettings.speed
				
				boat.CFrame = CFrame.new(script.Value.Value or boat.Position.X, boat.Position.Y, boat.Position.Z) * CFrame.Angles(
					math[rotationSettings.intensityXwave or "sin"](steppingValue) * rotationSettings.intensityX / 25 or DEFAULT_INTENSITY,
					math[rotationSettings.intensityYwave or "cos"](steppingValue) * rotationSettings.intensityY / 35 or DEFAULT_INTENSITY,
					math[rotationSettings.intensityZwave or "cos"](steppingValue) * rotationSettings.intensityZ / 25 or DEFAULT_INTENSITY
				)
				
				--boat.Orientation = Vector3.new(
				--	math[rotationSettings.intensityXwave or "sin"](steppingValue) * rotationSettings.intensityX or DEFAULT_INTENSITY,
				--	180 - (math[rotationSettings.intensityYwave or "cos"](steppingValue) * rotationSettings.intensityY) or DEFAULT_INTENSITY,
				--	math[rotationSettings.intensityZwave or "cos"](steppingValue) * rotationSettings.intensityZ or DEFAULT_INTENSITY
				--)
			end)
		end,
		["stopRotatingBoat"] = function()
			if connection == nil then return "no connection" end
			if not BOAT_ALREADY_ROTATING then return end
			connection:Disconnect()
			connection = nil
			BOAT_ALREADY_ROTATING = false
		end,
		["changeBoatSettings"] = function()
			if rotationSettings[args.key] then
				rotationSettings[args.key] = args.value
			end
		end,
	}
	if not switchTable[args.mode] then return end
	switchTable[args.mode]()
	
end)