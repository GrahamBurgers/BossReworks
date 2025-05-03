local player = EntityGetRootEntity(GetUpdatedEntityID())
local platform = EntityGetFirstComponent(player, "CharacterPlatformingComponent")
if not platform then return end
local swim_idle = ComponentGetValue2(platform, "swim_idle_buoyancy_coeff") * 0.6
local swim_up = ComponentGetValue2(platform, "swim_up_buoyancy_coeff") * 0.2
local swim_down = ComponentGetValue2(platform, "swim_down_buoyancy_coeff") * 0.2

local swim_drag = ComponentGetValue2(platform, "swim_drag") * 1.05
local swim_drag_extra = ComponentGetValue2(platform, "swim_extra_horizontal_drag") * 1.1

ComponentSetValue2(platform, "swim_idle_buoyancy_coeff", swim_idle)
ComponentSetValue2(platform, "swim_up_buoyancy_coeff", swim_up)
ComponentSetValue2(platform, "swim_down_buoyancy_coeff", swim_down)

ComponentSetValue2(platform, "swim_drag", swim_drag)
ComponentSetValue2(platform, "swim_extra_horizontal_drag", swim_drag_extra)