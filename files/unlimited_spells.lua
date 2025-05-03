local c = EntityGetAllChildren(GetUpdatedEntityID(), "card_action") or {}
for i = 1, #c do
    local item = EntityGetFirstComponentIncludingDisabled(c[i], "ItemComponent")
    if item then ComponentSetValue2(item, "uses_remaining", -1) end
end