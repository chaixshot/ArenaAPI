function CooldownPlayer(source, identifier, time)
    CooldownPlayers[source][identifier] = os.time(os.date("!*t")) + time
end

function IsPlayerInCooldown(source, identifier)
    if CooldownPlayers[source][identifier] == nil then
        return false
    end
    return CooldownPlayers[source][identifier] > os.time(os.date("!*t"))
end

function TimestampToString(time)
    return os.date("%H:%M:%S", time + Config.TimeZone * 60 * 60)
end

function GetCooldownForPlayer(source, identifier)
    if CooldownPlayers[source][identifier] == nil then
        return os.time(os.date("!*t"))
    end
    return CooldownPlayers[source][identifier]
end
