-- oot_triple_slash_clip_brute_force.lua
--
-- Brute force search for triple slash clip angles
-- Used for Ocarina of Time NTSC 1.0
--
-- Author: Exodus
-- Created: June 1st, 2022
 
function hexTranslator(result)
  if result >= 16 then
    local intQuotient = math.floor(result / 16)
    local remainder = result % 16
    return hexTranslator(intQuotient) .. hexTranslator(remainder)
  else
    if result == 10 then
      io.write("A")
      return "A"
    elseif result == 11 then
      io.write("B")
      return "B" 
    elseif result == 12 then
      io.write("C")
      return "C"
    elseif result == 13 then
      io.write("D")
      return "D"
    elseif result == 14 then
      io.write("E")
      return "E"
    elseif result == 15 then
      io.write("F")
      return "F"
    else
      io.write(result)
      return tostring(result)
    end
  end
end
 
-- Constants
X_ADDR = 0x1DAA54
Y_ADDR = 0x1DAA58
Z_ADDR = 0x1DAA5C
ANGLE_ADDR = 0x1DAAE6
ANIM_ADDR = 0x1DABDE
C_LEFT_ADDR = 0x11A639
bow = 3
slingshot = 6
hookshot = 10
boomerang = 14
itemNames = {}
itemNames[3] = "bow  "
itemNames[6] = "sling"
itemNames[10] = "hook "
itemNames[14] = "rang "
 
function attemptTSC(angle, frameNum, item)
    -- Load state
    savestate.loadslot(2)
    
    -- Read starting coords
    xpos1 = mainmemory.readfloat(X_ADDR, true)
    ypos1 = mainmemory.readfloat(Y_ADDR, true)
    zpos1 = mainmemory.readfloat(Z_ADDR, true)
    -- print("START: "..xpos.." "..ypos.." "..zpos)
    
    -- Set Angle and C-Left item
    mainmemory.write_u16_be(ANGLE_ADDR, math.fmod(angle, 0x10000))
    mainmemory.write_s8(C_LEFT_ADDR, item)
   
    -- Attempt Triple Slash clip
    repeat -- press b every other frame until link performs a triple slash
        joypad.set({["B"] = true}, 1)
        emu.frameadvance()
        joypad.set({["B"] = false}, 1)
        emu.frameadvance()
    until (mainmemory.read_u16_be(ANIM_ADDR) == 0x2978)
    
    for f=0,(frameNum*3 + 22) do -- start holding Z
        joypad.set({["Z"] = true}, 1)
        emu.frameadvance()
    end
    
    for f=0,30 do -- pull first person item
        joypad.set({["Z"] = true, ["C Left"] = true}, 1)
        emu.frameadvance()
    end
    
    -- Read ending coords
    xpos2 = mainmemory.readfloat(X_ADDR, true)
    ypos2 = mainmemory.readfloat(Y_ADDR, true)
    zpos2 = mainmemory.readfloat(Z_ADDR, true)
    
    xzDistance = math.floor(math.sqrt((xpos2 - xpos1)^2 + (zpos2 - zpos1)^2) * 100) / 100
    yDistance = math.floor((ypos2 - ypos1) * 100) / 100
    
    if xzDistance > 10 then
        CLIPPED = true
        
        --print(hexTranslator(math.fmod(angle, 0x10000)).." - xz ("..xzDistance.."), y ("..yDistance..")") 
        if yDistance < -20 then
            print(hexTranslator(math.fmod(angle, 0x10000)).." ("..itemNames[item]..", "..frameNum..") - Fall ("..xzDistance..")")
        else
            print(hexTranslator(math.fmod(angle, 0x10000)).." ("..itemNames[item]..", "..frameNum..") - Clip ("..xzDistance..")")
        end
    end
end

START_ANGLE = 0x1E1C
END_ANGLE = 0x1E1C
if END_ANGLE < START_ANGLE then
    END_ANGLE = END_ANGLE + 0x10000
end
 
CLIPPED = false
print("START: "..hexTranslator(START_ANGLE)..", END: "..hexTranslator(END_ANGLE))
 
for angle = START_ANGLE, END_ANGLE, 0x10 do
    attemptTSC(angle, 1, hookshot)
    attemptTSC(angle, 2, hookshot)
    attemptTSC(angle, 3, hookshot)
    attemptTSC(angle, 4, hookshot)
    attemptTSC(angle, 1, bow)
    attemptTSC(angle, 2, bow)
    attemptTSC(angle, 3, bow)
    attemptTSC(angle, 4, bow)
end
 
if CLIPPED == false then
    print("failed to find anything")
end
 
print("DONE!")