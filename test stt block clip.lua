
-- MM
LINEAR_VELOCITY = 0x400880 -- float
ANGLE = 0x3FFE6E -- short
MOVEMENT_ANGLE = 0x400884
ISG = 0x40088B -- byte

X_COORD = 0x3FFDD4
Y_COORD = 0x3FFDD8
Z_COORD = 0x3FFDDC
FLOOR_POLY = 0x3FFE30

-- OoT
--[[LINEAR_VELOCITY = 0x1DB258 -- float
ANGLE = 0x1DAAE6 -- short
ISG = 0x1DB263 -- byte
]]--

console.clear()

start_angle = 0x2B00
end_angle = 0x1A00


start_angle = 0xA000
end_angle = 0x9D00

start_angle = 0x7400
end_angle = 0x5900


start_angle = 0xE800
end_angle = 0xD800

start_angle = 0xF600
end_angle = 0xEC00



--start_angle = 0x6000
--end_angle = 0x5800

--j = 10.0
--while j < 20.0 do
	i = start_angle
	while i >= end_angle do
		
		k = 0
		while k < 3 do
			mainmemory.writefloat(Y_VELOCITY, -4, true)
			mainmemory.writefloat(LINEAR_VELOCITY, 0.0, true)
			mainmemory.writefloat(X_COORD, -1432.545, true)
			mainmemory.writefloat(Y_COORD, -9.392835, true)
			mainmemory.writefloat(Z_COORD, 419.6534, true)
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			k = k + 1
			
			--[[ 
			default: clips with 480,470
			mainmemory.writefloat(X_COORD, -1432.61, true)
			mainmemory.writefloat(Y_COORD, -9.42969, true)
			mainmemory.writefloat(Z_COORD, 419.6203, true)
			
			.01 linear velocity: clips with 480,470,460
			mainmemory.writefloat(X_COORD, -1432.605, true)
			mainmemory.writefloat(Y_COORD, -9.426135, true)
			mainmemory.writefloat(Z_COORD, 419.6276, true)
			
			.015 linear velocity: clips with 480,470,460 -- these coords with angle 480 clips with 9.7 speed (LOWEST SO FAR)
			mainmemory.writefloat(X_COORD, -1432.602, true)
			mainmemory.writefloat(Y_COORD, -9.424289, true)
			mainmemory.writefloat(Z_COORD, 419.6291, true)
			
			.02 linear velocity: clips with 480,470,460
			mainmemory.writefloat(X_COORD, -1432.599, true)
			mainmemory.writefloat(Y_COORD, -9.422442, true)
			mainmemory.writefloat(Z_COORD, 419.6304, true)
			
			.03 linear velocity: clips with 470,460
			mainmemory.writefloat(X_COORD, -1432.592, true)
			mainmemory.writefloat(Y_COORD, -9.41875, true)
			mainmemory.writefloat(Z_COORD, 419.6333, true)
			
			.04 linear velocity: clips with 470,460,450 -- these coords with angle 470 clips with 9.8 speed
			mainmemory.writefloat(X_COORD, -1432.585, true)
			mainmemory.writefloat(Y_COORD, -9.414989, true)
			mainmemory.writefloat(Z_COORD, 419.6362, true)
			
			.05 linear velocity: clips with  -- these coords with angle 470 clips with 9.7 speed (LOWEST SO FAR)
			mainmemory.writefloat(X_COORD, -1432.578, true)
			mainmemory.writefloat(Y_COORD, -9.411297, true)
			mainmemory.writefloat(Z_COORD, 419.639, true)
			
			.05 linear velocity: clips with 470,460,450 -- these coords with angle 470 clips with 9.7 speed (LOWEST SO FAR)
			mainmemory.writefloat(X_COORD, -1432.572, true)
			mainmemory.writefloat(Y_COORD, -9.407673, true)
			mainmemory.writefloat(Z_COORD, 419.6419, true)
			
			.07 linear velocity: clips with  -- these coords with angle 460 clips with 9.8 speed
			mainmemory.writefloat(X_COORD, -1432.565, true)
			mainmemory.writefloat(Y_COORD, -9.403912, true)
			mainmemory.writefloat(Z_COORD, 419.6448, true)
			
			]]--
		end
		
		mainmemory.write_u16_be(ANGLE, i)
		mainmemory.write_u16_be(MOVEMENT_ANGLE, i)
		mainmemory.writefloat(LINEAR_VELOCITY, 18, true)
		--mainmemory.writefloat(LINEAR_VELOCITY, 13.589099635, true)
		--mainmemory.write_u8(ISG, 1)
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
			print("clipped! "..string.format("0x%x", i))
		end
		
		--[[joypad.set({["Z"] = true}, 1)
		emu.frameadvance()
		joypad.set({["Z"] = true}, 1)
		emu.frameadvance()
		joypad.set({["Z"] = true}, 1)
		emu.frameadvance()
		
		k = 0
		while k < 10 do
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			
			k = k + 1
		end
		
		joypad.setanalog({
			['P1 X Axis'] = 0,
			['P1 Y Axis'] = 127,
		})
		
		k = 0
		while k < 20 do
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			if k == 12 then
				joypad.set({["Z"] = true; ["C Right"] = true}, 1)
				emu.frameadvance()
				joypad.set({["Z"] = true; ["C Right"] = true}, 1)
				emu.frameadvance()
				joypad.set({["Z"] = true; ["C Right"] = true}, 1)
				emu.frameadvance()
			end
			k = k + 1
		end
		
		joypad.setanalog({
			['P1 X Axis'] = 0,
			['P1 Y Axis'] = 0,
		})
		
		k = 0
		while k < 10 do
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			joypad.set({["Z"] = true}, 1)
			emu.frameadvance()
			
			k = k + 1
		end
		
		if mainmemory.readfloat(Z_COORD, true) < -640 then
			print("clipped! "..string.format("0x%x", i))
		end]]--
		
		
		--[[mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 5, true)
		
		]]--
		
		--[[mainmemory.writefloat(LINEAR_VELOCITY, j, true)
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, j, true)
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, j, true)
		emu.frameadvance()]]--
		
		
		--[[emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 0.0, true)
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 0.0, true)
		emu.frameadvance()
		mainmemory.writefloat(LINEAR_VELOCITY, 0.0, true)]]--
		i = i - 16
	end
	
	--j = j + 0.5
