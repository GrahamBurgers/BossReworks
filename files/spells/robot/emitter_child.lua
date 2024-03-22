local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)

local functions = {
    ["mods/boss_reworks/files/spells/robot/shape_anvil.png"] = function()
        EntityLoad("data/entities/buildings/forge_item_check.xml", x, y)
    end,
}

local particles = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if particles then
    local file = ComponentGetValue2(particles, "image_animation_file")
    if functions[file] ~= nil then functions[file]() end
end
EntityKill(me)