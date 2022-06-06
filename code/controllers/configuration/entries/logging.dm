/// log OOC channel
/datum/config_entry/flag/log_ooc
	config_entry_value = TRUE

/// log login/logout
/datum/config_entry/flag/log_access
	config_entry_value = TRUE

/// Config entry which special logging of failed logins under suspicious circumstances.
/datum/config_entry/flag/log_suspicious_login
	config_entry_value = TRUE

/// log client say
/datum/config_entry/flag/log_say
	config_entry_value = TRUE

/// log admin actions
/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED
	config_entry_value = TRUE

/// log prayers
/datum/config_entry/flag/log_prayer
	config_entry_value = TRUE

/// log lawchanges
/datum/config_entry/flag/log_law
	config_entry_value = TRUE

/// log game events
/datum/config_entry/flag/log_game
	config_entry_value = TRUE

/// log mech data
/datum/config_entry/flag/log_mecha
	config_entry_value = TRUE

/// log virology data
/datum/config_entry/flag/log_virus
	config_entry_value = TRUE

/// log voting
/datum/config_entry/flag/log_vote
	config_entry_value = TRUE

/// log crafting
/datum/config_entry/flag/log_craft
	config_entry_value = TRUE

/// log client whisper
/datum/config_entry/flag/log_whisper
	config_entry_value = TRUE

/// log attack messages
/datum/config_entry/flag/log_attack
	config_entry_value = TRUE

/// log attack messages
/datum/config_entry/flag/log_victim
	config_entry_value = TRUE

/// log emotes
/datum/config_entry/flag/log_emote
	config_entry_value = TRUE

/// log admin chat messages
/datum/config_entry/flag/log_adminchat
	protection = CONFIG_ENTRY_LOCKED

/// log shuttle related actions, ie shuttle computers, shuttle manipulator, emergency console
/datum/config_entry/flag/log_shuttle
	config_entry_value = TRUE

/// log pda messages
/datum/config_entry/flag/log_pda
	config_entry_value = TRUE

/// log telecomms messages
/datum/config_entry/flag/log_telecomms
	config_entry_value = TRUE

/// log economy
/datum/config_entry/flag/log_econ
	config_entry_value = TRUE

/// log certain expliotable parrots and other such fun things in a JSON file of twitter valid phrases.
/datum/config_entry/flag/log_twitter
	config_entry_value = TRUE

/// log all world.Topic() calls
/datum/config_entry/flag/log_world_topic
	config_entry_value = TRUE

/// log crew manifest to seperate file
/datum/config_entry/flag/log_manifest
	config_entry_value = TRUE

/// log roundstart divide occupations debug information to a file
/datum/config_entry/flag/log_job_debug
	config_entry_value = TRUE

/// log photos taken by players with a camera
/datum/config_entry/flag/log_pictures

/// This is... shitcode, literally same as above, if one of them is inactive, won't log at all, PLEASE FUCKING REMOVE THIS.
/datum/config_entry/flag/picture_logging_camera

/// forces log_href for tgui
/datum/config_entry/flag/emergency_tgui_logging
	config_entry_value = FALSE

/// The "cooldown" time for each occurrence of a unique error
/datum/config_entry/number/error_cooldown
	config_entry_value = 600
	min_val = 0

/// How many occurrences before the next will silence them
/datum/config_entry/number/error_limit
	config_entry_value = 50

/// How long a unique error will be silenced for
/datum/config_entry/number/error_silence_time
	config_entry_value = 6000

/// How long to wait between messaging admins about occurrences of a unique error
/datum/config_entry/number/error_msg_delay
	config_entry_value = 50
