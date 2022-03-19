function updateLCD(line1, line2)
    if LCD_UPDATE == false then
        return
    end

    text = line1 .. "\n" .. line2
    panel:getComponent("LCD"):setText(text)

    updateDeviceLCD(pad(line1) .. pad(line2))
end

-- pass a string of 32 chars max
function updateDeviceLCD(str)
    if str == nil then return end

    local i
    local char
    local byte
    local hexList = {}

    if string.len(str) > 32 then
        str = string.sub(str, 1, 32)
    end

    for i=1,string.len(str),1 do
        char = string.sub(str, i, i)
        byte = string.byte(char)
        table.insert(hexList, numToHex(byte))
    end

    sendSysex("20 00 00 ".. table.concat(hexList, " "))
end

function pad(str)
    if str == nil then return "" end

    local line = "                "

    if string.len(str) > 16 then
        str = string.sub(str, 1, 16)
    end

    newLine = str .. string.sub(line, string.len(str), string.len(line)-1)

    return newLine
end
