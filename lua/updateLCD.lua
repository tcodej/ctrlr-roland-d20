function updateLCD(line1, line2)
    if line1 == nil then line1 = "Roland D-20 Edit" end
    if line2 == nil then line2 = "By Trent Johnson" end
    local allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n0123456789&#!?.,:;\'\"*+-/<=>"
    -- todo: split text into two lines of 16 chars

    text = line1 .. "\n" .. line2
    panel:getComponent("LCD"):setText(text)
end