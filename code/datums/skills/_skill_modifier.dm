GLOBAL_LIST_EMPTY_TYPED(skill_modifiers, /datum/skill_modifier)
GLOBAL_LIST_EMPTY(potential_skills_per_mod)
GLOBAL_LIST_EMPTY(potential_mods_per_skill)

/**
  * Base skill modifier datum, used to modify a player skills without directly touching their values, levels and affinity
  * and cause lots of edge cases. These are fairly simple overall... make a subtype though, don't use this one.
  */
/datum/skill_modifier
	/// Name and description of the skill modifier, used in the UI
	var/name = "???"
	/// flags for this skill modifier.
	var/modifier_flags = NONE
	/// target skills, can be a specific skill typepath or a list of skill traits.
	var/target_skills = /datum/skill
	/// the GLOB.potential_skills_per_mod key generated on runtime. You shouldn't be var-editing it.
	var/target_skills_key
	/// The identifier key this skill modifier is associated with.
	var/identifier
	/// skill affinity modifier, can be a multiplier or addendum, depending on the modifier_flags.
	var/affinity_mod = 1
	/// skill value modifier, see above.
	var/value_mod = 1
	/// skill level modifier, see above.
	var/level_mod = 1
	/// Priority of this skill modifier compared to other ones.
	var/priority = MODIFIER_SKILL_PRIORITY_DEF

/datum/skill_modifier/New(id, register = FALSE)
	identifier = GET_SKILL_MOD_ID(type, id)
	if(id)
		var/former_id = identifier
		var/dupe = 0
		while(GLOB.skill_modifiers[identifier])
			identifier = "[former_id][++dupe]"

	if(register)
		register()

/datum/skill_modifier/proc/register()
	if(GLOB.skill_modifiers[identifier])
		CRASH("Skill modifier identifier \"[identifier]\" already taken.")
	GLOB.skill_modifiers[identifier] = src
	if(ispath(target_skills))
		target_skills_key = target_skills
		var/list/mod_L = GLOB.potential_mods_per_skill[target_skills]
		if(!mod_L)
			mod_L = GLOB.potential_mods_per_skill[target_skills] = list()
		else
			BINARY_INSERT(identifier, mod_L, /datum/skill_modifier, src, priority, COMPARE_VALUE)
		mod_L[identifier] = src
		GLOB.potential_skills_per_mod[target_skills_key] = list(target_skills)
	else //Should be a list.
		var/list/T = target_skills
		T = sortTim(target_skills, GLOBAL_PROC_REF(cmp_text_asc)) //Sort the list contents alphabetically.
		target_skills_key = T.Join("-")
		var/list/L = GLOB.potential_skills_per_mod[target_skills_key]
		if(!L)
			L = list()
			for(var/path in GLOB.skill_datums)
				if(GLOB.skill_datums[path].skill_traits & target_skills)
					L += path
			GLOB.potential_skills_per_mod[target_skills_key] = L
		for(var/path in L)
			var/list/mod_L = GLOB.potential_mods_per_skill[path]
			if(!mod_L)
				mod_L = GLOB.potential_mods_per_skill[path] = list()
			else
				BINARY_INSERT(identifier, mod_L, /datum/skill_modifier, src, priority, COMPARE_VALUE)
			mod_L[identifier] = src

/datum/skill_modifier/Destroy()
	for(var/path in GLOB.potential_skills_per_mod[target_skills_key])
		var/mod_L = GLOB.potential_mods_per_skill[path]
		mod_L -= identifier
		if(!length(mod_L))
			GLOB.potential_mods_per_skill -= path
	GLOB.skill_modifiers -= identifier
	return ..()

#define ADD_MOD_STEP(L, P, O, G) \
	var/__L = L[P];\
	if(!__L){\
		L[P] = list(id)\
	} else {\
		L[P] = GLOB.potential_mods_per_skill[P] & (__L + id)\
	}\
	if(M.modifier_flags & MODIFIER_SKILL_ORIGIN_DIFF){\
		LAZYADDASSOC(O, id, "[P]" = G)\
	}

/datum/mind/proc/add_skill_modifier(id)
	if(LAZYACCESS(skill_holder.all_current_skill_modifiers, id))
		return
	var/datum/skill_modifier/M = GLOB.skill_modifiers[id]
	if(!M)
		CRASH("Invalid add_skill_modifier id: [id].")
	if(M.modifier_flags & MODIFIER_SKILL_BODYBOUND && !current)
		CRASH("Body-bound skill modifier [M] was tried to be added to a mob-less mind.")

	if(M.modifier_flags & MODIFIER_SKILL_VALUE)
		LAZYINITLIST(skill_holder.skill_value_mods)
	if(M.modifier_flags & MODIFIER_SKILL_AFFINITY)
		LAZYINITLIST(skill_holder.skill_affinity_mods)
	if(M.modifier_flags & MODIFIER_SKILL_LEVEL)
		LAZYINITLIST(skill_holder.skill_level_mods)
	for(var/path in GLOB.potential_skills_per_mod[M.target_skills_key])
		if(M.modifier_flags & MODIFIER_SKILL_VALUE)
			ADD_MOD_STEP(skill_holder.skill_value_mods, path, skill_holder.original_values, get_skill_value(path, FALSE))
		if(M.modifier_flags & MODIFIER_SKILL_AFFINITY)
			ADD_MOD_STEP(skill_holder.skill_affinity_mods, path, skill_holder.original_affinities, get_skill_affinity(path, FALSE))
		if(M.modifier_flags & MODIFIER_SKILL_LEVEL)
			ADD_MOD_STEP(skill_holder.skill_level_mods, path, skill_holder.original_levels, get_skill_level(path, FALSE))
	LAZYSET(skill_holder.all_current_skill_modifiers, id, TRUE)
	skill_holder.need_static_data_update = TRUE

	if(M.modifier_flags & MODIFIER_SKILL_BODYBOUND)
		M.RegisterSignal(src, COMSIG_MIND_TRANSFER, TYPE_PROC_REF(/datum/skill_modifier, on_mind_transfer))
		M.RegisterSignal(current, COMSIG_MOB_ON_NEW_MIND, TYPE_PROC_REF(/datum/skill_modifier, on_mob_new_mind), TRUE)
	RegisterSignal(M, COMSIG_PARENT_PREQDELETED, PROC_REF(on_skill_modifier_deletion))

