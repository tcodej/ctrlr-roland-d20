--
-- System settings
--

function systemControls(mod, value)

    -- disable blinker during mod update
    stopBlinker()

    local sysex = nil
    local base = "10 00 "
    local addr = "00"
    local name = L(mod:getName())

    local offset = {}

    local line1 = ""
    local line2 = ""
    local v1 = ""

    if name == "midi-ch-out" then
        line1 = "Midi TxCH"
        line2 = zeroPad(value+1)

        if (ARP_ON) then
            -- set all notes off
            panic()
        end

        MIDI_CH = value
        panel:setPropertyInt("panelMidiOutputChannelDevice", MIDI_CH+1)

    elseif name == "btn-reset" then
        line1 = "Resetting Timbre"
        line2 = "Partials 1-4"
        resetTimbre()

    elseif name == "btn-panic" then
        line1 = "All Notes Off"
        line2 = "All Channels"
        panic()
        -- also turn off arpeggiator
        ARP_ON = false
        timer:stopTimer(TIMER.ARP_CLOCK)

    end

    --sendSysex(base .. addr .." ".. numToHex(value))

    updateLCD(line1, line2)

    startBlinker()

end


function resetTimbre()
    console("Reset tone")
    local resetCommon = {0xF0,0x41,0x10,0x16,0x12,0x04,0x00,0x00,0x44,0x65,0x66,0x61,0x75,0x6C,0x74,0x20,0x20,0x20,0x00,0x00,0x0F,0x00}
    local resetTone = {0x24,0x32,0x0B,0x01,0x00,0x00,0x32,0x07,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x32,0x32,0x32,0x32,0x32,0x00,0x00,0x00,0x5A,0x19,0x0B,0x00,0x07,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x64,0x32,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x64}
    local common = CtrlrLuaObjectWrapper(common)
    local tone = CtrlrLuaObjectWrapper(tone)
    local mb = CtrlrLuaMemoryBlock()

    mb:append(common)
    mb:append(tone)
    mb:append(tone)
    mb:append(tone)
    mb:append(tone)

    setData(mb)
    setTone(true)
end