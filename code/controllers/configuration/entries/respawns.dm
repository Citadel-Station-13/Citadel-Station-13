/// Allows usage of respawn system
/datum/config_entry/flag/respawns_enabled
	config_entry_value = FALSE

/// Minutes before allowing respawns.
/datum/config_entry/number/respawn_delay
	config_entry_value = 15.0
	integer = FALSE

/// Minutes before allowing respawn, if user cryo'd.
/datum/config_entry/number/respawn_delay_cryo
	config_entry_value = 5.0
	integer = FALSE

/// Allows respawning as non-assistant. Overrides all others of this type.
/datum/config_entry/flag/allow_non_assistant_respawn
	config_entry_value = FALSE

/// Allows respawning as a combat role, defined as security/head.
/datum/config_entry/flag/allow_combat_role_respawn
	config_entry_value = FALSE

/// Allows respawning as the same character as a previous life
/datum/config_entry/flag/allow_same_character_respawn
	config_entry_value = FALSE

/// Observing penalizes for respawns, not just joining.
/datum/config_entry/flag/respawn_penalty_includes_observe
	config_entry_value = FALSE
