/datum/element/decal
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/cleanable
	var/description
	var/mutable_appearance/pic

	var/first_dir // This stores the direction of the decal compared to the parent facing NORTH

/datum/element/decal/Attach(datum/target, _icon, _icon_state, _dir, _cleanable=CLEAN_GOD, _color, _layer=TURF_LAYER, _description, _alpha=255)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !isatom(target) || !_icon || !_icon_state)
		return ELEMENT_INCOMPATIBLE
	var/atom/A = target
	if(!pic)
		// It has to be made from an image or dir breaks because of a byond bug
		var/temp_image = image(_icon, null, _icon_state, _layer, _dir)
		pic = new(temp_image)
		pic.color = _color
		pic.alpha = _alpha
	first_dir = _dir
	description = _description
	cleanable = _cleanable

	if(first_dir)
		RegisterSignal(A, COMSIG_ATOM_DIR_CHANGE, .proc/rotate_react)
	if(cleanable)
		RegisterSignal(A, COMSIG_COMPONENT_CLEAN_ACT, .proc/clean_react)
	if(description)
		RegisterSignal(A, COMSIG_PARENT_EXAMINE, .proc/examine)

	apply(A)

/datum/element/decal/Detach(datum/target)
	var/atom/A = target
	remove(A, A.dir)
	UnregisterSignal(A, list(COMSIG_ATOM_DIR_CHANGE, COMSIG_COMPONENT_CLEAN_ACT, COMSIG_PARENT_EXAMINE))
	return ..()

/datum/element/decal/proc/remove(atom/target, old_dir)
	pic.dir = first_dir == NORTH ? target.dir : turn(first_dir, dir2angle(old_dir))
	target.cut_overlay(pic, TRUE)
	if(isitem(target))
		addtimer(CALLBACK(target, /obj/item/.proc/update_slot_icon), 0, TIMER_UNIQUE)
	return ..()

/datum/element/decal/proc/apply(atom/target)
	pic.dir = first_dir == NORTH ? target.dir : turn(first_dir, dir2angle(target.dir))
	target.add_overlay(pic, TRUE)
	if(isitem(target))
		addtimer(CALLBACK(target, /obj/item/.proc/update_slot_icon), 0, TIMER_UNIQUE)

/datum/element/decal/proc/rotate_react(datum/source, old_dir, new_dir)
	if(old_dir == new_dir)
		return
	remove(source, old_dir)
	apply(source)

/datum/element/decal/proc/clean_react(datum/source, strength)
	if(strength >= cleanable)
		Detach(source)

/datum/element/decal/proc/examine(datum/source, mob/user, list/examine_list)
	examine_list += description
