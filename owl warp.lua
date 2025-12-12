-- "owlmode.lua"
-- toggle the script, then when entering a loading zone it will simulate an owl void warp and terminate

local addr_game_mode = 0x1f3318
local addr_entrance_mod_setter = 0x1f35ba
local entrance_mod = 0x1F331f

mainmemory.write_u16_be(addr_entrance_mod_setter, 65520)

while true do
    if mainmemory.read_u16_be(addr_entrance_mod_setter) == 65519 then
        mainmemory.writebyte(addr_game_mode, 4)
		mainmemory.writebyte(entrance_mod, 1)
        break
    end
    emu.frameadvance()
end