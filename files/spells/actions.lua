---@diagnostic disable: undefined-global, lowercase-global
RemoveFlagPersistent("br_dummy_flag")
local to_insert = {
	{
		id                  = "BR_LONGTELETRIGGER",
		name                = "$br_spellname_longteletrigger",
		description         = "$br_spelldesc_longteletrigger",
		sprite              = "mods/boss_reworks/files/spells/longteletrigger.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile.xml"},
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,4,5,6", -- TELEPORT_PROJECTILE
		spawn_probability   = "0.4,0.4,0.2,0.2,0.2", -- TELEPORT_PROJECTILE
		price               = 130,
		mana                = 45,
		spawn_requires_flag = "card_unlocked_pyramid",
		max_uses            = -1,
		custom_xml_file     = "data/entities/misc/custom_cards/teleport_projectile.xml",
		action 	            = function()
			add_projectile_trigger_death("data/entities/projectiles/deck/teleport_projectile.xml", 1)
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.spread_degrees = c.spread_degrees - 2.0
		end,
	},
	{
		id                  = "BR_SHORTTELETRIGGER",
		name                = "$br_spellname_shortteletrigger",
		description         = "$br_spelldesc_shortteletrigger",
		sprite              = "mods/boss_reworks/files/spells/shortteletrigger.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_short.xml"},
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "1,2,4,5,6", -- TELEPORT_PROJECTILE
		spawn_probability   = "0.4,0.4,0.2,0.2,0.2", -- TELEPORT_PROJECTILE
		price               = 130,
		mana                = 25,
		spawn_requires_flag = "card_unlocked_pyramid",
		max_uses            = -1,
		custom_xml_file     = "data/entities/misc/custom_cards/teleport_projectile_short.xml",
		action              = function()
			add_projectile_trigger_death("data/entities/projectiles/deck/teleport_projectile_short.xml", 1)
			c.spread_degrees = c.spread_degrees - 2.0
		end,
	},
	{
		id                  = "BR_REWARD_LIMBS",
		name                = "$br_spellname_limbs",
		description         = "$br_spelldesc_limbs",
		sprite              = "mods/boss_reworks/files/spells/reward_limbs.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_limbs.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/limbs.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_limbs.xml")
		end,
	},
	{
		id                  = "BR_REWARD_FORGOTTEN",
		name                = "$br_spellname_forgotten",
		description         = "$br_spelldesc_forgotten",
		sprite              = "mods/boss_reworks/files/spells/reward_forgotten.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_forgotten.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/forgotten.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_forgotten.xml")
		end,
	},
	{
		id                  = "BR_REWARD_SQUIDWARD",
		name                = "$br_spellname_squidward",
		description         = "$br_spelldesc_squidward",
		sprite              = "mods/boss_reworks/files/spells/reward_squidward.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_squidward.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/squidward.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_squidward.xml")
		end,
	},
	{
		id                  = "BR_REWARD_DRAGON",
		name                = "$br_spellname_dragon",
		description         = "$br_spelldesc_dragon",
		sprite              = "mods/boss_reworks/files/spells/reward_dragon.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_dragon.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/dragon.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_dragon.xml")
		end,
	},
	{
		id                  = "BR_REWARD_GATE",
		name                = "$br_spellname_gate",
		description         = "$br_spelldesc_gate",
		sprite              = "mods/boss_reworks/files/spells/reward_gate.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_gate.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/gate.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_gate.xml")
		end,
	},
	{
		id                  = "BR_REWARD_ALCHEMIST",
		name                = "$br_spellname_alchemist",
		description         = "$br_spelldesc_alchemist",
		sprite              = "mods/boss_reworks/files/spells/reward_alchemist.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_alchemist.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/alchemist.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_alchemist.xml")
		end,
	},
	{
		id                  = "BR_REWARD_TINY",
		name                = "$br_spellname_tiny",
		description         = "$br_spelldesc_tiny",
		sprite              = "mods/boss_reworks/files/spells/reward_tiny.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_tiny.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/tiny.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_tiny.xml")
		end,
	},
	{
		id                  = "BR_REWARD_MASTER",
		name                = "$br_spellname_master",
		description         = "$br_spelldesc_master",
		sprite              = "mods/boss_reworks/files/spells/reward_master.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_master.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/master.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_master.xml")
		end,
	},
	{
		id                  = "BR_REWARD_LEVI",
		name                = "$br_spellname_leviathan",
		description         = "$br_spelldesc_leviathan",
		sprite              = "mods/boss_reworks/files/spells/reward_levi.png",
		related_projectiles = {"mods/boss_reworks/files/spells/reward_levi.xml"},
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/levi.xml",
		action              = function()
			add_projectile("mods/boss_reworks/files/spells/reward_levi.xml")
		end,
	},
	{
		id                  = "BR_REWARD_ROBOT",
		name                = "$br_spellname_robot",
		description         = "$br_spelldesc_robot",
		sprite              = "mods/boss_reworks/files/spells/reward_robot.png",
		type                = ACTION_TYPE_UTILITY,
		spawn_level         = "10",
		spawn_probability   = "0",
		price               = 80,
		mana                = 5,
		spawn_requires_flag = "br_dummy_flag",
		max_uses            = -1,
		custom_xml_file     = "mods/boss_reworks/files/spells/cards/robot.xml",
		action              = function()
			if reflecting then return end
			local construction = EntityGetWithTag("br_construction")
			for i = 1, #construction do
				if #(EntityGetAllChildren(construction[i]) or {}) <= 0 then
					local child = EntityLoad("mods/boss_reworks/files/spells/robot/emitter_child.xml")
					EntityAddChild(construction[i], child)
				end
			end
		end,
	},
}

if ModIsEnabled("grahamsperks") then
	to_insert[#to_insert+1] = {
		id                  = "BR_WARPTELEDEATHTRIGGER",
		name                = "$br_spellname_warpteledeathtrigger", -- how long can this be before things start breaking?
		description         = "$br_spelldesc_warpteledeathtrigger",
		sprite              = "mods/boss_reworks/files/spells/warp_teleport.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0,1,2",
		spawn_probability   = "0.6,0.4,0.2",
		price               = 180,
		mana                = 65,
		custom_xml_file     = "mods/grahamsperks/files/spells/teleport_fast_card.xml",
		related_projectiles = { "mods/grahamsperks/files/spells/teleport_fast.xml" },
		action              = function()
			c.fire_rate_wait = c.fire_rate_wait + 35
			add_projectile_trigger_death("mods/grahamsperks/files/spells/teleport_fast.xml", 1)
		end,
	}
end

local len = #actions
for i=1, #to_insert do
	actions[len+i] = to_insert[i]
end