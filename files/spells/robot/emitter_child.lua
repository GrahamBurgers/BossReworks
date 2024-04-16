local me = GetUpdatedEntityID()
local x, y, dir = EntityGetTransform(me)

local function dot(x, y)
	-- kinda ugly but i dont want to malloc a table
	--- NOTE: standard 2d rotation matrix except other dir. cos is symmetric.
	local matrix_0_0 = math.cos(dir)
	local matrix_1_0 = math.sin(dir)
	local matrix_0_1 = -math.sin(dir)
	local matrix_1_1 = math.cos(dir)
	return (x * matrix_0_0 + y * matrix_0_1), (x * matrix_1_0 + y * matrix_1_1)
end

print(dir)

local functions = {
	["mods/boss_reworks/files/spells/robot/shape_anvil.png"] = function()
		local xd, yd = dot(0, -20)
		-- EntityLoad("data/entities/particles/poof_blue.xml", x, y)
		EntityLoad("data/entities/buildings/forge_item_check.xml", x + xd, y + yd)
	end,
	["mods/boss_reworks/files/spells/robot/shape_triangle.png"] = function()
		EntityLoad("data/entities/buildings/wizardcave_gate.xml", x, y)
	end,
	["mods/boss_reworks/files/spells/robot/shape_chest.png"] = function()
		local xd, yd = dot(0, -14)
		EntityLoad("data/entities/particles/poof_blue.xml", x + xd, y + yd)
		EntityLoad("data/entities/items/pickup/chest_random.xml", x + xd, y + yd)
	end,
	["mods/boss_reworks/files/spells/robot/shape_pillar.png"] = function()
		local xd, yd = dot(0, -70)
		EntityLoad("data/entities/particles/poof_blue.xml", x + xd, y + yd)
		EntityLoad("data/entities/items/pickup/evil_eye.xml", x + xd, y + yd)
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

