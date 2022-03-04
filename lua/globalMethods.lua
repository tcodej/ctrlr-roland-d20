--
-- Variables and functions available globally
--

ARP_ON = false
ACT_OFF = 0
ACT_IN = 1
ACT_OUT = 2
ACT_SYS = 3

-- timers need a unique id
TIMER = {
    ARP_CLOCK = 1,
    ARP_NOTE = 2,
    SYSEX = 3,
    ONLOAD = 4,
    SET_TONE = 5,
    BLINKER = 6
}


-- when receiving data from the synth, set this to false to avoid
-- spamming those values back to the synth while modulators are set
ENABLE_OUT = true


-- whether or not to simulate envelope shape on LCD screen
-- if false, displays normal LCD values
DISPLAY_ENVS = false


ASCII = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
P_EDIT = {true, false, false, false}
OFF_ON = {" OFF"," ON "}
WAVE_SHAPE = {"SQU ","SAW ","SQU ","SAW "}
BIAS_PT = {"<A1 ","<A#1","<B1 ","<C1 ","<C#1","<D1 ","<D#1","<E1 ","<F1 ","<F#1","<G1 ","<G#1","<A2 ","<A#2","<B2 ","<C2 ","<C#2","<D2 ","<D#2","<E2 ","<F2 ","<F#2","<G2 ","<G#2","<A3 ","<A#3","<B3 ","<C3 ","<C#3","<D3 ","<D#3","<E3 ","<F3 ","<F#3","<G3 ","<G#3","<A4 ","<A#4","<B4 ","<C4 ","<C#4","<D4 ","<D#4","<E4 ","<F4 ","<F#4","<G4 ","<G#4","<A5 ","<A#5","<B5 ","<C5 ","<C#5","<D5 ","<D#5","<E5 ","<F5 ","<F#5","<G5 ","<G#5","<A6 ","<A#6","<B6 ","<C7 ",">A1 ",">A#1",">B1 ",">C1 ",">C#1",">D1 ",">D#1",">E1 ",">F1 ",">F#1",">G1 ",">G#1",">A2 ",">A#2",">B2 ",">C2 ",">C#2",">D2 ",">D#2",">E2 ",">F2 ",">F#2",">G2 ",">G#2",">A3 ",">A#3",">B3 ",">C3 ",">C#3",">D3 ",">D#3",">E3 ",">F3 ",">F#3",">G3 ",">G#3",">A4 ",">A#4",">B4 ",">C4 ",">C#4",">D4 ",">D#4",">E4 ",">F4 ",">F#4",">G4 ",">G#4",">A5 ",">A#5",">B5 ",">C5 ",">C#5",">D5 ",">D#5",">E5 ",">F5 ",">F#5",">G5 ",">G#5",">A6 ",">A#6",">B6 ",">C7 "}
BIAS_LVL_TVA = {"-12","-11","-10","-09","-08","-07","-06","-05","-04","-03","-02","-01"," 00"}
BIAS_LVL_TVF = {"-07","-06","-05","-04","-03","-02","-01"," 00","+01","+02","+03","+04","+05","+06","+07"}
KEY_FOL = {"-1  ","-1/2","-1/4"," 0  "," 1/8"," 1/4"," 3/8"," 1/2"," 5/8"," 3/4"," 7/8"," 1  "," 5/4"," 3/2"," 2  "}
KEY_FOL_PITCH = {} -- values set below
PITCH_COARSE = {" C1 "," C#1"," D1 "," D#1"," E1 "," F1 "," F#1"," G1 "," G#1"," A1 "," A#1"," B1 "," C2 "," C#2"," D2 "," D#2"," E2 "," F2 "," F#2"," G2 "," G#2"," A2 "," A#2"," B2 "," C3 "," C#3"," D3 "," D#3"," E3 "," F3 "," F#3"," G3 "," G#3"," A3 "," A#3"," B3 "," C4 "," C#4"," D4 "," D#4"," E4 "," F4 "," F#4"," G4 "," G#4"," A4 "," A#4"," B4 "," C5 "," C#5"," D5 "," D#5"," E5 "," F5 "," F#5"," G5 "," G#5"," A5 "," A#5"," B5 "," C6 "," C#6"," D6 "," D#6"," E6 "," F6 "," F#6"," G6 "," G#6"," A6 "," A#6"," B6 "," C7 "," C#7"," D7 "," D#7"," E7 "," F7 "," F#7"," G7 "," G#7"," A7 "," A#7"," B7 "," C8 "," C#8"," D8 "," D#8"," E8 "," F8 "," F#8"," G8 "," G#8"," C9 "}

LEVELS = {}

for i=-50,50,1 do
    local str

    if i == 0 then
        str = " 00"
    
    elseif i < 1 then
        if i > -10 then
            str = "-0".. math.abs(i)
        else
            str = i
        end

    else
        if i < 10 then
            str = "+0".. i
        else

            str = "+"..i
        end
    end

    table.insert(LEVELS, str)
end


-- used to build the lcd display values
function getValueStr(TABLE, name, pad)
    s1 = TABLE[get(name .."-p1")+1]
    s2 = TABLE[get(name .."-p2")+1]
    s3 = TABLE[get(name .."-p3")+1]
    s4 = TABLE[get(name .."-p4")+1]

    if pad == true then
        return s1 .." ".. s2 .." ".. s3 .." ".. s4

    else
        return s1..s2..s3..s4
    end
