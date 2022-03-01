--
-- TVA Level and Envelope
--

local partial

function ampControls(mod, value, source)
    local addr = "00"
    local name = L(mod:getName())

    partial = tonumber(string.sub(name, -1))

    -- remove the partial number
    name = string.sub(name, 0, -4)

    local base = sysExTone[1]

    if (partial > 2) then
        base = sysExTone[2]
    end

    local line1 = "TVA s1"
    local line2 = "s1s2s3s4"
    local v1 = "";
    local v2 = "s".. partial
    local valueStr = nil

    offset = {
        lvl = "29",
        vel = "2a",
        bp1 = "2b",
        bl1 = "2c",
        bp2 = "2d",
        bl2 = "2e",
        kftime = "2f",

        kfvel = "30",
        t1 = "31",
        t2 = "32",
        t3 = "33",
        t4 = "35",
        l1 = "36",
        l2 = "37",
        lsus = "39"
    }

    hideEnv()

    -- tvf frequency
    if string.find(name, "lvl") then
        v1 = "Level"
        addr = offset.lvl

    elseif name == "tva-vel" then
        v1 = "Velocity"
        addr = offset.vel
        valueStr = getValueStr(LEVELS, name, true)

    elseif string.find(name, "bp1") then
        v1 = "Bias Point 1"
        addr = offset.bp1
        valueStr = getValueStr(BIAS_PT, name, false)

    elseif string.find(name, "bl1") then
        v1 = "Bial Level 1"
        addr = offset.bl1
        valueStr = getValueStr(BIAS_LVL_TVA, name, false)

    elseif string.find(name, "bp2") then
        v1 = "Bias Point 2"
        addr = offset.bp2
        valueStr = getValueStr(BIAS_PT, name, false)

    elseif string.find(name, "bl2") then
        v1 = "Bial Level 2"
        addr = offset.bl2
        valueStr = getValueStr(BIAS_LVL_TVA, name, false)

    elseif string.find(name, "%-kftime") then
        v1 = "ENV Time KF"
        addr = offset.kftime

    elseif string.find(name, "%-kfvel") then
        v1 = "ENV T1 Velo"
        addr = offset.kfvel

    -- tvf env time
    elseif string.find(name, "t1") then
        v1 = "Time 1"
        addr = offset.t1
        refreshTVA()

    elseif string.find(name, "t2") then
        v1 = "Time 2"
        addr = offset.t2
        refreshTVA()

    elseif string.find(name, "t3") then
        v1 = "Time 3"
        addr = offset.t3
        refreshTVA()

    elseif string.find(name, "t4") then
        v1 = "Time 4"
        addr = offset.t4
        refreshTVA()


    -- tvf env level
    elseif string.find(name, "l1") then
        v1 = "Level 1"
        addr = offset.l1
        refreshTVA()

    elseif string.find(name, "l2") then
        v1 = "Level 2"
        addr = offset.l2
        refreshTVA()

    elseif string.find(name, "lsus") then
        v1 = "Sus Level"
        addr = offset.lsus
        refreshTVA()
    end


    s1 = get(name .."-p1")
    s2 = get(name .."-p2")
    s3 = get(name .."-p3")
    s4 = get(name .."-p4")
    

    line1 = line1:gsub("s1", v1)

    if valueStr ~= nil then
        if string.len(valueStr) > 4 then
            line2 = valueStr

        else
            line2 = line2:gsub(v2, valueStr)
        end

    else
        line2 = zeroPad(s1)..zeroPad(s2)..zeroPad(s3)..zeroPad(s4)
    end

    updateLCD(line1, line2)

    sendSysex(base .. calcOffset(partial, addr) .." ".. numToHex(value))
    
    -- todo: revisit this later. need to try toggling locked partial with selected partial
    -- todo: verify that source 4 is the controller being manipulated
--[[
    if source == 4 then
        if P_EDIT[1] then
            if partial ~= 1 then set(name.."-p1", value) end
        end

        if P_EDIT[2] then
            if partial ~= 2 then set(name.."-p2", value) end
        end

        if P_EDIT[3] then
            if partial ~= 3 then set(name.."-p3", value) end
        end

        if P_EDIT[4] then
            if partial ~= 4 then set(name.."-p4", value) end
        end
    end
--]]

end


function refreshTVA()
    setEnv("tva", partial)
    panel:getComponent("envelope-graph"):repaint()
end