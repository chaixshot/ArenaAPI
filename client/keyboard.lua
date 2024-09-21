local Promise = nil
local KeyboardActive = false

RegisterNUICallback("keyboard_dataPost", function(data, cb)
    if KeyboardActive then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        Promise:resolve(data.data)
        Promise = nil
        CloseKeyboard()
        cb("ok")
    end
end)

RegisterNUICallback("keyboard_cancel", function(data, cb)
    if KeyboardActive then
        PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        Promise:resolve(nil)
        Promise = nil
        CloseKeyboard()
    end
    cb("ok")
end)

Keyboard = function(data)
    if not data or Promise then return end
    while KeyboardActive do
        Citizen.Wait(0)
    end

    Promise = promise.new()

    OpenKeyboard(data)

    local keyboard = Citizen.Await(Promise)
    return keyboard and true or false, UnpackInput(keyboard)
end

UnpackInput = function(kb, i)
    if not kb then return end
    local index = i or 1

    if index <= #kb then
        return kb[index].input, UnpackInput(kb, index + 1)
    end
end

OpenKeyboard = function(data)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    KeyboardActive = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN",
        data = data
    })
end

CloseKeyboard = function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "CLOSE",
    })
    KeyboardActive = false
end
