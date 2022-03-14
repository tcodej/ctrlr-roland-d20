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
	if panel:getRestoreState() == true or panel:getProgramState() == true then
		return
	end

    local name = L(mod:getName())
    local line1 = ""
    local line2 = ""

    hideEnv()

    if name == "btn-arp" then
        if value == 0 then
            ARP_ON = false
            timer:stopTimer(TIMER.ARP_CLOCK)

            -- all notes off
            panic()
            line1 = "Arpeggiator"
            line2 = OFF_ON[1]
        end

        if value == 1 then
            reset()
            -- trigger the first note on button press
            sendNote()

            ARP_ON = true
            timer:setCallback(TIMER.ARP_CLOCK, sendNote)
            timer:startTimer(TIMER.ARP_CLOCK, rate)
            line1 = "Arpeggiator"
            line2 = OFF_ON[2]
        end

    elseif name == "arp-rate" then
        -- value is in beats per minute
        value = value + 60

        -- convert bpm to ms
        rate =  math.floor(60000 / value)

        --rate = (value + 1) * 50
        noteLength = rate - (rate / 4)

        line1 = "ARP Rate"
        line2 = value .."bpm ".. rate .."ms"

        if ARP_ON then
            timer:stopTimer(TIMER.ARP_CLOCK)
            timer:startTimer(TIMER.ARP_CLOCK, rate)
        end

    -- todo: need to shorten table if the new length is less than the current length
    elseif name == "arp-len" then
        maxNotes = value

        line1 = "ARP Note Count"
        line2 = zeroPad(value)
    end

    updateLCD(line1, line2)
end



function reset()
    maxNotes = 5
    notes = {"3c", "40", "43", "47", "48"}
    velocity = "64"
    curNote = 0

    if rate == nil then
        rate = 500
    end

    noteLength = rate - (rate / 4)
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
    panel:sendMidiMessageNow(CtrlrMidiMessage(MIDI_ON[MIDI_CH+1] .." ".. notes[curNote] .." ".. velocity))

	timer:setCallback(TIMER.ARP_NOTE, stopNote)
	timer:startTimer(TIMER.ARP_NOTE, noteLength)
end



function stopNote()
    activity(ACT_OFF)

    -- note off
    panel:sendMidiMessageNow(CtrlrMidiMessage(MIDI_OFF[MIDI_CH+1] .." ".. notes[curNote] .." 00"))

    timer:stopTimer(TIMER.ARP_NOTE)
end
