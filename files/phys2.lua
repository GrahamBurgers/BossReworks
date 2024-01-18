function item_pickup()
    local phys = EntityGetFirstComponent(GetUpdatedEntityID(), "PhysicsBody2Component")
    if not phys then return end
    ComponentSetValue2(phys, "is_static", false)
end