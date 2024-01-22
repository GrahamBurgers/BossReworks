local me = EntityGetRootEntity(GetUpdatedEntityID())
local bar = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "health_bar")
if not bar then return end -- todo: add mod settings
local whatx, whaty = ComponentGetValue2(bar, "transform_offset")
local offset_y = (ComponentGetValue2(bar, "offset_y"))
local sprite = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "SpriteComponent", "br_boss_rush_health_counter")
if not sprite then
    sprite = EntityAddComponent2(me, "SpriteComponent", {
        _tags = "br_boss_rush_health_counter",
        image_file = "data/fonts/font_pixel_white.xml",
        emissive = true,
        is_text_sprite = true,
        offset_x = 0,
        offset_y = 0,
        alpha = ComponentGetValue2(bar, "alpha"),
        update_transform = true,
        update_transform_rotation = false,
        text = "",
        has_special_scale = true,
        special_scale_x = 2/3,
        special_scale_y = 2/3,
        z_index = -9000,
        never_ragdollify_on_death = true
    })
end
local comp = EntityGetFirstComponentIncludingDisabled(me, "DamageModelComponent")
if not comp or not sprite then return end
local hp = math.floor(0.5 + ComponentGetValue2(comp, "hp") * 25)
local max_hp = math.floor(0.5 + ComponentGetValue2(comp, "max_hp") * 25)
hp = math.min(math.max(0, hp), max_hp)
local text = table.concat({hp, " / ", max_hp})
local gui = GuiCreate()
GuiStartFrame(gui)
local offset_x = (GuiGetTextDimensions(gui, text, 1)) / 2
GuiDestroy(gui)

ComponentSetValue2(sprite, "text", text)
ComponentSetValue2(sprite, "offset_x", offset_x)
ComponentSetValue2(sprite, "offset_y", 0)
ComponentSetValue2(sprite, "transform_offset", whatx, whaty - offset_y - 7.25)
EntityRefreshSprite(me, sprite)