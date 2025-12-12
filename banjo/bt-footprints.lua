console.clear()

next_entrance = 0x127640 -- u16
transition_trigger = 0x127642 -- u16, set to 257 to load a scene
previous_entrance = 0x132DC2 -- u16
next_character = 0x12704C -- byte, lock to switch characters
current_character = 0x136F63 -- byte

health_bk = 0x11B644 -- byte
health_solo_k = 0x11B662 -- byte

player_pointer = 0x135490 -- u32
player_pointer_index = 0x1354DF -- byte

playerPointerIndex = mainmemory.readbyte(player_pointer_index)
player = (mainmemory.read_u32_be(player_pointer) + 4 * playerPointerIndex) - 0x80000000
posX = mainmemory.readfloat(player + 0x724, true)
posY = mainmemory.readfloat(player + 0x728, true)
posZ = mainmemory.readfloat(player + 0x72C, true)
linear_velocity = mainmemory.readfloat(player + 0xA38, true)
facing_angle = mainmemory.readfloat(player + 0xC08, true)
movement_angle = mainmemory.readfloat(player + 0xC0C, true)
claw_clamber_posX = mainmemory.readfloat(player + 0x5EC, true)
claw_clamber_posY = mainmemory.readfloat(player + 0x5F0, true)
claw_clamber_posZ = mainmemory.readfloat(player + 0x5F4, true)
healthSoloK = mainmemory.readbyte(health_solo_k)

--[[print("playerPointerIndex: "..playerPointerIndex)
print(string.format("player: 0x%06X", player))
print("pos: "..posX..", "..posY..", "..posZ)
print("claw_clamber_pos: "..claw_clamber_posX..", "..claw_clamber_posY..", "..claw_clamber_posZ)

print("linear_velocity: "..linear_velocity)
print("facing_angle: "..facing_angle)
print("movement_angle: "..movement_angle)
print("healthSoloK: "..healthSoloK)]]--

-- string.format("%06X", )
hold_r = true


