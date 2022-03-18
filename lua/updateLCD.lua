function updateLCD(line1, line2)
    if LCD_UPDATE == false then
        return
    end

    -- todo: split text into two lines of 16 chars

    text = line1 .. "\n" .. line2
    panel:getComponent("LCD"):setText(text)
end