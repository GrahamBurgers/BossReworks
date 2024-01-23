dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local me = GetUpdatedEntityID()
local players = EntityGetWithTag("player_unit") or EntityGetWithTag("polymorphed_player")
if not players then return end
local how_many = 6
for i = 1, #players do
    local x, y = EntityGetTransform(players[i])
    local angle_inc = (2 * math.pi) / how_many
    SetRandomSeed(me + how_many + x, players[i] + GameGetFrameNum() + y)
	local theta = Random(-math.pi, math.pi)

	for j = 1, how_many do
		local vel_x = math.cos(theta) * 18
		local vel_y = math.sin(theta) * 18
		theta = theta + angle_inc
		local eid = ShootProjectile(me, "mods/boss_reworks/files/boss_wizard/effect_orb.xml", x + vel_x * 4, y + vel_y * 4, vel_x, vel_y)
        local comp = EntityGetFirstComponent(eid, "ProjectileComponent")
        if comp then
            -- I will subvert using variablestoragecomponents whenever possible
            ComponentSetValue2(comp, "ragdoll_force_multiplier", vel_x * -18)
            ComponentSetValue2(comp, "hit_particle_force_multiplier", vel_y * -18)
        end
        EntityAddComponent2(eid, "LuaComponent", {
            script_source_file = "mods/boss_reworks/files/boss_wizard/effect_orb_turnaround.lua"
        })
        local homing = EntityGetFirstComponent(eid, "HomingComponent")
        if homing then EntityRemoveComponent(eid, homing) end
	end
end