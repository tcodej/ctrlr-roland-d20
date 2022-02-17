--
-- Variables and functions available globally
--

-- pBase is populated down below...
pBase = {}

ARP_ON = false
ACT_OFF = 0
ACT_IN = 1
ACT_OUT = 2
ACT_SYS = 3

P_EDIT = {true, false, false, false}

BIAS_PT = {"<A1","<A#1","<B1","<C1","<C#1","<D1","<D#1","<E1","<F1","<F#1","<G1","<G#1","<A2","<A#2","<B2","<C2","<C#2","<D2","<D#2","<E2","<F2","<F#2","<G2","<G#2","<A3","<A#3","<B3","<C3","<C#3","<D3","<D#3","<E3","<F3","<F#3","<G3","<G#3","<A4","<A#4","<B4","<C4","<C#4","<D4","<D#4","<E4","<F4","<F#4","<G4","<G#4","<A5","<A#5","<B5","<C5","<C#5","<D5","<D#5","<E5","<F5","<F#5","<G5","<G#5","<A6","<A#6","<B6","<C7",">A1",">A#1",">B1",">C1",">C#1",">D1",">D#1",">E1",">F1",">F#1",">G1",">G#1",">A2",">A#2",">B2",">C2",">C#2",">D2",">D#2",">E2",">F2",">F#2",">G2",">G#2",">A3",">A#3",">B3",">C3",">C#3",">D3",">D#3",">E3",">F3",">F#3",">G3",">G#3",">A4",">A#4",">B4",">C4",">C#4",">D4",">D#4",">E4",">F4",">F#4",">G4",">G#4",">A5",">A#5",">B5",">C5",">C#5",">D5",">D#5",">E5",">F5",">F#5",">G5",">G#5",">A6",">A#6",">B6",">C7"}
KEY_FOL = {"-1","-1/2","-1/4","0","1/8","1/4","3/8","1/2","5/8","3/4","7/8","1","5/4","3/2","2"}
KEY_FOL_PITCH = {}

-- send prefix
prefixSend = "f0 41 10 16 12 "

-- data request prefix
prefixRecieve = "f0 41 10 16 11 "

suffix = " f7"


function sendSysex(msg)
    activity(ACT_SYS)

    timer:setCallback(10, stopSysexTimer)
    timer:startTimer(10, 100)

    sysex = prefixSend .. msg .. " " .. z4(msg) .. suffix
    panel:sendMidiMessageNow(CtrlrMidiMessage(sysex))

    return sysex
end

-- auto turn off led
function stopSysexTimer()
    activity(ACT_OFF)
    timer:stopTimer(10)
end



function recieveSysex(msg)
    sysex = prefixRecieve .. msg .. suffix
    panel:sendMidiMessageNow(CtrlrMidiMessage(sysex))

    return sysex
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


function z4(msg)
    pieces = split(msg, " ")
    total = hexToNum(pieces[1]) + hexToNum(pieces[2]) + hexToNum(pieces[3]) + hexToNum(pieces[4])
    -- is this really needed?
    --total = total - 1

    checksum = (127 - (total-1) % 128)

    return numToHex(checksum)
end



function hexToNum(hex)
    return tonumber(hex, 16)
end



function numToHex(num)
    hex = string.format("%x", num)

    if (string.len(hex) < 2) then
        hex = "0" .. hex
    end

    return hex
end


-- Fit values into a 4 char grid to preserve LCD column format.
-- example: 3 becomes " 03 ", 10 becomes " 10 " and -1/2 becomes "-1/2 "
function zeroPad(val)
    padded = ""

    if val == nil then
        val = 0
    end

    -- number
    if type(val) == "number" then
        if val < 10 then
            padded = " 0".. val

        elseif val < 100 then
            padded = " ".. val

        else
            padded = val
        end

        padded = padded .." "
    
    -- string
    elseif type(val) == "string" then
        local len = string.len(val)

        if len == 1 then
            padded = " ".. val .."  "

        elseif len == 2 then
            -- for negative kf values < 3 chars, don't add first space
            if string.sub(val, 0, 1) == "-" then
                padded = val .."  "

            else
                padded = " ".. val .." "
            end

        elseif len == 3 then
            -- bias vals start with < or > and are always left justified
            if string.sub(val, 0, 1) == "<" or string.sub(val, 0, 1) == ">" then
                padded = val .." "
            else
                padded = " ".. val
            end

        else
            padded = val
        end
    end

    return padded
end



function calcOffset(partial, hex)
    return numToHex(pBase[partial] + hexToNum(hex))
end


-- blink the midi activity light
function activity(num)
    if num == ACT_OFF then
        panel:getModulatorByName("img-activity"):getComponent():setPropertyString("uiImageResource", "led-off")

    elseif num == ACT_IN then
        -- in, blink red
        panel:getModulatorByName("img-activity"):getComponent():setPropertyString("uiImageResource", "led-red")

    elseif num == ACT_OUT then
        -- out, blink green
        panel:getModulatorByName("img-activity"):getComponent():setPropertyString("uiImageResource", "led-green")

    elseif num == ACT_SYS then
        -- sysex in or out blink blue
        panel:getModulatorByName("img-activity"):getComponent():setPropertyString("uiImageResource", "led-blue")
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
        console("Modulator ".. name .." not found.")
        return nil
    end
end


-- set a modulator value
function set(name, value)
    local mod = panel:getModulatorByName(name)
    if mod ~= nil then
        mod:setModulatorValue(value, false, false, false)
    else
        console("Modulator ".. name .." not found.")
    end
end


-- down here so hexToNum() is available
pBase[1] = hexToNum("0e")
pBase[2] = hexToNum("48")
pBase[3] = hexToNum("02")
pBase[4] = hexToNum("3c")

-- down here so tableConcat() is available
KEY_FOL_PITCH = tableConcat(KEY_FOL, {"s1","s2"})
dump(KEY_FOL_PITCH)

