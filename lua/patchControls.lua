--
-- Patch editor
--

local PATCHES = {
	{"Warm Pad Fade","Steam Pad","Sigh in Big City","Warm Ensemble","Inner Wood","Hollow Koto","Brassy Vox","Ensemble Series 22","Rich Piano","Elec Piano","Touch Piano","Synth Piano","Honky-Tonk PianoFunky Clav","Rich Harpsichord","Pick Guitar","Bright Brass","Soft Brass","Big ol' Brass","Fighting Brass","Trumpet Section","Trombone Section","Low Brass","Velo-Brass","Joyful Times","Vibe Strings","Fantasy Bell","Harmonicity","Chatter Glasses","Ice Rains ...","Rich Wood","Echo Bell","Fat Lead","Square-Wave Lead","Brassy Lead","Bright Power","Bend me 5ths","Clav+Organ Lead","Metalized Dist","Neat Lead","Native Dance Pt2","Nightmare","Velo-Oct Synth","Resonance Sweep","Fat Synth Bass","Fretless Bassolo","Vari Chopper!","Timbass","Balinese Hit!","Shiny Steel Drum","Ethnic Session","Japanese Duo","Wadaiko","Sho","Koto","Shamisen","Bubble Perc","Drop Hit!","Timbales","Conga Set","Metal Drum","< Cave'n Drum >","Cymbal Special?","< Drums Set >","Tenor Voices"},
	{"Tenor Voices","Voxy Women Sing","Breath Choir","Chorale Strings","Atmosphere","Good Night ...","New Age Harp","Panning Echo","Crystal Celesta","Xylocken Mallet","Southern Wind","Tropical Mallet","Native Perc","Hammer Bells","Bell Celesta","Tiny Hammer","Bowed Strings","Violin-Strings","Cellist","Contrabass-Cello","Rain Harp","Pizzicato","X-mod Strings","Deep Ana-Strings","Elec Organ","Rotor Organ","Hall Organ","Pforgan","Moss Organ","Str-organ","Rock'n'Roll EG","Harmonica","Concert Flute","Flute-Piccolo","Pan Pipes","Breath Ensemble","Sax Duo","Master Clarinet","Bassoon-Oboe","Blow Pipes","Brass Combo","Bass & Vibe","Synth Combo","Acoustic Club","Funky Slapping","SpSax + FrlsBass","Tango Passion","Hoppin' Poppin!","Orchestra Hit!","Go Against!","Resound Big\"B\"","Water Bells","Jungle Tune","Lonely Wolf","Tweeting Bird","Insects Sing","Attack! Attack!","Office Operator","Scene of Battle","Very Busy ...!","One Note Jam!","Stormy Sunday","Ironworks","Seashore"}
}

local KEY_MODE = {"WHOLE","DUAL","SPLIT"}

local SPLIT_POINT = {"C2","C#2","D2","D#2","E2","F2","F#2","G2","G#2","A2","A#2","B2","C3","C#3","D3","D#3","E3","F3","F#3","G3","G#3","A3","A#3","B3","C4","C#4","D4","D#4","E4","F4","F#4","G4","G#4","A4","A#4","B4","C5","C#5","D5","D#5","E5","F5","F#5","G5","G#5","A5","A#5","B5","C6","C#6","D6","D#6","E6","F6","F#6","G6","G#6","A6","A#6","B6","C7","C#7"}

