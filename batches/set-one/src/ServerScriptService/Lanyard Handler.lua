local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lanyardEvent = ReplicatedStorage["Game Events"].Lanyard

local lanyardModule = require(ServerScriptService["Game Scripts"].Lanyard)
local exclusives = require(ReplicatedStorage.Main.Exclusives).list

lanyardEvent.OnServerEvent:Connect(function(player)
	if not exclusives[player.UserId] then return end
	lanyardModule.giveBadge(player, exclusives[player.UserId].typeOfPriority)
end)
