-- Enable/disable partials
-- f0 41 10 16 12 04 00 0c xx z4 f7

local p1 = 1
local p2 = 1
local p3 = 1
local p4 = 1

function partialMute(mod, value)

    p1 = panel:getModulatorByName("btn-mute1"):getModulatorValue()
    p2 = panel:getModulatorByName("btn-mute2"):getModulatorValue()
    p3 = panel:getModulatorByName("btn-mute3"):getModulatorValue()
    p4 = panel:getModulatorByName("btn-mute4"):getModulatorValue()

    if p1 ~= nil and p2 ~= nul and p3 ~= nil and p4 ~= nil then
        -- Form a binary string based on button values
        binary = p4 .. p3 .. p2 .. p1
        num = tonumber(binary, 2)

        sendSysex("04 00 0c ".. numToHex(num))
    end
end

