--
-- Simple arpeggiator control
--

function keyboardControls(mod, value)
    activity(ACT_OUT)
    m = mod:getMidiMessage(0)
    
    note = numToHex(m:getNumber())
    velocity = numToHex(m:getValue())


    if value == 0 then activity(ACT_OFF) end

    -- add a note to the arp if it's activated
    if ARP_ON and value > 0 then
        addNote(note, velocity)
    end
end

