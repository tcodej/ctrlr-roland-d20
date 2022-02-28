local mm = nil
local count = 1

function midiMessageReceived(midiMessage)
    mm = midiMessage
    --count = count + 1

	if panel:getRestoreState() == true or panel:getProgramState() == true then
		return
	end

    hideEnv()

    if getByte(0) == "b0" then
        activity(ACT_OFF)

    else
        activity(ACT_IN)
    end

	size = mm:getSize()
    --console(tostring(size))

    updateLCD(
        getByteHex(0) .." ".. getByteHex(1) .." ".. getByteHex(2) .." ".. getByteHex(3) .." ".. getByteHex(4),
        getByteHex(5) .." ".. getByteHex(6) .." ".. getByteHex(7) .." ".. getByteHex(8) .." ".. getByteHex(9)
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
        activity(ACT_SYS)
        if getByteHex(0) .. getByteHex(1) .. getByteHex(2) == "f04110" then
            setTone()
        end

        data = mm:getLuaData() -- or getLuaData():getRange(0,24) etc.
        file = File("d:\\sysexdump\\tone".. count ..".syx")
        file:replaceWithData(data)
    end

end



-- return a hex byte
function getByteHex(num)
    if mm == nil then return end

    return numToHex(mm:getData():getByte(num))
end



-- return a decimal byte
function getByteNum(num)
    if mm == nil then return end

    return mm:getData():getByte(num)
end
