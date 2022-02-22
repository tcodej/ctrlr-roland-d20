--
-- Called when a component needs repainting
-- @comp
-- @g    http://ctrlr.org/api/class_ctrlr_lua_graphics.html
--              see also http://www.rawmaterialsoftware.com/juce/api/classGraphics.html
--

local g
local envs = {
    pitch = 1,
    tvf = 2,
    tva = 3
}
local envType
local partial
local width
local height
local lineTh = 2
local ratioX = 1
local ratioY = 1
local keyoff
local colors = {
    bg = 0xFF003300,
    xy = 0xFFFFFFFF,
    line = 0xff00ff21,
    text = 0xff00ff21
}


function paintEnvelope(comp, graphic)
    g = graphic

	width = g:getClipBounds():getWidth()
	height = g:getClipBounds():getHeight()
    ratioX = width / 100
    ratioY = height / 100
    keyoff = math.floor(width - (width / 5))

    g:setFont(9)
	g:fillAll(Colour(colors.bg))

    g:setColour(Colour(colors.xy))
    g:drawLine(keyoff, 0, keyoff, height, lineTh)

    if envType == nil then
        setEnv("pitch", 1)
    end

    if envType == 1 then
        paintPitchEnv()

    elseif envType == 2 then
        paintADSR("tvf")

    elseif envType == 3 then
        paintADSR("tva")
    end

    grid = resources:getResource("grid-screen"):asImage()
    g:fillAll(g:setTiledImageFill(grid, 0, 0, 1.0))

    g:setColour(Colour(colors.text))
    g:drawSingleLineText("KEY OFF", keyoff+4, 10, Justification(Justification.left))

    if envType == 1 then
        g:drawSingleLineText("PITCH", 4, 10, Justification(Justification.left))

    elseif envType == 2 then
        g:drawSingleLineText("TVF", 4, 10, Justification(Justification.left))

    elseif envType == 3 then
        g:drawSingleLineText("TVA", 4, 10, Justification(Justification.left))
    end

    showEnv()
end


function hideEnv()
    panel:getModulatorByName("envelope-graph"):getComponent():setVisible(false)
end


function showEnv()
    panel:getModulatorByName("envelope-graph"):getComponent():setVisible(true)
end


function setEnv(type, part)
    showEnv()

    if type == nil then
        envType = envs.pitch
    else
        envType = envs[type]
    end

    if part == nil then
        partial = 1
    else
        partial = part
    end
end


function calcX(name)
    -- divide by number of time faders and 1 sustain period
    x = (get(name) * ratioX) / 5
    if x < 0 then x = 0 end
    if x > width then x = width end
    return math.floor(x)
end


function calcY(name)
    y = height - get(name) * ratioY
    if y < 0 then y = 0 end
    if y > height-1 then y = height-1 end
    return math.floor(y)
end


function paintPitchEnv()
	t1 = calcX("penv-t1-p".. partial)
    t2 = calcX("penv-t2-p".. partial)
    t3 = calcX("penv-t3-p".. partial)
    tsus = math.floor((100 * ratioX) / 5)
    t4 = calcX("penv-t4-p".. partial)

    l0 = calcY("penv-l0-p".. partial)
    l1 = calcY("penv-l1-p".. partial)
    l2 = calcY("penv-l2-p".. partial)
    lend = calcY("penv-lend-p".. partial)
    lsus = math.floor(height / 2)

	g:setColour(Colour(colors.xy))
	g:drawLine(0, lsus, width, lsus, 1)


    g:setColour(Colour(colors.line))
	g:drawLine(0, l0, t1, l1, lineTh)
	g:drawLine(t1, l1, t1+t2, l2, lineTh)
	g:drawLine(t1+t2, l2, t1+t2+t3, lsus, lineTh)
    g:drawLine(t1+t2+t3, lsus, keyoff, lsus, lineTh)
	g:drawLine(keyoff, lsus, keyoff+t4, lend, lineTh)
    g:drawLine(keyoff+t4, lend, width, lend, lineTh)
end


function paintADSR(type)
	t1 = calcX(type .."-t1-p".. partial)
    t2 = calcX(type .."-t2-p".. partial)
    t3 = calcX(type .."-t3-p".. partial)
    tsus = (100 * ratioX) / 5
    t4 = calcX(type .."-t4-p".. partial)

    l1 = calcY(type .."-l1-p".. partial)
    l2 = calcY(type .."-l2-p".. partial)
    lsus = calcY(type .."-lsus-p".. partial)

	g:setColour(Colour(colors.xy))
	g:drawLine(0, height-1, width, height-1)

    g:setColour(Colour(colors.line))
	g:drawLine(0, height-1, t1, l1, lineTh)
	g:drawLine(t1, l1, t1+t2, l2, lineTh)
	g:drawLine(t1+t2, l2, t1+t2+t3, lsus, lineTh)
    g:drawLine(t1+t2+t3, lsus, keyoff, lsus, lineTh)
	g:drawLine(keyoff, lsus, keyoff+t4, height, lineTh)
    g:drawLine(keyoff+t4, height-1, width, height-1, lineTh)

end