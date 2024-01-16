local x, y = EntityGetTransform(GetUpdatedEntityID())
dofile_once("mods/boss_reworks/files/projectile_utils.lua")

local player = EntityGetClosestWithTag(x, y, "player_unit")
x, y = EntityGetTransform(player)
SetRandomSeed(x + GameGetFrameNum(), y + 4358)

local how_many = 5
local angle_inc = (2 * math.pi) / how_many
local theta = Random(-math.pi, math.pi)
local dist = 140

for i = 1, how_many do
    local vel_x = math.cos(theta) * dist
    local vel_y = math.sin(theta) * dist
    theta = theta + angle_inc
    EntityLoad( "mods/boss_reworks/files/boss_ghost/teleport.xml", x + vel_x, y + vel_y)
end

EntityAddComponent2(GetUpdatedEntityID(), "LuaComponent", {
    script_source_file="mods/boss_reworks/files/boss_ghost/teleport.lua",
    execute_every_n_frame=60,
    remove_after_executed=true,
})