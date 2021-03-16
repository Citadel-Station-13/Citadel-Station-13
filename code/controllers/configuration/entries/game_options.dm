/datum/config_entry/number_list/repeated_mode_adjust

/datum/config_entry/keyed_list/probability
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/probability/ValidateListEntry(key_name)
	return key_name in config.modes

/datum/config_entry/keyed_list/chaos_level
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/chaos_level/ValidateListEntry(key_name)
	return key_name in config.modes

/datum/config_entry/keyed_list/max_pop
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/max_pop/ValidateListEntry(key_name)
	return key_name in config.modes

/datum/config_entry/keyed_list/min_pop
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/min_pop/ValidateListEntry(key_name, key_value)
	return key_name in config.modes

/datum/config_entry/keyed_list/continuous	// which roundtypes continue if all antagonists die
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/continuous/ValidateListEntry(key_name, key_value)
	return key_name in config.modes

/datum/config_entry/keyed_list/midround_antag	// which roundtypes use the midround antagonist system
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/midround_antag/ValidateListEntry(key_name, key_value)
	return key_name in config.modes

/datum/config_entry/keyed_list/force_antag_count
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/force_antag_count/ValidateListEntry(key_name, key_value)
	return key_name in config.modes

/datum/config_entry/keyed_list/policy
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_TEXT

/datum/config_entry/number/damage_multiplier
	config_entry_value = 1
	integer = FALSE

/datum/config_entry/number/minimal_access_threshold	//If the number of players is larger than this threshold, minimal access will be turned on.
	min_val = 0

/datum/config_entry/flag/jobs_have_minimal_access	//determines whether jobs use minimal access or expanded access.

/datum/config_entry/flag/assistants_have_maint_access

/datum/config_entry/flag/security_has_maint_access

/datum/config_entry/flag/everyone_has_maint_access

/datum/config_entry/flag/sec_start_brig	//makes sec start in brig instead of dept sec posts

/datum/config_entry/flag/force_random_names

/datum/config_entry/flag/humans_need_surnames

/datum/config_entry/flag/allow_ai	// allow ai job

/datum/config_entry/flag/allow_ai_multicam //whether the AI can use their multicam

/datum/config_entry/flag/disable_human_mood

/datum/config_entry/flag/disable_borg_flash_knockdown //Should borg flashes be capable of knocking humanoid entities down?

/datum/config_entry/flag/weaken_secborg //Brings secborgs and k9s back in-line with the other borg modules

/datum/config_entry/flag/disable_secborg	// disallow secborg module to be chosen.

/datum/config_entry/flag/disable_peaceborg

/datum/config_entry/flag/economy	//money money money money money money money money money money money money

/datum/config_entry/number/minimum_secborg_alert	//Minimum alert level for secborgs to be chosen.
	config_entry_value = 3

/datum/config_entry/number/traitor_scaling_coeff	//how much does the amount of players get divided by to determine traitors
	config_entry_value = 6
	min_val = 1

/datum/config_entry/number/brother_scaling_coeff	//how many players per brother team
	config_entry_value = 25
	min_val = 1

/datum/config_entry/number/changeling_scaling_coeff	//how much does the amount of players get divided by to determine changelings
	config_entry_value = 6
	min_val = 1

/datum/config_entry/number/ecult_scaling_coeff		//how much does the amount of players get divided by to determine e_cult
	config_entry_value = 6
	integer = FALSE
	min_val = 1

/datum/config_entry/number/security_scaling_coeff	//how much does the amount of players get divided by to determine open security officer positions
	config_entry_value = 8
	min_val = 1

/datum/config_entry/number/abductor_scaling_coeff	//how many players per abductor team
	config_entry_value = 15
	min_val = 1

/datum/config_entry/number/traitor_objectives_amount
	config_entry_value = 2
	min_val = 0

/datum/config_entry/number/brother_objectives_amount
	config_entry_value = 2
	min_val = 0

/datum/config_entry/flag/reactionary_explosions	//If we use reactionary explosions, explosions that react to walls and doors

/datum/config_entry/flag/protect_roles_from_antagonist	//If security and such can be traitor/cult/other

/datum/config_entry/flag/protect_assistant_from_antagonist	//If assistants can be traitor/cult/other

