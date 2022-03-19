--
-- Tune/Function editor
--

PAN = {"7>  ","6>  ","5>  ","4>  ","3>  ","2>  ","1>  "," >< ","  <1","  <2","  <3","  <4","  <5","  <6","  <7"}

function tuneFunctionControls(mod, value)

    -- disable blinker during mod update
    stopBlinker()

    local sysex = nil
    local base = "10 00 "
    local addr = "00"
    local name = L(mod:getName())

    local offset = {
        mtune = "00",
        rtype = "01",
        rtime = "02",
        rlevel = "03",
        pt1level = "21",
        pt1panpot = "2a"
    }

    local line1 = ""
    local line2 = ""
    local v1 = ""
    local valueStr = nil

    local tuneLow = 428

    if name == "mod-master-vol" then
        line1 = "Master Volume"
        line2 = zeroPad(value)
        sysex = "b0 07 ".. numToHex(value)
        panel:sendMidiMessageNow(CtrlrMidiMessage(sysex))

    elseif string.find(name, "panpot1") then
        line1 = "Part1 Pan&Level"
        line2 = PAN[value+1] .."    ".. zeroPad(get("mod-tf-level1"))
        addr = offset.pt1panpot

    elseif string.find(name, "level1") then
        line1 = "Part1 Pan&Level"
        line2 = PAN[get("mod-tf-panpot1")+1] .."    ".. zeroPad(value)
        addr = offset.pt1level

    elseif name == "mod-master-tune" then
        line1 = "Master Tune"
        v1 = math.floor(tuneLow + (value / 5.05))
        line2 = v1 .."Hz"
        addr = offset.mtune

    elseif string.find(name, "rtype") then
        line1 = "Reverb Type"
        line2 = REVERB_TYPES[value+1]
        addr = offset.rtype

    elseif string.find(name, "rtime") then
        line1 = "Reverb Time"
        line2 = zeroPad(value+1)
        addr = offset.rtime

    elseif string.find(name, "rlevel") then
        line1 = "Reverb Level"
        line2 = zeroPad(value)

        addr = offset.rlevel
    end



    updateLCD(line1, line2)

    -- if sysex has a value then a custom sysex call was made earlier and this isn't needed
    if sysex == nil then
        sendSysex(base .. addr .." ".. numToHex(value))
    end

    startBlinker()

end