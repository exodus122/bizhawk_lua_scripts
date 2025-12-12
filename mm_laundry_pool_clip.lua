X_COORD = 0x3FFDD4 -- float
Y_COORD = 0x3FFDD8 -- float
Z_COORD = 0x3FFDDC -- float
ANGLE = 0x3FFE6E -- short
LINEAR_VELOCITY = 0x400880 -- float
Y_VELOCITY = 0x3FFE18 -- float
FLOOR_POLY = 0x3FFE30 -- unsigned long

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function attemptClip(x, z, angle)
	
	joypad.setanalog({
		['P1 X Axis'] = 0,
		['P1 Y Axis'] = 0,
	})
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	-- press z to put camera behind Link
	i = 0
	while i < 105 do
		if i > 10 and i < 25 then
			--set coords and angle and wait for link to be in that position
			
			mainmemory.writefloat(Y_VELOCITY, 0.0, true)
			mainmemory.writefloat(LINEAR_VELOCITY, 0.0, true)
			
			mainmemory.writefloat(X_COORD, x, true)
			mainmemory.writefloat(Y_COORD, -16.1319370, true)
			mainmemory.writefloat(Z_COORD, z, true)
			mainmemory.write_u16_be(ANGLE, angle)
			emu.frameadvance()
		elseif i >= 35 and i < 45 then
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			joypad.set({["Z"] = true}, 1)
		elseif i == 90 then
			-- start holding up
			joypad.setanalog({
				['P1 X Axis'] = 0,
				['P1 Y Axis'] = 127,
			})
			
			j = 0
			while j < 12 do
				emu.frameadvance()
				j = j + 1
			end
			
			joypad.set({["A"] = true}, 1)
			emu.frameadvance()
			joypad.set({["A"] = true}, 1)
			emu.frameadvance()
			joypad.set({["A"] = true}, 1)
			emu.frameadvance()
		elseif i == 100 then
			--check if the floor poly is null. if so, you clipped
			if mainmemory.read_u32_be(FLOOR_POLY) == 0x00000000 then
				print("clipped! "..x..", "..z..": "..string.format("0x%x", angle))
				returnVal = true
			else
				print("clip failed! "..x..", "..z..": "..string.format("0x%x", angle))
				returnVal = false
			end
			
			-- reset analog position
			joypad.setanalog({
				['P1 X Axis'] = 0,
				['P1 Y Axis'] = 0,
			})
		end
		
		emu.frameadvance()
		i = i + 1
	end
	
	
	--set linear velocity to 9.94
	--mainmemory.writefloat(LINEAR_VELOCITY, 9.94, true)=
	return returnVal
end

console.clear()

--attemptClip(-1437.27001, 380.8999938, 0x0410)


--[[
-- ANGLE 0x0410 range:
THE_ANGLE = 0x0410
START_X = -1437.305
START_Z = 380.56
END_X = -1437.255
END_Z = 380.92
]]--

--[[
-- TRY ANGLE 0x0420 range:
THE_ANGLE = 0x0420
START_X = -1437.335
START_Z = 380.70
END_X = -1437.330
END_Z = 380.94
]]--

--[[
-- TRY ANGLE 0x0430 range:
THE_ANGLE = 0x0430
START_X = -1437.560
START_Z = 380.70
END_X = -1437.480
END_Z = 380.84
]]--

--[[
-- TRY ANGLE 0x03D0 range:
THE_ANGLE = 0x03D0
START_X = -1436.930
START_Z = 380.90
END_X = -1436.910
END_Z = 380.96

SET_Z_END = 380.90
]]--

-- TRY ANGLE 0x03C0 range:
THE_ANGLE = 0x03C0
START_X = -1436.855
START_Z = 380.88
END_X = -1436.800
END_Z = 380.98

SET_Z_END = 380.90

X_ADD = 0.005
Z_ADD = 0.02

current_x = START_X
current_z = START_Z
while current_x < END_X do
	--print(current_x)
	while current_z < END_Z do
		success = attemptClip(current_x, current_z, THE_ANGLE)
		
		if success and current_z < SET_Z_END - Z_ADD then
			current_z = SET_Z_END - Z_ADD
		end
		
		current_z = current_z + Z_ADD
	end
	current_x = current_x + X_ADD
	current_z = START_Z
end

