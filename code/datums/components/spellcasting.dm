/datum/component/spellcasting
	dupe_type = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/magical_flags
	var/allowed_slots
	var/examine_text

/datum/component/spellcasting/Initialize(_magical_flags, _allowed_slots, _examine_text)
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_equip)
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/on_drop)
	else if(ismob(parent))
		RegisterSignal(parent, COMSIG_SPELL_CAST_CHECK, .proc/casting_check)
	else
		return COMPONENT_INCOMPATIBLE

	magical_flags = _magical_flags
	allowed_slots = _allowed_slots

	if(_examine_text)
		examine_text = _examine_text
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)

/datum/component/spellcasting/InheritComponent(datum/component/spellcasting/S, original, _magical_flags, _allowed_slots, _examine_text)
	ENABLE_BITFIELD(magical_flags, _magical_flags)
	ENABLE_BITFIELD(allowed_slots, _allowed_slots)

	if(_examine_text)
		var/newline = examine_text ? "\n" : ""
		if(!newline)
			RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)
		examine_text = "[examine_text][newline][_examine_text]"

/datum/component/spellcasting/proc/on_examine(datum/source, mob/user)
	to_chat(user, examine_text)

/datum/component/spellcasting/proc/on_equip(datum/source, mob/equipper, slot)
	if(!CHECK_BITFIELD(allowed_slots, slotdefine2slotbit(slot))) //Check if that the slot is valid
		UnregisterSignal(equipper, COMSIG_MOB_RECEIVE_MAGIC)
		return
	RegisterSignal(equipper, COMSIG_SPELL_CAST_CHECK, .proc/casting_check, TRUE)

/datum/component/spellcasting/proc/on_drop(datum/source, mob/user)
	UnregisterSignal(user, COMSIG_SPELL_CAST_CHECK)

/datum/component/spellcasting/proc/casting_check(datum/source)
	return magical_flags