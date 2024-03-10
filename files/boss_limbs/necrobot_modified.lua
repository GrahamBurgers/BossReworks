local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local targets = EntityGetInRadiusWithTag(x, y, 150, "boss_limbs_minion")

for i,v in ipairs(targets) do
	if not EntityHasTag(v, "necrobot_NOT") then
		EntityAddComponent2(v, "LuaComponent", {
			script_death = "data/scripts/status_effects/necrobot.lua",
			execute_every_n_frame = -1,
		})

		local x2, y2 = EntityGetTransform(v)
		EntityLoad("data/entities/particles/poof_green_sparse.xml", x2, y2)
		local eid = EntityLoad("data/entities/particles/tinyspark_green_sparse.xml", x2, y2)
		EntityAddChild(v, eid)
		EntityAddTag(v, "necrobot_NOT")
	end
end