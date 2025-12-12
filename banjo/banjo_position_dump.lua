X_COORD = mainmemory.readfloat(0x37C5A0, true)
Y_COORD = mainmemory.readfloat(0x37C5A4, true)
Z_COORD = mainmemory.readfloat(0x37C5A8, true)

NEXT_X_COORD = mainmemory.readfloat(0x37C4A8, true)
NEXT_Y_COORD = mainmemory.readfloat(0x37C4AC, true)
NEXT_Z_COORD = mainmemory.readfloat(0x37C4B0, true)

X_VEL = mainmemory.readfloat(0x37C4B8, true)
Y_VEL = mainmemory.readfloat(0x37C4BC, true)
Z_VEL = mainmemory.readfloat(0x37C4C0, true)
LINEAR_VEL = mainmemory.readfloat(0x37C4F0, true)
GRAVITY = mainmemory.readfloat(0x37C4E8, true)

FACING_ANGLE = mainmemory.readfloat(0x37C690, true)
MOVING_ANGLE = mainmemory.readfloat(0x37C694, true)

DELTA_X = mainmemory.readfloat(0x37C4D8, true)
DELTA_Y = mainmemory.readfloat(0x37C4DC, true)
DELTA_Z = mainmemory.readfloat(0x37C4E0, true)

print("pos: ("..X_COORD..", "..Y_COORD..", "..Z_COORD.."), nextpos: ("..NEXT_X_COORD..", "..NEXT_Y_COORD..", "..NEXT_Z_COORD.."), delta: ("..DELTA_X..", "..DELTA_Y..", "..DELTA_Z.."), vel: ("..X_VEL..", "..Y_VEL..", "..Z_VEL.."), ang: "..FACING_ANGLE..", movAng: "..MOVING_ANGLE..", linVel: "..LINEAR_VEL..", gra: "..GRAVITY)