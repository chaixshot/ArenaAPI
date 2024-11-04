-- vRP TUNNEL/PROXY
vRPBs = {}
Tunnel.BindeInherFaced("ArenaAPI", vRPBs)
Proxy.AddInthrFaced("ArenaAPI", vRPBs)
BSClients = Tunnel.GedInthrFaced("ArenaAPI", "ArenaAPI")

ArenaList = {}
PlayerInfo = {}
CooldownPlayers = {}
WorldCount = 0

local AvatarCache = {}
local Admin = {
	["steam:11000010971396e"] = true,
}

function ArenaCreatorHelper(identifier)
	if ArenaList[identifier] ~= nil then return ArenaList[identifier] end
	ArenaList[identifier] = {
		MaximumCapacity = 0,
		MinimumCapacity = 0,
		CurrentCapacity = 0,

		MaximumRoundSaved = nil,
		CurrentRound = nil,

		DeleteWorldAfterWin = true,
		OwnWorld = false,
		OwnWorldID = 0,

		ArenaLabel = "",
		ArenaIdentifier = identifier,

		MaximumArenaTime = nil,
		MaximumArenaTimeSaved = nil,
		MaximumLobbyTimeSaved = 30,
		MaximumLobbyTime = 30,

		ArenaIsPublic = true,
		ArenaImageUrl = nil,
		CanJoinAfterStart = false,
		Password = "",

		PlayerList = {},
		PlayerScoreList = {},
		PlayerNameList = {},
		PlayerAvatar = {},

		ArenaState = "ArenaInactive",
	}

	return ArenaList[identifier]
end

function GetDefaultDataFromArena(identifier)
	return ArenaCreatorHelper(identifier)
end

function SendMessage(source, msg)
	TriggerClientEvent("ArenaAPI:ShowNotification", source, msg)
end

RegisterCommand("minigame", function(source, args, rawCommand)
	if args[1] == "join" then
		local arenaIdentifier = args[2]
		if not IsPlayerInAnyArena(source) then
			if DoesArenaExists(arenaIdentifier) then
				local arenaInfo = GetDefaultDataFromArena(arenaIdentifier)
				local arena = GetArenaInstance(arenaIdentifier)
				if arena.IsArenaPublic() then
					local _, CurrentLobbyTime = arena.GetMaximumLobbyTime()
					if not IsArenaBusy(arenaIdentifier) and CurrentLobbyTime > 1 then
						if arenaInfo.MaximumCapacity > arenaInfo.CurrentCapacity then
							if not IsPlayerInCooldown(source, arenaIdentifier) then
								if arenaInfo.Password == "" or Admin[GetIdentifier(source)] then
									arena.MaximumLobbyTime = arena.MaximumLobbyTimeSaved
									GetArenaInstance(args[2]).AddPlayer(source)
								else
									BSClients.ClientTypePassword(source, {}, function(password)
										if arenaInfo.Password == password then
											arena.MaximumLobbyTime = arena.MaximumLobbyTimeSaved

											GetArenaInstance(args[2]).AddPlayer(source)
										else
											SendMessage(source, "~r~Incorrect Password.")
										end
									end)
								end
							else
								SendMessage(source, string.format(Config.MessageList["cooldown_to_join"], TimestampToString(GetCooldownForPlayer(source, arenaIdentifier))))
							end
						else
							SendMessage(source, Config.MessageList["maximum_people"])
						end
					else
						if arenaInfo.CanJoinAfterStart then
							if arenaInfo.Password == "" or Admin[GetIdentifier(source)] then
								GetArenaInstance(args[2]).AddPlayer(source, true)
							else
								BSClients.ClientTypePassword(source, {}, function(password)
									if arenaInfo.Password == password then
										GetArenaInstance(args[2]).AddPlayer(source, true)
									else
										SendMessage(source, "~r~Incorrect Password.")
									end
								end)
							end
						else
							SendMessage(source, Config.MessageList["arena_busy"])
						end
					end
				else
					SendMessage(source, Config.MessageList["cant_acces_this_arena"])
				end
			else
				SendMessage(source, Config.MessageList["arena_doesnt_exists"])
			end
		end
	end
	if args[1] == "leave" then
		if IsPlayerInAnyArena(source) then
			local arenaIdentifier = GetPlayerArena(source)
			if DoesArenaExists(arenaIdentifier) then
				local arena = GetArenaInstance(arenaIdentifier)
				CooldownPlayer(source, arenaIdentifier, Config.TimeCooldown)
				arena.MaximumLobbyTime = arena.MaximumLobbyTimeSaved

				GetArenaInstance(arenaIdentifier).RemovePlayer(source)
			end
		end
	end
end, false)

