if gameinfo.getromhash() == 'AD69C91157F6705E8AB06C79FE08AAD47BB57BA7' then -- OoT U 1.0
	Y_VELOCITY = 0x1DAA90
elseif gameinfo.getromhash() == 'D6133ACE5AFAA0882CF214CF88DABA39E266C078' then -- MM U
	Y_VELOCITY = 0x3FFE18
else -- OOT3D
	Y_VELOCITY = 0x06FF4074
end

while true do
	--print(joypad.get())
	
	if gameinfo.getromhash() == '8AEB0679FC5F77D35B8A58954CE98236' then -- MM3D U
		playerPtr = 0x0752FD6C -- or try 0x0752FFA8
		offset_addr = 0x24EE000
		
		addr_player = mainmemory.read_u32_le(playerPtr)
		if addr_player > offset_addr then
			addr_player = addr_player - offset_addr
		end
		Y_VELOCITY = addr_player + 0x68
		--console.clear()
		--print("player: "..string.format("0x%x", addr_player))
		--print("y velocity: "..string.format("0x%x", Y_VELOCITY))
		
		if joypad.get().Debug == true then
			mainmemory.writefloat(Y_VELOCITY, 7, false)
		end
	elseif joypad.get().Debug == true then -- OOT3D
		mainmemory.writefloat(Y_VELOCITY, 7, false)
	elseif joypad.get(1).L == true then -- OOT or MM
		mainmemory.writefloat(Y_VELOCITY, 7, true)
	end
	emu.frameadvance()
end
