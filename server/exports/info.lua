---@return table An array of arenas
function GetArenaList()
    return ArenaList
end

---@param identifier string Arena identifier
---@return table An instance of arena
function GetArena(identifier)
    return ArenaList[identifier]
end

---@param identifier string Arena identifier
---@return boolean?
function DoesArenaExists(identifier)
    return ArenaList[identifier] ~= nil
end

---@param identifier string Arena identifier
---@return table
function GetPlayerList(identifier)
    return ArenaList[identifier] and ArenaList[identifier].PlayerList or {}
end

---@param source integer Player server id
---@return boolean?
function IsPlayerInAnyArena(source)
    return PlayerInfo[source] ~= "none"
end

---@param source integer Player server id
---@param identifier string Arena identifier
---@return boolean?
function IsPlayerInArena(source, identifier)
    return PlayerInfo[source] == identifier
end

---@param source integer Player server id
---@return string Identifier of the arena, if he isn't anywhere it will return "none"
function GetPlayerArena(source)
    return PlayerInfo[source]
end

---@param identifier string Arena identifier
---@return boolean?
function IsArenaBusy(identifier)
    return ArenaList[identifier] and ArenaList[identifier].ArenaState == "ArenaBusy" or false
end

---@param identifier string Arena identifier
---@return boolean?
function IsArenaActive(identifier)
    return ArenaList[identifier] and ArenaList[identifier].ArenaState == "ArenaActive"
end

---@param identifier string Arena identifier
---@return boolean?
function IsArenaInactive(identifier)
    return ArenaList[identifier] and ArenaList[identifier].ArenaState == "ArenaInactive"
end

---@param identifier string Arena identifier
---@return integer
function GetPlayerCount(identifier)
    return ArenaList[identifier].CurrentCapacity
end

---@param identifier string Arena identifier
---@return string AtenaState <br>ArenaInactive - No one is in a lobby or arena<br>ArenaActive - People are in lobby<br>ArenaBusy - People playing already
function GetArenaState(identifier)
    return ArenaList[identifier].ArenaState
end

exports("GetArenaList", GetArenaList)
exports("GetArena", GetArena)
exports("DoesArenaExists", DoesArenaExists)
exports("GetPlayerList", GetPlayerList)
exports("IsPlayerInAnyArena", IsPlayerInAnyArena)
exports("IsPlayerInArena", IsPlayerInArena)
exports("GetPlayerArena", GetPlayerArena)
exports("IsArenaBusy", IsArenaBusy)
exports("GetPlayerCount", GetPlayerCount)
exports("IsArenaActive", IsArenaActive)
exports("IsArenaInactive", IsArenaInactive)
exports("GetArenaState", GetArenaState)
