local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "DamageModelComponent") or 0
local ratio = ComponentGetValue2(comp, "hp") / ComponentGetValue2(comp, "max_hp")
local amount = 40 - 20 * ratio
comp = EntityGetFirstComponent(me, "AreaDamageComponent") or 0
ComponentSetValue2(comp, "aabb_min", 0 - amount, 0 - amount)
ComponentSetValue2(comp, "aabb_max", amount, amount)
comp = EntityGetFirstComponent(me, "ParticleEmitterComponent") or 0
ComponentSetValue2(comp, "area_circle_radius", amount, amount)
if GameGetFrameNum() % 180 == 0 and #EntityGetWithTag("gate_monster") > 1 then
	local x, y = EntityGetTransform(me)
	dofile_once("mods/boss_reworks/files/projectile_utils.lua")
	CircleShot(me, "mods/boss_reworks/files/boss_gate/orb.xml", 8, x, y, 90)
end
