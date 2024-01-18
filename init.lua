dofile_once("mods/boss_reworks/files/boss_dragon/edit.lua")
dofile_once("mods/boss_reworks/files/boss_gate/edit.lua")
dofile_once("mods/boss_reworks/files/boss_limbs/edit.lua")
dofile_once("mods/boss_reworks/files/boss_fish/edit.lua")
dofile_once("mods/boss_reworks/files/boss_alchemist/edit.lua")
dofile_once("mods/boss_reworks/files/boss_ghost/edit.lua")
dofile_once("mods/boss_reworks/files/boss_robot/edit.lua")
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
-- ModTextFileSetContent("data/biome/_pixel_scenes.xml", content) -- wait until functional

function OnPlayerSpawned(player)
	if GameHasFlagRun("boss_reworks_init") then return end
	GameAddFlagRun("boss_reworks_init")
	EntityAddComponent2(player, "LuaComponent", {
		execute_every_n_frame = -1,
		script_shot = "mods/boss_reworks/files/shot.lua",
		script_damage_received = "mods/boss_reworks/files/damage_taken.lua",
	})
end

function OnWorldPreUpdate()
	if GlobalsGetValue("BR_BOSS_RUSH_ACTIVE", "0") == "1" then
		local players = EntityGetWithTag("player_unit") or {}
		for i = 1, #players do
			-- disable % based damage effects since those use the player's real HP
			local comp = 0
			comp = GameGetGameEffect( players[i], "POISON" )
			if comp > 0 then ComponentSetValue2(comp, "effect", "NONE") ComponentSetValue2(comp, "frames", 0) end
			comp = GameGetGameEffect( players[i], "RADIOACTIVE" )
			if comp > 0 then ComponentSetValue2(comp, "effect", "NONE") ComponentSetValue2(comp, "frames", 0) end
			comp = EntityGetFirstComponent(players[i], "DamageModelComponent") or 0
			if comp > 0 then ComponentSetValue2(comp, "mFireDamageBufferedNextDeliveryFrame", GameGetFrameNum() + 999) ComponentSetValue2(comp, "mFireFramesLeft", 0) ComponentSetValue2(comp, "mFireDamageBuffered", 0) end
		end
		-- i stole this code from lap 2 and modified it
		Gui = Gui or GuiCreate()
		GuiIdPushString(Gui, "br_healthbar")
		GuiStartFrame(Gui)

		local amount = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_LEFT", "0") or "0")
		local max = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_MAX") or "0")
		local multiplier = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_MULTIPLIER") or "0")
		local thing = tonumber(GlobalsGetValue("BR_BOSS_RUSH_HP_TWEEN") or "0")
		if thing <= amount then
			thing = amount
		else
			thing = thing - (thing - amount) / 20
		end
		GlobalsSetValue("BR_BOSS_RUSH_HP_TWEEN", tostring(thing))

		local text = math.floor(0.5 + math.max(0, amount)) / multiplier .. " / " .. math.floor(0.5 + math.max(0, max)) / multiplier
		local screen_w, screen_h = GuiGetScreenDimensions(Gui)
		local text_w, text_h = GuiGetTextDimensions(Gui, text)
		local bar = "mods/boss_reworks/files/boss_rush/health_bar.png"
		local bar_w, bar_h = GuiGetImageDimensions(Gui, bar)
		local tween = "mods/boss_reworks/files/boss_rush/health_tween.png"
		local tween_w, tween_h = GuiGetImageDimensions(Gui, bar)
		local frame = "mods/boss_reworks/files/boss_rush/health_frame.png"
		local frame_w, frame_h = GuiGetImageDimensions(Gui, frame)

		-- Red bar
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1000)
		GuiImage(Gui, 1, (screen_w - frame_w) / 2, screen_h / 1.2 - tween_h / 2, tween, 1, frame_w * thing / max, 1)
		-- Bar
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1001)
		GuiImage(Gui, 2, (screen_w - frame_w) / 2, screen_h / 1.2 - bar_h / 2, bar, 1, frame_w * amount / max, 1)
		-- Frame
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1002)
		GuiImage(Gui, 3, (screen_w - frame_w) / 2, screen_h / 1.2 - frame_h / 2, frame, 1, 1, 1)
		-- Countdown
		GuiOptionsAddForNextWidget(Gui, 2) -- Make non interactive
		GuiZSetForNextWidget(Gui, -1003)
		GuiText(Gui, (screen_w - text_w) / 2, screen_h / 1.2 - text_h / 2, text)

		GuiIdPop(Gui)
	end
end