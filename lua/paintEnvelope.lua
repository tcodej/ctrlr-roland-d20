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

function paintEnvelope(comp, graphic)
    g = graphic

	width = g:getClipBounds():getWidth()
	height = g:getClipBounds():getHeight()
	g:fillAll(Colour(0xff000000))

    if envType == nil then
        setEnv("pitch", 1)
    end
    console("type ".. envType)
    if envType == 1 then
        paintPitchEnv()

    elseif envType == 2 then
        paintTVFEnv()

    elseif envType == 3 then
        paintTVAEnv()
    end

    grid = resources:getResource("grid-screen"):asImage()
    g:fillAll(g:setTiledImageFill(grid, 0, 0, 1.0))
end



function setEnv(type, part)
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



function paintPitchEnv()
	t1 = get("penv-t1-p".. partial)
    t2 = get("penv-t2-p".. partial)
    t3 = get("penv-t3-p".. partial)
    t4 = get("penv-t4-p".. partial)

    l0 = height - get("penv-l0-p".. partial)
    l1 = height - get("penv-l1-p".. partial)
    l2 = height - get("penv-l2-p".. partial)
    lend = height - get("penv-lend-p".. partial)

	g:setColour(Colour(0xffffffff))
	g:drawLine(0, height/2, width, height/2, 1)

    g:setColour(Colour(0xff00ff21))
	g:drawLine(0, l0, t1, l1, lineTh)
	g:drawLine(t1, l1, t1+t2, l2, lineTh)
	g:drawLine(t1+t2, l2, t1+t2+t3, lend, lineTh)
	g:drawLine(t1+t2+t3, lend, t1+t2+t3+t4, lend, lineTh)
end



function paintTVFEnv()
    console("paintTVFEnv")
	g:setColour(Colour(0xffffffff))
	g:drawLine(0, height, width, height)
end



function paintTVAEnv()
	t1 = get("tva-t1-p".. partial)
    t2 = get("tva-t2-p".. partial)
    t3 = get("tva-t3-p".. partial)
    t4 = get("tva-t4-p".. partial)

    l1 = height - get("tva-l1-p".. partial)
    l2 = height - get("tva-l2-p".. partial)
    lsus = height - get("tva-lsus-p".. partial)

	g:setColour(Colour(0xffffffff))
	g:drawLine(0, height, width, height)

    g:setColour(Colour(0xff00ff21))
	g:drawLine(0, height, t1, l1, lineTh)
	g:drawLine(t1, l1, t1+t2, l2, lineTh)
	g:drawLine(t1+t2, l2, t1+t2+t3, lsus, lineTh)
	g:drawLine(t1+t2+t3, lsus, t1+t2+t3+t4, lsus, lineTh)
end
