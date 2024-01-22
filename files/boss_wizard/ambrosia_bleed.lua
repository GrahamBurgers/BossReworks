local x, y = EntityGetTransform(EntityGetRootEntity(GetUpdatedEntityID()))
local players = EntityGetInRadiusWithTag(x, y, 200, "player_unit")
local particle = EntityGetFirstComponent(GetUpdatedEntityID(), "ParticleEmitterComponent")
local bleed = false
for i = 1, #players do
    if GameGetGameEffectCount(players[i], "PROTECTION_ALL") > 0 then
        bleed = true
        if GameGetFrameNum() % 30 == 0 then
            EntityAddRandomStains(players[i], CellFactory_GetType("blood"), 1)
        end
        break
    end
end
if particle then
    ComponentSetValue2(particle, "create_real_particles", bleed)
    ComponentSetValue2(particle, "count_min", 3)
    ComponentSetValue2(particle, "count_max", 6)
end