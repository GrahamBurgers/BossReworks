local me = GetUpdatedEntityID()
local x, y, dir = EntityGetTransform(me)

local functions = {
    ["mods/boss_reworks/files/spells/robot/shape_anvil.png"] = function()
        local xmove = -20
        local ymove = 0
        x = x - (math.sin(dir) * xmove + math.cos(dir) * ymove)
        y = y + (math.cos(dir) * xmove + math.sin(dir) * ymove)
        -- EntityLoad("data/entities/particles/poof_blue.xml", x, y)
        EntityLoad("data/entities/buildings/forge_item_check.xml", x, y)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_triangle.png"] = function()
        EntityLoad("data/entities/buildings/wizardcave_gate.xml", x, y)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_chest.png"] = function()
        local xmove = -14
        local ymove = 0
        x = x - (math.sin(dir) * xmove + math.cos(dir) * ymove)
        y = y + (math.cos(dir) * xmove + math.sin(dir) * ymove)
        EntityLoad("data/entities/particles/poof_blue.xml", x, y)
        EntityLoad("data/entities/items/pickup/chest_random.xml", x, y)
    end,
    ["mods/boss_reworks/files/spells/robot/shape_pillar.png"] = function()
        local xmove = -70
        local ymove = 0
        x = x - (math.sin(dir) * xmove + math.cos(dir) * ymove)
        y = y + (math.cos(dir) * xmove + math.sin(dir) * ymove)
        EntityLoad("data/entities/particles/poof_blue.xml", x, y)
        EntityLoad("data/entities/items/pickup/evil_eye.xml", x, y)
    end,
}

local particles = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if particles then
    local file = ComponentGetValue2(particles, "image_animation_file")
    if functions[file] ~= nil then functions[file]() end
end
EntityKill(me)