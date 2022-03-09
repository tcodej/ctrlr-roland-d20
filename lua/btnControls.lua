function btnControls(mod, value)
    local name = L(mod:getName())

    if name == "btn-toggle-env" then
        startBlinker()

        if value == 0 then
            DISPLAY_ENVS = false
            hideEnv()
            updateLCD("ENV Visualizer", OFF_ON[1])

        else
            DISPLAY_ENVS = true
            updateLCD("ENV Visualizer", OFF_ON[2])
        end
    end

    if name == "btn-toggle-performance" then
        if value == 0 then
            console("performance off, tone on")
            toggleVisible("tabs-partials", true)
            toggleLayerVisible("tone-common", true)
            toggleLayerVisible("performance", false)

        else
            console("performance on, tone off")
            toggleVisible("tabs-partials", false)
            toggleLayerVisible("tone-common", false)
            toggleLayerVisible("performance", true)
        end
    end

end
