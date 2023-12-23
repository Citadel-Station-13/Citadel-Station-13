/datum/element/spellcasting //allows to cast certain spells or skip requirements.
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/cast_flags
	var/cast_slots
	var/list/users_by_item = list()
	var/list/stacked_spellcasting_by_user = list()

/datum/element/spellcasting/Attach(datum/target, _flags, _slots)
	. = ..()
	if(isitem(target))
		RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/on_equip)
		RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/on_drop)
	else if(ismob(target))
		RegisterSignal(target, COMSIG_MOB_SPELL_CAN_CAST, .proc/on_cast)
		stacked_spellcasting_by_user[target]++
	else
		return ELEMENT_INCOMPATIBLE
	cast_flags = _flags
	cast_slots = _slots

/datum/element/spellcasting/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_MOB_SPELL_CAN_CAST))
	if(users_by_item[target])
		var/mob/user = users_by_item[target]
		users_by_item -= target
		stacked_spellcasting_by_user[user]--
		if(!stacked_spellcasting_by_user[user])
			stacked_spellcasting_by_user -= user
			UnregisterSignal(user, COMSIG_MOB_SPELL_CAN_CAST)
	else if(ismob(target))
		stacked_spellcasting_by_user[target]--
		if(!stacked_spellcasting_by_user[target])
			stacked_spellcasting_by_user -= target

/datum/element/spellcasting/proc/on_equip(datum/source, mob/equipper, slot)
	if(!(cast_slots & slot))
		return
	users_by_item[source] = equipper
	if(!stacked_spellcasting_by_user[equipper])
		RegisterSignal(equipper, COMSIG_MOB_SPELL_CAN_CAST, .proc/on_cast)
	stacked_spellcasting_by_user[equipper]++

/datum/element/spellcasting/proc/on_drop(datum/source, mob/user)
	if(!users_by_item[source])
		return
	users_by_item -= source
	stacked_spellcasting_by_user[user]--
	if(!stacked_spellcasting_by_user[user])
		stacked_spellcasting_by_user -= user
		UnregisterSignal(user, COMSIG_MOB_SPELL_CAN_CAST)

/datum/element/spellcasting/proc/on_cast(mob/caster, obj/effect/proc_holder/spell)
	return cast_flags
