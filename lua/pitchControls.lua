--
-- WG Pitch controls
--

function pitchControls(mod, value, source)
    local addr = "00"
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))
    local sysEx = "04 00 "
    local valueStr = nil

    if (partial > 2) then sysEx = "04 01 " end

    local line1 = "s1"
    local line2 = "s1100  99  00"
    local v1 = "";
    local v2 = "s".. partial

    -- pitch env time
    if string.find(name, "t1") then
        v1 = "P-ENV Time 1"
        addr = calcOffset(partial, "0b")

    elseif string.find(name, "t2") then
        v1 = "P-ENV Time 2"
        addr = calcOffset(partial, "0c")

    elseif string.find(name, "t3") then
        v1 = "P-ENV Time 3"
        addr = calcOffset(partial, "0d")

    elseif string.find(name, "t4") then
        v1 = "P-ENV Time 4"
        addr = calcOffset(partial, "0e")


    -- pitch env level
    elseif string.find(name, "l0") then
        v1 = "P-ENV Level 0"
        addr = calcOffset(partial, "0f")

    elseif string.find(name, "l1") then
        v1 = "P-ENV Level 1"
        addr = calcOffset(partial, "10")

    elseif string.find(name, "l2") then
        v1 = "P-ENV Level 2"
        addr = calcOffset(partial, "11")

    elseif string.find(name, "lend") then
        v1 = "P-ENV End Level"
        addr = calcOffset(partial, "13")
    end


    -- pitch depth
    if string.find(name, "kf") then
        v1 = "WG Pitch KF"
        addr = calcOffset(partial, "02")
        valueStr = KEY_FOL_PITCH[value+1]
    end


    sysEx = sysEx .. addr .." ".. numToHex(value)

    line1 = line1:gsub("s1", v1)

    if valueStr ~= nil then
        line2 = line2:gsub(v2, zeroPad(valueStr))

    else
        line2 = line2:gsub(v2, zeroPad(value))
    end

    updateLCD(line1, line2)

    sendSysex(sysEx)

end
