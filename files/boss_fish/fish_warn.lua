local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
EntityAddComponent2(me, "SpriteComponent", {
    image_file="mods/boss_reworks/files/boss_fish/fish_warn.xml",
    emissive=true,
    never_ragdollify_on_death=true,
    update_transform_rotation=false,
    alpha=0.4,
})
GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y )