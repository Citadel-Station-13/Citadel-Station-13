/**
  * Skill holder datums
  */
/datum/skill_holder
	var/datum/mind/owner
	/// Our list of skills and values. Lazylist. Associative. Keys are datum typepaths to the skill.
	var/list/skills
	/// Same as [skills] but affinities, which are multiplied to increase amount when gaining skills.
	var/list/skill_affinities
	/// Let's say we want to get a specific skill "level" without looping through a proc everytime.
	/// Only supported by skills with tiers or levels.
	var/list/skill_levels

/datum/skill_holder/New(datum/mind/M)
	. = ..()
	owner = M

/**
  * Grabs the value of a skill.
  */
/datum/skill_holder/proc/get_skill_value(skill)
	if(!ispath(skill))
		CRASH("Invalid get_skill_value call. Use typepaths.")		//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	if(!skills)
		return null
	return skills[skill]

/**
  * Grabs the level of a skill. Only supported by skills with tiers or levels.
  */
/datum/skill_holder/proc/get_skill_level(skill)
	if(!ispath(skill))
		CRASH("Invalid get_skill_value call. Use typepaths.")		//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	if(!skill_levels)
		return 0
	return skill_levels[skill]

/**
  * Grabs our affinity for a skill. !!This is a multiplier!!
  */
/datum/skill_holder/proc/get_skill_affinity(skill)
	if(!ispath(skill))
		CRASH("Invalid get_skill_affinity call. Use typepaths.")		//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	var/affinity = LAZYACCESS(skill_affinities, skill)
	if(isnull(affinity))
		return 1
	return affinity

/**
  * Sets the value of a skill.
  */
/datum/skill_holder/proc/set_skill_value(skill, value, silent = FALSE)
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid set_skill_value call. Use typepaths.")		//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	var/datum/skill/S = GLOB.skill_datums[skill]
	value = S.sanitize_value(value)
	if(!isnull(value))
		LAZYINITLIST(skills)
		S.set_skill_value(src, value, owner, silent)
		return TRUE
	return FALSE

/**
  * Boosts a skill to a value if not aobve
  */
/datum/skill_holder/proc/boost_skill_value_to(skill, value, silent = FALSE)
	var/current = get_skill_value(skill)
	if(!is_skill_value_greater(skill, current, value))
		return FALSE
	set_skill_value(skill, value, silent)
	return TRUE

/**
  * Automatic skill increase, multiplied by skill affinity if existing.
  * Only works if skill is numerical.
  */
/datum/skill_holder/proc/auto_gain_experience(skill, value, maximum, silent = FALSE)
	if(!ispath(skill, /datum/skill/numerical))
		CRASH("You cannot auto increment a non numerical skill!")
	var/current = get_skill_value(skill)
	var/affinity = get_skill_affinity(skill)
	var/target_value = current + (value * affinity)
	if(maximum)
		target_value = max(target_value, maximum)
		if(target_value == maximum) //no more experience to gain, early return.
			return
	boost_skill_value_to(skill, target_value, silent)

/**
  * Generates a HTML readout of our skills.
  * Port to tgui-next when?
  */
/datum/skill_holder/proc/html_readout()
	var/list/out = list("<center><h1>Skills</h1></center><hr>")
	out += "<table style=\"width:100%\"><tr><th><b>Skill</b><th><b>Value</b></tr>"
	for(var/path in skills)
		var/datum/skill/S = GLOB.skill_datums[path]
		out += "<tr><td><font color='[S.name_color]'>[S.name]</font></td><td>[S.standard_render_value(skills[path])]</td></tr>"
	out += "</table>"
	return out.Join("")
