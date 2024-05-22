dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local anger = math.min(30, tonumber( GlobalsGetValue( "HELPLESS_KILLS", "1" ) ) or 1)

local wispnum = math.min( math.ceil( anger / 10 ), 20 )
if ( wispnum > 0 ) then
	for i=1,wispnum do
		local r = ProceduralRandomf(entity_id + i, 0, -1, 1)
		local offset = r * 24
		local wid = EntityLoad( "mods/boss_reworks/files/boss_deer/ghost.xml", x, y + offset )
		EntityAddChild( entity_id, wid )
	end
end