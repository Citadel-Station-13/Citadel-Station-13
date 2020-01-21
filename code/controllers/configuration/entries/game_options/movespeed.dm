/datum/config_entry/keyed_list/multiplicative_movespeed
	key_mode = KEY_MODE_TYPE
	value_mode = VALUE_MODE_NUM
	config_entry_value = list(			//DEFAULTS
	/mob/living/simple_animal = 1,
	/mob/living/silicon/pai = 1,
	/mob/living/carbon/alien/humanoid/hunter = -1,
	/mob/living/carbon/alien/humanoid/royal/praetorian = 1,
	/mob/living/carbon/alien/humanoid/royal/queen = 3
	)

/datum/config_entry/keyed_list/multiplicative_movespeed/ValidateAndSet()
	. = ..()
	if(.)
		update_config_movespeed_type_lookup(TRUE)

/datum/config_entry/keyed_list/multiplicative_movespeed/vv_edit_var(var_name, var_value)
	. = ..()
	if(. && (var_name == NAMEOF(src, config_entry_value)))
		update_config_movespeed_type_lookup(TRUE)

/datum/config_entry/number/movedelay	//Used for modifying movement speed for mobs.
	abstract_type = /datum/config_entry/number/movedelay

/datum/config_entry/number/movedelay/ValidateAndSet()
	. = ..()
	if(.)
		update_mob_config_movespeeds()

/datum/config_entry/number/movedelay/vv_edit_var(var_name, var_value)
	. = ..()
	if(. && (var_name == NAMEOF(src, config_entry_value)))
		update_mob_config_movespeeds()

/datum/config_entry/number/movedelay/run_delay

/datum/config_entry/number/movedelay/walk_delay

/////////////////////////////////////////////////Outdated move delay
/datum/config_entry/number/outdated_movedelay
	deprecated_by = /datum/config_entry/keyed_list/multiplicative_movespeed
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