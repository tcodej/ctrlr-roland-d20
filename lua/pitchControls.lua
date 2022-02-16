--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
-- names of modulator components must end with the partial number 1-4

function pitchControls(mod, value, source)
    local offset = "00"
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))
    local sysEx = "04 00 "

    if (partial > 2) then sysEx = "04 01 " end

    local line1 = "P-ENV s1"
    local line2 = "s1 100 100 100"
    local v1 = "";
    local v2 = "s".. partial

    -- pitch env time
    if string.find(name, "t1") then
        v1 = "Time 1"
        offset = calcOffset(partial, "0b")

    elseif string.find(name, "t2") then
        v1 = "Time 2"
        offset = calcOffset(partial, "0c")

    elseif string.find(name, "t3") then
        v1 = "Time 3"
        offset = calcOffset(partial, "0d")

    elseif string.find(name, "t4") then
        v1 = "Time 4"
        offset = calcOffset(partial, "0e")


    -- pitch end level
    elseif string.find(name, "l0") then
        v1 = "Level 0"
        offset = calcOffset(partial, "0f")

    elseif string.find(name, "l1") then
        v1 = "Level 1"
        offset = calcOffset(partial, "10")

    elseif string.find(name, "l2") then
        v1 = "Level 2"
        offset = calcOffset(partial, "11")

    elseif string.find(name, "lend") then
        v1 = "End Level"
        offset = calcOffset(partial, "13")
    end


    -- pitch depth
    -- coming soon



    sysEx = sysEx .. offset .." ".. numToHex(value)

    if value < 10 then
        value = " 0" .. value
    elseif value < 100 then
        value = " " .. value
    end

    line1 = line1:gsub("s1", v1)
    line2 = line2:gsub(v2, value)
    updateLCD(line1, line2)

    sendSysex(sysEx)
end
