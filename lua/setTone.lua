-- Sets tone options from data received from the D-20
-- getByte is available in midiMessageReceived which contains the data

function setTone()
    timer:setCallback(TIMER.SET_TONE, reenable)
    timer:startTimer(TIMER.SET_TONE, 100)
    ENABLE_OUT = false

    -- partial
    local p = 1

    -- partial 1 starting byte
    local b = 22

    -- common

    -- construct the name
    local name = ""
    for i=8, 17, 1 do
        num = tostring(getByteNum(i)-31)
        letter = string.sub(ASCII, num, num)
        name = name .. letter
    end

    panel:getLabel("label-name"):setText(name)

    set("mod-struct1", getByteNum(18))
    set("mod-struct2", getByteNum(19))
    -- partial mute, get back to this getByteNum(20)
    setMuteValue(getByteNum(20))
    set("btn-env-mode", getByteNum(21))

    -- partials
    for p=1, 4, 1 do
 
        -- penv
        set("penv-crs-p".. p, getByteNum(b))
        set("penv-fine-p".. p, getByteNum(b+1))
        set("penv-kfpitch-p".. p, getByteNum(b+2))
        set("btn-bend-p".. p, getByteNum(b+3))

        -- todo: handle the shape/bank combos based on partial type
        -- SQU/1, SAW/1, SQU/2, SAW/2

        set("btn-bank-p".. p, getByteNum(b+4))
        set("pcm-wave-number-slider-p".. p, getByteNum(b+5))
        set("form-pw-p".. p, getByteNum(b+6))
        set("form-vel-p".. p, getByteNum(b+7))

        set("penv-pdep-p".. p, getByteNum(b+8))
        set("penv-vel-p".. p, getByteNum(b+9))
        set("penv-kftime-p".. p, getByteNum(b+10))
        set("penv-t1-p".. p, getByteNum(b+11))
        set("penv-t2-p".. p, getByteNum(b+12))
        set("penv-t3-p".. p, getByteNum(b+13))
        set("penv-t4-p".. p, getByteNum(b+14))
        set("penv-l0-p".. p, getByteNum(b+15))
        set("penv-l1-p".. p, getByteNum(b+16))
        set("penv-l2-p".. p, getByteNum(b+17))
        -- 18 dummy for MT-32
        set("penv-lend-p".. p, getByteNum(b+19))
        set("penv-lrte-p".. p, getByteNum(b+20))
        set("penv-ldep-p".. p, getByteNum(b+21))
        set("penv-lmod-p".. p, getByteNum(b+22))

        -- tvf
        set("tvf-cutoff-p".. p, getByteNum(b+23))
        set("tvf-res-p".. p, getByteNum(b+24))
        set("tvf-freqkf-p".. p, getByteNum(b+25))
        set("tvf-bpt-p".. p, getByteNum(b+26))
        set("tvf-blv-p".. p, getByteNum(b+27))
        set("tvf-dep-p".. p, getByteNum(b+28))
        set("tvf-vel-p".. p, getByteNum(b+29))
        set("tvf-depkf-p".. p, getByteNum(b+30))
        set("tvf-tkf-p".. p, getByteNum(b+31))
        set("tvf-t1-p".. p, getByteNum(b+32))
        set("tvf-t2-p".. p, getByteNum(b+33))
        set("tvf-t3-p".. p, getByteNum(b+34))
        -- 35 dummy for MT-32
        set("tvf-t4-p".. p, getByteNum(b+36))
        set("tvf-l1-p".. p, getByteNum(b+37))
        set("tvf-l2-p".. p, getByteNum(b+38))
        -- 39 dummy for MT-32
        set("tvf-lsus-p".. p, getByteNum(b+40))

        -- tva
        set("tva-lvl-p".. p, getByteNum(b+41))
        set("tva-vel-p".. p, getByteNum(b+42))
        set("tva-bp1-p".. p, getByteNum(b+43))
        set("tva-bl1-p".. p, getByteNum(b+44))
        set("tva-bp2-p".. p, getByteNum(b+45))
        set("tva-bl2-p".. p, getByteNum(b+46))
        set("tva-kftime-p".. p, getByteNum(b+47))
        set("tva-kfvel-p".. p, getByteNum(b+48))
        set("tva-t1-p".. p, getByteNum(b+49))
        set("tva-t2-p".. p, getByteNum(b+50))
        set("tva-t3-p".. p, getByteNum(b+51))
        -- 52 dummy for MT-32
        set("tva-t4-p".. p, getByteNum(b+53))
        set("tva-l1-p".. p, getByteNum(b+54))
        set("tva-l2-p".. p, getByteNum(b+55))
        -- 56 dummy for MT-32
        set("tva-lsus-p".. p, getByteNum(b+57))

        b = b + 58
        --console("byte: "..b)
    end
end

function reenable()
    timer:stopTimer(TIMER.SET_TONE)
    ENABLE_OUT = true
    activity(ACT_OFF)
end