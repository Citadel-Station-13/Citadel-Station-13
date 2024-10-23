/// Allows usage of respawn system
/datum/config_entry/flag/respawns_enabled
	default = FALSE

/// Minutes before allowing respawns.
/datum/config_entry/number/respawn_delay
	default = 15.0
	integer = FALSE

/// Minutes before allowing respawn, if user cryo'd.
/datum/config_entry/number/respawn_delay_cryo
	default = 5.0
	integer = FALSE

/// Allows respawning as non-assistant. Overrides all others of this type.
/datum/config_entry/flag/allow_non_assistant_respawn
	default = FALSE

/// Allows respawning as a combat role, defined as security/head.
/datum/config_entry/flag/allow_combat_role_respawn
	default = FALSE

/// Allows respawning as the same character as a previous life
/datum/config_entry/flag/allow_same_character_respawn
	default = FALSE

/// Observing penalizes for respawns, not just joining.
/datum/config_entry/flag/respawn_penalty_includes_observe
	default = FALSE

/// Minutes from roundstart before someone can respawn
/datum/config_entry/number/respawn_minimum_delay_roundstart
	default = 30.0
	integer = FALSE

/// Gamemode config tags that are banned from respawning
/datum/config_entry/keyed_list/respawn_chaos_gamemodes
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/respawn_chaos_gamemodes/ValidateListEntry(key_name, key_value)
	. = ..()
	return . && (key_name in config.modes)

/datum/config_entry/keyed_list/respawn_chaos_gamemodes/preprocess_key(key)
	. = ..()
	return lowertext(key)
