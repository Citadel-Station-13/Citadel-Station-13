/**
  * Sets an ability property
  */
/mob/proc/set_ability_property(ability, property, value)
	LAZYINITLIST(ability_properties)
	LAZYINITLIST(ability_properties[ability])
	ability_properties[ability][property] = value

/**
  * Gets an ability property
  */
/mob/proc/get_ability_property(ability, property)
	return ability_properties && ability_properties[ability] && ability_properties[ability][property]

GLOBAL_LIST_INIT(innate_ability_typepaths, all_innate_ability_typepaths())

/proc/all_innate_ability_typepaths()
	return list(
		INNATE_ABILITY_HUMANOID_CUSTOMIZATION = /datum/action/innate/ability/humanoid_customization,
		INNATE_ABILITY_SLIME_BLOBFORM = /datum/action/innate/ability/slime_blobform,
		INNATE_ABILITY_LIMB_REGROWTH = /datum/action/innate/ability/limb_regrowth
	)

/**
  * Grants an ability from a source
  */
/mob/proc/grant_ability_from_source(list/abilities, source)
	if(!islist(abilities))
		abilities = list(abilities)
	for(var/ability in abilities)
		LAZYINITLIST(innate_abilities)
		LAZYINITLIST(innate_abilities[ability])
		innate_abilities[ability] |= source
		if(ability_actions[ability])
			return
		var/datum/action/innate/ability/A = ability_actions[ability] = new GLOB.innate_ability_typepaths[ability]
		A.Grant(src)

/**
  * Removes an ability from a source
  */
/mob/proc/remove_ability_from_source(list/abilities, source)
	if(!islist(abilities))
		abilities = list(abilities)
	for(var/ability in abilities)
		if(!innate_abilities || !length(innate_abilities[ability]))
			return
		innate_abilities[ability] -= source
		if(!length(innate_abilities[ability]))
			innate_abilities -= ability
			qdel(ability_actions[ability])
			ability_actions -= ability
