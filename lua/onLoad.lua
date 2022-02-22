--
-- Called when the panel has finished loading
--

function onLoad(type)
    hideEnv()
    updateLCD("* Roland  D-20 *", " LA Synthesizer ")

	timer:setCallback(20, updateCounter)
	timer:startTimer(20, 2000)
end

function updateCounter()
    timer:stopTimer(20)
    updateLCD("Part1      CH 01", "I-A11:AcouPiano1")
end