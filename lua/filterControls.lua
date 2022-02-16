--
-- TVF frequency and envelope
--

function filterControls(mod, value, source)
    local addr = "17"
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))
    local sysEx = "04 00 "

    if (partial > 2) then sysEx = "04 01 " end

    local line1 = "TVF s1"
    local line2 = "s1100 100 100"
    local v1 = "";
    local v2 = "s".. partial
    local valueStr = nil

    -- tvf frequency
    if string.find(name, "cutoff") then
        v1 = "Cutoff Freq"
        addr = calcOffset(partial, "17")

    elseif string.find(name, "res") then
        v1 = "Resonance"
        addr = calcOffset(partial, "18")

    elseif string.find(name, "freqkf") then
        line2 = "s11/2-1/4 0"
        v1 = "Freq KF"
        valueStr = KEY_FOL[value+1]
        addr = calcOffset(partial, "19")

    elseif string.find(name, "bpt") then
        line2 = "s1<A#6<B6 >C7"
        v1 = "Bias Point"
        valueStr = BIAS_PT[value+1]
        addr = calcOffset(partial, "1a")
    end



    -- tvf env time
    if string.find(name, "%-t1") then
        v1 = "Time 1"
        addr = calcOffset(partial, "0b")

    elseif string.find(name, "%-t2") then
        v1 = "Time 2"
        addr = calcOffset(partial, "0c")

    elseif string.find(name, "%-t3") then
        v1 = "Time 3"
        addr = calcOffset(partial, "0d")

    elseif string.find(name, "%-t4") then
        v1 = "Time 4"
        addr = calcOffset(partial, "0e")


    -- tvf env level
    elseif string.find(name, "l0") then
        v1 = "Level 0"
        addr = calcOffset(partial, "0f")

    elseif string.find(name, "l1") then
        v1 = "Level 1"
        addr = calcOffset(partial, "10")

    elseif string.find(name, "l2") then
        v1 = "Level 2"
        addr = calcOffset(partial, "11")

    elseif string.find(name, "lsus") then
        v1 = "End Level"
        addr = calcOffset(partial, "13")
    end



    

    line1 = line1:gsub("s1", v1)

    if valueStr ~= nil then
        line2 = line2:gsub(v2, zeroPad(valueStr))

    else
        line2 = line2:gsub(v2, zeroPad(value))
    end

    updateLCD(line1, line2)

    sendSysex(sysEx .. addr .." ".. numToHex(value))
end
