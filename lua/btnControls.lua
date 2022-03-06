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
        local common = panel:getCanvas():getLayerByName("common")

        if value == 0 then
            console("performance off, tone on")
            toggleVisible("tabs-partials", true)
            common:setPropertyInt("uiPanelCanvasLayerVisibility", 1)

        else
            console("performance on, tone off")
            toggleVisible("tabs-partials", false)
            common:setPropertyInt("uiPanelCanvasLayerVisibility", 0)
        end
    end

end
