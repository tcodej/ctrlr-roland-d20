--
-- Switch between partial tabs
--

function partialSelect(mod, value, source)
    local name = L(mod:getName())
    local partial = tonumber(string.sub(name, -1))

    panel:getComponent("tabs-partials"):setProperty("uiTabsCurrentTab", partial-1, false)
    updateLCD("Tone Edit", "Partial ".. partial)
end

