dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit") or EntityGetClosestWithTag(x, y, "polymorphed_player")
if player then
    x, y = EntityGetTransform(player)
end
y = y - 55
local count = 10
local spacing = 40
local luaspace = 3
local x2 = x - (spacing / 2) * count
x2 = x2 + spacing / 4
for i = 1, count do
    local eid = ShootProjectile( me, "mods/boss_reworks/files/boss_alchemist/ball.xml", x2, y, 0, -300, 1, true)
    local lua = EntityGetFirstComponent(eid, "LuaComponent")
    if lua then
        ComponentSetValue2(lua, "execute_every_n_frame", (i * luaspace))
        ComponentSetValue2(lua, "mNextExecutionTime", GameGetFrameNum() + (i * luaspace))
    end
    x2 = x2 + spacing
end
x2 = x - (spacing / -2) * count
x2 = x2 + spacing / -4
for i = 1, count do
    local eid = ShootProjectile( me, "mods/boss_reworks/files/boss_alchemist/ball.xml", x2, y, 0, -300, 1, true)
    local lua = EntityGetFirstComponent(eid, "LuaComponent")
    if lua then
        ComponentSetValue2(lua, "execute_every_n_frame", ((i * luaspace) + luaspace * count * 2))
        ComponentSetValue2(lua, "mNextExecutionTime", GameGetFrameNum() + ((i * luaspace) + luaspace * count * 2))
    end
    x2 = x2 - spacing
end