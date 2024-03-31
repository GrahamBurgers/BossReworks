local comp2 = EntityGetFirstComponent(GetUpdatedEntityID(), "VariableStorageComponent", "boss_wizard_mode")
local mode = 1
if comp2 then mode = ComponentGetValue2(comp2, "value_int") + 1 end
if mode < 2 then return end

local comp = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "ParticleEmitterComponent", "effect_radius")
if not comp then
    comp = EntityAddComponent2(GetUpdatedEntityID(), "ParticleEmitterComponent", {
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
        emitted_material_name="cursed_liquid",
        emitter_lifetime_frames=-1,
        lifetime_min=0.1,
        lifetime_max=0.1,
        velocity_always_away_from_center=-60,
        render_on_grid=false,
        fade_based_on_lifetime=true,
    })
    ComponentSetValue2(comp, "area_circle_radius", 350, 350)
end
local x, y = EntityGetTransform(GetUpdatedEntityID())
local radius, _ = ComponentGetValue2(comp, "area_circle_radius")
local add = 2
local regen = 0
if mode < 3 then
    radius = math.max(150, radius - 0.3)
    regen = 3
else
    radius = math.max(100, radius - 0.6)
    add = 6
    regen = 8
end
local entities = EntityGetWithTag("br_effect_timer") or {}
for i = 1, #entities do
    local x2, y2 = EntityGetTransform(entities[i])
    local distance = (x2 - x)^2 + (y2 - y)^2
    if distance > radius ^ 2 then
        local counter = EntityGetFirstComponent(entities[i], "VariableStorageComponent")
        if counter then
            local amount = ComponentGetValue2(counter, "value_float") + add
            ComponentSetValue2(counter, "value_float", amount)
            ComponentSetValue2(counter, "value_int", GameGetFrameNum() + 120)
            GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/poison/tick", x2, y2 )
        end
    end
end
ComponentSetValue2(comp, "area_circle_radius", radius, radius)
ComponentSetValue2(comp, "count_min", radius)
ComponentSetValue2(comp, "count_max", radius)

EntityInflictDamage(GetUpdatedEntityID(), (regen * -0.25) / 60, "DAMAGE_HEALING", "$damage_healing", "NONE", 0, 0, GetUpdatedEntityID())