--
-- Simple arpeggiator control
--

function keyboardControls(mod, value)
    m = mod:getMidiMessage(0)
    
    note = numToHex(m:getNumber())
    velocity = numToHex(m:getValue())

    -- ignore note off (velocity is 0)
    if ARP_ON and value > 0 then
        setNote(note, velocity)
    end
end

