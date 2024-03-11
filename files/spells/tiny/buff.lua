local player = EntityGetRootEntity(GetUpdatedEntityID())
local comp = GameGetGameEffect(player, "POISON")
if comp ~= 0 then ComponentSetValue2( comp, "effect", "NONE") end