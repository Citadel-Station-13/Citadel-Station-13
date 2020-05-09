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
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid get_skill_value call. Use skill typepaths.")	//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	if(!skill_levels)
		return 0
	return skill_levels[skill]

/**
  * Grabs our affinity for a skill. !!This is a multiplier!!
  */
/datum/skill_holder/proc/get_skill_affinity(skill)
	. = 1
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid get_skill_affinity call. Use skill typepaths.")	//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	var/affinity = LAZYACCESS(skill_affinities, skill)
	if(!isnull(affinity))
		. = affinity
	var/list/wrapped = list(.)
	SEND_SIGNAL(owner.current, COMSIG_MOB_SKILL_GET_AFFINITY, skill, wrapped)
	. = wrapped[1]


/**
  * Sets the value of a skill.
  */
/datum/skill_holder/proc/set_skill_value(skill, value, silent = FALSE)
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid set_skill_value call. Use skill typepaths.")	//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
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
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid set_skill_value call. Use skill typepaths.")
	var/datum/skill/S = GLOB.skill_datums[skill]
	if(S.progression_type != SKILL_PROGRESSION_NUMERICAL && S.progression_type != SKILL_PROGRESSION_LEVEL)
		CRASH("You cannot auto increment a non numerical(experience skill!")
	var/current = get_skill_value(skill)
	var/affinity = get_skill_affinity(skill)
	var/target_value = current + (value * affinity)
	if(maximum)
		target_value = max(target_value, maximum)
		if(target_value == maximum) //no more experience to gain, early return.
			return
	boost_skill_value_to(skill, target_value, silent)

/**
  * Generic value modifier proc that uses one skill.
  * Args:
  * * value : the value to modify, may be a delay, damage, probability.
  * * threshold : The difficulty of the action, in short. Refer to __DEFINES/skills/defines.dm for the defines.
  * * modifier_is_multiplier : wheter the modifier is a multiplier or a divisor.
  */
/datum/skill_holder/proc/action_skills_mod(skill, value, threshold, modifier_is_multiplier = TRUE)
	var/mod
	var/datum/skill/S = GLOB.skill_datums[skill]
	if(!S)
		return
	switch(S.progression_type)
		if(SKILL_PROGRESSION_LEVEL)
			mod = LAZYACCESS(skill_levels, S.type)
		else
			mod = LAZYACCESS(skills, S.type)
	mod = (1+(mod-S.competency_thresholds[threshold])*S.competency_mults[threshold])

	var/list/comsig_values = list(mod)
	SEND_SIGNAL(owner.current, COMSIG_MOB_ACTION_SKILL_MOD, args, comsig_values)
	mod = comsig_values[MOD_VALUES_SKILL_MOD]

	. = modifier_is_multiplier ? value*mod : value/mod

/**
  * Generic value modifier proc that uses several skills, intended for items.
  * Args:
  * * item/I : the item used in this action. its used_skills list variable contains the skills exercised with it.
  * * value : the value to modify, may be a delay, damage, probability.
  * * flags : the required flags that each skill (either in I.used_skills or the skill datum skill_flags) must have to influence
  * * 			the value.
  * * bad_flags : the opposite of the above, skills that must not be present to impact the value.
  * * modifier_is_multiplier : wheter the modifier is a multiplier or a divisor.
  */
/datum/skill_holder/proc/item_action_skills_mod(obj/item/I, value, flags = NONE, bad_flags = NONE, modifier_is_multiplier = TRUE)
	. = value
	var/sum = 0
	var/divisor = 0
	var/list/checked_skills
	for(var/k in I.used_skills)
		var/datum/skill/S = GLOB.skill_datums[k]
		if(!S)
			continue
		var/our_flags = (I.used_skills[k]|S.skill_flags)
		if((flags && !(our_flags & flags)) || (bad_flags && our_flags & bad_flags))
			continue
		var/mod
		switch(S.progression_type)
			if(SKILL_PROGRESSION_LEVEL)
				mod = LAZYACCESS(skill_levels, S.type)
			else
				mod = LAZYACCESS(skills, S.type)
		sum += 1+(mod - S.competency_thresholds[I.skill_difficulty])*S.competency_mults[I.skill_difficulty]
		LAZYADD(checked_skills, S)

	var/list/comsig_values = list(sum, divisor, checked_skills)
	SEND_SIGNAL(owner.current, COMSIG_MOB_ITEM_ACTION_SKILLS_MOD, args, comsig_values)
	sum = comsig_values[MOD_VALUES_ITEM_SKILLS_SUM]
	divisor = comsig_values[MOD_VALUES_ITEM_SKILLS_DIV]

	if(divisor)
		. = modifier_is_multiplier ? value*(sum/divisor) : value/(sum/divisor)

/**
  * Generates a HTML readout of our skills.
  * Port to tgui-next when?
  */
/datum/skill_holder/proc/html_readout()
	var/list/out = list("<center><h1>Skills</h1></center><hr>")
	out += "<table style=\"width:100%\"><tr><th><b>Skill</b><th><b>Value</b></tr>"
	for(var/path in skills)
		var/datum/skill/S = GLOB.skill_datums[path]
		out += "<tr><td><font color='[S.name_color]'>[S.name]</font></td><td>[S.standard_render_value(skills[path], LAZYACCESS(skill_levels, path) || 0)]</td></tr>"
	out += "</table>"
	return out.Join("")
