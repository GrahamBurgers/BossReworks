dofile_once("mods/boss_reworks/files/boss_dragon/edit.lua")
dofile_once("mods/boss_reworks/files/boss_gate/edit.lua")
dofile_once("mods/boss_reworks/files/boss_limbs/edit.lua")
dofile_once("mods/boss_reworks/files/boss_fish/edit.lua")
ModMaterialsFileAdd("mods/boss_reworks/files/materials.xml")

local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/boss_reworks/translations.csv")
translations = translations .. new_translations
translations = translations:gsub("\r",""):gsub("\n\n","\n")
ModTextFileSetContent("data/translations/common.csv", translations)