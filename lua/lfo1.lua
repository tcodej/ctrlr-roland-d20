--
-- Experimental LFO to auto modulate parameters
--

local lfoNum = 1

local SHAPES = {"Triangle","Square","Sawtooth","Random"}

local MODS = {
    { name = "mod-timbre-keyshft", min = 0, max = 48, step = 1 },
    { name = "tvf-cutoff-p1", min = 30, max = 100, step = 1 },
    { name = "tvf-res-p1", min = 15, max = 30, step = 1 },
    { name = "form-pw-p1", min = 0, max = 100, step = 1 },
    { name = "mod-patch-mainlevel", min = 0, max = 100, step = 10 }
}

local dest = MODS[get("mod-lfo1-mod")+1].name
local min = MODS[get("mod-lfo1-mod")+1].min
local max = MODS[get("mod-lfo1-mod")+1].max
local step = MODS[get("mod-lfo1-mod")+1].step

local rate = get("mod-lfo1-rate")
local shape = SHAPES[get("mod-lfo1-SHAPE")]
local val = min
local dir = 1

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
        dest = MODS[value+1].name
        min = MODS[value+1].min
        max = MODS[value+1].max
        step = MODS[value+1].step

        line1 = "LFO1 Target"
        line2 = dest

        if LFO[lfoNum] == true then
            stopLfo1()
            startLfo1()
        end
    end

    updateLCD(line1, line2)

end


function startLfo1()
    LCD_UPDATE = false
    LFO[lfoNum] = true
    val = 0
    timer:setCallback(TIMER.LFO[lfoNum], lfo1Loop)
    timer:startTimer(TIMER.LFO[lfoNum], rate)
end


function stopLfo1()
    LCD_UPDATE = true
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

        if shape == "Square" then
            if val == min or val == max then
                set(dest, val)
            end
            return
        end

    end

    set(dest, val)
end
