--
-- Timbre editor
--

local GROUPS = {"a","b","i","r"}
local TONES = {
    {"AcouPiano1","AcouPiano2","AcouPiano3","Honky-Tonk","ElecPiano1","ElecPiano2","ElecPiano3","ElecPiano4","ElecOrgan1","ElecOrgan2","ElecOrgan3","ElecOrgan4","PipeOrgan1","PipeOrgan2","PipeOrgan3","Accordion","Harpsi 1","Harpsi 2","Harpsi 3","Clav 1","Clav 2","Clav 3","Celesta 1","Celesta 2","Violin 1","Violin 2","Cello 1","Cello 2","Contrabass","Pizzicato","Harp","Harp 2","Strings 1","Strings 2","Strings 3","Strings 4","Brass 1","Brass 2","Brass 3","Brass 4","Trumpet 1","Trumpet 2","Trombone 1","Trombone 2","Horn","Fr Horn","Engl Horn","Tuba","Flute 1","Flute 2","Piccolo","Recorder","Pan Pipes","Bottleblow","Breathpipe","Whistle","Sax 1","Sax 2","Sax 3","Clarinet 1","Clarinet 2","Oboe","Bassoon","Harmonica"},
    {"Fantasy","Harmo Pan","Chorale","Glasses","Soundtrack","Atmosphere","Warm Bell","Space Horn","Echo Bell","Ice Rains","Oboe 2002","Echo Pan","Bell Swing","Reso Synth","Steam Pad","VibeString","Syn Lead 1","Syn Lead 2","Syn Lead 3","Syn Lead 4","Syn Bass 1","Syn Bass 2","Syn Bass 3","Syn Bass 4","AcouBass 1","AcouBass 2","ElecBass 1","ElecBass 2","SlapBass 1","SlapBass 2","Fretless 1","Fretless 2","Vibe","Glock","Marimba","Xylophone","Guitar 1","Guitar 2","Elec Gtr 1","Elec Gtr 2","Koto","Shamisen","Jamisen","Sho","Shakuhachi","WadaikoSet","Sitar","Steel Drum","Tech Snare","Elec Tom","Revrse Cym","Ethno Hit","Timpani","Triangle","Wind Bell","Tube Bell","Orche Hit","Bird Tweet","OneNoteJam","Telephone","Typewriter","Insect","WaterBells","JungleTune"},
    {"1","2","3","4"},
    {"Closed High Hat 1","Closed High Hat 2","Open High Hat 1","Open High Hat 2","Crash Cymbal","Crash Cymbal (short)","Crash Cymbal (mute)","Ride Cymbal","Ride Cymbal (short)","Ride Cymbal (mute)","Cup","Cup (mute)","China Cymbal","Splash Cymbal","Bass Drum 1","Bass Drum 2","Bass Drum 3","Bass Drum 4","Snare Drum 1","Snare Drum 2","Snare Drum 3","Snare Drum 4","Snare Drum 5","Snare Drum 6","Rim Shot","Brush 1","Brush 2","High Tom Tom 1","Middle Tom Tom 1","Low Tom Tom 1","High Tom Tom 2","Middle Tom Tom 2","Low Tom Tom 2","High Tom Tom 3","Middle Tom Tom 3","Low Tom Tom 3","High Pitch Tom Tom 1","High Pitch Tom Tom 2","Hand Clap","Tambourine","Cowbell","High Bongo","Low Bongo","High Conga (mute)","High Conga","Low Conga","High Timbale","Low Timbale","High Agogo","Low Agogo","Cabasa","Maracas","Short Whistle","Long Whistle","Quijada","Claves","Castanets","Triangle","Wood Block","Bell","Native Drum 1","Native Drum 2","Native Drum 3","OFF"}
}

local groupNum = 1
local toneNum = 1


function timbreControls(mod, value)

    -- disable blinker during mod update
    stopBlinker()

    local sysex = nil
    local base = "03 00 "
    local addr = "00"
    local name = L(mod:getName())

    local offset = {
        tgroup = "00",
        tnum = "01",
        kshift = "02",
        ftune = "03",
        brange = "04",
        assign = "05",
        reverb = "06"
    }

    local line1 = ""
    local line2 = ""

    groupNum = get("list-tone-grp")+1

    if get("list-tone-num") > 0 then
        toneNum = get("list-tone-num")
    end

    if string.find(name, "keyshft") then
        line1 = "Key Shift"
        line2 = KEY_SHIFT[value+1]
        addr = offset.kshift

    elseif string.find(name, "ftune") then
        line1 = "Fine Tune"
        line2 = LEVELS[value+1]
        addr = offset.ftune

    elseif string.find(name, "brange") then
        line1 = "Bender Range"
        line2 = zeroPad(value)
        addr = offset.brange

    elseif string.find(name, "assign") then
        line1 = "Assign Mode"
        line2 = " ".. (value+1)
        addr = offset.assign

    elseif string.find(name, "tone%-grp") then
        groupNum = value+1
        line1 = "Tone Select"
        line2 = GROUPS[groupNum] .. addZero(toneNum) ..":".. TONES[groupNum][toneNum]

        toneCombo = panel:getComponent("list-tone-num")
        local newList = table.concat(TONES[groupNum], "\n")
	    toneCombo:setProperty("uiComboContent", newList, true)
        set("list-tone-num", toneNum)

    elseif string.find(name, "tone%-num") then
        console("value ".. toneNum)
        if value < 0 then return end;
        toneNum = value+1
        line1 = "Tone Select"
        line2 = GROUPS[groupNum] .. addZero(toneNum) ..":".. TONES[groupNum][toneNum]
        console("tone set to ".. toneNum)
    end

    updateLCD(line1, line2)
    sendSysex(base .. addr .." ".. numToHex(value))
    startBlinker()
end

function addZero(num)
    if num < 10 then
        return "0".. num
    end

    return tostring(num)
end