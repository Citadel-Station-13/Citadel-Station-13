/datum/component/decal/blood
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/decal/blood/Initialize(_icon, _icon_state, _dir, _cleanable=CLEAN_STRENGTH_BLOOD, _color, _layer=ABOVE_OBJ_LAYER)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME, .proc/get_examine_name)

/datum/component/decal/blood/generate_appearance(_icon, _icon_state, _dir, _layer, _color)
	var/obj/item/I = parent
	I.cut_overlays()
	if(!_icon)
		_icon = 'icons/effects/blood.dmi'
	if(!_icon_state)
		_icon_state = "itemblood"
	var/icon = initial(I.icon)
	var/icon_state = initial(I.icon_state)
	if(!icon || !icon_state)
		// It's something which takes on the look of other items, probably
		icon = I.icon
		icon_state = I.icon_state
	var/icon/blood_splatter_icon = icon(initial(I.icon), initial(I.icon_state), , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
	blood_splatter_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
	blood_splatter_icon.Blend(icon(_icon, _icon_state), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
//	pic = mutable_appearance(blood_splatter_icon, initial(I.icon_state))

	I.blood_splatter_icon = blood_splatter_icon
	I.blood_overlay = image(I.blood_splatter_icon)
	I.blood_overlay.color = I.blood_DNA_to_color()
	I.update_icon()
	I.add_overlay(I.blood_overlay)

	return TRUE

/datum/component/decal/blood/proc/get_examine_name(datum/source, mob/user, list/override)
	var/atom/A = parent
	override[EXAMINE_POSITION_ARTICLE] = A.gender == PLURAL? "some" : "a"
	override[EXAMINE_POSITION_BEFORE] = " blood-stained "
	return COMPONENT_EXNAME_CHANGED
