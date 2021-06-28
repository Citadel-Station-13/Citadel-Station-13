/**
  * Skill holder datums
  * All procs are tied to the mind, since they are always expected to have a skill holder anyway.
  */
/datum/skill_holder
	/// Our list of skills and values. Lazylist. Associative. Keys are datum typepaths to the skill.
	var/list/skills
	/// Same as [skills] but affinities, which are multiplied to increase amount when gaining skills.
	var/list/skill_affinities
	/// Let's say we want to get a specific skill "level" without looping through a proc everytime.
	/// Only supported by skills with tiers or levels.
	var/list/skill_levels
	/// current skill modifiers lists, per value, affinity, level.
	var/list/skill_value_mods
	var/list/skill_affinity_mods
	var/list/skill_level_mods
	/// List of all current skill modifiers, so we don't add the same ones twice.
	var/list/all_current_skill_modifiers
	/// List of original values stored at the time a modifier with the MODIFIER_SKILL_ORIGIN_DIFF enabled was added.
	var/list/original_values
	var/list/original_affinities
	var/list/original_levels
	/// The mind datum this skill is associated with, only used for the check_skills UI
	var/datum/mind/owner
	/// For UI updates.
	var/need_static_data_update = TRUE
	/// Whether modifiers and final skill values or only base values are displayed.
	var/see_skill_mods = TRUE
	/// The current selected skill category.
	var/selected_category

/datum/skill_holder/New(owner)
	..()
	src.owner = owner

/**
  * Grabs the value of a skill.
  */
/datum/mind/proc/get_skill_value(skill, apply_modifiers = TRUE)
	if(!ispath(skill))
		CRASH("Invalid get_skill_value call. Use typepaths.")		//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	if(!skill_holder.skills)
		. = 0
	else
		. = skill_holder.skills[skill] || 0
	if(apply_modifiers && skill_holder.skill_value_mods)
		var/L = LAZYACCESS(skill_holder.skill_value_mods, skill)
		for(var/k in L)
			var/datum/skill_modifier/M = GLOB.skill_modifiers[k]
			. = M.apply_modifier(., skill, skill_holder, MODIFIER_TARGET_VALUE)

/**
  * Grabs the level of a skill. Only supported by skills with tiers or levels.
  */
/datum/mind/proc/get_skill_level(skill, apply_modifiers = TRUE, round = FALSE)
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid get_skill_value call. Use skill typepaths.")	//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	if(!skill_holder.skill_levels)
		. =  0
	else
		. = skill_holder.skill_levels[skill] || 0
	if(apply_modifiers && skill_holder.skill_level_mods)
		var/L = LAZYACCESS(skill_holder.skill_level_mods, skill)
		for(var/k in L)
			var/datum/skill_modifier/M = GLOB.skill_modifiers[k]
			. = M.apply_modifier(., skill, skill_holder, MODIFIER_TARGET_LEVEL)
		. = SANITIZE_SKILL_LEVEL(skill, round ? round(., 1) : .)

/**
  * Grabs our affinity for a skill. !!This is a multiplier!!
  */
/datum/mind/proc/get_skill_affinity(skill, apply_modifiers = TRUE)
	. = 1
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid get_skill_affinity call. Use skill typepaths.")	//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	var/affinity = LAZYACCESS(skill_holder.skill_affinities, skill)
	if(!isnull(affinity))
		. = affinity
	if(apply_modifiers && skill_holder.skill_affinity_mods)
		var/L = LAZYACCESS(skill_holder.skill_affinity_mods, skill)
		for(var/k in L)
			var/datum/skill_modifier/M = GLOB.skill_modifiers[k]
			. = M.apply_modifier(., skill, skill_holder, MODIFIER_TARGET_AFFINITY)


/**
  * Sets the value of a skill.
  */
/datum/mind/proc/set_skill_value(skill, value, silent = FALSE)
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid set_skill_value call. Use skill typepaths.")	//until a time when we somehow need text ids for dynamic skills, I'm enforcing this.
	var/datum/skill/S = GLOB.skill_datums[skill]
	value = S.sanitize_value(value)
	if(!isnull(value))
		LAZYINITLIST(skill_holder.skills)
		S.set_skill_value(skill_holder, value, src, silent)
		skill_holder.need_static_data_update = TRUE
		return TRUE
	return FALSE

/**
  * Boosts a skill to a value if not aobve
  */
/datum/mind/proc/boost_skill_value_to(skill, value, silent = FALSE, current)
	current = current || get_skill_value(skill, FALSE)
	if(!IS_SKILL_VALUE_GREATER(skill, current, value))
		return FALSE
	set_skill_value(skill, value, silent)
	return TRUE

