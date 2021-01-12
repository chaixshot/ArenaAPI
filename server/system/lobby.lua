function UpdateLobbies()
    SetTimeout(1000, UpdateLobbies)

    for k, v in pairs(ArenaList) do
        if IsArenaActive(k) then
            if v.MinimumCapacity - 1 < v.CurrentCapacity then
                v.MaximumLobbyTime = v.MaximumLobbyTime - 1
                if v.MaximumLobbyTime == 0 then
                    v.MaximumLobbyTime = v.MaximumLobbyTimeSaved

                    v.ArenaState = "ArenaBusy"
                    if v.EventList.OnArenaStarted then
                        v.EventList.OnArenaStarted(GetDefaultDataFromArena(k))
                    end
                    TriggerClientEvent("ArenaAPI:sendStatus", -1, "start", GetDefaultDataFromArena(k))
                end
            end
        end
        if IsArenaBusy(k) then
            if v.CurrentCapacity == 0 then
                GetArena(k).Reset()
            end
        end
    end
end
SetTimeout(1000, UpdateLobbies)

function UpdateArenaGame()
    SetTimeout(1000, UpdateArenaGame)

    for k, v in pairs(ArenaList) do
        if IsArenaBusy(k) then
            if v.MaximumArenaTime then
                v.MaximumArenaTime = v.MaximumArenaTime - 1
                if v.MaximumArenaTime == 0 then
                    v.MaximumArenaTime = v.MaximumArenaTimeSaved
                    GetArena(k).Reset()
                    TriggerClientEvent("ArenaAPI:sendStatus", -1, "end", GetDefaultDataFromArena(k))
                end
            end
        end
    end
end

SetTimeout(1000, UpdateArenaGame)