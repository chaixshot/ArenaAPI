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
								SendMessage(source, string.format(Config.MessageList["cooldown_to_join"], TimestampToString(GetcooldownForPlayer(source, arenaIdentifier))))
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

function GetIdentifier(source)
	local _source = source
	local steamid = "none"
	for k, v in pairs(GetPlayerIdentifiers(_source)) do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		end
	end
	return steamid or ""
end

---@async
---comment
---@param source integer Player server id
---@return string Steam image url
function GetSteamAvatar(source)
	local steamid = "none"
	for k, v in pairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		end
	end

	if AvatarCache[steamid] then
		return AvatarCache[steamid]
	end

	local steamIDInt = tonumber(string.sub(steamid, 7), 16)
	local avaterurl = promise.new()

	if not steamIDInt then
		return "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/f8/f8de58eb18a0cad87270ef1d1250c574498577fc_full.jpg"
	end

	Citizen.SetTimeout(5000, function()
		avaterurl:resolve(nil)
	end)

	PerformHttpRequest('https://steamcommunity.com/profiles/'..steamIDInt..'/?xml=1', function(Error, Content, Head)
		if Content then
			local SteamProfileSplitted = string.split(Content, '\n')

			for i, Line in ipairs(SteamProfileSplitted) do
				if Line:find('<avatarFull>') then
					local url = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
					url = string.sub(url, 1, string.len(url) - 1)
					avaterurl:resolve(url)
					break
				end
			end

			avaterurl:resolve(nil)
		end
	end)

	AvatarCache[steamid] = Citizen.Await(avaterurl)

	if AvatarCache[steamid] then
		return AvatarCache[steamid]
	else
		return "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/f8/f8de58eb18a0cad87270ef1d1250c574498577fc_full.jpg"
	end
end

Citizen.CreateThread(function()
	Citizen.Wait(2000)

	local resourceName = GetCurrentResourceName()
	local currentVersion = GetResourceMetadata(resourceName, "version", 0)
	PerformHttpRequest("https://api.github.com/repos/chaixshot/ArenaAPI/releases/latest", function(errorCode, resultData, resultHeaders)
		if errorCode == 200 then
			local data = json.decode(resultData)
			if currentVersion ~= data.name then
				print("------------------------------")
				print("Update available for ^1"..resourceName.."^0")
				print("Please update to the latest release ^2(version: "..data.name..")^0")
				print("Check in ^3"..data.html_url.."^0")
				print("------------------------------")
			end
		end
	end)
end)
