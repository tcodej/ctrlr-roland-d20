-- Enable/disable partials
-- f0 41 10 16 12 04 00 0c xx z4 f7

partialToggle = function(midiMessage)
--[[
    partial1 = panel:getModulatorByName("btn-p1"):getModulatorValue()
    partial2 = panel:getModulatorByName("btn-p2"):getModulatorValue()
    partial3 = panel:getModulatorByName("btn-p3"):getModulatorValue()
    partial4 = panel:getModulatorByName("btn-p4"):getModulatorValue()

    --try to keep ctrlr from crashing on first load
    if (partial1 == nil) then
        partial1 = 1
    end
    
    if (partial2 == nil) then
        partial2 = 1
    end
    
    if (partial3 == nil) then
        partial3 = 1
    end
    
    if (partial4 == nil) then
        partial4 = 1
    end
    
    -- Form a binary string based on button values
    binary = partial4 .. partial3 .. partial2 .. partial1

    -- Return the decimal value
    decimal = tonumber(binary, 2)

    return decimal
--]]
end

