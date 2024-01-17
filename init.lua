dofile_once("mods/boss_reworks/files/boss_dragon/edit.lua")
dofile_once("mods/boss_reworks/files/boss_gate/edit.lua")
dofile_once("mods/boss_reworks/files/boss_limbs/edit.lua")
dofile_once("mods/boss_reworks/files/boss_fish/edit.lua")
dofile_once("mods/boss_reworks/files/boss_alchemist/edit.lua")
dofile_once("mods/boss_reworks/files/boss_ghost/edit.lua")
ModMaterialsFileAdd("mods/boss_reworks/files/materials.xml")

local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/boss_reworks/translations.csv")
translations = translations .. new_translations
translations = translations:gsub("\r", ""):gsub("\n\n", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)

local content = ModTextFileGetContent("data/biome/_pixel_scenes.xml")
content = content:gsub("<mBufferedPixelScenes>", [[<mBufferedPixelScenes>
  <PixelScene pos_x="10496" pos_y="4352" just_load_an_entity="mods/boss_reworks/files/boss_rush/rooms/portal_space.xml" />
  <PixelScene pos_x="10496" pos_y="4352" just_load_an_entity="mods/boss_reworks/files/boss_rush/portals/boss_rush_portal_in.xml" />
]])
ModTextFileSetContent("data/biome/_pixel_scenes.xml", content)

function OnPlayerSpawned(player)
	if GameHasFlagRun("boss_reworks_init") then return end
	GameAddFlagRun("boss_reworks_init")
	EntityAddComponent2(player, "LuaComponent", {
		execute_every_n_frame = -1,
		script_shot = "mods/boss_reworks/files/shot.lua",
		script_damage_received = "mods/boss_reworks/files/damage_taken.lua",
	})
end
