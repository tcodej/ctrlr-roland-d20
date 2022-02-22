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

