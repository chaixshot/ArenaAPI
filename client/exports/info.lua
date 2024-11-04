---comment
---@return table List of arena in activate
function GetArenaList()
    return ArenaData
end

---Get arena instant
---@param identifier string Arena identifier
---@return table Arena instant
function GetArena(identifier)
    return ArenaData[identifier]
end

---comment
---@param identifier string Arena identifier
---@return boolean?
function DoesArenaExists(identifier)
    return ArenaData[identifier] ~= nil
end

---comment
---@param identifier string Arena identifier
---@return table List of player in arena
function GetPlayerList(identifier)
    return ArenaData[identifier] and ArenaData[identifier].PlayerList or {}
end

---comment
---@return boolean?
function IsPlayerInAnyArena()
    return PlayerData.ArenaIdentifier ~= "none"
end

---comment
---@param identifier string Arena identifier
---@return boolean?
function IsArenaBusy(identifier)
    return ArenaData[identifier] and ArenaData[identifier].ArenaState == "ArenaBusy" or false
end

---comment
---@return table Player list
function GetPlayerListArena()
    return PlayerList
end

---comment
---@param identifier string Arena identifier
---@return boolean?
function IsPlayerInArena(identifier)
    return PlayerData.ArenaIdentifier == identifier
end

---comment
---@param identifier string Arena identifier
---@return string
function GetArenaLabel(identifier)
    return GetCurrentArenaData(identifier).ArenaLabel
end

---comment
---@param identifier string Arena identifier
---@return integer
function GetArenaMaximumSize(identifier)
    return GetCurrentArenaData(identifier).MaximumCapacity
end

---comment
---@param identifier string Arena identifier
---@return integer
function GetArenaMinimumSize(identifier)
    return GetCurrentArenaData(identifier).MinimumCapacity
end

---comment
---@param identifier string Arena identifier
---@return integer
function GetArenaCurrentSize(identifier)
    return GetCurrentArenaData(identifier).CurrentCapacity
end

---comment
---@param identifier string Arena identifier
---@return table ArenaData[identifier, label, maximumCapacity, minimumCapacity, currentCapacity]
function GetCurrentArenaData(identifier)
    return {
        ArenaIdentifier = ArenaData?[identifier].ArenaIdentifier,
        ArenaLabel = ArenaData?[identifier].ArenaLabel,
        MaximumCapacity = ArenaData?[identifier].MaximumCapacity or -1,
        MinimumCapacity = ArenaData?[identifier].MinimumCapacity or -1,
        CurrentCapacity = ArenaData?[identifier].CurrentCapacity or -1,
    }
end

---comment
---@return string Current player arena identifier
function GetCurrentArenaIdentifier()
    return PlayerData.ArenaIdentifier
end

---comment
---@return string Current player arena identifier
function GetPlayerArena()
    return PlayerData.ArenaIdentifier
end

exports("GetArena", GetArena)
exports("GetArenaList", GetArenaList)
exports("DoesArenaExists", DoesArenaExists)
exports("GetPlayerList", GetPlayerList)
exports("IsPlayerInAnyArena", IsPlayerInAnyArena)
exports("IsArenaBusy", IsArenaBusy)
exports("GetPlayerListArena", GetPlayerListArena)
exports("IsPlayerInArena", IsPlayerInArena)
exports("GetArenaLabel", GetArenaLabel)
exports("GetArenaMaximumSize", GetArenaMaximumSize)
exports("GetArenaMinimumSize", GetArenaMinimumSize)
exports("GetArenaCurrentSize", GetArenaCurrentSize)
exports("GetCurrentArenaData", GetCurrentArenaData)
exports("GetCurrentArenaIdentifier", GetCurrentArenaIdentifier)
exports("GetPlayerArena", GetPlayerArena)