/**
  * Automatic skill increase, multiplied by skill affinity if existing.
  * Only works if skill is numerical or levelled..
  */
/datum/mind/proc/auto_gain_experience(skill, value, maximum, silent = FALSE)
	if(!ispath(skill, /datum/skill))
		CRASH("Invalid set_skill_value call. Use skill typepaths.")
	var/datum/skill/S = GLOB.skill_datums[skill]
	if(S.progression_type != SKILL_PROGRESSION_NUMERICAL && S.progression_type != SKILL_PROGRESSION_LEVEL)
		CRASH("You cannot auto increment a non numerical(experience skill!")
	var/current = get_skill_value(skill, FALSE)
	var/affinity = get_skill_affinity(skill)
	var/target_value = round(current + (value * affinity), S.skill_gain_quantisation)
	if(maximum && target_value >= maximum) //no more experience to gain, early return.
		return
	boost_skill_value_to(skill, target_value, silent, current)

/**
  * Generic value modifier proc that uses one skill.
  * Args:
  * * value : the value to modify, may be a delay, damage, probability.
  * * threshold : The difficulty of the action, in short. Refer to __DEFINES/skills/defines.dm for the defines.
  * * modifier_is_multiplier : wheter the modifier is a multiplier or a divisor.
  */
/datum/mind/proc/action_skill_mod(skill, value, threshold, modifier_is_multiplier = TRUE)
	var/datum/skill/S = GLOB.skill_datums[skill]
	if(!S)
		return value
	var/mod = S.base_multiplier
	switch(S.progression_type)
		if(SKILL_PROGRESSION_LEVEL)
			var/datum/skill/level/L = S
			var/skill_lvl = get_skill_level(L.type)
			mod += skill_lvl/(L.max_levels+max(L.competency_thresholds[threshold]-skill_lvl, 0))*L.competency_multiplier
		if(SKILL_PROGRESSION_NUMERICAL)
			var/datum/skill/numerical/N = S
			var/skill_val = get_skill_value(N.type)
			mod += skill_val/(N.max_value+max(N.competency_thresholds[threshold]-skill_val, 0))*N.competency_multiplier
		else
			var/comp_threshold = S.competency_thresholds[threshold]
			mod += (comp_threshold ? (get_skill_value(S.type) / comp_threshold) : get_skill_value(S.type))*S.competency_multiplier
	. = modifier_is_multiplier ? value*mod : value/mod

/**
  * Generic value modifier proc that uses several skills, intended for items.
  * Args:
  * * item/I : the item used in this action. its used_skills list variable contains the skills exercised with it.
  * * value : the value to modify, may be a delay, damage, probability.
  * * traits : the required traits each skill (either in I.used_skills or the skill datum skill_traits) must have to influence
  * * 			the value.
  * * bad_traits : the opposite of the above.
  * * modifier_is_multiplier : wheter the modifier is a multiplier or a divisor.
  */
/datum/mind/proc/item_action_skills_mod(obj/item/I, value, traits, bad_traits, modifier_is_multiplier = TRUE)
	. = value
	var/sum = 0
	var/divisor = 0
	var/one_trait = istext(traits)
	var/one_bad_trait = istext(bad_traits)
	for(var/k in I.used_skills)
		var/datum/skill/S = GLOB.skill_datums[k]
		if(!S)
			continue
		var/our_traits = S.skill_traits
		our_traits |= I.used_skills[k]
		if(traits && !(one_trait ? (traits in our_traits) : length(our_traits & traits)))
			continue
		if(bad_traits && (one_bad_trait ? (bad_traits in our_traits) : length(our_traits & bad_traits)))
			continue
		var/mod = S.base_multiplier
		switch(S.progression_type)
			if(SKILL_PROGRESSION_LEVEL)
				var/datum/skill/level/L = S
				var/skill_lvl = get_skill_level(L.type)
				mod += skill_lvl/(L.max_levels+max(L.competency_thresholds[I.skill_difficulty]-skill_lvl, 0))*L.competency_multiplier
			if(SKILL_PROGRESSION_NUMERICAL)
				var/datum/skill/numerical/N = S
				var/skill_val = get_skill_value(N.type)
				mod += skill_val/(N.max_value+max(N.competency_thresholds[I.skill_difficulty]-skill_val, 0))*N.competency_multiplier
			else
				var/comp_threshold = S.competency_thresholds[I.skill_difficulty]
				mod += (comp_threshold ? (get_skill_value(S.type) / comp_threshold) : get_skill_value(S.type))*S.competency_multiplier
		sum += mod
		divisor++
	if(divisor)
		. = modifier_is_multiplier ? value*(sum/divisor) : value/(sum/divisor)
