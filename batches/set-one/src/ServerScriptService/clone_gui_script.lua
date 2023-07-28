game.Players.PlayerAdded:Connect(function(player)
	local Scene = game.ReplicatedFirst["Warning Frame"]
	Scene:Clone().Parent = player.PlayerGui
end)