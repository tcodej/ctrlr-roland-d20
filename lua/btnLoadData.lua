--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
btnLoadData = function(mod, value, source)
    --console("Request data")
    sendSysex("20 00 00 a0")
end