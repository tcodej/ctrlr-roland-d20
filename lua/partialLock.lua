--
-- Lock/unlock editing 1-4 partial values at once
--

function partialLock(mod, value)
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))
    name = string.sub(name, 0, -2)

    console(name ..": ".. partial)
end
