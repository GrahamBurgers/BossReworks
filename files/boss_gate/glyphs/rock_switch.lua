local me = GetUpdatedEntityID()
local comp = EntityGetFirstComponent(me, "SpriteComponent") or 0
ComponentSetValue2(comp, "image_file", ComponentGetValue2(GetUpdatedComponentID(), "script_material_area_checker_failed"))
EntityRefreshSprite(me, comp)