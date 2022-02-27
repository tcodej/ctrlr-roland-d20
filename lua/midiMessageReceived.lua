local mm = nil
local count = 0

function midiMessageReceived(midiMessage)
    mm = midiMessage
    count = count + 1

	if panel:getRestoreState() == true or panel:getProgramState() == true then
		return
	end

    hideEnv()

    if getByte(0) == "b0" then
        activity(ACT_OFF)

    else
        activity(ACT_IN)
    end


    data = mm:getLuaData() -- or getLuaData():getRange(0,24) etc.
    file = File("d:\\sysexdump\\chunk".. count ..".syx")
    file:replaceWithData(data)


    --data = mm:getLuaData():getRange(0, 1)
	size = mm:getSize()
    --console(tostring(size))

    updateLCD(
        getByte(0) .." ".. getByte(1) .." ".. getByte(2) .." ".. getByte(3) .." ".. getByte(4),
        getByte(5) .." ".. getByte(6) .." ".. getByte(7) .." ".. getByte(8) .." ".. getByte(9)
    )
--]]
    tempTones = {
        "04 00 00",
        "04 01 76",
        "04 03 6c",
        "04 05 62",
        "04 07 58",
        "04 09 4E",
        "04 0b 44",
        "04 0d 3a"
    }
--]]

    if size == 256 then
        if getByte(0) .. getByte(1) .. getByte(2) == "f04110" then
            setTone()
        end
    end


--[[
	if ((s == 74) or (s == 138)) then
		local programData = midiMessage:getLuaData():getByte(6)

		if programData == 0x00 then Upper_Partial1(midiMessage) end
		if programData == 0x00 then Upper_Partial2(midiMessage) end

		if programData == 0x01 then Upper_Common(midiMessage) end
		if programData == 0x01 then Lower_Partial1(midiMessage) end

		if programData == 0x02 then Lower_Partial2(midiMessage) end
		if programData == 0x02 then Lower_Common(midiMessage) end

		if programData == 0x03 then Patch(midiMessage) end
	end
--]]
end


function getByte(num)
    if mm == nil then return end

    return numToHex(mm:getData():getByte(num))
end

--UP1_Coarse = midiMessage:getLuaData():getByte(8)
--panel:getModulatorByName("UP1_Coarse"):setModulatorValue(UP1_Coarse, false, false, false)