GLOBAL_LIST_INIT_TYPED(skill_datums, /datum/skill, init_skill_datums())

/proc/init_skill_datums()
	. = list()
	for(var/path in subtypesof(/datum/skill))
		var/datum/skill/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		.[S.type] = S

/**
  * Skill datums
  */

/datum/skill
	/// Our name
	var/name
	/// Our description
	var/desc
	/// Color of the name as shown in the html readout
	var/name_color = "#F0F0F0" // White on dark surface.
	/// Our progression type. These are mostly used to skip typechecks overhead, don't go around messing with these.
	var/progression_type
	/// Abstract type
	var/abstract_type = /datum/skill
	/// List of max levels. Only used in level skills, but present here for helper macros.
	var/max_levels = INFINITY
	/// skill threshold used in generic skill competency operations.
	var/list/competency_thresholds
	/// Base multiplier used in skill competency operations.
	var/base_multiplier = 1
	/// Value added to the base multiplier depending on overall competency compared to maximum value/level.
	var/competency_multiplier = 1
	/// A list of ways this skill can affect or be affected through actions and skill modifiers.
	var/list/skill_traits = list(SKILL_SANITY, SKILL_INTELLIGENCE)

/**
  * Ensures what someone's setting as a value for this skill is valid.
  */
/datum/skill/proc/sanitize_value(new_value)
	return new_value

/**
  * Sets the new value of this skill in the holder skills list.
  * As well as possible feedback messages or secondary effects on value change, that's on you.
  */
/datum/skill/proc/set_skill_value(datum/skill_holder/H, value, mob/owner)
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
/datum/skill/proc/standard_render_value(value, level)
	return value

// Just saying, the choice to use different sub-parent-types is to force coders to resolve issues as I won't be implementing custom procs to grab skill levels in a certain context.
// Aka: So people don't forget to change checks if they change a skill's progression type.

/datum/skill/binary
	abstract_type = /datum/skill/binary
	progression_type = SKILL_PROGRESSION_BINARY
	competency_thresholds = list(THRESHOLD_COMPETENT = FALSE, THRESHOLD_EXPERT = TRUE, THRESHOLD_MASTER = TRUE)

/datum/skill/binary/sanitize_value(new_value)
	return new_value? TRUE : FALSE

/datum/skill/binary/standard_render_value(value, level)
	return value? "Yes" : "No"

/datum/skill/numerical
	abstract_type = /datum/skill/numerical
	progression_type = SKILL_PROGRESSION_NUMERICAL
	competency_thresholds = list(THRESHOLD_COMPETENT = 25, THRESHOLD_EXPERT = 50, THRESHOLD_MASTER = 75)
	/// Max value of this skill
	var/max_value = 100
	/// Min value of this skill
	var/min_value = 0
	/// Display as a percent in standard_render_value?
	var/display_as_percent = FALSE

/datum/skill/numerical/sanitize_value(new_value)
	return clamp(new_value, min_value, max_value)

/datum/skill/numerical/standard_render_value(value, level)
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
/datum/skill/level
	abstract_type = /datum/skill/level
	progression_type = SKILL_PROGRESSION_LEVEL
	max_levels = STD_MAX_LVL
	var/standard_xp_lvl_up = STD_XP_LVL_UP //the standard required to level up. def: 100
	var/xp_lvl_multiplier = STD_XP_LVL_MULTI //standard required level up exp multiplier. def: 2 (100, 200, 400, 800 etc.)
	var/level_up_method = STANDARD_LEVEL_UP //how levels are calculated.
	var/list/levels = list() //level thresholds, if associative, these will be preceded by tiers such as "novice" or "trained"
	var/associative = FALSE //See above.
	var/unskilled_tier = "Unskilled" //Only relevant for associative experience levels

//Builds the levels list.
/datum/skill/level/New()
	. = ..()
	var/max_assoc = ""
	var/max_assoc_start = 1
	for(var/lvl in 1 to max_levels)
		var/value
		switch(level_up_method)
			if(STANDARD_LEVEL_UP)
				value = XP_LEVEL(standard_xp_lvl_up, xp_lvl_multiplier, lvl)
			if(DWARFY_LEVEL_UP)
				value = DORF_XP_LEVEL(standard_xp_lvl_up, xp_lvl_multiplier, lvl)
		value = round(value, 1)
		if(!associative)
			levels += value
			continue
		if(max_assoc)
			levels["[max_assoc] +[max_assoc_start++]"] = value
			continue
		var/key = LAZYACCESS(levels, lvl)
		if(!key)
			if(lvl == 1) //You dun goof it.
				stack_trace("Skill datum [src] was set to have an associative levels list despite the latter having no key value.")
				associative = FALSE
				levels += value
				continue
			max_assoc = levels[lvl-1]
			levels["[max_assoc] +[max_assoc_start++]"] = value
		levels[key] = value

/datum/skill/level/sanitize_value(new_value)
	return max(new_value, 0)

/datum/skill/level/set_skill_value(datum/skill_holder/H, value, datum/mind/M, silent = FALSE)
	H.skills[type] = value
	var/new_level
	for(var/k in levels)
		if(value < (associative ? levels[k] : k))
			break
		new_level++
	var/old_level = LAZYACCESS(H.skill_levels, type)
	LAZYSET(H.skill_levels, type, new_level)
	. = new_level - old_level
	if(silent || !(M?.current))
		return
	if(. > 0)
		to_chat(M.current, "<span class='nicegreen'>I feel like I've become more proficient at [name]!</span>")
	else if(. < 0)
		to_chat(M.current, "<span class='warning'>I feel like I've become worse at [name]!</span>")

/datum/skill/level/standard_render_value(value, level)
	var/current_lvl = associative ? (!level ? unskilled_tier : levels[level]) : level
	var/current_lvl_xp_sum = 0
	if(level)
		current_lvl_xp_sum = associative ? levels[levels[level]] : levels[level]
	var/next_index = min(max_levels, level+1)
	var/next_lvl_xp = associative ? levels[levels[next_index]] : levels[next_index]
	if(next_lvl_xp > current_lvl_xp_sum)
		next_lvl_xp -= current_lvl_xp_sum

	return "[associative ? current_lvl : "Lvl. [current_lvl]"] ([value - current_lvl_xp_sum]/[next_lvl_xp])[level == max_levels ? " \[MAX!\]" : ""]"

/datum/skill/level/job
	abstract_type = /datum/skill/level/job
	levels = list("Basic", "Trained", "Experienced", "Master")
	competency_thresholds = list(THRESHOLD_COMPETENT = JOB_SKILL_TRAINED, THRESHOLD_EXPERT = JOB_SKILL_EXPERT, THRESHOLD_MASTER = JOB_SKILL_MASTER)
	associative = TRUE

//quite the reference, no?
/datum/skill/level/dwarfy
	abstract_type = /datum/skill/level/dwarfy
	standard_xp_lvl_up = DORF_XP_LVL_UP
	xp_lvl_multiplier = DORF_XP_LVL_MULTI
	max_levels = DORF_MAX_LVL
	level_up_method = DWARFY_LEVEL_UP
	levels = list("Novice", "Adequate", "Competent", "Skilled",
				"Proficient", "Talented", "Adept", "Expert",
				"Professional", "Accomplished", "Great", "Master",
				"High Master", "Grand Master", "Legendary")
	competency_thresholds = list(THRESHOLD_COMPETENT = DORF_SKILL_COMPETENT, THRESHOLD_EXPERT = DORF_SKILL_EXPERT, THRESHOLD_MASTER = DORF_SKILL_MASTER)
	associative = TRUE
	unskilled_tier = "Dabbling"
