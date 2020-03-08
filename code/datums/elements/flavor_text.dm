GLOBAL_LIST_EMPTY(mobs_with_editable_flavor_text) //et tu, hacky code

/datum/element/flavor_text
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 3
	var/flavor_name = "Flavor Text"
	var/list/texts_by_mob = list()
	var/addendum = "This can also be used for OOC notes and preferences!"
	var/always_show = FALSE
	var/max_len = MAX_FAVOR_LEN

/datum/element/flavor_text/Attach(datum/target, text = "", _name = "Flavor Text", _addendum, _max_len = MAX_FAVOR_LEN, _always_show = FALSE, can_edit = TRUE)
	. = ..()

	if(. == ELEMENT_INCOMPATIBLE || !isatom(target)) //no reason why this shouldn't work on atoms too.
		return ELEMENT_INCOMPATIBLE

	if(_max_len)
		max_len = _max_len
	texts_by_mob[target] = copytext(text, 1, max_len)
	if(_name)
		flavor_name = _name
	if(!isnull(addendum))
		addendum = _addendum
	always_show = _always_show

	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/show_flavor)

	if(can_edit && ismob(target)) //but only mobs receive the proc/verb for the time being
		LAZYADD(GLOB.mobs_with_editable_flavor_text[target], src)
		var/mob/M = target
		M.verbs |= /mob/proc/manage_flavor_tests

/datum/element/flavor_text/Detach(atom/A)
	. = ..()
	UnregisterSignal(A, COMSIG_PARENT_EXAMINE)
	texts_by_mob -= A
	LAZYREMOVE(GLOB.mobs_with_editable_flavor_text[A], src)
	if(!GLOB.mobs_with_editable_flavor_text[A])
		GLOB.mobs_with_editable_flavor_text -= A
		if(ismob(A))
			var/mob/M = A
			M.verbs -= /mob/proc/manage_flavor_tests

/datum/element/flavor_text/proc/show_flavor(atom/target, mob/user, list/examine_list)
	if(!always_show && isliving(target))
		var/mob/living/L = target
		var/unknown = L.get_visible_name() == "Unknown"
		if(!unknown && iscarbon(target))
			var/mob/living/carbon/C = L
			unknown = (C.wear_mask && (C.wear_mask.flags_inv & HIDEFACE)) || (C.head && (C.head.flags_inv & HIDEFACE))
		if(unknown)
			if(!("...?" in examine_list)) //can't think of anything better in case of multiple flavor texts.
				examine_list += "...?"
			return
	var/text = texts_by_mob[target]
	if(!text)
		return
	var/msg = replacetext(text, "\n", " ")
	if(length_char(msg) <= 40)
		examine_list += "<span class='notice'>[html_encode(msg)]</span>"
	else
		examine_list += "<span class='notice'>[html_encode(copytext_char(msg, 1, 37))]... <a href='?src=[REF(src)];show_flavor=[REF(target)]'>More...</span></a>"

/datum/element/flavor_text/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["show_flavor"])
		var/atom/target = href_list["show_flavor"]
		var/text = texts_by_mob[target]
		if(text)
			usr << browse("<HTML><HEAD><TITLE>[target.name]</TITLE></HEAD><BODY><TT>[replacetext(texts_by_mob[target], "\n", "<BR>")]</TT></BODY></HTML>", "window=[target.name];size=500x200")
			onclose(usr, "[target.name]")
		return TRUE

/mob/proc/manage_flavor_tests()
	set name = "Manage Flavor Texts"
	set desc = "Used to manage your various flavor texts."
	set category = "IC"

	var/list/L = GLOB.mobs_with_editable_flavor_text[src]

	if(length(L) == 1)
		var/datum/element/flavor_text/F = L[1]
		F.set_flavor(src)
		return

	var/list/choices

	for(var/i in L)
		var/datum/element/flavor_text/F = i
		LAZYSET(choices, F.flavor_name, F)

	var/chosen = input(src, "Which flavor text would you like to modify?") as null|anything in choices
	if(!chosen)
		return
	var/datum/element/flavor_text/F = choices[chosen]
	F.set_flavor(src)

/datum/element/flavor_text/proc/set_flavor(mob/user)
	if(!(user in texts_by_mob))
		return FALSE

	var/lower_name = lowertext(flavor_name)
	var/new_text = stripped_multiline_input(user, "Set the [lower_name] displayed on 'examine'. [addendum]", flavor_name, texts_by_mob[usr], max_len, TRUE)
	if(!isnull(new_text) && (user in texts_by_mob))
		texts_by_mob[user] = html_decode(new_text)
		to_chat(src, "Your [lower_name] has been updated.")
		return TRUE
	return FALSE

//subtypes with additional hooks for DNA and preferences.
/datum/element/flavor_text/carbon

/datum/element/flavor_text/carbon/Attach(datum/target, text = "", _proc, _name = "Flavor Text", _addendum, _max_len = MAX_FAVOR_LEN, _always_show = FALSE, can_edit = TRUE)
	if(!iscarbon(target))
		return ELEMENT_INCOMPATIBLE
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return
	RegisterSignal(target, COMSIG_CARBON_IDENTITY_TRANSFERRED_TO, .proc/update_dna_flavor_text)
	if(ishuman(target))
		RegisterSignal(target, COMSIG_HUMAN_PREFS_COPIED_TO, .proc/update_prefs_flavor_text)
		RegisterSignal(target, COMSIG_HUMAN_HARDSET_DNA, .proc/update_dna_flavor_text)

/datum/element/flavor_text/carbon/Detach(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, list(COMSIG_CARBON_IDENTITY_TRANSFERRED_TO, COMSIG_HUMAN_PREFS_COPIED_TO, COMSIG_HUMAN_HARDSET_DNA))

/datum/element/flavor_text/carbon/proc/update_dna_flavor_text(mob/living/carbon/C)
	texts_by_mob[C] = C.dna.features["flavor_text"]

/datum/element/flavor_text/carbon/proc/update_prefs_flavor_text(mob/living/carbon/human/H, datum/preferences/P, icon_updates = TRUE, roundstart_checks = TRUE)
	texts_by_mob[H] = P.features["flavor_text"]

/datum/element/flavor_text/carbon/set_flavor(mob/living/carbon/user)
	. = ..()
	if(. && user.dna)
		user.dna.features["flavor_text"] = texts_by_mob[user]
