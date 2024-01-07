local eid = GetUpdatedEntityID()
local x, y = EntityGetTransform(eid)
local variable_storage_component = EntityGetComponent(eid, "VariableStorageComponent")
local map = {
	heal = function()
		local boss = EntityGetWithName("$animal_boss_limbs")
		if not EntityGetIsAlive(boss) then return end
		EntityInflictDamage(boss, -5, "DAMAGE_HEALING", "heal", "NONE", 0, 0)
	end,
	fire = function()
		EntityLoad("mods/boss_reworks/files/boss_limbs/fireball.xml", x, y)
	end,
	slime = function()
		local player = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
		if player == nil or not EntityGetIsAlive(player) then return end
		LoadGameEffectEntityTo(player, "mods/boss_reworks/files/boss_limbs/slimed.xml")
	end
}

local ctype
for k, v in ipairs(variable_storage_component or {}) do
	ctype = ComponentGetValue2(v, "value_string")
end
map[ctype]()
EntityKill(eid)