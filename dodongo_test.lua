X_COORD = 0x3FFDD4 -- float
Y_COORD = 0x3FFDD8 -- float
Z_COORD = 0x3FFDDC -- float
X_HOME = 0x3FFDB8 -- float
Y_HOME = 0x3FFDBC -- float
Z_HOME = 0x3FFDC0 -- float
ANGLE = 0x3FFE6E -- short
LINEAR_VELOCITY = 0x400880 -- float
Y_VELOCITY = 0x3FFE18 -- float

MOVEMENT_ANGLE = 0x400884
ISG = 0x40088B -- byte
FLOOR_POLY = 0x3FFE30 -- unsigned long

X_POS = 333.0835
Y_POS = 0
Z_POS = 1118.916
ANGLE_VAL = -12940

function attemptClip(y, linear)
	
	k = 0
	while k < 3 do
		mainmemory.writefloat(Y_VELOCITY, 0.0, true)
		mainmemory.writefloat(LINEAR_VELOCITY, 0.0, true)
		
		mainmemory.writefloat(X_COORD, X_POS, true)
		mainmemory.writefloat(Y_COORD, Y_POS, true)
		mainmemory.writefloat(Z_COORD, Z_POS, true)
		mainmemory.writefloat(X_HOME, X_POS, true)
		mainmemory.writefloat(Y_HOME, Y_POS, true)
		mainmemory.writefloat(Z_HOME, Z_POS, true)
		mainmemory.write_u16_be(ANGLE, ANGLE_VAL)
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		k = k + 1
	end
	
	mainmemory.writefloat(Y_VELOCITY, y, true)
	mainmemory.writefloat(LINEAR_VELOCITY, linear, true)
	
	j = 0
	while j < 12 do
		emu.frameadvance()
		j = j + 1
	end
	
	if mainmemory.read_u16_be(FLOOR_POLY) == 0x00000000 then
		print("clipped! "..string.format("0x%x", i))
	end
	
	return returnVal
end

console.clear()
for y = -15, -20, -0.2 do
	for linear = 1, 18, 0.2 do
		print(y..", "..linear)
		if(attemptClip(y, linear)) then
			print("SUCCESS: y="..y..", linear="..linear)
			break
		end
	end
    --print(i) -- Prints 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
end
