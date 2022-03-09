local mm
local data

function midiMessageReceived(midiMessage)
	if panel:getRestoreState() == true or panel:getProgramState() == true then
		return
	end

    mm = midiMessage
    data = mm:getData()

    hideEnv()

    if getByteHex(0) == "b0" then
        activity(ACT_OFF)

    else
        activity(ACT_IN)
    end




--[[
    updateLCD(
        getByteHex(0) .." ".. getByteHex(1) .." ".. getByteHex(2) .." ".. getByteHex(3) .." ".. getByteHex(4),
        getByteHex(5) .." ".. getByteHex(6) .." ".. getByteHex(7) .." ".. getByteHex(8) .." ".. getByteHex(9)
    )
--]]

	local size = mm:getSize()

    if size == 256 then
        activity(ACT_SYS)
        if getByteHex(0) .. getByteHex(1) .. getByteHex(2) == "f04110" then
            setTone()
        end

        --console(data:toHexString(1))
        --file = File("d:\\sysexdump\\tone1.syx")
        --file:replaceWithData(data)
    end

end



-- return a hex byte
function getByteHex(num)
    if data == nil then return end

    return numToHex(data:getByte(num))
end



-- return a decimal byte
function getByteNum(num)
    if data == nil then return end

    return data:getByte(num)
end


function setData(block)
    data = block
end
