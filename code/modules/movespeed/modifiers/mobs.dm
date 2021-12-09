/datum/movespeed_modifier/obesity
	multiplicative_slowdown = 1.5

/datum/movespeed_modifier/monkey_reagent_speedmod
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/monkey_health_speedmod
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/monkey_temperature_speedmod
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/hunger
	variable = TRUE
	blacklisted_movetypes = FLOATING|FLYING

/datum/movespeed_modifier/slaughter
	multiplicative_slowdown = -1

/datum/movespeed_modifier/damage_slowdown
	blacklisted_movetypes = FLOATING|FLYING
	variable = TRUE

/datum/movespeed_modifier/damage_slowdown_flying
	movetypes = FLYING
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/equipment_speedmod
	variable = TRUE
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/grab_slowdown
	id = MOVESPEED_ID_MOB_GRAB_STATE
	blacklisted_movetypes = FLOATING

/datum/movespeed_modifier/grab_slowdown/aggressive
	multiplicative_slowdown = 3

/datum/movespeed_modifier/grab_slowdown/neck
	multiplicative_slowdown = 6

/datum/movespeed_modifier/grab_slowdown/kill
	multiplicative_slowdown = 9

/datum/movespeed_modifier/slime_reagentmod
	variable = TRUE

/datum/movespeed_modifier/slime_healthmod
	variable = TRUE

/datum/movespeed_modifier/config_walk_run
	multiplicative_slowdown = 1
	id = MOVESPEED_ID_MOB_WALK_RUN
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/config_walk_run/proc/sync()

/datum/movespeed_modifier/config_walk_run/walk/sync()
	var/mod = CONFIG_GET(number/movedelay/walk_delay)
	multiplicative_slowdown = isnum(mod)? mod : initial(multiplicative_slowdown)

/datum/movespeed_modifier/config_wak_run/walk/apply_multiplicative(existing, mob/target)
	. = ..()
	if(HAS_TRAIT(target, TRAIT_SPEEDY_STEP))
		. -= 1.25

/datum/movespeed_modifier/config_walk_run/run/sync()
	var/mod = CONFIG_GET(number/movedelay/run_delay)
	multiplicative_slowdown = isnum(mod)? mod : initial(multiplicative_slowdown)

/datum/movespeed_modifier/turf_slowdown
	movetypes = GROUND
	blacklisted_movetypes = (FLYING|FLOATING)
	variable = TRUE

/datum/movespeed_modifier/bulky_drag
	variable = TRUE

/datum/movespeed_modifier/cold
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/human_carry
	variable = TRUE

/datum/movespeed_modifier/limbless
	variable = TRUE
	movetypes = GROUND
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/simplemob_varspeed
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/tarantula_web
	multiplicative_slowdown = 3

/datum/movespeed_modifier/gravity
	blacklisted_movetypes = FLOATING
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/carbon_softcrit
	multiplicative_slowdown = SOFTCRIT_ADD_SLOWDOWN

/datum/movespeed_modifier/slime_tempmod
	variable = TRUE

/datum/movespeed_modifier/carbon_crawling
	multiplicative_slowdown = CRAWLING_ADD_SLOWDOWN
	movetypes = CRAWLING
	flags = IGNORE_NOSLOW
	priority = 20000

/datum/movespeed_modifier/mob_config_speedmod
	variable = TRUE
	blacklisted_movetypes = FLOATING
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/mob_config_speedmod_floating
	variable = TRUE
	movetypes = FLOATING
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/liver_cirrhosis
	blacklisted_movetypes = FLOATING
	variable = TRUE

/datum/movespeed_modifier/active_block
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/sprinting
	flags = IGNORE_NOSLOW
	blacklisted_movetypes = FLOATING
	priority = 100

/// for speed reasons this is sorta copypasty.
/datum/movespeed_modifier/sprinting/apply_multiplicative(existing, mob/target)
	. = existing
	if(target.m_intent != MOVE_INTENT_RUN)
		return
	if(isliving(target))
		var/mob/living/L = target
		if(!(L.mobility_flags & MOBILITY_STAND))
			return
	if(iscyborg(target))
		return max(1, existing - 1)
	var/static/datum/config_entry/number/movedelay/sprint_max_tiles_increase/SMTI
	if(!SMTI)
		SMTI = CONFIG_GET_ENTRY(number/movedelay/sprint_max_tiles_increase)
	var/static/datum/config_entry/number/movedelay/sprint_speed_increase/SSI
	if(!SSI)
		SSI = CONFIG_GET_ENTRY(number/movedelay/sprint_speed_increase)
	var/static/datum/config_entry/number/movedelay/sprint_absolute_max_tiles/SAMT
	if(!SAMT)
		SAMT = CONFIG_GET_ENTRY(number/movedelay/sprint_absolute_max_tiles)
	var/current_tiles = 10 / max(existing, world.tick_lag)
	var/minimum_speed = 10 / min(max(SAMT.config_entry_value, current_tiles), current_tiles + SMTI.config_entry_value)
	. = min(., max(minimum_speed, existing - SSI.config_entry_value))

/datum/movespeed_modifier/dragon_rage
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/dragon_depression
	multiplicative_slowdown = 5

/datum/movespeed_modifier/gauntlet_concussion
	multiplicative_slowdown = 5
