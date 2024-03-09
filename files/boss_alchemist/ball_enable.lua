local me = GetUpdatedEntityID()
local comps = EntityGetAllComponents(me)
for i = 1, #comps do
    EntitySetComponentIsEnabled(me, comps[i], true)
    if ComponentGetTypeName(comps[i]) == "SpriteComponent" then
        EntityRefreshSprite(me, comps[i])
    end
end
EntityAddComponent2(me, "LuaComponent", {
    script_source_file="mods/boss_reworks/files/boss_alchemist/ball_hit.lua",
    execute_every_n_frame=24,
    remove_after_executed=true,
})