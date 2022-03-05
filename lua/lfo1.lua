--
-- Experimental LFO to auto modulate parameters
--

local lfoNum = 1

local rate = 33
local min = 20
local max = 25
local val = 0
local step = 1
local dir = 1
local mod = "tvf-res-p1"

function lfo1(mod, value)

    if value == 0 then
        LFO[lfoNum] = false

    else
        LFO[lfoNum] = true
    end

    if LFO[lfoNum] == false then
        startLfo1()

    else
        stopLfo1()
    end

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
    if val >= max then
        dir = -1
    end

    if val <= min then
        dir = 1
    end

    val = val + (step * dir)
    set(mod, val)
end
