EntityAddComponent2(GetUpdatedEntityID(), "HomingComponent", {
    target_tag="player_unit",
    detect_distance=500,
    homing_targeting_coeff=3,
    homing_velocity_multiplier=0.99
})