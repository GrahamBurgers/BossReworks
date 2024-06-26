dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit") or 0
if player == 0 then
	player = EntityGetClosestWithTag(x, y, "polymorphed_player") or 0
end
if player == 0 then return end
local orbs = EntityGetWithTag("wizard_orb_blood") or {}
for i = 1, #orbs do
    x, y = EntityGetTransform(orbs[i])
    ShootProjectileAtEntity(me, "mods/boss_reworks/files/boss_wizard/effect_orb.xml", x, y, player, 1)
end
orbs = EntityGetWithTag("wizard_orb_death") or {}
for i = 1, #orbs do
    x, y = EntityGetTransform(orbs[i])
    ShootProjectileAtEntity(me, "mods/boss_reworks/files/boss_wizard/effect_orb.xml", x, y, player, 1)
end