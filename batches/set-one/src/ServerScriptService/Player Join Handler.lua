local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")

local PlayerOwnsAsset = MarketplaceService.PlayerOwnsAsset

local log_en = false

function log(callback, ...)
	if not log_en then return end
	callback(...)
end

function givePlayerBarriers(player, priority)
	local event = ReplicatedStorage._main
	script.barriersCode:Clone().Parent = player.PlayerGui
	wait(2)

	event:FireClient(player, {
		priority = priority
	})
end

local exclusivesList = require(ReplicatedStorage.Main.Exclusives).list

function isInExclusivesList(player)
	return exclusivesList[player.UserId] or false
end

Players.PlayerAdded:Connect(function(player)
	local _, doesPlayerOwnAsset = pcall(PlayerOwnsAsset, MarketplaceService, player, 8510085349)
	local userGroups = GroupService:GetGroupsAsync(player.UserId)
	
	if isInExclusivesList(player) then
		log(warn, player.Name, "is ", exclusivesList[player.UserId].typeOfPriority.."!")
		givePlayerBarriers(player, exclusivesList[player.UserId].typeOfPriority)
		return
	end

	local success, message = pcall(function()
		for _, userGroup in ipairs(userGroups) do
			if userGroup.Id == 13159523 then
				local userRankIdInGroup = player:GetRankInGroup(userGroup.Id)
				if userRankIdInGroup >= 254 then
					if (not isInExclusivesList(player)) then
						exclusivesList[player.UserId] = { typeOfPriority = "staff"}
						log(warn, player.Name, "is Staff!")
						givePlayerBarriers(player, "staff")
					end
				end
			end
		end
		return
	end)
	
	if (doesPlayerOwnAsset and not isInExclusivesList(player)) then
		exclusivesList[player.UserId] = { typeOfPriority = "vip"}
		log(warn, player.Name, "is vip!")
		givePlayerBarriers(player, "vip")
		return
	end
	
	if not success then
		
	end
end)
	
