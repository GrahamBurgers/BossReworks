local eid = EntityGetWithTag("boss_limbs_minion")[1]
if eid == nil then return end
local x, y = EntityGetTransform(eid)
SetRandomSeed(x, y + GameGetFrameNum())
local me = GetUpdatedEntityID()
local damage_model = EntityGetComponent(me, "DamageModelComponent")
local hp
local max_hp
for k, v in ipairs(damage_model or {}) do
	hp = ComponentGetValue2(v, "hp")
	max_hp = ComponentGetValue2(v, "max_hp")
end

local heal = function()
	EntityInflictDamage(me, -5, "DAMAGE_HEALING", "heal", "NONE", 0, 0)
end
local fire = function()
	EntityLoad("mods/boss_reworks/files/boss_limbs/fireball.xml", x, y)
end
local slime = function()
	local player = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
	if player == nil or not EntityGetIsAlive(player) then return end
	LoadGameEffectEntityTo(player, "mods/boss_reworks/files/boss_limbs/slimed.xml")
end

if hp < max_hp / 2 then
	heal()
	EntityLoad("mods/boss_reworks/files/boss_limbs/circle_heal.xml", x, y)
elseif Random(1, 2) == 1 then
	fire()
	EntityLoad("mods/boss_reworks/files/boss_limbs/circle_fire.xml", x, y)
else
	slime()
	EntityLoad("mods/boss_reworks/files/boss_limbs/circle_slime.xml", x, y)
end

EntityKill(eid)
