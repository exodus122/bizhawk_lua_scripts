while true do
  for i=0,1 do
    obj = mainmemory.read_u32_be(0x383CE0 + 4*i)
	--print(i..". "..string.format("%06X: %04X, %06X, %06X", 0x383CE0 + 4*i, obj, mainmemory.read_u32_be(obj-0x80000000 + 4), obj+0x10))
    if mainmemory.read_u32_be(obj-0x80000000 + 4) ~= obj+0x10 then
      print("shits broke")
    end
  end
  emu.frameadvance()
end