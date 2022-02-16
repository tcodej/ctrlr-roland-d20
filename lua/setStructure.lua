-- Change the partial structure

function setStructure(mod, value, source)
    if value == 0 then
        showForm(0)

    elseif value == 1 then
        showForm(1)
    end
end

function showForm(num)
    panel:getComponent("tabs-p1-form"):setProperty ("uiTabsCurrentTab", num, false)
end