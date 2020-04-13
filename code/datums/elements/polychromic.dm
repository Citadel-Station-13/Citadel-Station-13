#define POLYCHROMIC_ALTCLICK		(1<<0)
#define POLYCHROMIC_ACTION			(1<<1)
#define POLYCHROMIC_NO_HELD			(1<<2)
#define POLYCHROMIC_NO_WORN			(1<<3)

/datum/element/polychromic
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 3
	var/overlays_states //A list or a number of states. In the latter case, the atom icon_state/item_state will be used followed by a number.
	var/list/colors_by_atom = list() //list of color strings or mutable appearances, depending on the above variable.
	var/icon_file
	var/list/overlays_names //wrap numbers into text strings please.
	var/list/actions_by_atom = list()
	var/list/already_updates_onmob = list()
	var/poly_flags
	var/worn_file //used in place of items' held or mob overlay icons if present.

/datum/element/polychromic/Attach(datum/target, list/colors, states, _icon, _flags = POLYCHROMIC_ALTCLICK|POLYCHROMIC_NO_HELD, _worn, list/names = list("Primary", "Secondary", "Tertiary", "Quaternary", "Quinary", "Senary"))
	. = ..()
	var/make_appearances = islist(states)
	var/states_len = make_appearances ? length(states) : states
	var/names_len = length(names)
	if(!states_len || !names_len || !isatom(target))
		return ELEMENT_INCOMPATIBLE
	var/atom/A = target

	overlays_states = states
	icon_file = _icon
	worn_file = _worn
	poly_flags = _flags

	var/mut_icon = icon_file || A.icon
	var/list/L = list()
	for(var/I in 1 to states_len)
		var/col = LAZYACCESS(colors, I) || "#FFFFFF"
		L += make_appearances ? mutable_appearance(mut_icon, overlays_states[I], color = col) : col
	colors_by_atom[A] = L

	RegisterSignal(A, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/apply_overlays)

	if(_flags & POLYCHROMIC_ALTCLICK)
		RegisterSignal(A, COMSIG_PARENT_EXAMINE, .proc/on_examine)
		RegisterSignal(A, COMSIG_CLICK_ALT, .proc/set_color)

	if(!overlays_names && names) //generate
		overlays_names = names
		var/diff = states_len - names_len
		if(diff > 0)
			for(var/i in 1 to diff)
				overlays_names += "[names_len + i]°"
		else if(diff < 0)
			overlays_names.len += diff

	if(isitem(A))
		if(_flags & POLYCHROMIC_ACTION)
			RegisterSignal(A, COMSIG_ITEM_EQUIPPED, .proc/grant_user_action)
			RegisterSignal(A, COMSIG_ITEM_DROPPED, .proc/remove_user_action)
		if(!(_flags & POLYCHROMIC_NO_HELD) && !(_flags & POLYCHROMIC_NO_WORN))
			if(!SSdcs.GetElement(/datum/element/update_icon_updates_onmob))
				A.AddElement(/datum/element/update_icon_updates_onmob)
			else
				already_updates_onmob[A]++
			RegisterSignal(A, COMSIG_ITEM_WORN_OVERLAYS, .proc/apply_worn_overlays)
	else if(_flags & POLYCHROMIC_ACTION && ismob(A)) //in the event mob update icon procs are ever standarized.
		var/datum/action/polychromic/P = new(A)
		RegisterSignal(P, COMSIG_ACTION_TRIGGER, .proc/activate_action)
		actions_by_atom[A] = P
		P.Grant(A)

	A.update_icon() //apply the overlays.

/datum/element/polychromic/Detach(atom/A)
	. = ..()
	A.cut_overlay(colors_by_atom[A])
	colors_by_atom -= A
	if(!(poly_flags & POLYCHROMIC_NO_HELD) && !(poly_flags & POLYCHROMIC_NO_WORN) && isitem(A))
		if(!already_updates_onmob[A])
			A.RemoveElement(/datum/element/update_icon_updates_onmob)
		else
			already_updates_onmob[A]--
			if(!already_updates_onmob[A])
				already_updates_onmob -= A
	var/datum/action/polychromic/P = actions_by_atom[A]
	if(P)
		actions_by_atom -= A
		qdel(P)
	UnregisterSignal(A, list(COMSIG_PARENT_EXAMINE, COMSIG_CLICK_ALT, COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_ITEM_WORN_OVERLAYS))

/datum/element/polychromic/proc/apply_overlays(atom/source, list/overlays)
	var/list/L = colors_by_atom[source]
	if(isnum(overlays_states))
		for(var/i in 1 to overlays_states)
			overlays += mutable_appearance(source.icon, "[source.icon_state]-[i]", color = L[i])
	else
		overlays += colors_by_atom[source]

/datum/element/polychromic/proc/apply_worn_overlays(obj/item/source, isinhands, icon_file, used_state, style_flags, list/overlays)
	if(poly_flags & (isinhands ? POLYCHROMIC_NO_HELD : POLYCHROMIC_NO_WORN))
		return
	var/f_icon = worn_file || icon_file
	var/list/L = colors_by_atom[source]

	if(isnum(overlays_states))
		for(var/i in 1 to overlays_states)
			overlays += mutable_appearance(f_icon, "[used_state]-[i]", color = L[i])
	else
		for(var/I in 1 to length(overlays_states))
			var/mutable_appearance/M = L[I]
			overlays += mutable_appearance(f_icon, overlays_states[I], color = M.color)

/datum/element/polychromic/proc/set_color(atom/source, mob/user)
	var/choice = input(user,"Polychromic options", "Recolor [source]") as null|anything in overlays_names
	if(!choice || QDELETED(source) || !user.canUseTopic(source, BE_CLOSE, NO_DEXTERY))
		return
	var/ncolor = input(user, "Polychromic options", "Choose [choice] Color") as color|null
	if(!ncolor || QDELETED(source) || !user.canUseTopic(source, BE_CLOSE, NO_DEXTERY))
		return
	var/list/L = colors_by_atom[source]
	if(!L) // Ummmmmh.
		return
	var/K = L[overlays_names.Find(choice)]
	if(istext(K))
		K = sanitize_hexcolor(ncolor, 6, TRUE, K)
	else
		var/mutable_appearance/M = K
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
		P.check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
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
	target_appearance_matrix = list(0.75,0,0,0,0.75,0)
