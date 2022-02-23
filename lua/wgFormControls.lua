-- Handles WG form controls (wav/pcm)

-- wg form/pcm bank
-- f0 41 10 16 12 04 00 12 xx z4 f7

-- wg wave no.
-- f0 41 10 16 12 04 00 13 xx z4 f7

-- wg pulse width
-- f0 41 10 16 12 04 00 14 xx z4 f7

-- wg pulse width velocity
-- f0 41 10 16 12 04 00 15 xx z4 f7

-- SQU/1, SAW/1, SQU/2, SAW/2


pcmBank = {}
pcmBank[0] = {"Bass Drum 1", "Bass Drum 2", "Bass Drum 3", "Snare Drum 1", "Snare Drum 2", "Snare Drum 3", "Snare Drum 4", "Tom Tom 1", "Tom Tom 2", "High Hat", "High Hat Loop", "Crash", "Crash Loop", "Ride", "Ride Loop", "Cup", "China", "China Loop", "Rim Shot", "Hand Clap", "Mute High Conga", "Conga", "Bongo", "Cowbell", "Tambourine", "Agogo", "Claves", "Timbale High", "Timbale Low", "Cabasa", "Timpani Attack", "Timpani", "Acoustic Piano High", "Acoustic Piano Low", "Piano Forte Thump", "Organ Percussion", "Trumpet", "Lips", "Trombone", "Clarinet", "Flute High", "Flute Low", "Steamer", "Indian Flute", "Breath", "Vibraphone High", "Vibraphone Low", "Marimba", "Xylophone High", "Xylophone Low", "Kalimba", "Wind Bell", "Chime Bar", "Hammer", "Guiro", "Chink", "Nails", "Fretless Bass", "Pull Bass", "Slap Bass", "Thump Bass", "Acoustic Bass", "Electric Bass", "Gut Guitar", "Steel Guitar", "Dirty Guitar", "Pizzicato", "Harp", "Contrabass", "Cello", "Violin 1", "Violin 2", "Koto", "Draw bars (Loop)", "High Organ (Loop)", "Low Organ (Loop)", "Trumpet (Loop)", "Trombone (Loop)", "Sax 1 (Loop)", "Sax 2 (Loop)", "Reed (Loop)", "Slap Bass (Loop)", "Acoustic Bass (Loop)", "Electric Bass 1 (Loop)", "Electric Bass 2 (Loop)", "Gut Guitar (Loop)", "Steel Guitar (Loop)", "Electric Guitar (Loop)", "Clav (Loop)", "Cello (Loop)", "Violin (Loop)", "Electric Piano 1 (Loop)", "Electric Piano 2 (Loop)", "Harpsichord 1 (Loop)", "Harpsichord 2 (Loop)", "Telephone Bell (Loop)", "Female Voice 1 (Loop)", "Female Voice 2 (Loop)", "Male Voice 1 (Loop)", "Male Voice 2 (Loop)", "Spectrum 1 (Loop)", "Spectrum 2 (Loop)", "Spectrum 3 (Loop)", "Spectrum 4 (Loop)", "Spectrum 5 (Loop)", "Spectrum 6 (Loop)", "Spectrum 7 (Loop)", "Spectrum 8 (Loop)", "Spectrum 9 (Loop)", "Spectrum 10 (Loop)", "Noise (Loop)", "Shot 1", "Shot 2", "Shot 3", "Shot 4", "Shot 5", "Shot 6", "Shot 7", "Shot 8", "Shot 9", "Shot 10", "Shot 11", "Shot 12", "Shot 13", "Shot 14", "Shot 15", "Shot 16", "Shot 17"}
pcmBank[1] = {"Bass Drum 1*", "Bass Drum 2*", "Bass Drum 3*", "Snare Drum 1*", "Snare Drum 2*", "Snare Drum 3*", "Snare Drum 4*", "Tom Tom 1*", "Tom Tom 2*", "High Hat*", "High Hat* (Loop)", "Crash Cymbal 1*", "Crash Cymbal 2* (Loop)", "Ride Cymbal 1*", "Ride Cymbal 2* (Loop)", "Cup*", "China Cymbal 1*", "China Cymbal 2* (Loop)", "Rim Shot*", "Hand Clap*", "Mute High Conga*", "Conga*", "Bongo*", "Cowbell*", "Tambourine*", "Agogo*", "Claves*", "Timbale High*", "Timbale Low*", "Cabasa*", "Loop 1", "Loop 2", "Loop 3", "Loop 4", "Loop 5", "Loop 6", "Loop 7", "Loop 8", "Loop 9", "Loop 10", "Loop 11", "Loop 12", "Loop 13", "Loop 14", "Loop 15", "Loop 16", "Loop 17", "Loop 18", "Loop 19", "Loop 20", "Loop 21", "Loop 22", "Loop 23", "Loop 24", "Loop 25", "Loop 26", "Loop 27", "Loop 28", "Loop 29", "Loop 30", "Loop 31", "Loop 32", "Loop 33", "Loop 34", "Loop 35", "Loop 36", "Loop 37", "Loop 38", "Loop 39", "Loop 40", "Loop 41", "Loop 42", "Loop 43", "Loop 44", "Loop 45", "Loop 46", "Loop 47", "Loop 48", "Loop 49", "Loop 50", "Loop 51", "Loop 52", "Loop 53", "Loop 54", "Loop 55", "Loop 56", "Loop 57", "Loop 58", "Loop 59", "Loop 60", "Loop 61", "Loop 62", "Loop 63", "Loop 64", "Jam 1", "Jam 2", "Jam 3", "Jam 4", "Jam 5", "Jam 6", "Jam 7", "Jam 8", "Jam 9", "Jam 10", "Jam 11", "Jam 12", "Jam 13", "Jam 14", "Jam 15", "Jam 16", "Jam 17", "Jam 18", "Jam 19", "Jam 20", "Jam 21", "Jam 22", "Jam 23", "Jam 24", "Jam 25", "Jam 26", "Jam 27", "Jam 28", "Jam 29", "Jam 30", "Jam 31", "Jam 32", "Jam 33", "Jam 34"}


