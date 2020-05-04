GLOBAL_LIST_INIT(skill_datums, init_skill_datums())

/proc/init_skill_datums()
	. = list()
	for(var/path in subtypesof(/datum/skill))
		var/datum/skill/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		.[S.type] = S

/proc/sanitize_skill_value(path, value)
	var/datum/skill/S = GET_SKILL_DATUM(path)
	// don't check, if we runtime let it happen.
	return S.sanitize_value(value)

/proc/is_skill_value_greater(path, existing, new_value)
	var/datum/skill/S = GET_SKILL_DATUM(path)
	// don't check, if we runtime let it happen.
	return S.is_value_greater(existing, new_value)

/**
  * Skill datums
  */
/datum/skill
	/// Our name
	var/name
	/// Our description
	var/desc
	/// Color of the name as shown in the html readout
	var/name_color = "#000000"
	/// Our progression type
	var/progression_type
	/// Abstract type
	var/abstract_type = /datum/skill

/**
  * Ensures what someone's setting as a value for this skill is valid.
  */
/datum/skill/proc/sanitize_value(new_value)
	return new_value

/**
  * Sets the new value of this skill in the holder skills list.
  * As well as possible feedback messages or secondary effects on value change, that's on you.
  */
/datum/skill/proc/set_skill(datum/skill_holder/H, value, mob/owner)
	H.skills[type] = value

/**
  * Checks if a value is greater
  */
/datum/skill/proc/is_value_greater(existing, new_value)
	if(!existing)
		return TRUE
	return new_value > existing

/**
  * Standard value "render"
  */
/datum/skill/proc/standard_render_value(value)
	return value

// Just saying, the choice to use different sub-parent-types is to force coders to resolve issues as I won't be implementing custom procs to grab skill levels in a certain context.
// Aka: So people don't forget to change checks if they change a skill's progression type.

/datum/skill/binary
	abstract_type = /datum/skill/binary
	progression_type = SKILL_PROGRESSION_BINARY

/datum/skill/binary/sanitize_value(new_value)
	return new_value? TRUE : FALSE

/datum/skill/binary/standard_render_value(value)
	return value? "Yes" : "No"

/datum/skill/numerical
	abstract_type = /datum/skill/numerical
	progression_type = SKILL_PROGRESSION_NUMERICAL
	/// Max value of this skill
	var/max_value = 100
	/// Min value of this skill
	var/min_value = 0
	/// Display as a percent in standard_render_value?
	var/display_as_percent = FALSE

/datum/skill/numerical/sanitize_value(new_value)
	return clamp(new_value, min_value, max_value)

/datum/skill/numerical/standard_render_value(value)
	return display_as_percent? "[round(value/max_value/100, 0.01)]%" : "[value] / [max_value]"

/datum/skill/enum
	abstract_type = /datum/skill/enum
	progression_type = SKILL_PROGRESSION_ENUM
	/// Valid values for the skill
	var/list/valid_values = list()

/datum/skill/enum/sanitize_value(new_value)
	if(new_value in valid_values)
		return new_value

/**
  * Classing r p g styled skills, tiered by lvl, and current/nextlvl experience.
  */
/datum/skill/experience
	abstract_type = /datum/skill/experience
	var/standard_xp_lvl_up = STD_XP_LVL_UP //the standard required to level up. def: 100
	var/xp_lvl_multiplier = STD_XP_LVL_UP //standard required level up exp multiplier. def: 2 (100, 200, 400, 800 etc.)
	var/max_lvl = STD_MAX_LVL
	var/level_up_method = STANDARD_LEVEL_UP //how levels are calculated.
	var/list/levels = list() //level thresholds, if associative, these will be preceded by tiers such as "novice" or "trained"
	var/associative = FALSE //See above.
	var/unskilled_tier = "Unskilled" //Only relevant for associative experience levels

//Builds the levels list.
/datum/skill/experience/New()
	. = ..()
	var/max_assoc = ""
	var/max_assoc_start = 1
	for(var/lvl in 1 to max_lvl)
		var/value
		switch(level_up_method)
			if(STANDARD_LEVEL_UP)
				value = XP_LEVEL(standard_xp_lvl_up, xp_lvl_multiplier, lvl)
			if(DWARFY_LEVEL_UP)
				value = DORF_XP_LEVEL(standard_xp_lvl_up, xp_lvl_multiplier, lvl)
		value = round(value)
		if(!associative)
			levels += value
			continue
		if(max_assoc)
			levels["[max_assoc] +[max_assoc_start++]"] = value
			continue
		var/key = LAZYACCESS(levels, lvl)
		if(!key)
			if(lvl == 1) //You dun goof it.
				stack_trace("Skill datum [src] was set to have an associative levels list despite the latted having no key.")
				associative = FALSE
				levels += value
				continue
			max_assoc = levels[lvl-1]
			levels["[max_assoc] +[max_assoc_start++]"] = value
		levels[key] = value


/datum/skill/experience/sanitize_value(new_value)
	return round(max(new_value, 0))

/datum/skill/experience/set_skill(datum/skill_holder/H, value, mob/owner)
	var/old_value = H.skills[type]
	H.skills[type] = value
	if(value > old_value)

/datum/skill/experience/standard_render_value(value)
	var/current_lvl = associative ? unskilled_tier : 0
	var/current_lvl_xp_sum = 0
	var/next_lvl_xp_sum
	for(var/lvl in 1 to max_lvl)
		next_lvl_xp_sum = associative ? levels[levels[lvl]] : levels[lvl]
		if(value < next_lvl_xp_sum)
			break
		current_lvl_xp_sum = next_lvl_xp_sum
		current_lvl = associative ? levels[lvl] : current_lvl+1

	return "[associative ? current_lvl : "Lvl. [current_lvl]"] ([value - current_lvl_xp_sum]/[next_lvl_xp_sum])[value > next_lvl_xp_sum ? " \[MAX!\]" : ""]"

/datum/skill/experience/job
	levels = ("Basic", "Trained", "Experienced", "Master")
	associative = TRUE

//quite the reference, no?
/datum/skill/experience/dwarfy
	abstract_type = /datum/skill/experience/dwarfy
	standard_xp_lvl_up = DORF_XP_LVL_UP
	xp_lvl_multiplier = DORF_XP_LVL_MULTI
	max_lvl = DORF_MAX_LVL
	levels = list("Novice", "Adequate", "Competent", "Skilled",
				"Proficient", "Talented", "Adept", "Expert",
				"Professional", "Accomplished", "Great", "Master",
				"High Master", "Grand Master", "Legendary")
	associative = TRUE
	unskilled_tier = "Dabbling"
