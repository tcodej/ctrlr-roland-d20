function btnTest(mod, value)

    updateLCD("D20 v1.0 2022-02", "By Trent Johnson")

-- send part2/lower tone data from temp area
-- f0 41 10 16 11 04 01 76 00 01 76 0e f7

-- in performance mode this sends patch data from the temp area
-- f0 41 10 16 11 03 04 00 00 00 26 53 f7

-- sets partial reserve (?)
-- f0 41 10 16 12 10 00 04 00 08 0a 00 00 00 00 00 00 08 66 f7

-- write part 3 temporary into I-B24
-- f0 41 10 16 12 40 04 4b 00 71 f7

-- D-50 - request patch memory 1-1
-- f0 41 00 14 41 02 00 00 00 03 40 3b 47

-- pitch env kf p1 02
-- f0 41 10 16 12 04 00 18 02 62 f7

-- pitch env t1 p1 00
-- f0 41 10 16 12 04 00 19 00 63 f7

    -- +01F6
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
--[[
    for i=1,tableLength(tempTones),1 do
        msg = tempTones[i] .." 00 01 76"
        console(msg)
        recieveSysex(msg)
    end
--]]

    recieveSysex(tempTones[1] .." 00 01 76")
    
    count = 0

end
