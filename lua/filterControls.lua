--
-- TVF frequency and envelope
--

function filterControls(mod, value, source)
    local addr = "00"
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))
    -- remove the partial number
    name = string.sub(name, 0, -4)

    local base = sysExTone[1]

    if (partial > 2) then
        base = sysExTone[2]
    end

    local line1 = "TVF s1"
    local line2 = "s1s2s3s4"
    local v1 = "";
    local v2 = "s".. partial
    local valueStr = nil

    offset = {
        cutoff = "17",
        res = "18",
        freqkf = "19",
        bpt = "1a",
        blv = "1b",

        dep = "1c",
        vel = "1d",
        depkf = "1e",

        tkf = "1f",
        t1 = "20",
        t2 = "21",
        t3 = "22",
        t4 = "24",

        l1 = "25",
        l2 = "26",
        lsus = "28"
    }

    hideEnv()

    -- tvf frequency
    if string.find(name, "cutoff") then
        v1 = "Cutoff Freq"
        addr = offset.cutoff

    elseif string.find(name, "res") then
        v1 = "Resonance"
        addr = offset.res

    elseif string.find(name, "freqkf") then
        line2 = "s11/2-1/4 0"
        v1 = "Freq KF"
        valueStr = KEY_FOL[value+1]
        addr = offset.freqkf

    elseif string.find(name, "bpt") then
        line2 = "s1<A#6<B6 >C7"
        v1 = "Bias Point"
        valueStr = BIAS_PT[value+1]
        addr = offset.bpt

    elseif string.find(name, "blv") then
        --line2 = "s1<A#6<B6 >C7"
        v1 = "Bias Level"
        valueStr = BIAS_PT[value+1]
        addr = offset.blv

    -- tvf depth
    elseif name == "tvf-dep" then
        v1 = "ENV Depth"
        addr = offset.dep

    elseif string.find(name, "vel") then
        v1 = "ENV Velocity"
        addr = offset.vel

    elseif string.find(name, "depkf") then
        v1 = "ENV Depth KF"
        addr = offset.depkf

    -- tvf env time
    elseif string.find(name, "%-t1") then
        v1 = "Time 1"
        addr = offset.t1
        refreshTVF()

    elseif string.find(name, "%-t2") then
        v1 = "Time 2"
        addr = offset.t2
        refreshTVF()

    elseif string.find(name, "%-t3") then
        v1 = "Time 3"
        addr = offset.t3
        refreshTVF()

    elseif string.find(name, "%-t4") then
        v1 = "Time 4"
        addr = offset.t4
        refreshTVF()

    elseif string.find(name, "tkf") then
        v1 = "ENV Time KF"
        addr = offset.tkf


    -- tvf env level
    elseif string.find(name, "l1") then
        v1 = "Level 1"
        addr = offset.l1
        refreshTVF()

    elseif string.find(name, "l2") then
        v1 = "Level 2"
        addr = offset.l2
        refreshTVF()

    elseif string.find(name, "lsus") then
        v1 = "Sus Level"
        addr = offset.lsus
        refreshTVF()
    end


    s1 = get(name .."-p1")
    s2 = get(name .."-p2")
    s3 = get(name .."-p3")
    s4 = get(name .."-p4")
    

    line1 = line1:gsub("s1", v1)

    if valueStr ~= nil then
        line2 = line2:gsub(v2, zeroPad(valueStr))

    else
         line2 = zeroPad(s1)..zeroPad(s2)..zeroPad(s3)..zeroPad(s4)
    end

    updateLCD(line1, line2)

    sendSysex(base .. calcOffset(partial, addr) .." ".. numToHex(value))
    
    -- todo: verify that source 4 is the controller being manipulated
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

end

function refreshTVF()
    setEnv("tvf", partial)
    panel:getComponent("envelope-graph"):repaint()
end