end







-- partial base values
pBase = {"0e", "48", "02", "3c"}

-- send prefix
prefixSend = "f0 41 10 16 12 "

-- data request prefix
prefixRecieve = "f0 41 10 16 11 "

-- tone sysex base
sysExTone = {"04 00 ", "04 01 "}

suffix = " f7"


function sendSysex(msg)
    if ENABLE_OUT == true then
        activity(ACT_SYS)

        timer:setCallback(TIMER.SYSEX, stopSysexTimer)
        timer:startTimer(TIMER.SYSEX, 100)

        sysex = prefixSend .. msg .. " " .. checkSum(msg) .. suffix
        panel:sendMidiMessageNow(CtrlrMidiMessage(sysex))

        return sysex

    else
        --console('Output disabled')
    end
end


-- auto turn off led
function stopSysexTimer()
    activity(ACT_OFF)
    timer:stopTimer(TIMER.SYSEX)
end


-- this sends a receive request, but does not return data
-- use midiMessageReceived
function recieveSysex(msg)
    sysex = prefixRecieve .. msg .. checkSum(msg) .. suffix
    panel:sendMidiMessageNow(CtrlrMidiMessage(sysex))
end


function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end



function dump(o)
   if type(o) == 'table' then
      local s = '{ '

      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..']=' .. dump(v) .. ', '
      end

      return s .. '} '

   else
      return tostring(o)
   end
end


function tableLength(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end


function checkSum(msg)
    total = 0
    pieces = split(msg, " ")
    
    for k,hex in pairs(pieces) do
        total = total + hexToNum(hex)
    end

    --total = hexToNum(pieces[1]) + hexToNum(pieces[2]) + hexToNum(pieces[3]) + hexToNum(pieces[4])

    cs = (128 - total) % 128

    --console(msg .." checkSum: ".. numToHex(cs))

    return numToHex(cs)
end



function hexToNum(hex)
    return tonumber(hex, 16)
end



function numToHex(num)
    hex = string.format("%x", num)

    if (string.len(hex) < 2) then
        hex = "0".. hex
    end

    return hex
end


-- Fit values into a 4 char grid to preserve LCD column format.
-- example: 3 becomes " 03 ", 10 becomes " 10 "
function zeroPad(val)
    padded = ""

    if val == nil then
        val = 0
    end

    -- numbers only
    if type(val) == "number" then
        if val < 10 then
            padded = " 0".. val

        elseif val < 100 then
            padded = " ".. val

        else
            padded = val
        end

        padded = padded .." "

    -- strings no update
    else
        padded = val
    end

    return padded
end



function calcOffset(partial, hex)
    return numToHex(hexToNum(pBase[partial]) + hexToNum(hex))
end


-- blink the midi activity light
function activity(num)
    local activityImg = panel:getModulatorByName("img-activity"):getComponent()

    if num == ACT_OFF then
        activityImg:setPropertyString("uiImageResource", "led-off")

    elseif num == ACT_IN then
        -- in, blink red
        activityImg:setPropertyString("uiImageResource", "led-red")

    elseif num == ACT_OUT then
        -- out, blink green
        activityImg:setPropertyString("uiImageResource", "led-green")

    elseif num == ACT_SYS then
        -- sysex in or out blink blue
        activityImg:setPropertyString("uiImageResource", "led-blue")
    end
end



function tableConcat(t1, t2)
   for i=1,#t2 do
      t1[#t1+1] = t2[i]
   end

   return t1
end


-- get a modulator value
function get(name)
    mod = panel:getModulatorByName(name)
    if mod ~= nil then
        return mod:getModulatorValue()

    else
        --console("Modulator ".. name .." not found.")
        return 0
    end
end


-- set a modulator value
function set(name, value)
    local mod = panel:getModulatorByName(name)
    if mod ~= nil then
        mod:setModulatorValue(value, false, false, false)

    else
        console("Modulator ".. name .." not found.")
        return 0
    end
end



local blinkOn = false
local blinks = 0
local blinkImg

function startBlinker()
    -- first reset as this function gets spammed when adjusting sliders
    stopBlinker()
    timer:setCallback(TIMER.BLINKER, blink)
    timer:startTimer(TIMER.BLINKER, 500)
end

function blink()
    blinks = blinks + 1

    if blinkOn == false then
        blinkOn = true
        blinkImg = "blink-on"

    else
        blinkOn = false
        blinkImg = "blink-off"
    end


    for i=1, 4, 1 do
        if (P_EDIT[i] == true) then
            panel:getModulatorByName("img-blink-p".. i):getComponent():setPropertyString("uiImageResource", blinkImg)
        end
    end

    if blinks > 50 then
        stopBlinker()
    end
end

function stopBlinker()
    blinks = 0
    timer:stopTimer(TIMER.BLINKER)
    blinkImg = "blink-off"

    for i=1, 4, 1 do
        panel:getModulatorByName("img-blink-p".. i):getComponent():setPropertyString("uiImageResource", blinkImg)
    end
end




-- down here so tableConcat() is available
KEY_FOL_PITCH = tableConcat(KEY_FOL, {" s1 "," s2 "})
