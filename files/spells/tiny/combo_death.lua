function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    if EntityHasTag(entity_thats_responsible, "br_worm_combo_entity") then
        local me = GetUpdatedEntityID()
        local score_add = 0
        if EntityHasTag(me, "helpless_animal") then
            GamePrint(GameTextGet("$br_wormpoints_helpless_kill", "100"))
            score_add = 100
        elseif EntityHasTag(me, "boss") or EntityHasTag(me, "miniboss") then
            GamePrint(GameTextGet("$br_wormpoints_boss_kill", "10000"))
            score_add = 10000
        elseif EntityHasTag(me, "enemy") then
            GamePrint(GameTextGet("$br_wormpoints_normal_kill", "200"))
            score_add = 200
        else
            GamePrint(GameTextGet("$br_wormpoints_weird_kill", "50"))
            score_add = 50
        end
        GlobalsSetValue("BR_WORM_SCORE", tostring(score_add + tonumber(GlobalsGetValue("BR_WORM_SCORE", "0"))))
        local max = tonumber(GlobalsGetValue("BR_WORM_COMBO_MAX", "0")) + score_add * 0.3
        local amount = tonumber(GlobalsGetValue("BR_WORM_COMBO", "0")) + score_add * 0.6
        GlobalsSetValue("BR_WORM_COMBO_MAX", tostring(max))
        GlobalsSetValue("BR_WORM_COMBO", tostring(math.min(amount, max)))
    end
end