/datum/config_entry/flag/enforce_human_authority	//If non-human species are barred from joining as a head of staff

/datum/config_entry/flag/allow_latejoin_antagonists	// If late-joining players can be traitor/changeling

/datum/config_entry/flag/use_antag_rep // see game_options.txt for details

/datum/config_entry/number/antag_rep_maximum
	config_entry_value = 200
	min_val = 0

/datum/config_entry/number/default_antag_tickets
	config_entry_value = 100
	min_val = 0

/datum/config_entry/number/max_tickets_per_roll
	config_entry_value = 100
	min_val = 0

/datum/config_entry/number/midround_antag_time_check	// How late (in minutes you want the midround antag system to stay on, setting this to 0 will disable the system)
	config_entry_value = 60
	min_val = 0

/datum/config_entry/number/midround_antag_life_check	// A ratio of how many people need to be alive in order for the round not to immediately end in midround antagonist
	config_entry_value = 0.7
	integer = FALSE
	min_val = 0
	max_val = 1

/datum/config_entry/number/suicide_reenter_round_timer
	config_entry_value = 30
	min_val = 0

/datum/config_entry/number/roundstart_suicide_time_limit
	config_entry_value = 30
	min_val = 0

/datum/config_entry/number/shuttle_refuel_delay
	config_entry_value = 12000
	min_val = 0

/datum/config_entry/flag/show_game_type_odds	//if set this allows players to see the odds of each roundtype on the get revision screen

/datum/config_entry/keyed_list/roundstart_races	//races you can play as from the get go.
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/flag/join_with_mutant_humans	//players can pick mutant bodyparts for humans before joining the game

/datum/config_entry/flag/no_summon_guns		//No

/datum/config_entry/flag/no_summon_magic	//Fun

/datum/config_entry/flag/no_summon_events	//Allowed

/datum/config_entry/flag/no_summon_traumas	//!

/datum/config_entry/flag/no_intercept_report	//Whether or not to send a communications intercept report roundstart. This may be overridden by gamemodes.

/datum/config_entry/number/arrivals_shuttle_dock_window	//Time from when a player late joins on the arrivals shuttle to when the shuttle docks on the station
	config_entry_value = 55
	min_val = 30

/datum/config_entry/flag/arrivals_shuttle_require_undocked	//Require the arrivals shuttle to be undocked before latejoiners can join

/datum/config_entry/flag/arrivals_shuttle_require_safe_latejoin	//Require the arrivals shuttle to be operational in order for latejoiners to join

/datum/config_entry/string/alert_green
	config_entry_value = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/datum/config_entry/string/alert_blue_upto
	config_entry_value = "The station has received reliable information about potential threats to the station. Security staff may have weapons visible, random searches are permitted."

/datum/config_entry/string/alert_blue_downto
	config_entry_value = "Significant confirmed threats have been neutralized. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still permitted."

/datum/config_entry/string/alert_amber_upto
	config_entry_value = "There are significant confirmed threats to the station. Security staff may have weapons unholstered at all times. Random searches are allowed and advised."

/datum/config_entry/string/alert_amber_downto
	config_entry_value = "The immediate threat has passed. Security is no longer authorized to use lethal force, but may continue to have weapons drawn. Access requirements have been restored."

/datum/config_entry/string/alert_red_upto
	config_entry_value = "There is an immediate serious threat to the station. Security is now authorized to use lethal force. Additionally, access requirements on some machines have been lifted."

/datum/config_entry/string/alert_red_downto
	config_entry_value = "The station's destruction has been averted. There is still however an immediate serious threat to the station. Security is still authorized to use lethal force."

/datum/config_entry/string/alert_delta
	config_entry_value = "Destruction of the station is imminent. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

/datum/config_entry/flag/revival_pod_plants

/datum/config_entry/flag/revival_cloning

/datum/config_entry/number/revival_brain_life
	config_entry_value = -1
	min_val = -1

/datum/config_entry/flag/ooc_during_round

/datum/config_entry/flag/emojis

/datum/config_entry/keyed_list/multiplicative_movespeed
	key_mode = KEY_MODE_TYPE
	value_mode = VALUE_MODE_NUM
	abstract_type = /datum/config_entry/keyed_list/multiplicative_movespeed

