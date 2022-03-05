--
-- Experimental LFO to auto modulate parameters
--

local lfoNum = 2
local type = "square"

local rate = 33
local min = 40
local max = 100
local val = 0
local step = 4
local dir = 1
local mod = "tvf-cutoff-p1"

function lfo2(mod, value)
    if value == 0 then
        LFO[lfoNum] = false

    else
        LFO[lfoNum] = true
    end

    if LFO[lfoNum] == false then
        startLfo2()

    else
        stopLfo2()
    end

end


function startLfo2()
    console("Start lfo2")
    LFO[lfoNum] = true
    val = 0
    timer:setCallback(TIMER.LFO[lfoNum], lfo2Loop)
    timer:startTimer(TIMER.LFO[lfoNum], rate)
end


function stopLfo2()
    console("Stop lfo2")
    LFO[lfoNum] = false
    timer:stopTimer(TIMER.LFO[lfoNum])
    val = 0
end


function lfo2Loop()
    val = val + (step * dir)

    if val >= max then
        dir = -1
        val = max

        if type == "square" then
            set(mod, val)
        end
    end

    if val <= min then
        dir = 1
        val = min

        if type == "square" then
            set(mod, val)
        end
    end

    if type ~= "square" then
        set(mod, val)
    end
end
