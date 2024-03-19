local player = EntityGetRootEntity(GetUpdatedEntityID())
local comp = GameGetGameEffect(player, "POISON")
if comp ~= 0 then ComponentSetValue2( comp, "effect", "NONE") end
local comp2 = GameGetGameEffect(player, "BLINDNESS")
if comp2 ~= 0 then ComponentSetValue2( comp2, "effect", "NONE") end