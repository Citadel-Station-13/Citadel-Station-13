#define POLYCHROMIC_ALTCLICK		(1<<0)
#define POLYCHROMIC_ACTION			(1<<1)
#define POLYCHROMIC_NO_HELD			(1<<2)
#define POLYCHROMIC_NO_WORN			(1<<3)

/datum/element/polychromic
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 3
	var/list/overlays_by_atom = list()
	var/list/overlays_states //also used for worn/held overlsays
	var/icon_file
	var/list/overlays_names //wrap numbers into text strings please.
	var/list/actions_by_atom = list()
	var/poly_flags
	//item variables
	var/worn_file //used for boths held and worn overlays if present.

/datum/element/polychromic/Attach(datum/target, list/colors, list/states, _icon, _flags = POLYCHROMIC_ALTCLICK|POLYCHROMIC_NO_HELD, _worn, list/names = list("Primary", "Secondary", "Tertiary", "Quaternary", "Quinary", "Senary"))
	. = ..()
	var/states_len = length(overlays_states)
	var/names_len = length(names)
	if(!states_len || names_len || !isatom(target))
		return ELEMENT_INCOMPATIBLE
	var/atom/A = target

	overlays_states = states
	icon_file = _icon
	worn_file = _worn
	poly_flags = _flags

	var/mut_icon = icon_file || A.icon
	var/list/L = list()
	for(var/I in overlays_states)
		var/col = popleft(colors) || "#FFFFFF"
		L += mutable_appearance(mut_icon, I, color = col)
		A.add_overlay(L)
	overlays_by_atom[A] = L

	if(_flags & POLYCHROMIC_ALTCLICK)
		RegisterSignal(A, COMSIG_PARENT_EXAMINE, .proc/on_examine)
		RegisterSignal(A, COMSIG_CLICK_ALT, .proc/set_color)

	if(!overlays_names && names)
		overlays_names = names
		var/diff = states_len - names_len
		if(diff > 0) //It will be ugly, but still functional.
			for(var/i in 1 to diff)
				overlays_names += "[names_len + i]"
		else if(diff < 0)
			overlays_names.len += diff

	if(isitem(A))
		if(_flags & POLYCHROMIC_ACTION)
			RegisterSignal(src, COMSIG_ITEM_EQUIPPED, .proc/grant_user_action)
			RegisterSignal(src, COMSIG_ITEM_DROPPED, .proc/remove_user_action)
		AddElement(A, /datum/element/update_icon_updates_onmob) //Since we can change the overall aspect of the item.
		RegisterSignal(A, COMSIG_ITEM_WORN_OVERLAYS, .proc/apply_worn_overlays)
	else if(_flags & POLYCHROMIC_ACTION && ismob(A)) //Not safe until mob icon updating procs are standarized and stop using cut_overlays()
		var/datum/action/polychromic/P = new(A)
		RegisterSignal(P, COMSIG_ACTION_TRIGGER, .proc/activate_action)
		actions_by_atom[A] = P
		P.Grant(A)

/datum/element/polychromic/Detach(atom/A)
	. = ..()
	A.cut_overlay(overlays_by_atom[A])
	overlays_by_atom -= A
	var/datum/action/polychromic/P = actions_by_atom[A]
	if(P)
		qdel(P)
	actions_by_atom -= A
	if(poly_flags & POLYCHROMIC_ALTCLICK)
		UnregisterSignal(A, list(COMSIG_PARENT_EXAMINE, COMSIG_CLICK_ALT))

/datum/element/polychromic/proc/apply_worn_overlays(obj/item/source, isinhands, icon_file, style_flags, list/overlays)
	if(poly_flags & (isinhands ? POLYCHROMIC_NO_HELD : POLYCHROMIC_NO_WORN))
		return
	var/f_icon = worn_file || icon_file
	var/list/L = overlays_by_atom[source]

	for(var/I in 1 to length(overlays_states))
		var/mutable_appearance/M = L[I]
		overlays += mutable_appearance(f_icon, overlays_states[I], color = M.color)

/datum/element/polychromic/proc/set_color(atom/source, mob/user)
	var/choice = input(user,"Polychromic options", "Recolor [source]") as null|anything in overlays_names
	if(!choice || QDELETED(source) || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		return
	choice = overlays_names.Find(choice)
	var/ncolor = input(user, "Polychromic options", "Choose [choice] Color") as color|null
	if(!ncolor || QDELETED(source) || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		return
	var/list/L = overlays_by_atom[source]
	if(!L) // Ummmmmh.
		return
	var/mutable_appearance/M = L[choice]
	M.color = sanitize_hexcolor(ncolor, 6, TRUE, M.color)
	source.update_icon()
	return TRUE

/datum/element/polychromic/proc/grant_user_action(atom/source, mob/user, slot)
	if(slot == SLOT_IN_BACKPACK || slot == SLOT_LEGCUFFED || slot == SLOT_HANDCUFFED || slot == SLOT_GENERC_DEXTROUS_STORAGE)
		return
	var/datum/action/polychromic/P = actions_by_atom[source]
	if(!P)
		P = new (source)
		actions_by_atom[source] = P
		P.check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
		RegisterSignal(P, COMSIG_ACTION_TRIGGER, .proc/activate_action)
	P.Grant(user)

/datum/element/polychromic/proc/remove_user_action(atom/source, mob/user)
	var/datum/action/polychromic/P = actions_by_atom[source]
	P?.Remove(user)

/datum/element/polychromic/proc/activate_action(datum/action/source, atom/target)
	set_color(target, source.owner)

/datum/element/polychromic/proc/on_examine(atom/source, mob/user, list/examine_list)
	examine_list += "<span class='notice'>Alt-click to recolor it.</span>"

/datum/action/polychromic
	name = "Modify Polychromic Colors"
	background_icon_state = "bg_polychromic"
	use_target_appearance = TRUE
	button_icon_state = null
	target_appearance_matrix = list(0.7,0,0,0,0.7,0)
