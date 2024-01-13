local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local boss = EntityGetInRadiusWithTag(x, y, 350, "boss_limbs") or {}
if #boss < 1 then
    EntityConvertToMaterial(me, "soil_lush")
    EntityKill(me)
end