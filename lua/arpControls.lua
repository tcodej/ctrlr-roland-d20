--
-- Auto-play notes when adjusting tone parameters
--

-- hex
local notes = {"3c"}
local velocity = "64"

local curNote = 0
local maxNotes = 9
local dir = 1
local updown = 0

-- milliseconds
local rate = nil
local noteLength = nil

function arpControls(mod, value)

    local name = L(mod:getName())

    hideEnv()

    if name == "btn-arp" then
        if value == 0 then
            ARP_ON = false
            timer:stopTimer(TIMER.ARP_CLOCK)

            -- all notes off
            panel:sendMidiMessageNow(CtrlrMidiMessage("b0 7b 00"))
        end

        if value == 1 then
            reset()
            -- trigger the first note on button press
            sendNote()

            ARP_ON = true
            timer:setCallback(TIMER.ARP_CLOCK, sendNote)
            timer:startTimer(TIMER.ARP_CLOCK, rate)
        end

    elseif name == "arp-rate" then
        -- convert to high to low
        value = 20 - value

        rate = (value + 1) * 50
        noteLength = rate - (rate * .1)

        if ARP_ON then
            timer:stopTimer(TIMER.ARP_CLOCK)
            timer:startTimer(TIMER.ARP_CLOCK, rate)
        end
    end
end



function reset()
    notes = {"3c", "40", "43", "47", "48"}
    velocity = "64"
    curNote = 0

    if rate == nil then
        rate = 250
    end

    noteLength = rate - (rate * .1)
end



function addNote(num, vel)
    if num ~= notes[curNote] then
        stopNote()
    end

    if tableLength(notes) >= maxNotes then
        table.remove(notes, 1)
    end

    table.insert(notes, num)
    velocity = vel
end



function sendNote()
    activity(ACT_OUT)

    curNote = curNote + dir
    if curNote > tableLength(notes) then
        curNote = 1
    end

    if curNote < 1 then
        curNote = tableLength(notes)
    end

    -- note on
    panel:sendMidiMessageNow(CtrlrMidiMessage("90 ".. notes[curNote] .." ".. velocity))

	timer:setCallback(TIMER.ARP_NOTE, stopNote)
	timer:startTimer(TIMER.ARP_NOTE, noteLength)
end



function stopNote()
    activity(ACT_OFF)

    -- note off
    panel:sendMidiMessageNow(CtrlrMidiMessage("80 ".. notes[curNote] .." 00"))

    timer:stopTimer(TIMER.ARP_NOTE)
end
