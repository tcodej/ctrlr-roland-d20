--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator


function btnTest(mod, value)

-- send part2/lower tone data from temp area
-- f0 41 10 16 11 04 01 76 00 01 76 0e f7
-- 

    tone1 = "04 00 00"
    tone2 = "04 01 76"
    tone7 = "04 0b 44"

    --recieveSysex(tone2 .." 00 01 76 0e")

end
