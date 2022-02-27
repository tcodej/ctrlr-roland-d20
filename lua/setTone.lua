-- Sets tone options from data received from the D-20
-- getByte is available in midiMessageReceived which contains the data

function setTone()

    -- construct the name
    local name = ""
    for i=8,17,1 do
        num = tostring(hexToNum(getByte(i))-31)
        letter = string.sub(ASCII, num, num)
        name = name .. letter
    end

    console(name)
end



