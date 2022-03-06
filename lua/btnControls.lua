function btnControls(mod, value)
    local name = L(mod:getName())

    if name == "btn-toggle-env" then
        if value == 0 then
            DISPLAY_ENVS = false
            hideEnv()

        else
            DISPLAY_ENVS = true
        end
    end

    if name == "btn-toggle-performance" then
        if value == 0 then
            console("performance off, tone on")
            toggleVisible("tabs-partials", true)
            toggleLayerVisible("common", true)
            toggleLayerVisible("performance", false)

        else
            console("performance on, tone off")
            toggleVisible("tabs-partials", false)
            toggleLayerVisible("common", false)
            toggleLayerVisible("performance", true)
        end
    end

end