/datum/config_entry/keyed_list/multiplicative_movespeed/ValidateAndSet()
	. = ..()
	if(.)
		update_config_movespeed_type_lookup(TRUE)

/datum/config_entry/keyed_list/multiplicative_movespeed/vv_edit_var(var_name, var_value)
	. = ..()
	if(. && (var_name == NAMEOF(src, config_entry_value)))
		update_config_movespeed_type_lookup(TRUE)

/datum/config_entry/keyed_list/multiplicative_movespeed/normal
	name = "multiplicative_movespeed"
	config_entry_value = list(			//DEFAULTS
	/mob/living/simple_animal = 1,
	/mob/living/silicon/pai = 1,
	/mob/living/carbon/alien/humanoid/sentinel = 0.25,
	/mob/living/carbon/alien/humanoid/drone = 0.5,
	/mob/living/carbon/alien/humanoid/royal/praetorian = 1,
	/mob/living/carbon/alien/humanoid/royal/queen = 3
	)

/datum/config_entry/keyed_list/multiplicative_movespeed/floating
	name = "multiplicative_movespeed_floating"
	config_entry_value = list(
		/mob/living = 0,
		/mob/living/carbon/alien/humanoid = 0,
		/mob/living/carbon/alien/humanoid/royal/praetorian = 0,
		/mob/living/carbon/alien/humanoid/royal/queen = 2
	)

/datum/config_entry/number/movedelay	//Used for modifying movement speed for mobs.
	abstract_type = /datum/config_entry/number/movedelay
	integer = FALSE

/datum/config_entry/number/movedelay/ValidateAndSet()
	. = ..()
	if(.)
		update_mob_config_movespeeds()

/datum/config_entry/number/movedelay/vv_edit_var(var_name, var_value)
	. = ..()
	if(. && (var_name == NAMEOF(src, config_entry_value)))
		update_mob_config_movespeeds()

/datum/config_entry/number/movedelay/run_delay

/datum/config_entry/number/movedelay/run_delay/ValidateAndSet()
	. = ..()
	var/datum/movespeed_modifier/config_walk_run/M = get_cached_movespeed_modifier(/datum/movespeed_modifier/config_walk_run/run)
	M.sync()

/datum/config_entry/number/movedelay/walk_delay

/datum/config_entry/number/movedelay/walk_delay/ValidateAndSet()
	. = ..()
	var/datum/movespeed_modifier/config_walk_run/M = get_cached_movespeed_modifier(/datum/movespeed_modifier/config_walk_run/walk)
	M.sync()

/datum/config_entry/flag/sprint_enabled
	config_entry_value = TRUE

/datum/config_entry/flag/sprint_enabled/ValidateAndSet(str_val)
	. = ..()
	for(var/datum/hud/human/H)
		H.assert_move_intent_ui()
	if(!config_entry_value)		// disabled
		for(var/mob/living/L in world)
			L.disable_intentional_sprint_mode()

/datum/config_entry/number/movedelay/sprint_speed_increase
	config_entry_value = 1

/datum/config_entry/number/movedelay/sprint_max_tiles_increase
	config_entry_value = 5

/datum/config_entry/number/movedelay/sprint_absolute_max_tiles
	config_entry_value = 13

/datum/config_entry/number/movedelay/sprint_buffer_max
	config_entry_value = 24

/datum/config_entry/number/movedelay/sprint_stamina_cost
	config_entry_value = 1.4

/datum/config_entry/number/movedelay/sprint_buffer_regen_per_ds
	config_entry_value = 0.4

/////////////////////////////////////////////////Outdated move delay
/datum/config_entry/number/outdated_movedelay
	deprecated_by = /datum/config_entry/keyed_list/multiplicative_movespeed/normal
	abstract_type = /datum/config_entry/number/outdated_movedelay

	var/movedelay_type

/datum/config_entry/number/outdated_movedelay/DeprecationUpdate(value)
	return "[movedelay_type] [value]"

/datum/config_entry/number/outdated_movedelay/human_delay
	movedelay_type = /mob/living/carbon/human
/datum/config_entry/number/outdated_movedelay/robot_delay
	movedelay_type = /mob/living/silicon/robot
