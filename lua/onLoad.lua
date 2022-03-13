--
-- Called when the panel has finished loading
--

function onLoad(type)
	if panel:getRestoreState() == true or panel:getProgramState() == true then
		return
	end

    hideEnv()
    updateLCD("D20 v1.0 2022-02", "By Trent Johnson")

	timer:setCallback(TIMER.ONLOAD, updateCounter)
	timer:startTimer(TIMER.ONLOAD, 2000)

    set("btn-toggle-performance", 0)
end

function updateCounter()
    timer:stopTimer(TIMER.ONLOAD)
    updateLCD("* Roland  D-20 *", " LA Synthesizer ")
    set("btn-toggle-performance", 0)
end