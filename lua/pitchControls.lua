--
-- WG Pitch controls
--

local partial

function pitchControls(mod, value, source)
    local addr = "00"
    local name = L(mod:getName())

    partial = tonumber(string.sub(name, -1))

    -- remove the partial number
    name = string.sub(name, 0, -4)

    local base = sysExTone[1]

    if (partial > 2) then
        base = sysExTone[2]
    end


    local line1 = "s1"
    local line2 = "s1s2s3s4"
    local v1 = "";
    local v2 = "s".. partial
    local valueStr = nil

    offset = {
        crs = "00",
        fine = "01",
        kfpitch = "02",
        bend = "03",
        
        pdep = "08",
        vel = "09",
        kftime = "0a",

        t1 = "0b",
        t2 = "0c",
        t3 = "0d",
        t4 = "0e",
        l0 = "0f",
        l1 = "10",
        l2 = "11",
        lend = "13",

        lrte = "14",
        ldep = "15",
        lmod = "16"
    }

    hideEnv()

    -- pitch mod
    if string.find(name, "crs") then
        v1 = "WG Pitch Coarse"
        addr = offset.crs
        valueStr = PITCH_COARSE[value+1]

    elseif string.find(name, "fine") then
        v1 = "WG Pitch Fine"
        addr = offset.fine
        valueStr = LEVELS[value+1]

    elseif string.find(name, "kfpitch") then
        v1 = "WG Pitch KF"
        addr = offset.kfpitch
        valueStr = KEY_FOL_PITCH[value+1]

    elseif string.find(name, "bend") then
        v1 = "WG Bender Switch"
        addr = offset.bend
        valueStr = OFF_ON[value+1]


    -- pitch env time
    elseif string.find(name, "t1") then
        v1 = "P-ENV Time 1"
        addr = offset.t1
        refreshPitchEnv()

    elseif string.find(name, "t2") then
        v1 = "P-ENV Time 2"
        addr = offset.t2
        refreshPitchEnv()

    elseif string.find(name, "t3") then
        v1 = "P-ENV Time 3"
        addr = offset.t3
        refreshPitchEnv()

    elseif string.find(name, "t4") then
        v1 = "P-ENV Time 4"
        addr = offset.t4
        refreshPitchEnv()

    -- pitch env level
    elseif string.find(name, "l0") then
        v1 = "P-ENV Level 0"
        addr = offset.l0
        valueStr = LEVELS[value+1]
        refreshPitchEnv()

    elseif string.find(name, "l1") then
        v1 = "P-ENV Level 1"
        addr = offset.l1
        valueStr = LEVELS[value+1]
        s1 = getLevel(get(name .."-p1"))
        s2 = getLevel(get(name .."-p2"))
        s3 = getLevel(get(name .."-p3"))
        s4 = getLevel(get(name .."-p4"))

        valueStr = zeroPad(s1)..zeroPad(s2)..zeroPad(s3)..zeroPad(s4)
        refreshPitchEnv()

    elseif string.find(name, "l2") then
        v1 = "P-ENV Level 2"
        addr = offset.l2
        valueStr = LEVELS[value+1]
        refreshPitchEnv()

    elseif string.find(name, "lend") then
        v1 = "P-ENV End Level"
        addr = offset.lend
        valueStr = LEVELS[value+1]
        refreshPitchEnv()


    -- pitch depth
    elseif string.find(name, "pdep") then
        v1 = "P-ENV Depth"
        addr = offset.pdep

    elseif string.find(name, "vel") then
        v1 = "P-ENV Velocity"
        addr = offset.vel

    elseif string.find(name, "kftime") then
        v1 = "P-ENV Time KF"
        addr = offset.kftime

    -- pitch mod
    elseif string.find(name, "lrte") then
        v1 = "LFO Rate"
        addr = offset.lrte
        refreshLfo()

    elseif string.find(name, "ldep") then
        v1 = "LFO Depth"
        addr = offset.ldep
        refreshLfo()

    elseif string.find(name, "lmod") then
        v1 = "WG Modulation"
        addr = offset.lmod
    end



    line1 = line1:gsub("s1", v1)

    if valueStr ~= nil then
        if string.len(valueStr) > 4 then
            line2 = valueStr

        else
            line2 = line2:gsub(v2, valueStr)
        end

    else
        s1 = get(name .."-p1")
        s2 = get(name .."-p2")
        s3 = get(name .."-p3")
        s4 = get(name .."-p4")
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


function refreshPitchEnv()
    setEnv("pitch", partial)
    panel:getComponent("envelope-graph"):repaint()
end


function refreshLfo()
    setEnv("lfo", partial)
    panel:getComponent("envelope-graph"):repaint()
end