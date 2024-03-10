local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
EntityKill(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end
local whoshot = ComponentGetValue2(proj, "mWhoShot")
if not whoshot or not EntityHasTag(whoshot, "player_unit") or EntityHasTag(whoshot, "polymorphable_NOT") or GameGetGameEffectCount(whoshot, "PROTECTION_POLYMORPH") > 0 then
    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
    return
end
local worms = {
    "mods/boss_reworks/files/spells/tiny/worm.xml",
    -- "mods/boss_reworks/files/spells/tiny/worm_ghost.xml",
    -- "mods/boss_reworks/files/spells/tiny/worm_hell.xml",
}
SetRandomSeed(me + GameGetFrameNum(), whoshot + 24950)
for i = 1, #worms do
    if Random(1, 4) > 1 or i == #worms then
        LoadGameEffectEntityTo(whoshot, worms[i])
        return
    end
end