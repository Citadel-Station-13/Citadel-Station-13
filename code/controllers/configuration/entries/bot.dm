/datum/config_entry/flag/irc_announce_new_game
	deprecated_by = /datum/config_entry/string/chat_announce_new_game

/datum/config_entry/flag/irc_announce_new_game/DeprecationUpdate(value)
	return ""	//default broadcast

/datum/config_entry/string/chat_announce_new_game
	default = null

/datum/config_entry/string/chat_reboot_role

/datum/config_entry/string/chat_roundend_notice_tag

/datum/config_entry/string/chat_squawk_tag
