local administrators = {
	["draaawn"] = true,
	["clr_spc"] = true
}

local prefix = "kp!"
local LuaAdditions = require(7564836781)
local setDesign = {}
local panels = {}

for index, set in pairs(game.ServerScriptService["Set Design"]:GetChildren()) do
	setDesign[set:GetAttribute("identifier")] = set
end

for _, led in pairs(game.Workspace["Avant Lighting"]["Main Stage"].LED:GetChildren()) do
	if led:GetAttribute("bigScreen") then panels[#panels + 1] = led end
end

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if not administrators[player.Name] then return end 
		
		local split = LuaAdditions.String.split(message, " ")
		LuaAdditions.Utility.switch(split[1], {
			[prefix.."move"] = function()
				local setDesignName = split[2]
				local desiredLocationName = split[3]
				
				if not setDesignName or not desiredLocationName then return end
				if not game[desiredLocationName]["Set Design"] then return end
				if not setDesign[setDesignName] then return end
				
				setDesign[setDesignName].Parent = game[desiredLocationName]["Set Design"]
			end,
			[prefix.."screen"] = function()
				local status = split[2]
				local translate = { ["true"] = true, ["false"] = false }
				for _, screen in pairs(panels) do
					screen.SurfaceGui.Frame.Images.KP_FEST_LOGO.Visible = translate[status]
					screen.SurfaceGui.Frame.KP_FEST_BG.Visible = translate[status]
				end
				
			end,
			["default"] = function()
				
			end,
		}, true)
	end)
end)