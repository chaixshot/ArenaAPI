-- vRP TUNNEL/PROXY
vRPBs = {}
Tunnel.BindeInherFaced("ArenaAPI",vRPBs)
Proxy.AddInthrFaced("ArenaAPI",vRPBs)
BSClients = Tunnel.GedInthrFaced("ArenaAPI", "ArenaAPI")

ArenaList = {}
PlayerInfo = {}
CooldownPlayers = {}
WorldCount = 0
----------------------------------------
function ArenaCreatorHelper(identifier)
    if ArenaList[identifier] ~= nil then return ArenaList[identifier] end
    ArenaList[identifier] = {
        MaximumCapacity = 0,
        MinimumCapacity = 0,
        CurrentCapacity = 0,
        -----
        MaximumRoundSaved = nil,
        CurrentRound = nil,
        -----
        DeleteWorldAfterWin = true,
        OwnWorld = false,
        OwnWorldID = 0,
        -----
        ArenaLabel = "",
        ArenaIdentifier = identifier,
        -----
        MaximumArenaTime = nil,
        MaximumArenaTimeSaved = nil,
        MaximumLobbyTimeSaved = 30,
        MaximumLobbyTime = 30,
        -----
        ArenaIsPublic = true,
		CanJoinAfterStart = false,
		Password = "",
        -----
        PlayerList = {},
        PlayerScoreList = {},
        PlayerNameList = {},
        -----
        ArenaState = "ArenaInactive",
        -----
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
        local arenaName = args[2]
        if not IsPlayerInAnyArena(source) then
            if DoesArenaExists(arenaName) then
                local arenaInfo = GetDefaultDataFromArena(arenaName)
                local arena = GetArenaInstance(arenaName)
                if arena.IsArenaPublic() then
                    if not IsArenaBusy(arenaName) then
                        if arenaInfo.MaximumCapacity > arenaInfo.CurrentCapacity then
                            if not IsPlayerInCooldown(source, arenaName) then
								if arenaInfo.Password == "" then
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
                                SendMessage(source, string.format(Config.MessageList["cooldown_to_join"], TimestampToString(GetcooldownForPlayer(source, arenaName))))
                            end
                        else
                            SendMessage(source, Config.MessageList["maximum_people"])
                        end
                    else
						if arenaInfo.CanJoinAfterStart then
							if arenaInfo.Password == "" then
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
            local arenaName = GetPlayerArena(source)
            if DoesArenaExists(arenaName) then
                local arena = GetArenaInstance(arenaName)
                CooldownPlayer(source, arenaName, Config.TimeCooldown)
                arena.MaximumLobbyTime = arena.MaximumLobbyTimeSaved

                GetArenaInstance(arenaName).RemovePlayer(source)
            end
        end
    end
end, false)