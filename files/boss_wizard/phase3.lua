local comp2 = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_wizard_mode")
local mode = 1
if comp2 then mode = ComponentGetValue2(comp2, "value_int") + 1 end
if mode < 2 then return end

local comps = EntityGetComponentIncludingDisabled(GetUpdatedEntityID(), "ParticleEmitterComponent", "effect_radius") or {}
if #comps < 1 then
    comps[#comps+1] = EntityAddComponent2(GetUpdatedEntityID(), "ParticleEmitterComponent", {
        _tags="effect_radius",
        area_circle_sector_degrees=360,
        collide_with_gas_and_fire=false,
        collide_with_grid=false,
        cosmetic_force_create=true,
        count_min=0,
        count_max=0,
        create_real_particles=false,
        custom_alpha=1,
        draw_as_long=false,
        render_back=false,
        emission_interval_min_frames=1,
        emission_interval_max_frames=1,
        emit_cosmetic_particles=true,
        emit_only_if_there_is_space=false,
        emit_real_particles=false,
        emitted_material_name="boss_reworks_cursed_liquid_nostain",
        emitter_lifetime_frames=-1,
        lifetime_min=0.1,
        lifetime_max=0.1,
        velocity_always_away_from_center=-60,
        render_on_grid=false,
        fade_based_on_lifetime=true,
    })
    comps[#comps+1] = EntityAddComponent2(GetUpdatedEntityID(), "ParticleEmitterComponent", {
        _tags="effect_radius",
        area_circle_sector_degrees=360,
        collide_with_gas_and_fire=false,
        collide_with_grid=false,
        cosmetic_force_create=true,
        count_min=0,
        count_max=0,
        create_real_particles=false,
        custom_alpha=1,
        draw_as_long=false,
        render_back=false,
        emission_interval_min_frames=1,
        emission_interval_max_frames=1,
        emit_cosmetic_particles=true,
        emit_only_if_there_is_space=false,
        emit_real_particles=false,
        emitted_material_name="material_confusion",
        emitter_lifetime_frames=-1,
        lifetime_min=0.6,
        lifetime_max=0.6,
        velocity_always_away_from_center=-80,
        render_on_grid=false,
        fade_based_on_lifetime=true,
    })
    ComponentSetValue2(comps[1], "area_circle_radius", 350, 350)
    ComponentSetValue2(comps[2], "area_circle_radius", 350, 700)
    ComponentSetValue2(comps[1], "gravity", 0, 0)
    ComponentSetValue2(comps[2], "gravity", 0, 0)
end
local x, y = EntityGetTransform(GetUpdatedEntityID())
local radius, _ = ComponentGetValue2(comps[1], "area_circle_radius")
local add = 2
if mode < 3 then
    radius = math.max(150, radius - 0.3)
else
    radius = math.max(100, radius - 0.6)
    add = 6
end
local entities = EntityGetWithTag("br_effect_timer") or {}
for i = 1, #entities do
    local x2, y2 = EntityGetTransform(entities[i])
    local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
    if distance > radius and distance < radius * 4 then
        local counter = EntityGetFirstComponent(entities[i], "VariableStorageComponent")
        if counter then
            local amount = ComponentGetValue2(counter, "value_float") + add
            ComponentSetValue2(counter, "value_float", amount)
            ComponentSetValue2(counter, "value_int", GameGetFrameNum() + 120)
            GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/poison/tick", x2, y2 )
        end
    end
end
ComponentSetValue2(comps[1], "area_circle_radius", radius, radius)
ComponentSetValue2(comps[1], "count_min", radius)
ComponentSetValue2(comps[1], "count_max", radius)
ComponentSetValue2(comps[2], "area_circle_radius", radius, radius * 4)
ComponentSetValue2(comps[2], "count_min", radius * 8)
ComponentSetValue2(comps[2], "count_max", radius * 8)