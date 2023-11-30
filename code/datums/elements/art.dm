
#define BAD_ART 12.5
#define GOOD_ART 25
#define GREAT_ART 50

/datum/element/art
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/impressiveness = 0

/datum/element/art/Attach(datum/target, impress)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !isatom(target) || isarea(target))
		return ELEMENT_INCOMPATIBLE
	impressiveness = impress
	if(isobj(target))
		RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_obj_examine))
		if(isstructure(target))
			RegisterSignal(target, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
		if(isitem(target))
			RegisterSignal(target, COMSIG_ITEM_ATTACK_SELF, PROC_REF(apply_moodlet))
	else
		RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_other_examine))

/datum/element/art/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_PARENT_EXAMINE, COMSIG_ATOM_ATTACK_HAND, COMSIG_ITEM_ATTACK_SELF))
	return ..()

/datum/element/art/proc/apply_moodlet(atom/source, mob/M, impress)
	M.visible_message("<span class='notice'>[M] stops and looks intently at [source].</span>", \
						 "<span class='notice'>You stop to take in [source].</span>")
	switch(impress)
		if (0 to BAD_ART)
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "artbad", /datum/mood_event/artbad)
		if (BAD_ART to GOOD_ART)
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "artok", /datum/mood_event/artok)
		if (GOOD_ART to GREAT_ART)
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "artgood", /datum/mood_event/artgood)
		if(GREAT_ART to INFINITY)
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "artgreat", /datum/mood_event/artgreat)

/datum/element/art/proc/on_other_examine(atom/source, mob/M)
	apply_moodlet(source, M, impressiveness)

/datum/element/art/proc/on_obj_examine(atom/source, mob/M)
	var/obj/O = source
	apply_moodlet(source, M, impressiveness *(O.obj_integrity/O.max_integrity))

/datum/element/art/proc/on_attack_hand(atom/source, mob/M)
	to_chat(M, "<span class='notice'>You start examining [source]...</span>")
	if(!do_after(M, 20, target = source))
		return
	on_obj_examine(source, M)

/datum/element/art/rev

/datum/element/art/rev/apply_moodlet(atom/source, mob/user, impress)
	var/msg
	if(user.mind?.has_antag_datum(/datum/antagonist/rev))
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artgreat", /datum/mood_event/artgreat)
		msg = "What \a [pick("masterpiece", "chef-d'oeuvre")] [source.p_theyre()]. So [pick("subversive", "revolutionary", "unitizing", "egalitarian")]!"
	else
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "artbad", /datum/mood_event/artbad)
		msg = "Wow, [source.p_they()] sucks."

	user.visible_message(span_notice("[user] stops to inspect [source]."), \
		span_notice("You appraise [source], inspecting the fine craftsmanship of the proletariat... [msg]"))
