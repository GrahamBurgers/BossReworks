-- todo: do more things with this?

local function shuffle(t) -- stolen from stackoverflow
    local s = {}
    for i = 1, #t do s[i] = t[i] end
    for i = #t, 2, -1 do
        local j = math.random(i)
        s[i], s[j] = s[j], s[i]
    end
    return s
end

---@param id string
function Soul(id)
    local souls_list = {"BR_REWARD_LIMBS", "BR_REWARD_FORGOTTEN",
    "BR_REWARD_SQUIDWARD", "BR_REWARD_DRAGON", "BR_REWARD_GATE",
    "BR_REWARD_ALCHEMIST", "BR_REWARD_TINY", "BR_REWARD_MASTER",
    "BR_REWARD_LEVI", "BR_REWARD_ROBOT",}
    local mode = tostring(ModSettingGet("boss_reworks.mode"))
    if mode == "Shuffle" then
        for i = 1, #souls_list do
            if id == souls_list[i] then
                SetRandomSeed(i, i)
                souls_list = shuffle(souls_list)
                id = souls_list[i]
                break
            end
        end
    end
    if ModSettingGet("boss_reworks.souls") == false then
        id = "" -- probably errors
    end
    return id
end