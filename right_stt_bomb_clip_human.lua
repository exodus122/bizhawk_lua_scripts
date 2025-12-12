X_COORD = 0x3FFDD4
Y_COORD = 0x3FFDD8
Z_COORD = 0x3FFDDC

LINEAR_VELOCITY = 0x400880 -- float
ANGLE = 0x3FFE6E -- short
ISG = 0x40088B -- byte
FLOOR_POLY = 0x3FFE30


i = 808.0
while i < 816 do
	mainmemory.write_u16_be(ANGLE, 0x5C40) --4708
	mainmemory.writefloat(X_COORD, i, true)
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	mainmemory.write_u16_be(ANGLE, 0x5C40) --4708
	mainmemory.writefloat(X_COORD, i, true)
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	mainmemory.write_u16_be(ANGLE, 0x5C40) --4708
	mainmemory.writefloat(X_COORD, i, true)
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	mainmemory.writefloat(LINEAR_VELOCITY, 15.0, true)
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	
	if mainmemory.read_u16_be(FLOOR_POLY) == 0x00000000 then
		print("clipped! "+string.format("0x%x", i))
	end
	
	i = i + 0.05
end