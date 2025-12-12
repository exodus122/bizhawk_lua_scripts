MAP_MODEL_OBJECT_START = 0x382350

console.clear()

 -- contains tri count
CollisionList_collision_opa = mainmemory.read_u32_be(MAP_MODEL_OBJECT_START + 0x8)
CollisionList_collision_xlu = mainmemory.read_u32_be(MAP_MODEL_OBJECT_START + 0xC)

-- contains ptr to vtxlist and meshlist
BKModel_model_opa = mainmemory.read_u32_be(MAP_MODEL_OBJECT_START + 0x10)
BKModel_model_xlu = mainmemory.read_u32_be(MAP_MODEL_OBJECT_START + 0x14)

print("CollisionList_collision_opa: "..string.format("0x%08X", CollisionList_collision_opa))
print("CollisionList_collision_xlu: "..string.format("0x%08X", CollisionList_collision_xlu))
print("BKModel_model_opa: "..string.format("0x%08X", BKModel_model_opa))
print("BKModel_model_xlu: "..string.format("0x%08X", BKModel_model_xlu))