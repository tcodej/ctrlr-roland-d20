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

    console(name.." "..tostring(DISPLAY_ENVS))
end
