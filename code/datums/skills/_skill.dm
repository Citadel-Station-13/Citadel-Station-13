GLOBAL_LIST_INIT(skill_datums, init_skill_datums())

/proc/init_skill_datums()
	. = list()
	for(var/path in subtypesof(/datum/skill))
		var/datum/skill/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		.[S.type] = S

/proc/get_skill_datum(path)
	return GLOB.skill_datums[path]

/proc/sanitize_skill_value(path, value)
	var/datum/skill/S = get_skill_datum(path)
	// don't check, if we runtime let it happen.
	return S.sanitize_value(value)

/proc/is_skill_value_greater(path, existing, new_value)
	var/datum/skill/S = get_skill_datum(path)
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
