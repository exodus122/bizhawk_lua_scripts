
--[[

// oot floor properties
typedef enum FloorProperty {
    /*  0 */ FLOOR_PROPERTY_0, // default, no effect
    /*  5 */ FLOOR_PROPERTY_5 = 5, // out to entrance ?
    /*  6 */ FLOOR_PROPERTY_6, // ? also disables jumping? slippery slope ledge grab related?
    /*  7 */ FLOOR_PROPERTY_7, // chamber of sages only, allows hovering without isg (revert xyz position AND set speed to 0, instead of falling/jumping/etc)
    /*  8 */ FLOOR_PROPERTY_8, // weird walking in air thing, revert x+z position to prev position (Spirit Temple, Bowling, Shooting Gallery)
    /*  9 */ FLOOR_PROPERTY_9, // disable jumping from this poly
    /* 11 */ FLOOR_PROPERTY_11 = 11, // dive off
    /* 12 */ FLOOR_PROPERTY_12 // plane back to entrance
} FloorProperty;

typedef enum FloorType {
    /*  0 */ FLOOR_TYPE_0,  // default, no effect
    /*  1 */ FLOOR_TYPE_1,  // sand or grass (Kokiri, LW, SFM, Colossus, Wasteland)
    /*  2 */ FLOOR_TYPE_2,  // various scenes, does soemthing to some actors
    /*  3 */ FLOOR_TYPE_3,  // lava surface (KD, Volv, Ganon's Tower, Ganon's Tower (Collapsing), Bongo, Fire Temple, Lava)
    /*  4 */ FLOOR_TYPE_4,  // sandy surface (Spot 13 - Haunted Wasteland, Spot 11 - Desert Colossus, Gerudo Training Ground, Spirit Temple
    /*  5 */ FLOOR_TYPE_5,  // icy surface (Ice cavern, Fountain, etc)
    /*  6 */ FLOOR_TYPE_6,  // used by some objects (fire temple pillars, bongo drums, spirit temple lift, deku webs)
							// Inside Jabu-Jabu's Belly, Forest Temple, King Dodongo's Lair, many more
    /*  7 */ FLOOR_TYPE_7,  // Spot 13 - Haunted Wasteland (also blocks epona, does something with spawning leevers)
    /*  8 */ FLOOR_TYPE_8,  // Barinade's Lair, Inside Jabu-Jabu's Belly
    /*  9 */ FLOOR_TYPE_9,  // Inside Ganon's Castle, Gerudo Training Ground, Morpha's Lair, Ganon's Castle Exterior, Spot 17 - Death Mountain Crater (kills bubbles, torch slugs, stalfos, damages link)
    /* 10 */ FLOOR_TYPE_10, // Dampé's Grave & Windmill (maybe exit pad?)
    /* 11 */ FLOOR_TYPE_11, // Grave (Redead), Grave (Fairy's Fountain), Royal Family's Tomb, Grottos, Fairy's Fountain (i think its the exit pad)
    /* 12 */ FLOOR_TYPE_12  // spawning leevers related, Spot 13 - Haunted Wasteland
} FloorType;

#define WALL_FLAG_0 (1 << 0) // ladder
#define WALL_FLAG_1 (1 << 1) // ladder
#define WALL_FLAG_2 (1 << 2)
#define WALL_FLAG_3 (1 << 3)
#define WALL_FLAG_CRAWLSPACE_1 (1 << 4)
#define WALL_FLAG_CRAWLSPACE_2 (1 << 5)
#define WALL_FLAG_6 (1 << 6)
#define WALL_FLAG_CRAWLSPACE (WALL_FLAG_CRAWLSPACE_1 | WALL_FLAG_CRAWLSPACE_2)

D_80119D90[WALL_TYPE_MAX] = {
    0,                         // WALL_TYPE_0
    WALL_FLAG_0,               // WALL_TYPE_1
    WALL_FLAG_0 | WALL_FLAG_1, // WALL_TYPE_2 // ladder
    WALL_FLAG_0 | WALL_FLAG_2, // WALL_TYPE_3
    WALL_FLAG_3,               // WALL_TYPE_4
    WALL_FLAG_CRAWLSPACE_1,    // WALL_TYPE_5
    WALL_FLAG_CRAWLSPACE_2,    // WALL_TYPE_6
    WALL_FLAG_6,               // WALL_TYPE_7
};

typedef enum WallType {
    /*  0 */ WALL_TYPE_0,
    /*  1 */ WALL_TYPE_1,
    /*  2 */ WALL_TYPE_2,
    /*  3 */ WALL_TYPE_3,
    /*  4 */ WALL_TYPE_4,
    /*  5 */ WALL_TYPE_5,
    /*  6 */ WALL_TYPE_6,
    /*  7 */ WALL_TYPE_7,
    /*  8 */ WALL_TYPE_8,
    /*  9 */ WALL_TYPE_9,
    /* 10 */ WALL_TYPE_10,
    /* 11 */ WALL_TYPE_11,
    /* 12 */ WALL_TYPE_12,
    /* 32 */ WALL_TYPE_MAX = 32
} WallType;


289

(1) #define BGCHECKFLAG_GROUND (1 << 0) // Standing on the ground
(2) #define BGCHECKFLAG_GROUND_TOUCH (1 << 1) // Has touched the ground (only active for 1 frame)
(4) #define BGCHECKFLAG_GROUND_LEAVE (1 << 2) // Has left the ground (only active for 1 frame)
(8) #define BGCHECKFLAG_WALL (1 << 3) // Touching a wall
(10) #define BGCHECKFLAG_CEILING (1 << 4) // Touching a ceiling
(20) #define BGCHECKFLAG_WATER (1 << 5) // In water
(40) #define BGCHECKFLAG_WATER_TOUCH (1 << 6) // Has touched water (reset when leaving water)
(80) #define BGCHECKFLAG_GROUND_STRICT (1 << 7) // Strictly on ground (BGCHECKFLAG_GROUND has some leeway)
(100) #define BGCHECKFLAG_CRUSHED (1 << 8) // Crushed between a floor and ceiling (triggers a for player)
(200) #define BGCHECKFLAG_PLAYER_WALL_INTERACT (1 << 9) // Only set/used by player, related to interacting with walls

#define UPDBGCHECKINFO_FLAG_0 (1 << 0) // check wall
#define UPDBGCHECKINFO_FLAG_1 (1 << 1) // check ceiling
#define UPDBGCHECKINFO_FLAG_2 (1 << 2) // check floor and water
#define UPDBGCHECKINFO_FLAG_3 (1 << 3) // kind of means apply -4 y velocity?
#define UPDBGCHECKINFO_FLAG_4 (1 << 4) // kind of means apply 0 y velocity (for in water i guess)
#define UPDBGCHECKINFO_FLAG_5 (1 << 5) // unused
#define UPDBGCHECKINFO_FLAG_6 (1 << 6) // disable water ripples
#define UPDBGCHECKINFO_FLAG_7 (1 << 7) // alternate wall check?


	# Player States
	
	stateFlags1
	
0	0x1 = Loading a new area
1	0x2 = Swinging Bottle
2	0x4 = Reached Hookshot target
3	0x8 = First Person Item in Hand
4	0x10 = Z-Targeting an Enemy
5	0x20 = Disable inputs player actor is seeing, can still pause (only used during Bongo Bongo intro cutscene)
6	0x40 = Talking/ checking/ showing item with text box
7	0x80 = Death (Zombie Walking, ignore loading zone in MM)
	
8	0x100 = Putting Away Item
9	0x200 = First Person Item Loaded
10	0x400 = Receiving Item / Get Item Manipulation
11	0x800 = Holding something over your head / Ground Jump
12	0x1000 = Charging Sword
13	0x2000 = Hanging from a ledge / Ledge Cancel (with Down on A)
14	0x4000 = Climbing to higher ground (or out of water) / Ledge Cancel
15	0x8000 = Z-Targeting
	
16	0x10000 = Z-Targeting something (or checking/ speaking to it)
17	0x20000 = Z-Targeting
18	0x40000 = Jumping/Hopping
19	0x80000 = Fell off a ledge without jumping?
20	0x100000 = First person view (C-up) / Return A
21	0x200000 = Climbing a ladder or vines / Down A
22	0x400000 = Shielding
23	0x800000 = Riding Epona
	
24	0x1000000 = Boomerang in hand
25	0x2000000 = Threw Boomerang (Fixed Camera)
26	0x4000000 = Blinking Red (took damage)
27	0x8000000 = Swimming
28	0x10000000 = Using Cutscene Item (beans, trade item, ocarina, bottle, etc.)
29	0x20000000 = Freeze all Actors (including Link) / (Unset this when a text box is on screen to cause "Walking While Talking" or crawlspace GID or fairy revival GID)
30	0x40000000 = unknown (messes up z-targeting when locked)
31	0x80000000 = Entering grotto (disable ground collision)
	
	stateFlags2
	
0	0x1 = Grab on A (for grabbing a pushable object)
1	0x2 = Speak/Check on A
2	0x4 = Climb on A (for climbing a block that you can also grab)
3	0x8 = Seems to randomly get set when you walk around
4	0x10 = ?
5	0x20 = Almost everything that moves you
6	0x40 = Hanging from Ledge / Climbing from hanging from ledge / Crawling in crawlspace / Leaving Crawlspace / Climbing Ladder / Climbing off ladder / Riding Epona / Dismounting Epona / grabbing something, etc
7	0x80 = ?
	
8	0x100 = ?
9	0x200 = ?
10	0x400 = Underwater / Get Item Delay
11	0x800 = Dive Meter on A
12	0x1000 = ?
13	0x2000 = Switch Targeting something
14	0x4000 = ?
15	0x8000 = Completely freezes Link
	
16	0x10000 = Enter on A (for crawlspaces)
17	0x20000 = Spin Attacking
18	0x40000 = In crawlspace / Blank A
19	0x80000 = Sidehopping / Backflipping
20	0x100000 = Navi is flying around
21	0x200000 = Navi is flashing on c-up
22	0x400000 = Down on A (while on Epona)
23	0x800000 = Green Navi
	
24	0x1000000 = ?
25	0x2000000 = ?
26	0x4000000 = Draw Link's reflection (used in Dark Link's room)
27	0x8000000 = Playing Ocarina (Freezes all actors except Link)
28	0x10000000 = Idle Animation
29	0x20000000 = Invisible (might be related to the invisibility glitches)
30	0x40000000 = ?
31	0x80000000 = Voiding out / Crushed

	stateFlags3

0	PLAYER_STATE3_0	0x1 = Link ignores floor, water, and ceiling collision (used for dark link falling through the floor when damage is dealt)
1	PLAYER_STATE3_1	0x2 = used for collision detection and correction. set by start of jumpslash, aerial damage, and some cutscene command
2	PLAYER_STATE3_2	0x4 = Dark Link jumping on Link's sword? (UNSET BY PLAYER, used for dark link?)
3	PLAYER_STATE3_3	0x8 = Set when you slash sword, but have not moved since
4	PLAYER_STATE3_4	0x10 = some collision flag thing
5	PLAYER_STATE3_5	0x20 = will pull ocarina for memory game
6	PLAYER_STATE3_RESTORE_NAYRUS_LOVE	0x40 = Set by ocarina effects actors when destroyed to signal Nayru's Love may be restored
7	PLAYER_STATE3_FLYING_WITH_HOOKSHOT	0x80 = Flying in the air with the hookshot as it pulls Player toward its destination

/* action funcs */
Player_Action_OwlSaveArrive
Player_Action_1
Player_Action_2
Player_Action_3 Z-targetting (also 3rd person aiming)
Player_Action_Idle (standing still)
Player_Action_5
Player_Action_6 Backwalk
Player_Action_7
Player_Action_8
Player_Action_9
Player_Action_TurnInPlace
Player_Action_11
Player_Action_12
Player_Action_13 Walk (includes slow slope walk)
Player_Action_14
Player_Action_15
Player_Action_16
Player_Action_17
Player_Action_18 Shielding
Player_Action_19
Player_Action_20
Player_Action_21
Player_Action_22
Player_Action_23
Player_Action_24
Player_Action_25 Aerial (Autojump / Backflip / sidehop / fall. NOT jumpslash)
Player_Action_26 Roll
Player_Action_27
Player_Action_28
Player_Action_29 Starting a Jumpslash (before sword hitbox)
Player_Action_30 Charging spin attack (without magic. idk if with magic is the same, but probably is)
Player_Action_31
Player_Action_32
Player_Action_33
Player_Action_WaitForPutAway
Player_Action_35 Opening door?
Player_Action_36
Player_Action_37
Player_Action_38
Player_Action_39
Player_Action_40
Player_Action_41
Player_Action_42
Player_Action_43 Aiming first person item
Player_Action_Talk (also to navi)
Player_Action_45
Player_Action_46
Player_Action_47
Player_Action_48 Hang from ledge with one hand
Player_Action_49 Climb up from hang from ledge with one hand
Player_Action_50
Player_Action_51
Player_Action_52
Player_Action_53
Player_Action_54
Player_Action_55
Player_Action_56
Player_Action_57
Player_Action_58
Player_Action_59
Player_Action_60
Player_Action_61
Player_Action_62
Player_Action_63
Player_Action_64
Player_Action_65
Player_Action_TimeTravelEnd
Player_Action_67
Player_Action_68
Player_Action_69
Player_Action_70
Player_Action_ExchangeItem
Player_Action_72
Player_Action_SlideOnSlope
Player_Action_WaitForCutscene
Player_Action_StartWarpSongArrive
Player_Action_BlueWarpArrive
Player_Action_77
Player_Action_TryOpeningDoor
Player_Action_ExitGrotto
Player_Action_80
Player_Action_81
Player_Action_82
Player_Action_83
Player_Action_84 Swing sword horizontal or vertical (also jumpslash sword active. also spin attack)
Player_Action_85 Recoil from torch?
Player_Action_86 Transforming
Player_Action_87 Transforming end part (which can be cancelled by holding a direction)
Player_Action_88
Player_Action_89
Player_Action_90
Player_Action_91
Player_Action_HookshotFly
Player_Action_93 Entering/In deku flower
Player_Action_94 Shooting out of deku flower / Flying as deku (also using nut while flying)
Player_Action_95 Deku spin
Player_Action_96
Player_Action_CsAction

(upperActionFunc)
Player_UpperAction_0
Player_UpperAction_1
Player_UpperAction_ChangeHeldItem
Player_UpperAction_3
Player_UpperAction_4
Player_UpperAction_5
Player_UpperAction_6
Player_UpperAction_7
Player_UpperAction_8 ??
Player_UpperAction_9
Player_UpperAction_CarryActor
Player_UpperAction_11
Player_UpperAction_12
Player_UpperAction_13
Player_UpperAction_14
Player_UpperAction_15
Player_UpperAction_16

Player_InitDefaultIA
Player_InitDekuStickIA
Player_InitBowOrDekuNutIA
Player_InitExplosiveIA
Player_InitHookshotIA
Player_InitZoraBoomerangIA

Player_ActionHandler_0
Player_ActionHandler_1
Player_ActionHandler_2
Player_ActionHandler_3
Player_ActionHandler_Talk
Player_ActionHandler_5
Player_ActionHandler_6
Player_ActionHandler_7
Player_ActionHandler_8
Player_ActionHandler_9
Player_ActionHandler_10
Player_ActionHandler_11
Player_ActionHandler_12
Player_ActionHandler_13
Player_ActionHandler_14


So hookslide is the game alternating between Player_Action_HookshotFly and Player_Action_25 (aerial) each frame.

Pulling hook or bow bottle is this action: Player_Action_43 Aiming first person item


Player_PostLimbDrawGameplay is where player.rightHandWorld AND Arms_Hook.world.pos + rot are updated. player.rightHandWorld gets updated as long as player->rightHandType == PLAYER_MODELTYPE_RH_HOOKSHOT. Arms_Hook.world.pos only gets updated if that AND held actor is not null. heldActor is null if you are shooting hook. notably, during remote hookshot state of walking around after drank milk, neither of these 2 update, so that is why the hook position stays where ti is, rather than get updated to where link is. ALSO, the hookshot is not DRAWN during this state, which prevents certain things from updating (1E0, collider, etc).

Arms_Hook unk1EC is previous frames starting position of the actor
unk1E0 is 

PostLimbDrawGameplay updates player.rightHandWorld AND Arms_Hook.world.pos based on that

func_80831194 (in Player_UpperAction_7 in Player_UpdateUpperBody upperActionFunc) is where hook's parent is set to null, and player's child is set to null, signalling hook actor to SHOOT. also, this is where player's heldActor is NULL (which prevents PostLimbDrawGameplay from updating hook worldpos, but it still updates rightHandPos). then in ArmsHook_Shoot, it may call ArmsHook_PullPlayer which will set player's parent to hook, and that causes player to run the Player_Action_HookshotFly action

- 1E0 is end of line test but it subtracts the prevFrameDifference each frame. 1E0 is UPDATED in Update, used in Update as the end of the line test, then updated AGAIN in Draw. Update happens before draw in a particular frame. (it is also initialized in init to world.pos)
- 1EC is the END of the line test from the previous frame (at the end of update, 1EC gets set to the value of 1E0, so essentially, 1EC is the previous frame's value for 1E0. 1EC is used along with 1E0 to dtermine the START of the line test for current frame)
- sp60 is beginning of line test (1EC - (1E0 - 1EC))



BgCheck_CheckLineImpl(colCtx, COLPOLY_IGNORE_ENTITY, COLPOLY_IGNORE_NONE, posA, posB, posResult, outPoly,
                                 bgId, NULL, 1.0f,
                                 BgCheck_GetBccFlags(checkWall, checkFloor, checkCeil, checkOneFace, true));
BgCheck_CheckLineImpl(colCtx, COLPOLY_IGNORE_PROJECTILES, COLPOLY_IGNORE_NONE, posA, posB, posResult,
                                 outPoly, bgId, NULL, 1.0f,
                                 BgCheck_GetBccFlags(checkWall, checkFloor, checkCeil, checkOneFace, true));

"Zora hover" state is when link actor has a parent, but broke out in a glitchy way, this prevents func_80844784 from being called, which has velocity/world.pos calculations


ORDER of operations:
Player_Update
ArmsHook_Update
Player_Draw
ArmsHook_Draw

A = prevpos
B = worldpos
C = 1EC
D = 1E0 (from draw?)
E = new 1E0 (end linetest)
F = sp60 (start linetest)
G = Torch
H = posResult (position you are pulled to)



quad:
-166.273468, -1458.87854, 2205.72437
-172.148499, -1450.78723, 2205.77759
-115.015198, -1160.28564, 902.881348
-115.018143, -1150.28601, 902.80481

]]--


