local x, y = EntityGetTransform(GetUpdatedEntityID())
local fish = EntityGetInRadiusWithTag(x, y, 300, "helpless_animal") or {}
SetRandomSeed(x + 4280, y + #fish + GetUpdatedComponentID())
if #fish > 1 then
    for i = 1, 2 do
        local rand = Random(1, #fish)
        local condemned = fish[rand]
        table.remove(fish, rand)
        EntityAddComponent2(condemned, "LuaComponent", {
            script_source_file="mods/boss_reworks/files/boss_fish/fish_warn.lua",
            execute_every_n_frame=1,
            remove_after_executed=true,
        })
        EntityAddComponent2(condemned, "LuaComponent", {
            script_source_file="mods/boss_reworks/files/boss_fish/fish_detonation.lua",
            execute_every_n_frame=35,
            remove_after_executed=true,
        })
    end
else
    EntityKill(GetUpdatedEntityID())
end