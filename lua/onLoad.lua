--
-- Called when the panel has finished loading
--

function onLoad(type)
    hideEnv()
    updateLCD("D20 v1.0 2022-02", "By Trent Johnson")

	timer:setCallback(TIMER.ONLOAD, updateCounter)
	timer:startTimer(TIMER.ONLOAD, 2000)
end

function updateCounter()
    timer:stopTimer(TIMER.ONLOAD)
    updateLCD("* Roland  D-20 *", " LA Synthesizer ")
end