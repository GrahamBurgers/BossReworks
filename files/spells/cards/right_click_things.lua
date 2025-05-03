local player = EntityGetRootEntity(GetUpdatedEntityID())
if not (player and player > 0) then return end
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
local action = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "ItemActionComponent")
if action and controls and ComponentGetValue2(controls, "mButtonFrameThrow") == GameGetFrameNum() then
    local id = ComponentGetValue2(action, "action_id")
    if id == "BR_REWARD_LEVI" then
        -- cancel tranquility
        local entities = EntityGetWithTag("br_spellname_levi") or {}
        for i = 1, #entities do
            local proj = EntityGetFirstComponent(entities[i], "ProjectileComponent")
            if proj and ComponentGetValue2(proj, "mWhoShot") == player then
                EntityKill(entities[i])
            end
        end
    elseif id == "BR_REWARD_LIMBS" then
        -- cancel stillness
        local entities = EntityGetWithTag("br_spellname_limbs") or {}
        for i = 1, #entities do
            local proj = EntityGetFirstComponent(entities[i], "ProjectileComponent")
            if proj and ComponentGetValue2(proj, "mWhoShot") == player then
                EntityKill(entities[i])
            end
        end
    elseif id == "BR_REWARD_FORGOTTEN" then
        -- teleport nearby markers to player
        local x, y = EntityGetTransform(player)
        local radius = 30
        local entities = EntityGetWithTag("br_forgotten_flare") or {}
        for i = 1, #entities do
            local proj = EntityGetFirstComponentIncludingDisabled(entities[i], "ProjectileComponent")
            local particles = EntityGetFirstComponentIncludingDisabled(entities[i], "ParticleEmitterComponent")
            if proj and particles then
                local target = ComponentGetValue2(proj, "mEntityThatShot")
                local x2, y2 = EntityGetTransform(entities[i])
                local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
                if distance <= radius and EntityGetIsAlive(target) then
                    EntityLoad("data/entities/particles/teleportation_target.xml", x2, y2)
                    GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", x2, y2)
                    EntityApplyTransform(target, x2, y2, 0)
                    EntitySetTransform(target, x2, y2, 0)
                    PhysicsApplyTorque(target, 0) -- WAKE UP
                    local comp = GetGameEffectLoadTo(target, "PROTECTION_ALL", true)
                    ComponentSetValue2(comp, "frames", 180)
                    EntityAddComponent2(entities[i], "LifetimeComponent", {lifetime = 2})
                    ComponentSetValue2(particles, "emitted_material_name", "spark_white")
                else
                    ComponentSetValue2(particles, "emitted_material_name", "smoke")
                end
                EntitySetComponentIsEnabled(entities[i], particles, true)
                EntityAddComponent2(entities[i], "LuaComponent", {
                    script_source_file="mods/boss_reworks/files/spells/forgotten_flare.lua",
                    remove_after_executed=true,
                })
            end
        end
    end
end