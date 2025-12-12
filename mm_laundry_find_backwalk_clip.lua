X_COORD = 0x3FFDD4 -- float
Y_COORD = 0x3FFDD8 -- float
Z_COORD = 0x3FFDDC -- float
ANGLE = 0x3FFE6E -- short
LINEAR_VELOCITY = 0x400880 -- float
Y_VELOCITY = 0x3FFE18 -- float
FLOOR_POLY = 0x3FFE30 -- unsigned long

function attemptClip(x, z, angle)
	i = 0
	while i < 6 do
		if i >= 0 and i < 3 then
			--set coords and angle and wait for link to be in that position
			
			mainmemory.writefloat(Y_VELOCITY, 0.0, true)
			mainmemory.writefloat(LINEAR_VELOCITY, 0.0, true)
			
			mainmemory.writefloat(X_COORD, x, true)
			mainmemory.writefloat(Y_COORD, -8, true)
			mainmemory.writefloat(Z_COORD, z, true)
			mainmemory.write_u16_be(ANGLE, angle)
		elseif i == 4 then
			mainmemory.writefloat(LINEAR_VELOCITY, 9, true)
		elseif i == 5 then
			--check if the floor poly is null. if so, you clipped
			if mainmemory.read_u32_be(FLOOR_POLY) == 0x00000000 then
				print("clipped! "..x..", "..z..": "..string.format("%06X", angle))
				returnVal = true
			else
				print("clip failed! "..x..", "..z..": "..string.format("%06X", angle))
				returnVal = false
			end
		end
		
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		i = i + 1
	end
	
	return returnVal
end

--[[
COMPLETED RANGES 
X:, 1434-1430 (.1 incr) Y:418-421 (.1 incr), angle: 0x0000-0x0800
(was doing this but stopped: X:, 1434-1430 (.1 incr) Y:418-421 (.1 incr), angle: 0x0000-0x0800)


]]--


function main()

	--START_ANGLE = -0x1000
	START_ANGLE = 0x0000
	--END_ANGLE = 0x1000
	END_ANGLE = 0x0800

	--START_X = -1434
	START_X = -1432.4
	END_X = -1430
	--END_X = -1421

	--START_Z = 418
	START_Z = 418
	END_Z = 421
	--END_Z = 421

	X_ADD = 0.1
	Z_ADD = 0.1
	ANGLE_ADD = 0x10

	current_x = START_X
	current_z = START_Z
	current_angle = START_ANGLE
	while current_x < END_X do
		while current_z < END_Z do
			console.clear()
			while current_angle < END_ANGLE do
				success = attemptClip(current_x, current_z, current_angle)
				
				if success == true then
					return
				end
				
				current_angle = current_angle + ANGLE_ADD
			end
			current_z = current_z + Z_ADD
			current_angle = START_ANGLE
		end
		current_x = current_x + X_ADD
		current_z = START_Z
		current_angle = START_ANGLE
	end
end

main()