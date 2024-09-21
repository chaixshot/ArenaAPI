--[[Proxy/Tunnel]] --
vRPBs = {}
Tunnel.BindeInherFaced("ArenaAPI", vRPBs)
BSServers = Tunnel.GedInthrFaced("ArenaAPI", "ArenaAPI")

IsArenaBusy = false

ArenaData = {}
PlayerList = {}
PlayerData = {
	ArenaIdentifier = "none",
}

function DecimalsToMinutes(dec)
	if dec then
		local ms = tonumber(dec)
		return math.floor(ms / 60)..":"..(ms % 60)
	else
		return 0
	end
end

function UpdatePlayerNameList()
	if IsPlayerInAnyArena() then
		local data = GetArena(GetPlayerArena())
		local names = {}
		for source, name in pairs(data.PlayerNameList) do
			table.insert(names, {name = name, avatar = data.PlayerAvatar[source]})
		end
		SendNUIMessage({type = "playerNameList", Names = names,})
	end
end

Citizen.CreateThread(function()
	TriggerServerEvent("ArenaAPI:PlayerJoinedFivem")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if IsArenaBusy then
			local data = GetArena(GetPlayerArena())
			if data and data.MaximumArenaTime ~= nil and data.MaximumArenaTime > 1 then
				data.MaximumArenaTime -= 1
				if data.ShowArenaTime then
					BeginTextCommandPrint('STRING')
					AddTextComponentSubstringPlayerName("Time Left "..DecimalsToMinutes(data.MaximumArenaTime))
					EndTextCommandPrint(1000, true)
				end
				TriggerEvent("ArenaAPI:UpdateArenaTime", DecimalsToMinutes(data.MaximumArenaTime))
			end
		end

		if IsPlayerInAnyArena() then
			local data = GetArena(GetPlayerArena())
			if data and data.MinimumCapacity - 1 < data.CurrentCapacity then
				if data.MaximumLobbyTime == 1 then
					SendNUIMessage({type = "ui", status = false})
				else
					data.MaximumLobbyTime -= 1
					SendNUIMessage({
						type = "updateTime",
						time = data.MaximumLobbyTime,
					})
				end
			end
		end
	end
end)

local onPause = false
Citizen.CreateThread(function()
	while true do
		if IsPauseMenuActive() then
			if not onPause then
				onPause = not onPause
				if IsPlayerInAnyArena() and not IsArenaBusy then
					SendNUIMessage({type = "ui", status = false})
				end
			end
		elseif onPause then
			onPause = not onPause
			if IsPlayerInAnyArena() and not IsArenaBusy then
				SendNUIMessage({type = "ui", status = true})
			end
		end
		Citizen.Wait(100)
	end
end)

function vRPBs.ClientTypePassword()
	local keyboard, password = Keyboard({
		rows = {"Password:"},
		value = {""},
	})

	if keyboard then
		return password
	end
	
	return ""
end

RegisterNetEvent("ArenaAPI:ShowNotification")
AddEventHandler("ArenaAPI:ShowNotification", function(msg)
	BeginTextCommandThefeedPost('STRING')
	AddTextComponentSubstringPlayerName(msg)
	local id = EndTextCommandThefeedPostTicker(false, true)
	ThefeedRemoveItem(id - 5)
end)
