--
-- Experimental LFO to auto modulate parameters
--

local lfoNum = 1

local rate = 30
local min = 0
local max = 48
local val = 0
local step = 1
local dir = 1
local dest = "mod-timbre-keyshft"
local shape = "Triangle"

local SHAPES = {"Triangle","Square","Sawtooth","Random"}
local MODS = {"mod-timbre-keyshft","tvf-cutoff-p1","tvf-res-p1","form-pw-p1"}

function lfo1(mod, value)

    local name = L(mod:getName())
    local line1 = ""
    local line2 = ""

    if string.find(name, "toggle") then
        line1 = "LFO1"
        line2 = OFF_ON[value+1]

        if value == 0 then
            LFO[lfoNum] = false
            stopLfo1()

        else
            LFO[lfoNum] = true
            startLfo1()
        end

    elseif string.find(name, "rate") then
        -- never zero
        rate = ((value + 1) * 10)
        line1 = "LFO1 Rate"
        line2 = zeroPad(rate)

        if LFO[lfoNum] == true then
            stopLfo1()
            startLfo1()
        end

    elseif string.find(name, "shape") then
        shape = SHAPES[value+1]
        line1 = "LFO1 Shape"
        line2 = shape

    elseif string.find(name, "mod") then
        dest = MODS[value+1]
        line1 = "LFO1 Shape"
        line2 = dest

        if LFO[lfoNum] == true then
            stopLfo1()
            startLfo1()
        end
    end

    updateLCD(line1, line2)

end


function startLfo1()
    console("Start lfo1")
    LFO[lfoNum] = true
    val = 0
    timer:setCallback(TIMER.LFO[lfoNum], lfo1Loop)
    timer:startTimer(TIMER.LFO[lfoNum], rate)
end


function stopLfo1()
    console("Stop lfo1")
    LFO[lfoNum] = false
    timer:stopTimer(TIMER.LFO[lfoNum])
    val = 0
end


function lfo1Loop()
    if shape == "Random" then
        val = math.random(min, max)

    else


        if val >= max then
            dir = -1
        end

        if val <= min then
            dir = 1
        end

        val = val + (step * dir)
    end

    console(dest)

    set(dest, val)
end
