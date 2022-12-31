function GetArenaList()
    return ArenaData
end
exports("GetArenaList", GetArenaList)

function GetArena(identifier)
    return ArenaData[identifier]
end
exports("GetArena", GetArena)

function DoesArenaExists(identifier)
    return ArenaData[identifier] ~= nil
end
exports("DoesArenaExists", DoesArenaExists)

function GetPlayerList(identifier)
    return ArenaData[identifier] and ArenaData[identifier].PlayerList or {}
end
exports("GetPlayerList", GetPlayerList)

function IsPlayerInAnyArena()
    return PlayerData.CurrentArena ~= "none"
end
exports("IsPlayerInAnyArena", IsPlayerInAnyArena)

function IsArenaBusy(identifier)
    return ArenaData[identifier] and ArenaData[identifier].ArenaState == "ArenaBusy" or false
end
exports("IsArenaBusy", IsArenaBusy)

function GetPlayerListArena()
    return PlayerList
end
exports("GetPlayerListArena", GetPlayerListArena)

function IsPlayerInArena(arena)
    return PlayerData.CurrentArena == arena
end
exports("IsPlayerInArena", IsPlayerInArena)

function GetArenaLabel(identifier)
    return GetCurrentArenaData(identifier).ArenaLabel
end
exports("GetArenaLabel", GetArenaLabel)

function GetArenaMaximumSize(identifier)
    return GetCurrentArenaData(identifier).MaximumCapacity
end
exports("GetArenaMaximumSize", GetArenaMaximumSize)

function GetArenaMinimumSize(identifier)
    return GetCurrentArenaData(identifier).MinimumCapacity
end
exports("GetArenaMinimumSize", GetArenaMinimumSize)

function GetArenaCurrentSize(identifier)
    return GetCurrentArenaData(identifier).CurrentCapacity
end
exports("GetArenaCurrentSize", GetArenaCurrentSize)

function GetCurrentArenaData(identifier)
    return {
        ArenaIdentifier = ArenaData[identifier].ArenaIdentifier,
        ArenaLabel = ArenaData[identifier].ArenaLabel,
        MaximumCapacity = ArenaData[identifier].MaximumCapacity,
        MinimumCapacity = ArenaData[identifier].MinimumCapacity,
        CurrentCapacity = ArenaData[identifier].CurrentCapacity,
    }
end
exports("GetCurrentArenaData", GetCurrentArenaData)

function GetCurrentArenaIdentifier()
    return PlayerData.CurrentArena
end
exports("GetCurrentArenaIdentifier", GetCurrentArenaIdentifier)

function GetPlayerArena()
    return PlayerData.CurrentArena
end
exports("GetPlayerArena", GetPlayerArena)