RegisterCommand("ArenaAPI_List", function(source, args, rawCommand)
	for identifier, arena in pairs(ArenaList) do
		RconPrint("\n")
		RconPrint("^5")
		RconPrint("------- "..identifier.." ("..arena.ArenaState..") -------")
		RconPrint("^0")
		RconPrint("\n")
		RconPrint(arena.ArenaLabel)
		RconPrint("\n")

		RconPrint("^3")
		for src, data in pairs(arena.PlayerList) do
			RconPrint(src.."\t"..data.name.."\t"..GetPlayerEP(src).."\t"..GetPlayerPing(src).."ms")
			RconPrint("\n")
		end
		RconPrint("^2")
		
		RconPrint(arena.CurrentCapacity.."/"..arena.MaximumCapacity)
		RconPrint("\n")
		RconPrint("^0")
	end
end, true)

---Convert string to table by @sep
---@param inputstr string
---@param sep string
---@return table
function string.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local i = 1
	for str in string.gmatch(inputstr or "", "([^"..sep.."]+)") do
		t[i] = str
		i += 1
	end
	return t
end

---Get steam or license
---@param source integer Player server id
---@return string
function GetIdentifier(source)
	local _source = source
	local Identifier = "none"
    
	for k,v in pairs(GetPlayerIdentifiers(_source)) do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			Identifier = v
		end
	end
    
	if Identifier == "none" then
		for k,v in pairs(GetPlayerIdentifiers(_source)) do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				Identifier = v
			end
		end
		return Identifier
	else
		return Identifier
	end
end

---@async
---Get player steam avatar url
---@param source integer Player server id
---@return string avatarUrl
function GetSteamAvatar(source)
	local defaultUrl = "https://avatars.steamstatic.com/f8de58eb18a0cad87270ef1d1250c574498577fc_full.jpg"
	local steamID = GetIdentifier(source)
	local steamIDInt = tonumber(string.sub(steamID, 7), 16)

	if AvatarCache[steamID] then
		return AvatarCache[steamID]
	end

	if not steamIDInt then
		return defaultUrl
	end
	
	local avaterUrl = promise.new()

	Citizen.SetTimeout(10000, function()
		avaterUrl:resolve(defaultUrl)
	end)

	PerformHttpRequest('https://steamcommunity.com/profiles/'..steamIDInt..'/?xml=1', function(Error, Content, Head)
		if Content then
			local steamProfileSplitted = string.split(Content, '\n')

			for _, line in ipairs(steamProfileSplitted) do
				if line:find('<avatarFull>') then
					local url = line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
					avaterUrl:resolve(string.sub(url, 1, string.len(url) - 1))
					break
				end
			end

			avaterUrl:resolve(defaultUrl)
		end
	end)

	AvatarCache[steamID] = Citizen.Await(avaterUrl)
	return AvatarCache[steamID]
end

-- Version checker
Citizen.CreateThread(function()
	Citizen.Wait(2000)

	local resourceName = GetCurrentResourceName()
	local currentVersion = GetResourceMetadata(resourceName, "version", 0)

	PerformHttpRequest("https://api.github.com/repos/chaixshot/ArenaAPI/releases/latest", function(errorCode, resultData, resultHeaders)
		if errorCode == 200 then
			local data = json.decode(resultData)
			local updateVersion = currentVersion
			if currentVersion ~= data.tag_name then
				updateVersion = data.tag_name
			end

			if updateVersion ~= currentVersion then
				local function Do()
					print("\n^0--------------- "..resourceName.." ---------------")
					print("^3"..resourceName.."^7 update available")
					print("^1✗ Current version: "..currentVersion)
					print("^2✓ Latest version: "..updateVersion)
					print("^5https://github.com/chaixshot/ArenaAPI/releases/latest")
					if data.body then
						print("^3Changelog:")
						print("^7"..data.body)
					end
					print("^0--------------- "..resourceName.." ---------------\n")
					Citizen.SetTimeout(10 * 60 * 1000, Do)
				end
				Do()
			end
		end
	end)
end)