--end

-- 5F10 works to clip on right side block like the zora clip as human

--[[
right side sun block clip speeds

human/deku with 10.95ish-13.15ish speed
zora with 14.70ish-16.95ish speed
goron can clip with 16.1ish-18.35ish speed
fd with 23.2ish-25.40ish speed

backwalk pot push works as human (gives up to 14ish speed, or down to 11.8ish)
]]--

--[[
Form wallCheckRadius and ceilingCheckHeight:

form 0: fd
radius: 27.0
height: 84.0

form 1: goron
radius: 19.5
height: 70.0

form 2: zora / adult oot
radius: 18.0
height: 56.0

form 3: deku
radius: 14.0
height: 35.0

form 4: human mm / child oot
radius: 14.0
height: 40.0
]]--

--[[
--- OLD INACCURATE SPEEDS (using non col coords) ---
slash distances / speeds
lunge 1h slash: 19.115864406299 / 12.74 -- WRONG
lunge 1h stab: 18.139496492461 / 12.09 -- WRONG
lunge 2h slash: 16.957117679606 / 11.30 -- WRONG
lunge 2h stab: 23.621119469661 / 15.74 -- WRONG

lunge 2h stab (FULL): 31.116201280362 / 20.74 -- not a real speed value, just total distance traveled




--- NEW ACCURATE SPEEDS 1/12/25 (using col coords) ---

human backwalk pot push: 17.823872783433 / 11.88 (stt test angle 0?)
alt pot push test: 17.215179757412 / 11.4767 (test wft angle not near wall)
alt pot push test: 18.5187 / 12.34 (actual clip)
human forward walk pot push: 12.3587 / 8.2391


wft pot push with wft clip angle: gives 1 frame of 11.7945473805 speed

pot push as human seems to work like a 14 speed push for some reason


POT PUSH DECOMP VALS (HUMAN):
displacement from pot (when near wall wft) 8.9765493952533
total displacement from pot and velocity (when near wall) 21.079978120112 (speed: 14.0533187467)
displacement from pot (when NOT near wall) 5.9468705621005
total displacement from pot and velocity (when NOT near wall) 18.31469808945 (speed: 12.2097987263)

oot: (these are untested, especially angles make be wrong as far as positive/negative)
child lunge 1h slash: 1 frame of  speed at angle 
child lunge 1h stab: 1 frame of  speed at angle 
child lunge 2h slash: 1 frame of -3.74964294596 speed at angle 0x0A2D, then 1 frame of 11.0235565949 speed at angle -0x0108 (should be same as adult oops)
child lunge 2h stab: 1 frame of  speed at angle , then 1 frame of  speed at angle 
adult lunge 1h slash: 1 frame of -7.26050197224 speed at angle -x0866 (F79A), then 1 frame of 14.2290126151 speed at angle -0x0361
adult lunge 1h stab: 1 frame of -7.626902677 speed at angle -0x0052 (FFAA), then 1 frame of 11.2739719906 speed at angle -0x006F
adult lunge 2h slash: 1 frame of -3.71752008139 speed at angle 0x08B0, then 1 frame of 11.0235565949 speed at angle -0x0108
adult lunge 2h stab: 1 frame of 7.56142255869 speed at angle -0x00CA, then 1 frame of 15.5509499531 speed at angle -0x01F0
adult jumpslash: 1 frame of 5 speed, then 4.9, then 4.8, then 4.7, then  4.6, then 4.5, then 4.4, then 4.3, then 4.3, then 18.1866666667, then -0.28, ...

mm:
lunge 1h slash: 1 frame of 12.727577652 speed at angle -0x271
lunge 1h stab: 1 frame of 10.824276255 speed at angle -0x004A
lunge 2h slash: 1 frame of 10.6615421857 speed at angle -0x00B1
lunge 2h stab: 1 frame of 13.589099635 speed at angle +0x16F, then 1 frame of 7.15487091273 speed at angle +0x127 -- CORRECT (slightly off)

zora punch: 1 frame of 12.0003703647 speed at angle -0x01F2
zora fins clip thing: 64.43 / 42.9533333333 - only seems to work if ground is there (like slashes)

goron punch combo: 32.146 distance / 21.4306666667 speed

(need about -1230.5, -789.5, angle DF30)
-1226.793, -793.0674

damage: 22.5 / 15
HESS/superslide: 27 / 18
megaflip: 17.95, 17.90, 17.85, 17.80, 17.75, 17.70, 17.65, 16.65, 8.65, 8.65, 6.65, 4.65, 2.65, 0.65
shield damage (crouch or not): 10
crouch stab (wall or crouch stab armos non-enemy): -14
crouch stab stick on armos ENEMY: -18 (should work on other enemies, such as knuckles?)
weirdslide: 16, 14, 12, 10, 8, 6, 4, 2

human:
sidehop starts at 8.5 and decreases
backwalk 8.25
roll 8.25
run 5.5
backflip 6

deku
sidehop starts at 8.5 and decreases
backwalk 9
run/backflip 6
run+spin 9.94
backwalk+spin 10.34ish (verify?)

goron
sidehop starts at 8.5 and decreases
backwalk 9
run/backflip 6
roll (nonmagic) 15.6

zora
sidehop starts at 8.5 and decreases
backwalk 9
run/backflip 6
roll 9

]]--

