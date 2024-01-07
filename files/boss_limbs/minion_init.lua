local eid = GetUpdatedEntityID()
local x, y = EntityGetTransform(eid)
SetRandomSeed(x, y + GameGetFrameNum())
local types = { "heal", "fire", "slime" }
local ctype = types[Random(1, #types)]
local sprite = "mods/boss_reworks/files/boss_limbs/minion_" .. ctype .. ".xml"
local sprite_component = EntityGetComponent(eid, "SpriteComponent")
for k, v in ipairs(sprite_component or {}) do
	ComponentSetValue2(v, "image_file", sprite)
	EntityRefreshSprite(eid, v)
end
local variable_storage_component = EntityGetComponent(eid, "VariableStorageComponent")
for k, v in ipairs(variable_storage_component or {}) do
	ComponentSetValue2(v, "value_string", ctype)
end
