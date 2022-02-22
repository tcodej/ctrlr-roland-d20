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
            timer:stopTimer(1)

            -- all notes off
            panel:sendMidiMessageNow(CtrlrMidiMessage("b0 7b 00"))
        end

        if value == 1 then
            reset()
            -- trigger the first note on button press
            sendNote()

            ARP_ON = true
            timer:setCallback(1, sendNote)
            timer:startTimer(1, rate)
        end

    elseif name == "arp-rate" then
        -- convert to high to low
        value = 20 - value

        rate = (value + 1) * 50
        noteLength = rate / 2
        console("rate: ".. rate)

        if ARP_ON then
            timer:stopTimer(1)
            timer:startTimer(1, rate)
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
    noteLength = rate / 2
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

	timer:setCallback(2, stopNote)
	timer:startTimer(2, noteLength)
end

function stopNote()
    activity(ACT_OFF)

    -- note off
    panel:sendMidiMessageNow(CtrlrMidiMessage("80 ".. notes[curNote] .." 00"))

    timer:stopTimer(2)
end