--[[
wft pillar clip:
with one frame 15.74 speed, angle 0x7000 clips
pot push backwalk (11.88) clips? - ehh

bomb holding clip with angle 5c4B works (down to 5450 also works) - inconsistent due to breathing animation

]]--

--[[
-1100
-1300

-1100
-1300

-1099.282 (-1100)
-1294.629 (-1300)

-1098.978 (-1099.282)
-1276.401 (-1279.629)

-1098.978 (-1098.978)
-1268.901 (-1268.901)

lunge gfs: figure out the angle and speed of each of the 3 frames of movement
also whether it uses collision or normal coords

normal coords:
frame 1: 5.4187789214915 (3.61251928099) angle 0x056A (E5AA)
frame 2: 18.230534824848 (12.1536898832) angle 0x00AD (E0ED)
frame 3: 7.5 (5) angle 0 (E040)

collision coords:
frame 1: 0 (0)
frame 2: 20.383649452441 (13.589099635) angle 0x16F (E1AF) --- THIS!!!
frame 3: 10.732306369089 (7.15487091273) angle 0x127 (E167)


how I calculated the speeds pretty accurately:
use this site for 2d distance formula: https://www.calculator.net/distance-calculator.html
distance is the distance traveled. multiply by 2/3 for the speed
then take the absolute value of that theta angle and put in this formula: (1-(x/90))*16384
then put that number in hex calc to get the hex equivalent. 
if that theta was negative, then add a negative to the final value.
]]--

--[[
pot push find exact speed and angle:

543.25
-570.5622

530.875
-570.5622

518.5
-570.5622

500.6467
-570.5622



635.4599
-564.6173



frame before push col coords: 676, -628.2766 (velocity 8.085659)
frame after push col coords: 676, -646.7953 (velocity 6.7023)
]]--

--[[


]]--

--[[
oot dot clip speeds

adult 15.15-18.30  (18 body) also 11-13 with multiple frames of speed???
child 11.50-14.25  (14 body)


]]--

--[[
dot skip child

with lunge storage
-104.0145 x
1085.298 z
32.1636 velocity xz (camera variable)

-89.78556
1085.683
14.23411

not finished...




without lunge storage
-104.0145
1085.298
32.1636

-89.78556
1085.683
14.23411

not finished...


]]--