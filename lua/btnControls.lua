function btnControls(mod, value)
    local name = L(mod:getName())
    stopBlinker()

    if name == "btn-toggle-env" then
        if value == 0 then
            --startBlinker()
            DISPLAY_ENVS = false
            hideEnv()
            updateLCD("ENV Visualizer", OFF_ON[1])

        else
            DISPLAY_ENVS = true
            showEnv()
            updateLCD("ENV Visualizer", OFF_ON[2])
            panel:getComponent("envelope-graph"):repaint()
        end
    end

    if name == "btn-toggle-functions" then

        if value == 0 then
            --console("performance off, tone on")
            setMode("partials")
            updateLCD("Partials 1-4","Edit")

        else
            --console("performance on, tone off")
            setMode("functions")
            updateLCD("Timbre/Patch","Edit")
        end
    end

end

-- this is also used by partial select buttons
function setMode(type)
    local ledFunctions = panel:getModulatorByName("img-led-functions"):getComponent()
    local ledPartials = panel:getModulatorByName("img-led-partials"):getComponent()

    if type == "partials" then
        toggleVisible("tabs-partials", true)
        toggleLayerVisible("tone-common", true)
        toggleLayerVisible("functions", false)

        ledFunctions:setPropertyString("uiImageResource", "led-off")
        ledPartials:setPropertyString("uiImageResource", "led-red")

    else
        toggleVisible("tabs-partials", false)
        toggleLayerVisible("tone-common", false)
        toggleLayerVisible("functions", true)

        ledFunctions:setPropertyString("uiImageResource", "led-red")
        ledPartials:setPropertyString("uiImageResource", "led-off")
    end
end
