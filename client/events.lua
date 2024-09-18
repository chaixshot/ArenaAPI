AddEventHandler('onResourceStop', function(resourceName)
    RemoveEventsWithNameResource(resourceName)
end)

RegisterNetEvent("ArenaAPI:sendStatus")
AddEventHandler("ArenaAPI:sendStatus", function(type, data)
    local arenaIdentifier = data.ArenaIdentifier
    if type == "updateData" then
        ArenaData = data
        UpdatePlayerNameList()
    end

    if type == "updatePlayerList" then
        if data.PlayerList and PlayerData.ArenaIdentifier == arenaIdentifier then
            PlayerList = data.PlayerList
        end
    end

    if type == "roundEnd" then
        if ArenaData[arenaIdentifier].MaximumArenaTime then
            ArenaData[arenaIdentifier].MaximumArenaTime = data.MaximumLobbyTime + 1
        end
        CallOn(arenaIdentifier, "roundend", data)
    end

    if type == "start" then
        if ArenaData[arenaIdentifier] then
            ArenaData[arenaIdentifier].ArenaState = "ArenaBusy"
        end
        CallOn(arenaIdentifier, "start", data)
        if PlayerData.ArenaIdentifier == arenaIdentifier then
            SendNUIMessage({type = "ui", status = false})
            IsArenaBusy = true
            Citizen.Wait(1000)
        end
    end

    if type == "end" then
        if ArenaData[arenaIdentifier] then
            ArenaData[arenaIdentifier].ArenaState = "ArenaInactive"
        end
        CallOn(arenaIdentifier, "end", data)
        if ArenaData[arenaIdentifier] and ArenaData[arenaIdentifier].MaximumArenaTime then
            ArenaData[arenaIdentifier].MaximumArenaTime = data.MaximumLobbyTime + 1
        end
        if PlayerData.ArenaIdentifier == arenaIdentifier then
            IsArenaBusy = false
            PlayerData.ArenaIdentifier = "none"
            PlayerList = {}
        end
    end

    if type == "join" then
        PlayerData.ArenaIdentifier = data.ArenaIdentifier
        CallOn(arenaIdentifier, "join", data)

        if data.JoinAfterArenaStart then
            TriggerEvent("ArenaAPI:sendStatus", "start", data)
        elseif not data.ArenaIdentifier:lower():find("freemode") then
            SendNUIMessage({type = "ui", status = true})
            SendNUIMessage({type = "arenaName", arenaName = data.ArenaLabel})
            if data.ArenaImageUrl and data.ArenaImageUrl ~= "" then
                SendNUIMessage({type = "arenaImageURL", arenaImage = data.ArenaImageUrl})
            else
                SendNUIMessage({type = "arenaImage", arenaImage = string.gsub(data.ArenaIdentifier, "%d+", "")})
            end
        end
        UpdatePlayerNameList()
    end

    if type == "leave" then
        CallOn(arenaIdentifier, "leave", data)

        if PlayerData.ArenaIdentifier == arenaIdentifier then
            IsArenaBusy = false
            PlayerList = {}
        end

        PlayerData.ArenaIdentifier = "none"
        SendNUIMessage({type = "ui", status = false})
    end
end)
