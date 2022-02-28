-- Enable/disable partials
-- f0 41 10 16 12 04 00 0c xx z4 f7

local p1 = 1
local p2 = 1
local p3 = 1
local p4 = 1

function partialMute(mod, value)

    p1 = get("btn-mute-p1")
    p2 = get("btn-mute-p2")
    p3 = get("btn-mute-p3")
    p4 = get("btn-mute-p4")

    if p1 ~= nil and p2 ~= nul and p3 ~= nil and p4 ~= nil then
        -- Form a binary string based on button values
        binary = p4 .. p3 .. p2 .. p1
        num = tonumber(binary, 2)

        sendSysex("04 00 0c ".. numToHex(num))
    end
end


-- called from setTone
function setMuteValue(value)
    --console(value .." ".. numToBinary(value))
    binary = numToBinary(value)

    for i=1, 4, 1 do
        console("btn-mute-p".. i .." ".. binary[i])
        set("btn-mute-p".. i, binary[i])
    end

end


function numToBinary(num)
    -- returns a table of bits, least significant first.
    local t={}
    for b = 1, 4, 1 do
        rest=math.fmod(num,2)
        t[b]=rest
        num=(num-rest)/2
    end
    return t
end
