local x, y = EntityGetTransform(GetUpdatedEntityID())
local fish = EntityGetInRadiusWithTag(x, y, 300, "helpless_animal") or {}
SetRandomSeed(x + 4280, y + #fish + GetUpdatedComponentID())
if #fish > 0 then
    local condemned = fish[Random(1, #fish)]
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
else
    for i = 1, Random(10, 30) do
        if Random(1, 3) < 3 then
            EntityLoad("data/entities/animals/fish.xml", x, y)
        else
            EntityLoad("data/entities/animals/fish_large.xml", x, y)
        end
    end
    EntityKill(GetUpdatedEntityID())
end