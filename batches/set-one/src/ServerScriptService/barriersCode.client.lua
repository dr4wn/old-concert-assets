local replicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui") 

local event = replicatedStorage:WaitForChild("_main")

function notify(arguments)
	StarterGui:SetCore("SendNotification", {
		Title = "Your rank is "..string.upper(arguments.priority).."!",
		Text = "The permissions for backstage access & lanyard access have been granted. For more information, ask a staff member!",
		Duration = 15
	})
end
event.OnClientEvent:Connect(function(arguments)
	local priorityDeleters = {
		["vip"] = { game.Workspace.Barriers["VIP Barriers"] },
		["staff"] = { game.Workspace.Barriers["VIP Barriers"], game.Workspace.Barriers.Regular }
	}
	notify({ priority = arguments.priority })
	if priorityDeleters[arguments.priority] then
		for _, barrier in pairs(priorityDeleters[arguments.priority]) do
			barrier:Destroy()
		end
	end
end)