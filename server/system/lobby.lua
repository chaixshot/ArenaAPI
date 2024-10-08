function UpdateLobbies()
    Citizen.SetTimeout(1000, UpdateLobbies)

    for k, v in pairs(ArenaList) do
        if IsArenaActive(k) then
            if v.MinimumCapacity - 1 < v.CurrentCapacity then
                v.MaximumLobbyTime -= 1
                if v.MaximumLobbyTime == 0 then
                    v.MaximumLobbyTime = v.MaximumLobbyTimeSaved

                    v.ArenaState = "ArenaBusy"

                    TriggerClientEvent("ArenaAPI:sendStatus", -1, "start", GetDefaultDataFromArena(k))

                    CallOn(k, "start", v)

                    if v.OwnWorld then
                        for id, _ in pairs(v.PlayerList) do
                            SetPlayerRoutingBucket(id, v.OwnWorldID)
                        end
                    end
                end
            end
        end
        if IsArenaBusy(k) then
            if v.CurrentCapacity == 0 then
                GetArenaInstance(k).Reset()
            end
        end
    end
end

Citizen.SetTimeout(1000, UpdateLobbies)

function UpdateArenaGame()
    Citizen.SetTimeout(1000, UpdateArenaGame)

    for k, v in pairs(ArenaList) do
        if IsArenaBusy(k) then
            if v.MaximumArenaTime then
                v.MaximumArenaTime -= 1
                if v.MaximumArenaTime == 0 then
                    v.MaximumArenaTime = v.MaximumArenaTimeSaved
                    if v.CurrentRound then
                        v.CurrentRound -= 1
                        if v.CurrentRound == -1 then
                            GetArenaInstance(k).Reset()
                            TriggerClientEvent("ArenaAPI:sendStatus", -1, "end", GetDefaultDataFromArena(k))
                        else
                            CallOn(k, "roundEnd", v)
                            TriggerClientEvent("ArenaAPI:sendStatus", -1, "roundEnd", GetDefaultDataFromArena(k))
                        end
                    else
                        GetArenaInstance(k).Reset()
                        TriggerClientEvent("ArenaAPI:sendStatus", -1, "end", GetDefaultDataFromArena(k))
                    end
                end
            end
        end
    end
end

Citizen.SetTimeout(1000, UpdateArenaGame)
