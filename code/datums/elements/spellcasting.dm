/datum/element/spellcasting //allows to cast certain spells or skip requirements.
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/cast_flags
	var/cast_slots
	var/list/users_by_item = list()

/datum/element/spellcasting/Attach(datum/target, _flags, _slots)
	. = ..()
	if(isitem(target))
		RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/on_equip)
		RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/on_drop)
	else if(ismob(target))
		RegisterSignal(target, COMSIG_MOB_SPELL_CAST_CHECK, .proc/on_cast)
	else
		return ELEMENT_INCOMPATIBLE
	cast_flags = _flags
	cast_slots = _slots

/datum/element/spellcasting/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_MOB_SPELL_CAST_CHECK))
	if(users_by_item[target])
		var/mob/user = users_by_item[target]
		UnregisterSignal(user, COMSIG_MOB_SPELL_CAST_CHECK)

/datum/element/spellcasting/proc/on_equip(datum/source, mob/equipper, slot)
	if(slot in cast_slots)
		RegisterSignal(equipper, COMSIG_MOB_SPELL_CAST_CHECK, .proc/on_cast)
		users_by_item[source] = equipper

/datum/element/spellcasting/proc/on_drop(datum/source, mob/user)
	UnregisterSignal(user, COMSIG_MOB_SPELL_CAST_CHECK)
	users_by_item -= source

/datum/element/spellcasting/proc/on_cast(mob/caster, obj/effect/proc_holder/spell)
	return cast_flags
