local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local module = {}
module.badges = {}

for _, badge in pairs(ServerScriptService.Templates:GetChildren()) do
	if not badge:GetAttribute("identifier") then continue end
	module.badges[badge:GetAttribute("identifier")] = badge
end

function giveBadge(character, player, title)
	local userId = player.UserId
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size420x420
	local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

	local newID = module.badges[title]:Clone()
	newID.NameTag.SurfaceGui.TextLabel.Text = player.Name
	newID.Title.SurfaceGui.TextLabel.Text = string.upper(title)
	newID.PlayerPhoto.Decal.Texture = content
	newID.Middle.Position = character.UpperTorso.Position
	newID.Middle.Orientation = character.UpperTorso.Orientation

	local IDWeld = Instance.new("WeldConstraint")
	IDWeld.Part0 = character.UpperTorso
	IDWeld.Part1 = newID.Middle

	IDWeld.Parent = newID
	newID.Parent = character
end

module.giveBadge = function(player, title)
	local player = player
	local badge = player.Character:FindFirstChild("STAFF_BADGE")
	if badge ~= nil then
		badge:Destroy()
	else
		giveBadge(player.Character, player, title)
	end
end



return module