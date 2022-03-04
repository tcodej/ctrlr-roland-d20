--
-- Lock/unlock editing 1-4 partial values at once
--

function partialLock(mod, value)
    stopBlinker()
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))
    name = string.sub(name, 0, -2)

    if value == 0 then
        value = false
    end
    
    if value == 1 then
        value = true
    end

    P_EDIT[partial] = value

    startBlinker()
end
