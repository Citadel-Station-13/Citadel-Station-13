/datum/config_entry/number/stamina_combat
	integer = FALSE
	abstract_type = /datum/config_entry/number/stamina_combat

/// Maximum stamina buffer
/datum/config_entry/number/stamina_combat/buffer_max
	default = 25

/// Seconds until percent_regeneration_out_of_combat kicks in
/datum/config_entry/number/stamina_combat/out_of_combat_timer
	default = 15

/// Base regeneration per second
/datum/config_entry/number/stamina_combat/base_regeneration
	default = 3.5

/// After out_of_combat_timer elapses, additionally regenerate this percent of total stamina per second. Unaffected by combat mode.
/datum/config_entry/number/stamina_combat/percent_regeneration_out_of_combat
	default = 30

/// Seconds after an action for which your regeneration is penalized
/datum/config_entry/number/stamina_combat/post_action_penalty_delay
	default = 5

/// Factor to multiply by for penalizing post-action-stamina-regen
/datum/config_entry/number/stamina_combat/post_action_penalty_factor
	default = 0.25

/// Factor to multiply by for stamina usage past buffer into health
/datum/config_entry/number/stamina_combat/overdraw_penalty_factor
	default = 1.5

/datum/config_entry/flag/disable_stambuffer
