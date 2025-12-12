form_addr = 0x1EF690
player_xpos_addr = 0x3FFDD4
player_angle_addr = 0x3FFE6E
held_actor_addr = 0x400138

savestate.loadslot(6)
form = mainmemory.readbyte(form_addr)
starting_xpos = mainmemory.read_u32_be(player_xpos_addr)
file=io.open(string.format('angle_drop_mm_%02X_%08X.txt', form, starting_xpos),'w')

angle = 0x0000
while angle < 0x10000 do
    savestate.loadslot(6)
    mainmemory.write_u16_be(player_angle_addr,angle)
    held_actor = mainmemory.read_u32_be(held_actor_addr)
    for i=1,4 do
        joypad.set({["P1 A"]=true})
        emu.frameadvance()
    end
    for i=1,7 do
        emu.frameadvance()
    end
    resulting_xpos = mainmemory.read_u32_be(held_actor-0x80000000+0x24)
    print(string.format("form=%02X, starting_xpos=%08X, angle=%04X, resulting_xpos=%08X", form, starting_xpos, angle, resulting_xpos))
    file:write(string.format("form=%02X, starting_xpos=%08X, angle=%04X, resulting_xpos=%08X\n", form, starting_xpos, angle, resulting_xpos))
    angle = angle + 0x10

end

file:close()