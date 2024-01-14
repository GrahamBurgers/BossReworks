local me = GetUpdatedEntityID()
local comps = EntityGetAllComponents(me)
for i = 1, #comps do
    EntitySetComponentIsEnabled(me, comps[i], true)
    if ComponentGetTypeName(comps[i]) == "SpriteComponent" then
        EntityRefreshSprite(me, comps[i])
    end
end