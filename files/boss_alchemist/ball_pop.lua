local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local x, y = EntityGetTransform(me)
if proj then
    local radius = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
    local players = EntityGetInRadiusWithTag(x, y, radius, "prey") or {}
    for i = 1, #players do
    local levi = EntityGetFirstComponent(players[i], "CharacterDataComponent")
        if levi then
            ComponentSetValue2(levi, "mFlyingTimeLeft", 0)
            local x2, y2 = EntityGetTransform(players[i])
			EntityLoad("data/entities/particles/poof_blue.xml", x2, y2)
            GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x2, y2)
        end
    end
end