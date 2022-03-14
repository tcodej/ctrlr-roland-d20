-- Handles common controls

-- structure sysex
-- f0 41 10 16 12 04 00 0a/0b xx z4 f7

function commonControls(mod, value, source)
	local offset = "00"
    local name = L(mod:getName())
    local sysEx = "04 00 0a"

    local line1 = ""
    local line2 = ""

    hideEnv()

    if name == "btn-env-mode" then
        line1 = "ENV Mode"
        if value == 0 then line2 = "NORMAL" end
        if value == 1 then line2 = "NO SUSTAIN" end
        sysEx = "04 00 0d"

    elseif name == "mod-struct1" then
        line1 = "Structure 1&2"
        line2 = zeroPad(value+1)
        sysEx = "04 00 0a"
        structureMatrix(1, value)

    elseif name == "mod-struct2" then
        line1 = "Structure 3&4"
        line2 = zeroPad(value+1)
        sysEx = "04 00 0b"
        structureMatrix(2, value)
    end

    sysEx = sysEx .." ".. numToHex(value)

    updateLCD(line1, line2)

    sendSysex(sysEx)
end



function toggleForm(partial, value)
    -- 0 is wav
    -- 1 is pcm

    panel:getComponent("tabs-form".. partial):setProperty("uiTabsCurrentTab", value, false)


    -- pcm hides group-tvf-freq, group-tvf-env
    if value == 0 then value = true end
    if value == 1 then value = false end

    panel:getModulatorByName("group-tvf-freq".. partial):getComponent():setVisible(value)
    panel:getModulatorByName("group-tvf-env".. partial):getComponent():setVisible(value)
end



--[[
1	s-s
2	s-s-r
3	p-s
4	p-s-r
5	s-p-r
6	p-p
7	p-p-r
8	s s
9	p p
10	s s r
11	p s r
12	s p r
13	p p r
--]]

function structureMatrix(partialGroup, val)
    if partialGroup ~= 1 then partialGroup = 3 end

    --console(tostring(val))

    if val == 0 or val == 1 or val == 7 or val == 9  then
        -- ss
        toggleForm(partialGroup, 0)
        toggleForm(partialGroup+1, 0)

    elseif val == 5 or val == 6 or val == 8 or val == 12 then
        -- pp
        toggleForm(partialGroup, 1)
        toggleForm(partialGroup+1, 1)

    elseif val == 2 or val == 3 or val == 10 then
        -- ps
        toggleForm(partialGroup, 1)
        toggleForm(partialGroup+1, 0)

    elseif val == 4 or val == 11 then
        -- sp
        toggleForm(partialGroup, 0)
        toggleForm(partialGroup+1, 1)
    end
end