/datum/config_entry/number/outdated_movedelay/monkey_delay
	movedelay_type = /mob/living/carbon/monkey
/datum/config_entry/number/outdated_movedelay/alien_delay
	movedelay_type = /mob/living/carbon/alien
/datum/config_entry/number/outdated_movedelay/slime_delay
	movedelay_type = /mob/living/simple_animal/slime
/datum/config_entry/number/outdated_movedelay/animal_delay
	movedelay_type = /mob/living/simple_animal
/////////////////////////////////////////////////

/datum/config_entry/flag/roundstart_away	//Will random away mission be loaded.

/datum/config_entry/flag/roundstart_vr 		//Will virtual reality missions be loaded?

/datum/config_entry/number/gateway_delay	//How long the gateway takes before it activates. Default is half an hour. Only matters if roundstart_away is enabled.
	config_entry_value = 18000
	min_val = 0

/datum/config_entry/flag/ghost_interaction

/datum/config_entry/flag/silent_ai
/datum/config_entry/flag/silent_borg

/datum/config_entry/flag/sandbox_autoclose	// close the sandbox panel after spawning an item, potentially reducing griff

/datum/config_entry/number/default_laws //Controls what laws the AI spawns with.
	config_entry_value = 0
	min_val = 0
	max_val = 3

/datum/config_entry/number/silicon_max_law_amount
	config_entry_value = 12
	min_val = 0

/datum/config_entry/keyed_list/random_laws
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/law_weight
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	splitter = ","

/datum/config_entry/number/overflow_cap
	config_entry_value = -1
	min_val = -1

/datum/config_entry/string/overflow_job
	config_entry_value = "Assistant"

/datum/config_entry/flag/starlight
/datum/config_entry/flag/grey_assistants

/datum/config_entry/number/lavaland_budget
	config_entry_value = 60
	min_val = 0

/datum/config_entry/number/space_budget
	config_entry_value = 16
	min_val = 0

/datum/config_entry/number/icemoon_budget
	config_entry_value = 90
	integer = FALSE
	min_val = 0

/datum/config_entry/number/station_space_budget
	config_entry_value = 10
	min_val = 0

/datum/config_entry/flag/allow_random_events	// Enables random events mid-round when set

/datum/config_entry/number/events_min_time_mul	// Multipliers for random events minimal starting time and minimal players amounts
	config_entry_value = 1
	min_val = 0
	integer = FALSE

/datum/config_entry/number/events_min_players_mul
	config_entry_value = 1
	min_val = 0
	integer = FALSE

/datum/config_entry/number/mice_roundstart
	config_entry_value = 10
	min_val = 0

/datum/config_entry/number/bombcap
	config_entry_value = 14
	min_val = 4

/datum/config_entry/number/bombcap/ValidateAndSet(str_val)
	. = ..()
	if(.)
		GLOB.MAX_EX_DEVESTATION_RANGE = round(config_entry_value / 4)
		GLOB.MAX_EX_HEAVY_RANGE = round(config_entry_value / 2)
		GLOB.MAX_EX_LIGHT_RANGE = config_entry_value
		GLOB.MAX_EX_FLASH_RANGE = config_entry_value
		GLOB.MAX_EX_FLAME_RANGE = config_entry_value

/datum/config_entry/number/emergency_shuttle_autocall_threshold
	min_val = 0
	max_val = 1
	integer = FALSE

/datum/config_entry/flag/ic_printing

/datum/config_entry/flag/roundstart_traits

/datum/config_entry/flag/enable_night_shifts

/datum/config_entry/number/night_shift_public_areas_only
	config_entry_value = NIGHTSHIFT_AREA_PUBLIC

/datum/config_entry/flag/nightshift_toggle_requires_auth
	config_entry_value = FALSE

/datum/config_entry/flag/nightshift_toggle_public_requires_auth
	config_entry_value = TRUE

/datum/config_entry/flag/randomize_shift_time

/datum/config_entry/flag/shift_time_realtime

/datum/config_entry/keyed_list/antag_rep
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/job_threat
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/keyed_list/antag_threat
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM

/datum/config_entry/number/monkeycap
	config_entry_value = 64
	min_val = 0

/datum/config_entry/number/ratcap
	config_entry_value = 64
	min_val = 0