function patchControls(mod, value)

    -- disable blinker during mod update
    stopBlinker()

    local sysex = nil
    local base = "03 04 "
    local addr = "00"
    local name = L(mod:getName())

    local offset = {
        keymode = "00",
        split = "01",
        grplow = "02",
        tonelow = "03",
        grpup = "04",
        toneup = "05",
        shiftlow = "06",
        shifup = "07",
        tunelow = "08",
        tuneup= "09",
        bendlow = "0a",
        bendup = "0b",
        assignlow = "0c",
        assignup = "0d",
        revlow = "0e",
        revup = "0f",
        revmode = "10",
        revtime = "11",
        revlevel = "12",
        balance = "13",
        level = "14"
    }

    -- patch name 15-24

    local line1 = ""
    local line2 = ""

    --groupNum = get("list-tone-grp")+1

    --if get("list-tone-num") > 0 then
    --    toneNum = get("list-tone-num")
    --end

    if string.find(name, "mainlevel") then
        line1 = "Patch Level"
        line2 = zeroPad(value)
        addr = offset.level

    elseif string.find(name, "keymode") then
        line1 = "Key Mode"
        line2 = KEY_MODE[value+1]
        addr = offset.keymode
   
    elseif string.find(name, "split") then
        line1 = "Split Point"
        line2 = " ".. SPLIT_POINT[value+1]
        addr = offset.split
   
    elseif string.find(name, "grplow") then
        line1 = "Lower Tone Sel"
        line2 = value
        addr = offset.grplow
   
    elseif string.find(name, "grpup") then
        line1 = "Upper Tone Sel"
        line2 = value
        addr = offset.grpup

    elseif string.find(name, "tonelow") then
        line1 = "Lower Tone Sel"
        line2 = value
        addr = offset.tonelow
   
    elseif string.find(name, "toneup") then
        line1 = "Upper Tone Sel"
        line2 = value
        addr = offset.toneup

    elseif string.find(name, "shiftlow") then
        line1 = "Key Shift"
        line2 = lowUpVals(KEY_SHIFT[value+1], " ".. KEY_SHIFT[get("mod-patch-shiftup")+1])
        addr = offset.shiftlow
   
    elseif string.find(name, "shiftup") then
        line1 = "Key Shift"
        line2 = lowUpVals(KEY_SHIFT[get("mod-patch-shiftlow")+1], " ".. KEY_SHIFT[value+1])
        addr = offset.shifup
   
    elseif string.find(name, "tunelow") then
        line1 = "Fine Tune"
        line2 = lowUpVals(LEVELS[value+1], " ".. LEVELS[get("mod-patch-tuneup")+1])
        addr = offset.tunelow
   
    elseif string.find(name, "tuneup") then
        line1 = "Fine Tune"
        line2 = lowUpVals(LEVELS[get("mod-patch-tunelow")+1], " ".. LEVELS[value+1])
        addr = offset.tuneup
   
    elseif string.find(name, "bendlow") then
        line1 = "Bender Range"
        line2 = lowUpVals(zeroPad(value), zeroPad(get("mod-patch-bendup")))
        addr = offset.bendlow
   
    elseif string.find(name, "bendup") then
        line1 = "Bender Range"
        line2 = lowUpVals(zeroPad(get("mod-patch-bendlow")), zeroPad(value))
        addr = offset.bendup
   
    elseif string.find(name, "assignlow") then
        line1 = "Assign Mode"
        line2 = lowUpVals(" ".. value+1, "   ".. get("mod-patch-assignup")+1)
        addr = offset.assignlow
   
    elseif string.find(name, "assignup") then
        line1 = "Assign Mode"
        line2 = lowUpVals(" ".. get("mod-patch-assignlow")+1, "   ".. value+1)
        addr = offset.assignup
   
    elseif string.find(name, "revlow") then
        line1 = "Reverb Switch"
        line2 = lowUpVals(OFF_ON[value+1], OFF_ON[get("btn-revup")+1])
        addr = offset.revlow
   
    elseif string.find(name, "revup") then
        line1 = "Reverb Switch"
        line2 = lowUpVals(OFF_ON[get("btn-revlow")+1], OFF_ON[value+1])
        addr = offset.revup
   
    elseif string.find(name, "revmode") then
        line1 = "Reverb Type"
        line2 = REVERB_TYPES[value+1]
        addr = offset.revmode
   
    elseif string.find(name, "revtime") then
        line1 = "Reverb Time"
        line2 = zeroPad(value+1)
        addr = offset.revtime
   
    elseif string.find(name, "revlevel") then
        line1 = "Reverb Level"
        line2 = zeroPad(value)
        addr = offset.revlevel
   
    elseif string.find(name, "balance") then
        line1 = "Tone Balance"
        line2 = lowUpVals(zeroPad(100-value), zeroPad(value))
        addr = offset.balance
   
    end

    updateLCD(line1, line2)
    sendSysex(base .. addr .." ".. numToHex(value))
    startBlinker()
end

function lowUpVals(lower, upper)
    return lower .."    ".. upper
end