function wgFormControls(mod, value, source)
	local addr = "00"
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))
    -- remove the partial number
    name = string.sub(name, 0, -4)

    local sysEx = "04 00 "

    if (partial > 2) then sysEx = "04 01 " end

    local line1 = "WG s1"
    local line2 = "s1 s2 s3 s4"
    local v1 = "";
    local v2 = "s".. partial
    local valueStr = nul

    local bank = get("btn-bank-p".. partial)

    hideEnv()

    -- wave shape
    if string.find(name, "btn%-shape") then
        v1 = "Waveform"
        addr = calcOffset(partial, "04")

        if value == 0 or value == 2 then
            valueStr = "SQU"

        elseif value == 1 or value == 3 then
            valueStr = "SAW"
        end
    end

    -- pcm bank
    if string.find(name, "btn%-bank") then
        v1 = "PCM Wave Bank"
        addr = calcOffset(partial, "04")
        bank = value

        waveCombo = panel:getComponent("list-pcm-wave-number-p".. partial)
	    waveCombo:setProperty("uiComboContent", table.concat(pcmBank[bank], "\n"), false)

        if value == 0 then
            value = 1
            valueStr = "01"

        elseif value == 1 then
            value = 3
            valueStr = "02"
        end
    end


    -- pcm wave
    if string.find(name, "wave%-number") then
        v1 = "PCM Wave No."
        addr = calcOffset(partial, "05")
        --valueStr = zeroPad(value+1) ..":".. pcmBank[bank][value+1]
        valueStr = pcmBank[bank][value+1]
    end

    
    -- wave pulse width
    if string.find(name, "form%-pw") then
        v1 = "Pulse Width"
        addr = calcOffset(partial, "06")

    elseif string.find(name, "form%-vel") then
        v1 = "PW Velocity"
        addr = calcOffset(partial, "07")

    end






    sysEx = sysEx .. addr .." ".. numToHex(value)

    line1 = line1:gsub("s1", v1)

    if valueStr ~= nil then
        line2 = line2:gsub(v2, valueStr)

    else
        line2 = line2:gsub(v2, zeroPad(value))
    end

    updateLCD(line1, line2)

    sendSysex(sysEx)
end
