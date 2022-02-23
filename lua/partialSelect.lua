--
-- Switch between partial tabs
--

function partialSelect(mod, value, source)
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))

    hideEnv()

    panel:getComponent("tabs-partials"):setProperty("uiTabsCurrentTab", partial-1, false)
    updateLCD("Tone Edit", "Partial ".. partial)

    -- don't allow the currently pressed button to get in an off state
    if get("btn-p".. partial) == 0 then
        set("btn-p".. partial, 1)
    end
end

