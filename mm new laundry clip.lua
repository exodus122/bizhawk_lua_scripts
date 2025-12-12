X_COORD = 0x3FFDD4 -- float
Y_COORD = 0x3FFDD8 -- float
Z_COORD = 0x3FFDDC -- float
ANGLE = 0x3FFE6E -- short
MOVEMENT_ANGLE = 0x400884 -- short
LINEAR_VELOCITY = 0x400880 -- float
Y_VELOCITY = 0x3FFE18 -- float
FLOOR_POLY = 0x3FFE30 -- unsigned long
WARP_TRIGGER = 0x3FF395

console.clear()

--lowest speed i've gotten to clip with is 12.2 with very edge of ledge, angle about 1000, and mid hop angle change

for v = -12.0,-13.5,-0.1 do
	savestate.loadslot(1)
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	mainmemory.writefloat(LINEAR_VELOCITY, v, true)
	j = 0
	repeat
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		
		--[[if j > 8 then -- can be like 5-10 at least
			mainmemory.write_u16_be(MOVEMENT_ANGLE, 0x1A68) -- allows clip with 12.3, angle about 1800 to 2000
		end]]--
		if j > 8 then -- can be like 5-10 at least
			mainmemory.write_u16_be(MOVEMENT_ANGLE, 0x2000) -- allows clip with 12.3, or 12.2 if very corner and angle 1000ish
		end
		
		fadeout = mainmemory.read_u8(WARP_TRIGGER)
		j = j + 1
	until fadeout ~= 0 or j == 50
	
	
	
	temp_x = mainmemory.readfloat(X_COORD, true)
	if fadeout ~= 0 or (mainmemory.readfloat(Z_COORD, true) < -80 and (temp_x > -2115 and temp_x < -2084)) then
		print("clipped! "..v)
	else
		print("no clip "..v)
	end
end

--12.2 clips with very edge of ledge position, and frog angle (0E83) through 1000ish, with the changed movement angle mid hop

--0EDC is target frog
--angle 0E00-1200 13+
--angle 1300-1400 12.5+
--angle 1500 13+

--1200 12.6
--1300 12.5
--1340 12.5
--1380 12.4
--1390 12.4
--13A0 12.4
--13B0 12.4
--13C0 12.4
--13D0 12.4
--13E0 12.4
--13F0 12.4
--1400 12.5
--1500 12.6