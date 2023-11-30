/datum/element/tactical
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/allowed_slot

/datum/element/tactical/Attach(datum/target, allowed_slot)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !isitem(target))
		return ELEMENT_INCOMPATIBLE

	src.allowed_slot = allowed_slot
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(modify))
	RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(unmodify))

/datum/element/tactical/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	unmodify(target)
	return ..()

/datum/element/tactical/proc/modify(obj/item/source, mob/user, slot)
	if(allowed_slot && slot != allowed_slot)
		unmodify(source, user)
		return

	var/image/I = image(icon = source.icon, icon_state = source.icon_state, loc = user)
	I.copy_overlays(source)
	I.override = TRUE
	source.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/everyone, "sneaking_mission", I)
	I.layer = ABOVE_MOB_LAYER

/datum/element/tactical/proc/unmodify(obj/item/source, mob/user)
	if(!user)
		if(!ismob(source.loc))
			return
		user = source.loc

	user.remove_alt_appearance("sneaking_mission")
