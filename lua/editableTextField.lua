--
-- Handle text field editing
--

function editableTextField(label, newContent)
    toneName = L(panel:getLabel("label-tone-name"):getText())

    console(toneName)

end

--[[
	-- Your method code here
	console ("sendPatchName")

	messageToSend	= MemoryBlock ({0xf0, 0x10, 0x03, 0x01})
	-- we prepare our message we will be sending to the device, this is just
	-- the prefix to the message, the rest of the data will be appended at the
	-- end of this method

	messageSuffix	= MemoryBlock ({0x00, 0xf7})
	-- this variable hold the suffix of the entire MIDI message, this can be
	-- altered later to hold the checksum if needed

	text 		= L(panel:getLabel("nameInputLabel"):getText())
	-- we take the text from the "nameInputLabel" and convert it to Lua type of
	-- string, that's why there is the L() macro, otherwise we'd get a String()
	-- instance, that might not work well with the native Lua library

	textLen		= string.len(text)
	-- we can use string library function safely now
	-- here we take the length of the string and keep it in a variable

	textTable	= {}
	-- we'll use a table to store our patch name as bytes of data
	-- this creates a new empty table, this could be local not to confuse
	-- other methods

	for i=1,textLen do
		textTable[i] = string.byte(text,i)
		-- the bytes here can be prepared to fit a MIDI message
		-- if there are ASCII characters beyond 127 then this will
		-- casue invalid MIDI messages, it's up to you to check
		-- you can also apply restrictions on the input label
	end

	for j=1,#textTable do
		console (string.format ("%d = %d %2x [%c]", j, textTable[j], textTable[j], textTable[j]))
		-- this is for debugging purposes only, it prints every entry
		-- in the table we created above, tables start at "1" in Lua
		-- #textTable means the tables size/length
	end

	patchNameData	= MemoryBlock.fromLuaTable(textTable)
	-- here we converted our table of characters into a Ctrlr compatible MemoryBlock
	
	console ("\tpatch name as memory block: "..patchNameData:toHexString(1))
	-- for debugging purposes let's see how that looks like

	-- Now we will construct the entire message, the variable "messageToSend"
	-- holds all the data we need, we append any new data we gathered here
	-- then at the end, append the messageSuffix that ends the message 
	--(there might be a need for a checksum, that's the place to calculate it)
	messageToSend:append (patchNameData)
	messageToSend:append (messageSuffix)

	console ("\tpatch data: "..messageToSend:toHexString(1))
	-- for debugging let's see the entire message, we can now send it by creating
	-- a CtrlrMidiMessage from this data, or maybe save it for later

	panel:getLabel("debugOutputLabel"):setText(messageToSend:toHexString(1))
--]]