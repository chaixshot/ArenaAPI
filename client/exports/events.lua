---Called whenever someone join arena
---@param identifier string Arena identifier
---@param cb function Callback function
function OnArenaRoundEnd(identifier, cb)
    On(identifier, "roundend", cb)
end

---Called whenever player leave arena
---@param identifier string Arena identifier
---@param cb function Callback function
function OnPlayerJoinLobby(identifier, cb)
    On(identifier, "join", cb)
end

---Called whenever arena started game
---@param identifier string Arena identifier
---@param cb function Callback function
function OnPlayerExitLobby(identifier, cb)
    On(identifier, "leave", cb)
end

---Called after arena runs out of time or player achieve enough points
---@param identifier string Arena identifier
---@param cb function Callback function
function OnArenaStart(identifier, cb)
    On(identifier, "start", cb)
end

---@param identifier string Arena identifier
---@param cb function Callback function
function OnArenaEnd(identifier, cb)
    On(identifier, "end", cb)
end

exports("On", On)
exports("OnArenaRoundEnd", OnArenaRoundEnd)
exports("OnPlayerJoinLobby", OnPlayerJoinLobby)
exports("OnPlayerExitLobby", OnPlayerExitLobby)
exports("OnArenaStart", OnArenaStart)
exports("OnArenaEnd", OnArenaEnd)
