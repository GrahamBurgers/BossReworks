local eye = EntityGetAllChildren(GetUpdatedEntityID())[1]
local varsto = EntityGetFirstComponent(eye, "VariableStorageComponent")
if not varsto then return end

local damagemodel = EntityGetFirstComponent(GetUpdatedEntityID(), "DamageModelComponent")
if damagemodel then
    local max_hp = ComponentGetValue2(damagemodel, "max_hp")
    local hp = ComponentGetValue2(damagemodel, "hp")
    if hp >= max_hp then
		ComponentSetValue2(varsto, "value_int", 180)
	end
end
local timer = ComponentGetValue2(varsto, "value_int")
local particles = EntityGetFirstComponentIncludingDisabled(eye, "ParticleEmitterComponent")
if not particles then
    particles = EntityAddComponent2(eye, "ParticleEmitterComponent", {
        emitted_material_name="spark_green_bright",
		lifetime_min=1,
		lifetime_max=1,
		count_min=22,
		count_max=24,
		render_on_grid=false,
        render_back=false,
		fade_based_on_lifetime=true,
		airflow_force=0.5,
		airflow_time=0.1,
		airflow_scale=0.5,
		emission_interval_min_frames=1,
		emission_interval_max_frames=1,
		emit_cosmetic_particles=true,
		is_emitting=true,
        collide_with_grid=true,
        cosmetic_force_create=true,
		area_circle_sector_degrees=360,
    })
end
if timer > 180 then
    ComponentSetValue2(particles, "is_emitting", true)
    local amount = 80 * ((360 - timer) / 360)
    ComponentSetValue2(particles, "area_circle_radius", amount, amount)
    ComponentSetValue2(particles, "gravity", 0, 0)
else
    ComponentSetValue2(particles, "is_emitting", false)
end