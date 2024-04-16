local me = GetUpdatedEntityID()
local x, y, dir = EntityGetTransform(me)

local function dot(vec_x, vec_y)
	-- kinda ugly but i dont want to malloc a table
	--- NOTE: standard 2d rotation matrix except other dir. cos is symmetric.
	local matrix_0_0 = math.cos(dir)
	local matrix_1_0 = math.sin(dir)
	local matrix_0_1 = -math.sin(dir)
	local matrix_1_1 = math.cos(dir)
	return (vec_x * matrix_0_0 + vec_y * matrix_0_1), (vec_x * matrix_1_0 + vec_y * matrix_1_1)
end

local function load_entity_relative(entity, xmove, ymove, dont_poof)
	local xd, yd = dot(xmove, ymove)
	local x2 = x + xd
	local y2 = y + yd
	local e = EntityLoad(entity, x2, y2)
	-- WARNING: Doesn't work on physics objects
	-- EntityApplyTransform(e, x2, y2, dir)
	if not dont_poof then
		EntityLoad("data/entities/particles/poof_blue.xml", x2, y2)
	end
end

print(dir)

local functions = {
	["mods/boss_reworks/files/spells/robot/shape_anvil.png"] = function()
		load_entity_relative("data/entities/buildings/forge_item_check.xml", 0, -20, true)
	end,
	["mods/boss_reworks/files/spells/robot/shape_triangle.png"] = function()
		EntityLoad("data/entities/buildings/wizardcave_gate.xml", x, y)
	end,
	["mods/boss_reworks/files/spells/robot/shape_chest.png"] = function()
		load_entity_relative("data/entities/items/pickup/chest_random.xml", 0, -14, false)
	end,
	["mods/boss_reworks/files/spells/robot/shape_pillar.png"] = function()
		load_entity_relative("data/entities/items/pickup/evil_eye.xml", 0, -70, false)
	end,
	["mods/boss_reworks/files/spells/robot/shape_utilitybox.png"] = function()
		load_entity_relative("data/entities/items/pickup/utility_box.xml", 0, -11)
	end,
	["mods/boss_reworks/files/spells/robot/shape_kammi.png"] = function()
		load_entity_relative("data/entities/props/physics_lantern.xml", -1, -12)
		load_entity_relative("data/entities/props/furniture_bed.xml", -36, 12)
		load_entity_relative("data/entities/props/furniture_wood_table.xml", 25, 12)
		load_entity_relative("data/entities/props/physics_fungus_acid_small.xml", 41, 25)
	end,
}

local particles = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if particles then
	local file = ComponentGetValue2(particles, "image_animation_file")
	if functions[file] ~= nil then
		functions[file]()
	end
end
EntityKill(me)
