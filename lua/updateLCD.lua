function updateLCD(line1, line2)
    
    -- todo: split text into two lines of 16 chars

    text = line1 .. "\n" .. line2
    panel:getComponent("LCD"):setText(text)
end