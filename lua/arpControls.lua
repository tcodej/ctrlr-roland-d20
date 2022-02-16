--
-- Auto-play notes when adjusting tone parameters
--

-- hex
local notes = {"3c"}
local velocity = "64"

local curNote = 1
local maxNotes = 5
local dir = 1
local updown = 0

-- milliseconds
local rate = 500
local noteLength = rate / 2

function arpControls(mod, value)
    local name = L(mod:getName())

    if name == "btn-arp" then
        if value == 0 then
            ARP_ON = false
            timer:stopTimer(1)

            curNote = 1
            notes = {"3c"}
            velocity = "64"

            -- all notes off
            panel:sendMidiMessageNow(CtrlrMidiMessage("b0 7b 00"))
        end

        if value == 1 then
            ARP_ON = true
            timer:setCallback(1, sendNote)
            timer:startTimer(1, rate)
        end

    elseif name == "arp-rate" then
        timer:stopTimer(1)
        rate = (value + 1) * 50
        noteLength = rate / 2
        timer:startTimer(1, rate)
        console("rate: ".. rate)
    end
end



function addNote(num, vel)
    if num ~= notes[curNote] then
        stopNote()
    end

    if tableLength(notes) >= maxNotes then
        table.remove(notes, 1)
    end

    table.insert(notes, num)
    --console(dump(notes))

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

	timer:setCallback(2, stopNote)
	timer:startTimer(2, noteLength)
end

function stopNote()
    activity(ACT_OFF)

    -- note off
    panel:sendMidiMessageNow(CtrlrMidiMessage("80 ".. notes[curNote] .." 00"))

    timer:stopTimer(2)
end
