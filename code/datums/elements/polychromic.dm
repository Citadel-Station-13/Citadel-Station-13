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
	var/worn_file //used in place of items' held or mob overlay icons if present.
	var/list/overlays_names //wrap numbers into text strings please.
	var/list/actions_by_atom = list()
	var/poly_flags
	var/static/list/suits_with_helmet_typecache = typecacheof(list(/obj/item/clothing/suit/hooded, /obj/item/clothing/suit/space/hardsuit))
	var/list/helmet_by_suit = list() //because poly winter coats exist.
	var/list/suit_by_helmet = list() //Idem.

/datum/element/polychromic/Attach(datum/target, list/colors, states, _flags = POLYCHROMIC_ACTION|POLYCHROMIC_NO_HELD, _icon, _worn, list/names = list("Primary", "Secondary", "Tertiary", "Quaternary", "Quinary", "Senary"))
	. = ..()
	var/make_appearances = islist(states)
	var/states_len = make_appearances ? length(states) : states
	var/names_len = length(names)
	if(!states_len || !names_len || colors_by_atom[target] || !isatom(target))
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
		if(!(_flags & POLYCHROMIC_NO_WORN) || !(_flags & POLYCHROMIC_NO_HELD))
			A.AddElement(/datum/element/update_icon_updates_onmob)
			RegisterSignal(A, COMSIG_ITEM_WORN_OVERLAYS, .proc/apply_worn_overlays)
			if(suits_with_helmet_typecache[A.type])
				RegisterSignal(A, COMSIG_SUIT_MADE_HELMET, .proc/register_helmet)
	else if(_flags & POLYCHROMIC_ACTION && ismob(A)) //in the event mob update icon procs are ever standarized.
		var/datum/action/polychromic/P = new(A)
		RegisterSignal(P, COMSIG_ACTION_TRIGGER, .proc/activate_action)
		actions_by_atom[A] = P
		P.Grant(A)

	A.update_icon() //apply the overlays.

/datum/element/polychromic/Detach(atom/A)
	. = ..()
	colors_by_atom -= A
	var/datum/action/polychromic/P = actions_by_atom[A]
	if(P)
		actions_by_atom -= A
		qdel(P)
	UnregisterSignal(A, list(COMSIG_PARENT_EXAMINE, COMSIG_CLICK_ALT, COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_ITEM_WORN_OVERLAYS, COMSIG_SUIT_MADE_HELMET))
	if(isitem(A))
		var/obj/item/clothing/head/H = helmet_by_suit[A]
		if(H)
			UnregisterSignal(H, list(COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_ITEM_WORN_OVERLAYS, COMSIG_PARENT_QDELETING))
			helmet_by_suit -= A
			suit_by_helmet -= H
			colors_by_atom -= H
			if(!QDELETED(H))
				H.update_icon() //removing the overlays
		if(!(poly_flags & POLYCHROMIC_NO_WORN) || !(poly_flags & POLYCHROMIC_NO_HELD))
			A.RemoveElement(/datum/element/update_icon_updates_onmob)
			if(!QDELETED(A) && ismob(A.loc))
				var/mob/M = A.loc
				if(!(poly_flags & POLYCHROMIC_NO_HELD) && M.is_holding(A))
					M.update_inv_hands()
				else if(!(poly_flags & POLYCHROMIC_NO_WORN))
					M.regenerate_icons()
	if(!QDELETED(A))
		A.update_icon() //removing the overlays

/datum/element/polychromic/proc/apply_overlays(atom/source, list/overlays)
	var/list/L = colors_by_atom[source]
	var/f_icon = icon_file || source.icon
	if(isnum(overlays_states))
		for(var/i in 1 to overlays_states)
			overlays += mutable_appearance(f_icon, "[source.icon_state]-[i]", color = L[i])
	else
		overlays += colors_by_atom[source]

/datum/element/polychromic/proc/apply_worn_overlays(obj/item/source, isinhands, icon, used_state, style_flags, list/overlays)
	if(poly_flags & (isinhands ? POLYCHROMIC_NO_HELD : POLYCHROMIC_NO_WORN))
		return
	var/f_icon = worn_file || icon
	var/list/L = colors_by_atom[source]

	if(isnum(overlays_states))
		for(var/i in 1 to overlays_states)
			overlays += mutable_appearance(f_icon, "[used_state]-[i]", color = L[i])
	else
		for(var/i in 1 to length(overlays_states))
			var/mutable_appearance/M = L[i]
			overlays += mutable_appearance(f_icon, overlays_states[i], color = M.color)

/datum/element/polychromic/proc/set_color(atom/source, mob/user)
	var/choice = input(user,"Polychromic options", "Recolor [source]") as null|anything in overlays_names
	if(!choice || QDELETED(source) || !user.canUseTopic(source, BE_CLOSE, NO_DEXTERY))
		return
	var/index = overlays_names.Find(choice)
	var/list/L = colors_by_atom[source]
	if(!L) // Ummmmmh.
		return
	var/mutable_appearance/M = L[index]
	var/old_color = istype(M) ? M.color : M
	var/ncolor = input(user, "Polychromic options", "Choose [choice] Color", old_color) as color|null
	if(!ncolor || QDELETED(source) || !colors_by_atom[source] || !user.canUseTopic(source, BE_CLOSE, NO_DEXTERY))
		return
	ncolor = sanitize_hexcolor(ncolor, 6, TRUE, old_color)
	if(istype(M))
		M.color = ncolor
	else
		L[index] = ncolor

	source.update_icon()
	return TRUE

/datum/element/polychromic/proc/grant_user_action(atom/source, mob/user, slot)
	if(slot == SLOT_IN_BACKPACK || slot == SLOT_LEGCUFFED || slot == SLOT_HANDCUFFED || slot == SLOT_GENERC_DEXTROUS_STORAGE)
		return
	var/datum/action/polychromic/P = actions_by_atom[source]
	if(!P)
		P = new (source)
		P.name = "Modify [source]'\s Colors"
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

/datum/element/polychromic/proc/register_helmet(atom/source, obj/item/clothing/head/H)
	suit_by_helmet[H] = source
	helmet_by_suit[source] = H
	colors_by_atom[H] = colors_by_atom[source]
	RegisterSignal(H, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/apply_overlays)
	RegisterSignal(H, COMSIG_ITEM_WORN_OVERLAYS, .proc/apply_worn_overlays)
	RegisterSignal(H, COMSIG_PARENT_QDELETING, .proc/unregister_helmet)

/datum/element/polychromic/proc/unregister_helmet(atom/source)
	var/obj/item/clothing/suit/S = suit_by_helmet[source]
	suit_by_helmet -= source
	helmet_by_suit -= S
	colors_by_atom -= source

/datum/action/polychromic
	name = "Modify Polychromic Colors"
	background_icon_state = "bg_polychromic"
	use_target_appearance = TRUE
	button_icon_state = null
	target_appearance_matrix = list(0.8,0,0,0,0.8,0)
