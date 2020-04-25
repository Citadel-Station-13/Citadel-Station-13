/**
  * Skill holder datums
  */
/datum/skill_holder
	/// Our list of skills and values. Lazylist. Associative. Keys are datum typepaths to the skill.
	var/list/skills
	/// Same as [skills] but affinities, which are multiplied to increase amount when gaining skills.
	var/list/skill_affinities

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
  * Grabs our affinity for a skill. !!This is a multiplier!!
  */
/datum/skill_holder/proc/get_skill_affinity(skill)
	if(!ispath(skill))
		CRASH("Invalid get_skill_affinity call. Use typepaths.")		//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	if(!skills)
		return 1
	var/affinity = skill_affinities[skill]
	if(isnull(affinity))
		return 1
	return affinity

/**
  * Sets the value of a skill.
  */
/datum/skill_holder/proc/set_skill_value(skill, value)
	if(!ispath(skill))
		CRASH("Invalid set_skill_value call. Use typepaths.")		//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	LAZYINITLIST(skills)
	value = sanitize_skill_value(skill, value)
	if(!isnull(value))
		skills[skill] = value
		return TRUE
	return FALSE

/**
  * Boosts a skill to a value if not aobve
  */
/datum/skill_holder/proc/boost_skill_value_to(skill, value)
	var/current = get_skill_value(skill)
	if(!is_skill_value_greater(skill, current, value))
		return FALSE
	set_skill_value(skill, value)
	return TRUE

/**
  * Automatic skill increase, multiplied by skill affinity if existing.
  * Only works if skill is numerical.
  */
/datum/skill_holder/proc/auto_gain_experience(skill, value)
	if(!ispath(skill, /datum/skill/numerical))
		CRASH("You cannot auto increment a non numerical skill!")
	var/current = get_skill_value(skill)
	var/affinity = get_skill_affinity(skill)
	boost_skill_value_to(skill, current + (value * affinity))

/**
  * Generates a HTML readout of our skills.
  * Port to tgui-next when?
  */
/datum/skill_holder/proc/html_readout()
	var/list/out = list("<center><h1>Skills</h1></center><hr>")
	out += "<table style=\"width:100%\"><tr><th><b>Skill</b><th><b>Value</b></tr>"
	for(var/path in skills)
		var/datum/skill/S = GLOB.skill_datums[path]
		out += "<tr><td>[S.name]</td><td>[S.standard_render_value(skills[path])]</td></tr>"
	out += "</table>"
	return out.Join("")