#undef ADD_MOD_STEP

#define REMOVE_MOD_STEP(L, P, O)\
	LAZYREMOVEASSOC(L, P, id);\
	if(M.modifier_flags & MODIFIER_SKILL_ORIGIN_DIFF){\
		LAZYREMOVEASSOC(O, id, "[P]")\
	}

/datum/mind/proc/remove_skill_modifier(id, mind_transfer = FALSE)
	if(!LAZYACCESS(skill_holder.all_current_skill_modifiers, id))
		return
	var/datum/skill_modifier/M = GLOB.skill_modifiers[id]
	if(!M)
		CRASH("Invalid remove_skill_modifier id: [id].")

	if(!skill_holder.skill_value_mods && !skill_holder.skill_affinity_mods && !skill_holder.skill_level_mods)
		return
	for(var/path in GLOB.potential_skills_per_mod[M.target_skills_key])
		if(M.modifier_flags & MODIFIER_SKILL_VALUE && skill_holder.skill_value_mods)
			REMOVE_MOD_STEP(skill_holder.skill_value_mods, path, skill_holder.original_values)
		if(M.modifier_flags & MODIFIER_SKILL_AFFINITY && skill_holder.skill_affinity_mods)
			REMOVE_MOD_STEP(skill_holder.skill_affinity_mods, path, skill_holder.original_affinities)
		if(M.modifier_flags & MODIFIER_SKILL_LEVEL && skill_holder.skill_level_mods)
			REMOVE_MOD_STEP(skill_holder.skill_level_mods, path, skill_holder.original_levels)
	LAZYREMOVE(skill_holder.all_current_skill_modifiers, id)
	skill_holder.need_static_data_update = TRUE

	if(!mind_transfer && M.modifier_flags & MODIFIER_SKILL_BODYBOUND)
		M.UnregisterSignal(src, COMSIG_MIND_TRANSFER)
		M.UnregisterSignal(current, list(COMSIG_MOB_ON_NEW_MIND))
	UnregisterSignal(M, COMSIG_PARENT_PREQDELETED)

#undef REMOVE_MOD_STEP

/datum/mind/proc/on_skill_modifier_deletion(datum/skill_modifier/source)
	remove_skill_modifier(source.identifier)

/datum/skill_modifier/proc/apply_modifier(value, skillpath, datum/skill_holder/H, method = MODIFIER_TARGET_VALUE)
	. = value
	var/mod = value_mod
	switch(method)
		if(MODIFIER_TARGET_LEVEL)
			mod = level_mod
		if(MODIFIER_TARGET_AFFINITY)
			mod = affinity_mod

	if(modifier_flags & MODIFIER_USE_THRESHOLDS && istext(mod))
		var/datum/skill/S = GLOB.skill_datums[skillpath]
		if(method == MODIFIER_TARGET_VALUE && S.progression_type == SKILL_PROGRESSION_LEVEL)
			var/datum/skill/level/L = S
			mod = L.get_skill_level_value(L.competency_thresholds[mod])
		else
			mod = S.competency_thresholds[mod]

	var/diff = 0
	if(modifier_flags & (MODIFIER_SKILL_VIRTUE|MODIFIER_SKILL_HANDICAP))
		if(modifier_flags & MODIFIER_SKILL_VIRTUE)
			. = max(., mod)
		if(modifier_flags & MODIFIER_SKILL_HANDICAP)
			. = min(., mod)
		diff = . - mod
	else if(modifier_flags & MODIFIER_SKILL_MULT)
		. *= mod
	else
		. += mod

	if(modifier_flags & MODIFIER_SKILL_ORIGIN_DIFF)
		var/list/to_access = H.original_values
		switch(method)
			if(MODIFIER_TARGET_LEVEL)
				to_access = H.original_levels
			if(MODIFIER_TARGET_AFFINITY)
				to_access = H.original_affinities
		. += value - diff - LAZYACCESS(to_access[identifier], "[skillpath]")

///Body bound modifier signal procs.
/datum/skill_modifier/proc/on_mind_transfer(datum/mind/source, mob/new_character, mob/old_character)
	source.remove_skill_modifier(identifier, TRUE)
	UnregisterSignal(source, COMSIG_MIND_TRANSFER)

/datum/skill_modifier/proc/on_mob_new_mind(mob/source)
	source.mind.add_skill_modifier(identifier)
	RegisterSignal(source.mind, COMSIG_MIND_TRANSFER, TYPE_PROC_REF(/datum/skill_modifier, on_mind_transfer))
