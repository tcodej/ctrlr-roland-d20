--
-- Update display with the selected slider value
--

function btnShowValues(mod, value)
    local name = L(mod:getName())
    -- remove "btn-" fromstring
    name = string.sub(name, 5)
    console(name)

    local num = get(name .."-p1")
    -- set value to itsself to trigger display update
    set(name .."-p1", num)
end