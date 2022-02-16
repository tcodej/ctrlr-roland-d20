--
-- Variables and functions available globally
--

ARP_ON = false
ACT_OFF = 0
ACT_IN = 1
ACT_OUT = 2

-- send prefix
prefixSend = "f0 41 10 16 12 "

-- data request prefix
prefixRecieve = "f0 41 10 16 11 "

suffix = " f7"


function sendSysex(msg)
    sysex = prefixSend .. msg .. " " .. z4(msg) .. suffix
    panel:sendMidiMessageNow(CtrlrMidiMessage(sysex))

    return sysex
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


-- Return " 03" in case of 3 to preserve LCD column format. Otherwise does nothing.
function zeroPad(num)
    if num == nil then
        num = 0
    end

    if type(num) == "number" then
        if num < 10 then
            num = " 0" .. num
        elseif num < 100 then
            num = " " .. num
        end
    end

    return num
end



function calcOffset(partial, hex)
    return numToHex(pBase[partial] + hexToNum(hex))
end


-- blink the midi activity light
function activity(num)
    if num == ACT_OFF then
        panel:getModulatorByName("img-activity"):getComponent():setPropertyString("uiImageResource", "led-off")

    elseif num == ACT_IN then
        -- in, blink blue
        panel:getModulatorByName("img-activity"):getComponent():setPropertyString("uiImageResource", "led-blue")

    elseif num == ACT_OUT then
        -- out, blink green
        panel:getModulatorByName("img-activity"):getComponent():setPropertyString("uiImageResource", "led-green")
    end
end



pBase = {}
pBase[1] = hexToNum("0e")
pBase[2] = hexToNum("48")
pBase[3] = hexToNum("02")
pBase[4] = hexToNum("3c")

