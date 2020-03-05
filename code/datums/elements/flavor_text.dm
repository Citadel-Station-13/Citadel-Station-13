/datum/element/flavor_text
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 3
	var/flavor_name = "Flavor Text"
	var/procpath/verb_instance
	var/invoke_proc
	var/list/texts_by_mob = list()
	var/addendum = "This can also be used for OOC notes and preferences!"
	var/always_show = FALSE
	var/max_len = MAX_FAVOR_LEN

/datum/element/flavor_text/Attach(datum/target, text, _proc, _name = "Flavor Text", _desc = "Sets an extended description of your character's features.", _addendum, _max_len = MAX_FAVOR_LEN, _always_show = FALSE, can_edit = TRUE)
	. = ..()

	if(. == ELEMENT_INCOMPATIBLE || !isatom(target)) //no reason why this shouldn't work on atoms too.
		return ELEMENT_INCOMPATIBLE

	texts_by_mob[target] = text
	if(_name)
		flavor_name = _name
	if(_proc)
		invoke_proc = _proc
	if(_max_len)
		max_len = _max_len
	if(!isnull(addendum))
		addendum = _addendum
	always_show = _always_show

	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/show_flavor)

	if(can_edit && ismob(target)) //but only mobs receive the proc/verb for the time being
		var/mob/M = target
		if(!verb_instance)
			verb_instance = new /datum/element/flavor_text/proc/set_flavor (src, "Set [_name]", _desc)
		M.verbs += verb_instance

/datum/element/flavor_text/Detach(atom/A)
	. = ..()
	UnregisterSignal(A, COMSIG_PARENT_EXAMINE)
	texts_by_mob -= A
	A.verbs -= verb_instance

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
		return "<span class='notice'>[html_encode(msg)]</span>"
	else
		return "<span class='notice'>[html_encode(copytext_char(msg, 1, 37))]... <a href='?src=[REF(src)];show_flavor=[REF(target)]'>More...</span></a>"

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

/datum/element/flavor_text/proc/set_flavor()
	set category = "IC"

	if(!(usr in texts_by_mob))
		return

	var/lower_name = lowertext(flavor_name)
	var/new_text = stripped_multiline_input(usr, "Set the [lower_name] displayed on 'examine'. [addendum]", flavor_name, texts_by_mob[usr], max_len, TRUE)
	if(!isnull(new_text) && (usr in texts_by_mob))
		texts_by_mob[usr] = html_decode(new_text)
		to_chat(src, "Your [lower_name] has been updated.")
		if(invoke_proc)
			INVOKE_ASYNC(usr, invoke_proc, new_text)

//subtypes with additional hooks for DNA and preferences.
/datum/element/flavor_text/carbon
	invoke_proc = /mob/living/carbon.proc/update_flavor_text_feature

/datum/element/flavor_text/carbon/Attach(datum/target, text, _proc, _name = "Flavor Text", _desc = "Sets an extended description of your character's features.", _addendum, _max_len = MAX_FAVOR_LEN, _always_show = FALSE, can_edit = TRUE)
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
