local x, y = EntityGetTransform(GetUpdatedEntityID())
y = y + 35
if not (#EntityGetInRadiusWithTag(x, y, 200, "player_unit") > 0 or #EntityGetInRadiusWithTag(x, y, 200, "polymorphed_player") > 0) then return end
SetRandomSeed(x + 4280, y + GetUpdatedComponentID())
local toggle = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if toggle % 2 == 0 then
    for i = 1, Random(20, 25) do
        local fish
        if Random(1, 3) < 3 then
            fish = EntityLoad("data/entities/animals/fish.xml", x + Random(-20, 20), y + Random(-20, 20))
        else
            fish = EntityLoad("data/entities/animals/fish_large.xml", x + Random(-20, 20), y + Random(-20, 20))
        end
        local comp = EntityGetFirstComponent(fish, "DamageModelComponent")
        if comp then
            ComponentSetValue2(comp, "create_ragdoll", false)
        end
    end
    local eid = EntityLoad("mods/boss_reworks/files/boss_fish/fish_targeter.xml", x, y)
    EntityAddChild(GetUpdatedEntityID(), eid)
else
    EntityAddComponent2(GetUpdatedEntityID(), "LuaComponent", {
        execute_every_n_frame=25,
        execute_times=25,
        script_source_file="mods/boss_reworks/files/boss_fish/bubble_spawn.lua"
    })
end