function attemptClip(diag_x, diag_y, right_x, right_y, right_start, jump1_start, jump1_end, jump2_start)
	
	stick_inputs_x = {}
	stick_inputs_y = {}
	a_inputs = {}
	
	-- Load state
    savestate.loadslot(2)
	
	i = 0
	repeat
		if i < right_start then -- holding up-right
			joypad.setanalog({
				['P1 X Axis'] = diag_x,
				['P1 Y Axis'] = diag_y,
			})
			
			if hold_r then
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
			else
				emu.frameadvance()
				emu.frameadvance()
				emu.frameadvance()
			end
			
		elseif i < right_start + jump1_start then -- holding right
			joypad.setanalog({
				['P1 X Axis'] = right_x,
				['P1 Y Axis'] = right_y,
			})
			
			if hold_r then
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
			else
				emu.frameadvance()
				emu.frameadvance()
				emu.frameadvance()
			end
		elseif i < right_start + jump1_start + jump1_end then
			--print("here")
			if hold_r and false then
				joypad.set({["A"] = true, ["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true, ["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true, ["R"] = true}, 1)
				emu.frameadvance()
			else
				joypad.set({["A"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true}, 1)
				emu.frameadvance()
			end
		elseif i < right_start + jump1_start + jump1_end + jump2_start then
			if hold_r and false then
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
			else
				emu.frameadvance()
				emu.frameadvance()
				emu.frameadvance()
			end
		elseif i < right_start + jump1_start + jump1_end + jump2_start + 10 then
			if hold_r and false then
				joypad.set({["A"] = true, ["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true, ["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true, ["R"] = true}, 1)
				emu.frameadvance()
			else
				joypad.set({["A"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true}, 1)
				emu.frameadvance()
				joypad.set({["A"] = true}, 1)
				emu.frameadvance()
			end
		else
			if i == right_start + jump2_start + jump1_end + 10 + 15 then
				--check if loading an area. if so, you clipped
				if mainmemory.read_u16_be(transition_trigger) == 257 then
					print("clipped!")
					print("diag_x: "..tostring(diag_x))
					print("diag_y: "..tostring(diag_y))
					print("right_x: "..tostring(right_x))
					print("right_y: "..tostring(right_y))
					print("right_start: "..tostring(right_start))
					print("jump1_start: "..tostring(jump1_start))
					print("jump1_end: "..tostring(jump1_end))
					print("jump2_start: "..tostring(jump2_start))
					returnVal = true
				else
					--print("clip failed!")
					--print(string.format("clipped failed! - diag_x: %d, diag_y: %d, right_x: %d, right_y: %d, right_start: %d, jump1_start: %d, jump1_end: %d, jump2_start: %d", diag_x, diag_y, right_x, right_y, right_start, jump1_start, jump1_end, jump2_start))
					returnVal = false
				end
			end
			
			if hold_r and false then
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
				joypad.set({["R"] = true}, 1)
				emu.frameadvance()
			else
				emu.frameadvance()
				emu.frameadvance()
				emu.frameadvance()
			end
		end
		
		if mainmemory.readbyte(health_solo_k) == 1 then
			--print(string.format("damaged - diag_x: %d, diag_y: %d, right_x: %d, right_y: %d, right_start: %d, jump1_start: %d, jump1_end: %d, jump2_start: %d", diag_x, diag_y, right_x, right_y, right_start, jump1_start, jump1_end, jump2_start))
			-- reset analog position
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			break
		end
		
		i = i + 1
		
	until i == right_start + jump2_start + jump1_end + 10 + 15 + 2
	
	return returnVal
end

--[[
diag_vals = {48, 112
49, 112
51, 112
52, 110
54, 110
55, 110
56, 109
58, 109
59, 106
61, 106
62, 108
64, 108
65, 108
66, 108
68, 106
69, 105
71, 105
72, 103
73, 103
75, 102
77, 100
78, 99
79, 98
80, 98
81, 97
82, 96
83, 95
84, 94
85, 94
86, 93
87, 91
88, 91
89, 89
90, 89
91, 88
92, 87
93, 86
94, 85
95, 82
96, 82
97, 81
98, 79
99, 78
100, 76
99, 72}
]]--
--[[ original attempt
diag_vals = {48, 112, 49, 112, 51, 112, 52, 110, 54, 110, 55, 110, 56, 109, 58, 109, 59, 106, 61, 106, 62, 108, 64, 108, 65, 108, 66, 108, 68, 106, 69, 105, 71, 105, 72, 103, 73, 103, 75, 102, 77, 100, 78, 99, 79, 98, 80, 98, 81, 97, 82, 96, 83, 95, 84, 94, 85, 94, 86, 93, 87, 91, 88, 91, 89, 89, 90, 89, 91, 88, 92, 87, 93, 86, 94, 85, 95, 82, 96, 82, 97, 81, 98, 79, 99, 78, 100, 76, 99, 72}
right_vals = {0, -1, 1, -2, 2, -3, 3, -4, 4, -5, 5, -6, 6, -7, 7, -8, 8, -9, 9, -10, 10}

right_start = 30
jump1_start = 32
jump1_end = 60
jump2_start = 65

for count = 1,45,1 do

	for j = 1,23,1 do
]]--

event.onexit(function()
	joypad.setanalog({
		['P1 X Axis'] = "",
		['P1 Y Axis'] = "",
	})
end)

--
diag_vals = {59, 106, 61, 106, 62, 108, 64, 108, 65, 108, 66, 108, 68, 106, 69, 105, 71, 105, 72, 103, 73, 103, 75, 102, 77, 100, 78, 99, 79, 98, 80, 98, 81, 97, 82, 96, 83, 95, 84, 94, 85, 94, 86, 93, 87, 91, 88, 91, 89, 89, 90, 89, 91, 88, 92, 87, 93, 86, 94, 85, 95, 82, 96, 82, 97, 81, 98, 79, 99, 78, 100, 76, 99, 72}
--
right_vals = {0, -1, 1, -2, 2, -3, 3, -4, 4, -5, 5, -6, 6, -7, 7, -8, 8, -9, 9, -10, 10}

function iterate_old()

	

	--diag_vals = {59, 106}
	--right_vals = {0}

	right_start = 30
	jump1_start = 2
	jump1_end = 28
	jump2_start = 2
	
	for diag_index = 1,(#diag_vals)/2,1 do

		diag_x = diag_vals[(diag_index*2)]
		diag_y = diag_vals[diag_index*2-1]
		--print(diag_x..", "..diag_y)
		
		for right_index = 1,#right_vals,1 do
			
			right_x = 127
			right_y = right_vals[right_index]
			
			--print(right_x..", "..right_y)
			
			--[[for right_start = 29,33,1 do
				for jump1_start = 2,4,1 do
					for jump1_end = 26,31,1 do
						for jump2_start = 1,5,1 do]]--
							
							--foundClip = attemptClip(diag_x, diag_y, right_x, right_y, right_start, jump1_start, jump1_end, jump2_start)
							foundClip = attemptClip(diag_x, diag_y, right_x, right_y, right_start, jump1_start, jump1_end, jump2_start)
											
							-- reset analog position
							joypad.setanalog({
								['P1 X Axis'] = "",
								['P1 Y Axis'] = "",
							})
							
							if foundClip == true then
								break
							end
						--[[end
					end
				end
			end]]--
			
			--print("diag: "..diag_vals[(diag_index*2)]..", "..diag_vals[diag_index*2-1]..", right_y done: "..right_y)
		end
		console.clear()
	end
end

function random_try()
	while true do
		
		diag_index = math.random(1, (#diag_vals)/2)
		right_index = math.random(1, #right_vals)
		
		diag_x = diag_vals[(diag_index*2)]
		diag_y = diag_vals[diag_index*2-1]
		right_x = 127
		right_y = right_vals[right_index]
		right_start = math.random(28, 30)
		jump1_start = math.random(2, 3)
		jump1_end = math.random(28, 33)
		jump2_start = math.random(1, 8)
		
		foundClip = attemptClip(diag_x, diag_y, right_x, right_y, right_start, jump1_start, jump1_end, jump2_start)
		
		joypad.setanalog({
			['P1 X Axis'] = "",
			['P1 Y Axis'] = "",
		})
		
		if foundClip == true then
			break
		end
	end
end

math.randomseed(os.time())
math.random()
--print(math.random(1, 10))
--print(math.random(1, 10))

--iterate_old()

random_try()