/datum/config_entry/flag/disable_stambuffer

/datum/config_entry/keyed_list/box_random_engine
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	lowercase = FALSE
	splitter = ","

/datum/config_entry/flag/pai_custom_holoforms

/datum/config_entry/number/marauder_delay_non_reebe
	config_entry_value = 1800
	min_val = 0

/datum/config_entry/flag/allow_clockwork_marauder_on_station
	config_entry_value = TRUE

/datum/config_entry/flag/modetier_voting

/datum/config_entry/flag/must_be_readied_to_vote_gamemode

/datum/config_entry/number/dropped_modes
	config_entry_value = 3

/datum/config_entry/flag/suicide_allowed

/datum/config_entry/keyed_list/breasts_cups_prefs
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
	config_entry_value = list("a", "b", "c", "d", "e") //keep these lowercase

/datum/config_entry/number/penis_min_inches_prefs
	config_entry_value = 1
	min_val = 0

/datum/config_entry/number/penis_max_inches_prefs
	config_entry_value = 20
	min_val = 0

/datum/config_entry/keyed_list/safe_visibility_toggles
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
	config_entry_value = list(GEN_VISIBLE_NO_CLOTHES, GEN_VISIBLE_NO_UNDIES, GEN_VISIBLE_NEVER) //refer to cit_helpers for all toggles.

//Body size configs, the feature will be disabled if both min and max have the same value.
/datum/config_entry/number/body_size_min
	config_entry_value = 0.9
	min_val = 0.1 //to avoid issues with zeros and negative values.
	max_val = RESIZE_DEFAULT_SIZE
	integer = FALSE

/datum/config_entry/number/body_size_max
	config_entry_value = 1.25
	min_val = RESIZE_DEFAULT_SIZE
	integer = FALSE

//Penalties given to characters with a body size smaller than this value,
//to compensate for their smaller hitbox.
//To disable, just make sure the value is lower than 'body_size_min'
/datum/config_entry/number/threshold_body_size_penalty
	config_entry_value = RESIZE_DEFAULT_SIZE
	min_val = 0
	max_val = RESIZE_DEFAULT_SIZE
	integer = FALSE

//multiplicative slowdown multiplier. See 'dna.update_body_size' for the operation.
//doesn't apply to floating or crawling mobs
/datum/config_entry/number/body_size_slowdown_multiplier
	config_entry_value = 0
	min_val = 0
	integer = FALSE

//Allows players to set a hexadecimal color of their choice as skin tone, on top of the standard ones.
/datum/config_entry/flag/allow_custom_skintones

///Initial loadout points
/datum/config_entry/number/initial_gear_points
	config_entry_value = 10

/**
  * Enables the FoV component, which hides objects and mobs behind the parent from their sight, unless they turn around, duh.
  * Camera mobs, AIs, ghosts and some other are of course exempt from this. This also doesn't influence simplemob AI, for the best.
  */
/datum/config_entry/flag/use_field_of_vision

//Shuttle size limiter
/datum/config_entry/number/max_shuttle_count
	config_entry_value = 6

/datum/config_entry/number/max_shuttle_size
	config_entry_value = 500

//wound config stuff (increases the max injury roll, making injuries more likely)
/datum/config_entry/number/wound_exponent
	config_entry_value = WOUND_DAMAGE_EXPONENT
	min_val = 0
	integer = FALSE

//adds a set amount to any injury rolls on a limb using get_damage() multiplied by this number
/datum/config_entry/number/wound_damage_multiplier
	config_entry_value = 0.333
	min_val = 0
	integer = FALSE

/// Amount of dirtyness tiles need to spawn dirt.
/datum/config_entry/number/turf_dirt_threshold
	config_entry_value = 100
	min_val = 1
	integer = TRUE

/// Alpha dirt starts at
/datum/config_entry/number/dirt_alpha_starting
	config_entry_value = 127
	max_val = 255
	min_val = 0
	integer = TRUE

/// Dirtyness multiplier for making turfs dirty
/datum/config_entry/number/turf_dirty_multiplier
	config_entry_value = 1

/datum/config_entry/flag/weigh_by_recent_chaos

/datum/config_entry/number/chaos_exponent
	config_entry_value = 1
