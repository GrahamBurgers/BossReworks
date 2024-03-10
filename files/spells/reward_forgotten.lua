dofile_once("mods/boss_reworks/files/projectile_utils.lua")
Items = { -- will mods want to append to this?
    {"alchemist_key", "mods/boss_reworks/files/spells/forgotten/key.png",           0, 119, 63},
    {"wand",          "mods/boss_reworks/files/spells/forgotten/wand.png" ,         0, 66, 115},
    {"potion",        "mods/boss_reworks/files/spells/forgotten/potion.png",        136, 136, 136},
    {"br_pouch",      "mods/boss_reworks/files/spells/forgotten/pouch.png",         81, 61, 17},
    {"seed_a",        "mods/boss_reworks/files/spells/forgotten/seed_a.png",        79, 79, 79},
    {"seed_b",        "mods/boss_reworks/files/spells/forgotten/seed_b.png",        55, 0, 0},
    {"seed_c",        "mods/boss_reworks/files/spells/forgotten/seed_c.png",        198, 181, 65},
    {"seed_d",        "mods/boss_reworks/files/spells/forgotten/seed_d.png",        146, 126, 26},
    {"seed_e",        "mods/boss_reworks/files/spells/forgotten/seed_e.png",        255, 255, 255},
    {"seed_f",        "mods/boss_reworks/files/spells/forgotten/seed_f.png",        0, 0, 0},
    {"br_orb",        "mods/boss_reworks/files/spells/forgotten/orb.png",           25, 111, 146},
    {"normal_tablet", "mods/boss_reworks/files/spells/forgotten/tablet.png",        41, 148, 84},
    {"forged_tablet", "mods/boss_reworks/files/spells/forgotten/tablet_forged.png", 84, 78, 45},
    -- {"br_hamis",      "mods/boss_reworks/files/spells/forgotten/hamis.png",         28, 11, 43},
    {"this_is_sampo", "mods/boss_reworks/files/spells/forgotten/sampo.png",         56, 138, 174},
    {"evil_eye",      "mods/boss_reworks/files/spells/forgotten/evil_eye.png",      146, 80, 93},
    {"br_musicstone", "mods/boss_reworks/files/spells/forgotten/musicstone.png",    45, 160, 122},
    {"card_summon_portal_broken", "mods/boss_reworks/files/spells/forgotten/broken_spell.png", 84, 12, 87},
    {"statue_hand",   "mods/boss_reworks/files/spells/forgotten/monk_hand.png",     46, 46, 46},
    {"br_moon",       "mods/boss_reworks/files/spells/forgotten/moon.png",          130, 123, 120},
    {"broken_wand",   "mods/boss_reworks/files/spells/forgotten/broken_wand.png",   177, 39, 168},
    {"br_wandcore",   "mods/boss_reworks/files/spells/forgotten/wandcore.png",      21, 156, 75},
}

local old = EntityGetWithTag("br_forgotten_flare") -- keeping things safe, try to reduce lag
for i = 1, #old do
    EntityKill(old[i])
end

local bonk = true
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
for i = 1, #Items do
    local entities = EntityGetInRadiusWithTag(x, y, 1600, Items[i][1]) or {}
    for j = 1, #entities do
        if not EntityHasTag(EntityGetRootEntity(entities[j]), "player_unit") then
            local eid = ShootProjectileAtEntity(me, "mods/boss_reworks/files/spells/forgotten_flare.xml", x, y, entities[j], 1)
            if eid then
                local proj = EntityGetFirstComponentIncludingDisabled(eid, "ProjectileComponent")
                local homing = EntityGetFirstComponentIncludingDisabled(eid, "HomingComponent")
                local sprite = EntityGetFirstComponentIncludingDisabled(eid, "SpriteComponent")
                local particles = EntityGetFirstComponentIncludingDisabled(eid, "SpriteParticleEmitterComponent")
                if proj and homing and sprite and particles then
                    local x2, y2 = EntityGetTransform(entities[j])
                    local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
                    ComponentSetValue2(proj, "lifetime", math.min(300, 60 * (distance / ComponentGetValue2(proj, "speed_max"))))
                    ComponentSetValue2(sprite, "image_file", Items[i][2])
                    ComponentSetValue2(particles, "sprite_file", Items[i][2])
                    ComponentSetValue2(particles, "color", Items[i][3] / 255, Items[i][4] / 255, Items[i][5] / 255, 1)
                    ComponentSetValue2(homing, "predefined_target", entities[j])
                    EntityRefreshSprite(eid, sprite)
                end
                bonk = false
            end
        end
    end
end

if bonk then
    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
end

EntityKill(me)