/// log OOC channel
/datum/config_entry/flag/log_ooc
	default = TRUE

/// log login/logout
/datum/config_entry/flag/log_access
	default = TRUE

/// Config entry which special logging of failed logins under suspicious circumstances.
/datum/config_entry/flag/log_suspicious_login
	default = TRUE

/// log client say
/datum/config_entry/flag/log_say
	default = TRUE

/// log admin actions
/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED
	default = TRUE

/// log prayers
/datum/config_entry/flag/log_prayer
	default = TRUE

/// log lawchanges
/datum/config_entry/flag/log_law
	default = TRUE

/// log game events
/datum/config_entry/flag/log_game
	default = TRUE

/// log mech data
/datum/config_entry/flag/log_mecha
	default = TRUE

/// log virology data
/datum/config_entry/flag/log_virus
	default = TRUE

/// log voting
/datum/config_entry/flag/log_vote
	default = TRUE

/// log crafting
/datum/config_entry/flag/log_craft
	default = TRUE

/// log client whisper
/datum/config_entry/flag/log_whisper
	default = TRUE

/// log attack messages
/datum/config_entry/flag/log_attack
	default = TRUE

/// log attack messages
/datum/config_entry/flag/log_victim
	default = TRUE

/// log emotes
/datum/config_entry/flag/log_emote
	default = TRUE

/// log admin chat messages
/datum/config_entry/flag/log_adminchat
	protection = CONFIG_ENTRY_LOCKED

/// log shuttle related actions, ie shuttle computers, shuttle manipulator, emergency console
/datum/config_entry/flag/log_shuttle
	default = TRUE

/// log pda messages
/datum/config_entry/flag/log_pda
	default = TRUE

/// log telecomms messages
/datum/config_entry/flag/log_telecomms
	default = TRUE

/// log economy
/datum/config_entry/flag/log_econ
	default = TRUE

/// log certain expliotable parrots and other such fun things in a JSON file of twitter valid phrases.
/datum/config_entry/flag/log_twitter
	default = TRUE

/// log all world.Topic() calls
/datum/config_entry/flag/log_world_topic
	default = TRUE

/// log crew manifest to seperate file
/datum/config_entry/flag/log_manifest
	default = TRUE

/// log roundstart divide occupations debug information to a file
/datum/config_entry/flag/log_job_debug
	default = TRUE

/// log photos taken by players with a camera
/datum/config_entry/flag/log_pictures

/// This is... shitcode, literally same as above, if one of them is inactive, won't log at all, PLEASE FUCKING REMOVE THIS.
/datum/config_entry/flag/picture_logging_camera

/// forces log_href for tgui
/datum/config_entry/flag/emergency_tgui_logging
	default = FALSE

/// The "cooldown" time for each occurrence of a unique error
/datum/config_entry/number/error_cooldown
	default = 600
	min_val = 0

/// How many occurrences before the next will silence them
/datum/config_entry/number/error_limit
	default = 50

/// How long a unique error will be silenced for
/datum/config_entry/number/error_silence_time
	default = 6000

/// How long to wait between messaging admins about occurrences of a unique error
/datum/config_entry/number/error_msg_delay
	default = 50
