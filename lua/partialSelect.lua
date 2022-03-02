--
-- Switch between partial tabs
--

function partialSelect(mod, value, source)
    -- first disable blinker
    stopBlinker()

    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))

    hideEnv()

    panel:getComponent("tabs-partials"):setProperty("uiTabsCurrentTab", partial-1, false)

    -- reset
    P_EDIT[1] = false
    P_EDIT[2] = false
    P_EDIT[3] = false
    P_EDIT[4] = false

    -- set chosen as active
    P_EDIT[partial] = true

    startBlinker()

    --updateLCD("Tone Edit", "Partial ".. partial)

    -- don't allow the currently pressed button to get in an off state
    if get("btn-p".. partial) == 0 then
        set("btn-p".. partial, 1)
    end
end

