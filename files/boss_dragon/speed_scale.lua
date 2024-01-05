local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "BossDragonComponent")
if comp == nil then return end
local xs, ys = ComponentGetValue2(comp, "mTargetVec")
if xs and ys then
    local scale = (math.abs(xs) + math.abs(ys)) -- probably deals more damage diagonally?
    ComponentSetValue2(comp, "bite_damage", scale)
end
if GameGetFrameNum() % 150 == 0 then
    local hitboxes = EntityGetComponent(me, "HitboxComponent")
    if hitboxes ~= nil then
        local hitbox = hitboxes[#hitboxes]
        local x, y = EntityGetTransform(me)
        local x2 = (ComponentGetValue2(hitbox, "aabb_min_x") + ComponentGetValue2(hitbox, "aabb_max_x")) / 2
        local y2 = (ComponentGetValue2(hitbox, "aabb_min_y") + ComponentGetValue2(hitbox, "aabb_max_y")) / 2
        SetRandomSeed(x + 425909, y + GameGetFrameNum())
        dofile_once("mods/boss_reworks/files/projectile_utils.lua")
        Shoot_projectile( me, "mods/boss_reworks/files/boss_dragon/dragon_orb_creator.xml", x + x2, y + y2, 0, 0)
    end
    local hpcomp = EntityGetFirstComponent(me, "DamageModelComponent")
    local healthbar = EntityGetFirstComponent(me, "SpriteComponent", "health_bar")
    if hpcomp ~= nil and healthbar ~= nil then
        if ComponentGetValue2(hpcomp, "hp") <= ComponentGetValue2(hpcomp, "max_hp") * 0.35 then
            ComponentSetValue2(comp, "direction_adjust_speed", 0.005)
            ComponentSetValue2(comp, "direction_adjust_speed_hunt", 0.06)
            ComponentSetValue2(comp, "projectile_1_count", 4)
            ComponentSetValue2(comp, "projectile_2_count", 8)
            ComponentSetValue2(comp, "speed", 1.5)
            ComponentSetValue2(healthbar, "image_file", "mods/boss_reworks/files/health_slider_panic.png" )
        else
            ComponentSetValue2(comp, "direction_adjust_speed", 0.003)
            ComponentSetValue2(comp, "direction_adjust_speed_hunt", 0.04)
            ComponentSetValue2(comp, "projectile_1_count", 2)
            ComponentSetValue2(comp, "projectile_2_count", 5)
            ComponentSetValue2(comp, "speed", 1)
            ComponentSetValue2(healthbar, "image_file", "data/ui_gfx/health_slider_front.png" )
        end
    end
end