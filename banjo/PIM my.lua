-- Function to write a single 32-bit floating-point number represented in hexadecimal
function writeFloat32Hex(addr, hexValue)
	mainmemory.write_u32_be(addr, tonumber(hexValue, 16))
end

-- Get the player object's base memory address. This is a hypothetical function and might need to be adjusted.
while true do
	local playerObject = Game.getPlayerObject()
	--print(string.format("playerObject: %08X", playerObject))

	local address = 0
	-- Calculate the specific address you're interested in by adding 3600 to the base address.
	if (playerObject ~= nil) then
		local dataToWriteAddress = playerObject + 0xE08
		address = dataToWriteAddress + 46
		
		-- Generate a random increment between 1 and 255
		local i = math.random(1, 255)

		local currentAddress = dataToWriteAddress + ((i)-2) * 28
		-- Write 8 bytes of zeros in two 32-bit chunks
		--[[mainmemory.write_s32_be(currentAddress, 0)      -- Write the first 4 bytes of zeros
		mainmemory.write_s32_be(currentAddress + 4, 0)  -- Write the second 4 bytes of zeros

		-- Optional: Check if the zeros were written correctly (for debugging purposes)
		local checkFirstPart = mainmemory.read_s32_be(currentAddress)
		local checkSecondPart = mainmemory.read_s32_be(currentAddress + 4)
		print("Wrote to: "..string.format("%08X",currentAddress))

		-- Assume dataToWriteAddress is already defined
		--]]
		local address = currentAddress

		-- List of hex values to write
		local temp = math.random(1,2)
		local hexValues = {}
		if (temp == 2) then
		hexValues = {"00000000", "00000000", "3DF5C28F", "3E4CCCCD", "3F000000", "3F400000", "3F800000"}

		else
		 hexValues = {"00000000", "00000000"}
		end

		local originalValues = {}
		local summaryString = "Overwritten values: "
		for i, hexValue in ipairs(hexValues) do
			-- Read and store the original value
			local originalValue = mainmemory.read_u32_be(address)
			table.insert(originalValues, string.format("%08X", originalValue))
			
			-- Write the new hex value
			--writeFloat32Hex(address, hexValue)
			
			-- Move to the next address
			address = address + 4

			-- Append details to the summary string
			summaryString = summaryString.." ".. string.format("%08X", originalValue) 
		end

		-- Print the summary of overwritten values
		--print(summaryString)
		--print("Values written successfully starting from address:", string.format("%08X", currentAddress))
		--print("Snoozes needed: "..(256 - i))
		

	else
		print("No player found!")
	end
	
	-- Print the address of the PIM index
	--print(string.format("address: %08X", address))

	-- Advance the emulator frames to allow for game processing.
	for i = 1, 60 do
		emu.frameadvance()  -- This function advances the emulator by one frame.

		if playerObject ~= nil then
			-- Display the number of backpacks needed
			
			-- Read the 7 PIM write words and display it on screen
			local hexValues2 = string.format("%08X", mainmemory.read_u32_be(playerObject + 0xE08))
			-- Read and append the next six 32-bit values (24 bytes total) as unsigned
			for j = 1, 6 do
				local byteOffset = 4 * j  -- Compute the byte offset for each 32-bit integer
				local additionalValue = mainmemory.read_u32_be(playerObject + 0xE08 + byteOffset)
				hexValues2 = hexValues2 .. " " .. string.format("%08X", additionalValue)
			end
			gui.text(1,600, "PIM Write: " .. hexValues2)
			
			
			if address ~= nil then
				
				-- Display PIM Index in hexadecimal
				gui.text(1, 615, "PIM Index: " .. string.format("%02X", mainmemory.read_u8(address)))

				-- Calculate and display the target address (which is WHERE the data will be written)
				local targetAddress = (mainmemory.read_u8(address) * 28) + playerObject + 0xDD0
				gui.text(1, 630, "Target Address: " .. string.format("%08X", targetAddress))

				-- Read and display the Target value (which is the current values of the memory location that WILL be written to
				local hexValues = string.format("%08X", mainmemory.read_u32_be(targetAddress))
				for j = 1, 6 do
					local byteOffset = 4 * j  -- Compute the byte offset for each 32-bit integer
					local additionalValue = mainmemory.read_u32_be(targetAddress + byteOffset)
					hexValues = hexValues .. " " .. string.format("%08X", additionalValue)
				end
				gui.text(1, 645, "Target Value: " .. hexValues)

				-- Display the remaining snoozes
				local snoozes = 256 - mainmemory.read_u8(address)
				if (snoozes == 256 or snoozes == 255) then
					snoozes = "Null"
				end
				gui.text(1, 660, "Snoozes: " .. snoozes)
				
				--print("first object addr: "..string.format("%08X", Game.getObjectModel1Pointers()[1]))
				if (getObjectModel1Pointers()[1] ~= nil and Game.getPlayerObject() ~= nil) then
					local diff = getObjectModel1Pointers()[1] - Game.getPlayerObject()
					if diff >= 0 then
						gui.text(1, 675, "Diff: " .. string.format("%08X", diff))
					else
						gui.text(1, 675, "Diff: -" .. string.format("%08X", -diff))
					end
				end
				
			end
		end
	end
end