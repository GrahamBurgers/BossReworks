dofile_once("mods/boss_reworks/files/projectile_utils.lua")
local me = GetUpdatedEntityID()
local x3, y3 = EntityGetTransform(me)
local x = x3
local y = y3
local player = EntityGetClosestWithTag(x3, y3, "player_unit") or 0
if player == 0 then
	player = EntityGetClosestWithTag(x3, y3, "polymorphed_player") or 0
end
if player > 0 then
    x, y = EntityGetTransform(player)
end
local distance = math.sqrt((x3 - x)^2 + (y3 - y)^2)
if distance > 300 then return end
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