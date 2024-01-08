local comp = EntityGetFirstComponent(EntityGetRootEntity(GetUpdatedEntityID()), "CharacterDataComponent")
if not comp then return end
local x, y = ComponentGetValue2(comp, "mVelocity")
y = y + (150 - y) / 8
ComponentSetValue2(comp, "mVelocity", x, y)