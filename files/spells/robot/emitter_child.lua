local me = GetUpdatedEntityID()
local x, y, dir = EntityGetTransform(me)
local function load_entity_relative(entity, xmove, ymove, dont_poof)
    local x2 = x - (math.sin(dir) * xmove + math.cos(dir) * ymove)
    local y2 = y + (math.cos(dir) * xmove + math.sin(dir) * ymove)
    EntityLoad(entity, x2, y2)
    if not dont_poof then
        EntityLoad("data/entities/particles/poof_blue.xml", x2, y2)
    end
end

local functions = {
    ["mods/boss_reworks/files/spells/robot/shape_anvil.png"] = function()
        load_entity_relative("data/entities/buildings/forge_item_check.xml", -20, 0, true)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_triangle.png"] = function()
        EntityLoad("data/entities/buildings/wizardcave_gate.xml", x, y)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_chest.png"] = function()
        load_entity_relative("data/entities/items/pickup/chest_random.xml", -14, 0)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_utilitybox.png"] = function()
        load_entity_relative("data/entities/items/pickup/utility_box.xml", -11, 0)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_pillar.png"] = function()
        load_entity_relative("data/entities/items/pickup/evil_eye.xml", -68, 0)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_kammi.png"] = function()
        load_entity_relative("data/entities/props/physics_lantern.xml", -12, -1)
        load_entity_relative("data/entities/props/furniture_bed.xml", 12, -36)
        load_entity_relative("data/entities/props/furniture_wood_table.xml", 12, 25)
        load_entity_relative("data/entities/props/physics_fungus_acid_small.xml", 25, 41)
    end,
}

local particles = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if particles then
    local file = ComponentGetValue2(particles, "image_animation_file")
    if functions[file] ~= nil then functions[file]() end
end
EntityKill(me)