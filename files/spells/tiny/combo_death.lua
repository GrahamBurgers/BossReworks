function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    if EntityHasTag(entity_thats_responsible, "br_worm_combo_entity") then
        local me = GetUpdatedEntityID()
        local score_add = 0
        if EntityHasTag(me, "helpless_animal") then
            score_add = 100
            GamePrint(GameTextGet("$br_wormpoints_helpless_kill", tostring(score_add)))
        elseif EntityHasTag(me, "boss") or EntityHasTag(me, "miniboss") then
            score_add = 10000
            GamePrint(GameTextGet("$br_wormpoints_boss_kill", tostring(score_add)))
        elseif EntityHasTag(me, "necromancer_shop") then
            score_add = 800
            GamePrint(GameTextGet("$br_wormpoints_steve_kill", tostring(score_add)))
        elseif EntityHasTag(me, "small_friend") or EntityHasTag(me, "big_friend") then
            score_add = 2000
            GamePrint(GameTextGet("$br_wormpoints_friend_kill", tostring(score_add)))
        elseif EntityHasTag(me, "enemy") then
            score_add = 200
            GamePrint(GameTextGet("$br_wormpoints_normal_kill", tostring(score_add)))
        else
            score_add = 50
            GamePrint(GameTextGet("$br_wormpoints_weird_kill", tostring(score_add)))
        end
        GlobalsSetValue("BR_WORM_SCORE", tostring(score_add + tonumber(GlobalsGetValue("BR_WORM_SCORE", "0"))))
        local max = tonumber(GlobalsGetValue("BR_WORM_COMBO_MAX", "0")) + score_add * 0.3
        local amount = tonumber(GlobalsGetValue("BR_WORM_COMBO", "0")) + score_add * 0.6
        GlobalsSetValue("BR_WORM_COMBO_MAX", tostring(max))
        GlobalsSetValue("BR_WORM_COMBO", tostring(math.min(amount, max)))
    end
end