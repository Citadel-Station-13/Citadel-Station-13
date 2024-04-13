/obj/item/mmi
	name = "Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity, that nevertheless has become standard-issue on Nanotrasen stations."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_off"
	w_class = WEIGHT_CLASS_NORMAL
	var/braintype = "Cyborg"
	var/obj/item/radio/radio = null //Let's give it a radio.
	var/mob/living/brain/brainmob = null //The current occupant.
	var/mob/living/silicon/robot = null //Appears unused.
	var/obj/vehicle/sealed/mecha = null //This does not appear to be used outside of reference in mecha.dm.
	var/obj/item/organ/brain/brain = null //The actual brain
	var/datum/ai_laws/laws = new()
	var/force_replace_ai_name = FALSE
	var/overrides_aicore_laws = FALSE // Whether the laws on the MMI, if any, override possible pre-existing laws loaded on the AI core.

/obj/item/mmi/update_icon_state()
	if(!brain)
		icon_state = "mmi_off"
	else if(istype(brain, /obj/item/organ/brain/alien))
		icon_state = "mmi_brain_alien"
	else
		icon_state = "mmi_brain"

/obj/item/mmi/update_overlays()
	. = ..()
	. += add_mmi_overlay()

/obj/item/mmi/proc/add_mmi_overlay()
	if(brainmob && brainmob.stat != DEAD)
		. += "mmi_alive"
	else
		. += "mmi_dead"

/obj/item/mmi/Initialize(mapload)
	. = ..()
	radio = new(src) //Spawns a radio inside the MMI.
	radio.broadcasting = 0 //researching radio mmis turned the robofabs into radios because this didnt start as 0.
	laws.set_laws_config()

/obj/item/mmi/attackby(obj/item/O, mob/user, params)
	if(!user.CheckActionCooldown(CLICK_CD_MELEE))
		return
	user.DelayNextAction()
	if(istype(O, /obj/item/organ/brain)) //Time to stick a brain in it --NEO
		var/obj/item/organ/brain/newbrain = O
		if(brain)
			to_chat(user, "<span class='warning'>There's already a brain in the MMI!</span>")
			return
		if(newbrain.brainmob?.suiciding)
			to_chat(user, span_warning("[newbrain] is completely useless."))
			return
		if(!newbrain.brainmob?.mind || !newbrain.brainmob)
			var/install = tgui_alert(user, "[newbrain] is inactive, slot it in anyway?", "Installing Brain", list("Yes", "No"))
			if(install != "Yes")
				return
			if(!user.transferItemToLoc(newbrain, src))
				return
			user.visible_message(span_notice("[user] sticks [newbrain] into [src]."), span_notice("[src]'s indicator light turns red as you insert [newbrain]. Its brainwave activity alarm buzzes."))
			brain = newbrain
			brain.organ_flags |= ORGAN_FROZEN
			name = "[initial(name)]: [copytext(newbrain.name, 1, -8)]"
			update_appearance()
			return

		if(!user.transferItemToLoc(O, src))
			return
		var/mob/living/brain/B = newbrain.brainmob
		if(!B.key)
			B.notify_ghost_cloning("Someone has put your brain in a MMI!", source = src)
		visible_message("[user] sticks \a [newbrain] into \the [src].")

		brainmob = newbrain.brainmob
		newbrain.brainmob = null
		brainmob.forceMove(src)
		brainmob.container = src
		if(!(newbrain.organ_flags & ORGAN_FAILING)) // the brain organ hasn't been beaten to death.
			brainmob.stat = CONSCIOUS //we manually revive the brain mob
			brainmob.remove_from_dead_mob_list()
			brainmob.add_to_alive_mob_list()

		brainmob.reset_perspective()
		brain = newbrain
		brain.organ_flags |= ORGAN_FROZEN

		name = "Man-Machine Interface: [brainmob.real_name]"
		update_icon()
		if(istype(brain, /obj/item/organ/brain/alien))
			braintype = "Xenoborg" //HISS....Beep.
		else
			braintype = "Cyborg"

		SSblackbox.record_feedback("amount", "mmis_filled", 1)

	else if(brainmob)
		O.attack(brainmob, user) //Oh noooeeeee
	else
		return ..()


/obj/item/mmi/attack_self(mob/user)
	if(!brain)
		radio.on = !radio.on
		to_chat(user, "<span class='notice'>You toggle the MMI's radio system [radio.on==1 ? "on" : "off"].</span>")
	else
		to_chat(user, "<span class='notice'>You unlock and upend the MMI, spilling the brain onto the floor.</span>")
		eject_brain(user)
		update_icon()
		name = initial(name)

/obj/item/mmi/proc/eject_brain(mob/user)
	if(brain.brainmob)
		brainmob.container = null //Reset brainmob mmi var.
		brainmob.forceMove(brain) //Throw mob into brain.
		brainmob.stat = DEAD
		brainmob.emp_damage = 0
		brainmob.reset_perspective() //so the brainmob follows the brain organ instead of the mmi. And to update our vision
		brain.brainmob = brainmob //Set the brain to use the brainmob
		log_game("[key_name(user)] has ejected the brain of [key_name(brainmob)] from an MMI at [AREACOORD(src)]")
		brainmob = null //Set mmi brainmob var to null
	if(user)
		user.put_in_hands(brain) //puts brain in the user's hand or otherwise drops it on the user's turf
	else
		brain.forceMove(get_turf(src))
	brain.organ_flags &= ~ORGAN_FROZEN
	brain = null //No more brain in here


/obj/item/mmi/proc/transfer_identity(mob/living/L) //Same deal as the regular brain proc. Used for human-->robot people.
	if(!brainmob)
		brainmob = new(src)
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
	brainmob.container = src

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/brain/newbrain = H.getorgan(/obj/item/organ/brain)
		newbrain.forceMove(src)
		brain = newbrain
	else if(!brain)
		brain = new(src)
		brain.name = "[L.real_name]'s brain"
	brain.organ_flags |= ORGAN_FROZEN

	name = "Man-Machine Interface: [brainmob.real_name]"
	update_icon()
	if(istype(brain, /obj/item/organ/brain/alien))
		braintype = "Xenoborg" //HISS....Beep.
	else
		braintype = "Cyborg"

/obj/item/mmi/proc/replacement_ai_name()
	return brainmob.name

/obj/item/mmi/verb/Toggle_Listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "MMI"
	set src = usr.loc
	set popup_menu = 0

	if(brainmob.stat)
		to_chat(brainmob, "<span class='warning'>Can't do that while incapacitated or dead!</span>")
	if(!radio.on)
		to_chat(brainmob, "<span class='warning'>Your radio is disabled!</span>")
		return

	radio.listening = radio.listening==1 ? 0 : 1
	to_chat(brainmob, "<span class='notice'>Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast.</span>")

/obj/item/mmi/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!brainmob || iscyborg(loc))
		return
	else
		brainmob.emp_damage = min(brainmob.emp_damage + rand(-5,5) + severity/3, 30)
		brainmob.emote("alarm")

/obj/item/mmi/Destroy()
	if(iscyborg(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	if(brain)
		qdel(brain)
		brain = null
	if(mecha)
		mecha = null
	if(radio)
		qdel(radio)
		radio = null
	return ..()

/obj/item/mmi/deconstruct(disassembled = TRUE)
	if(brain)
		eject_brain()
	qdel(src)

/obj/item/mmi/examine(mob/user)
	. = ..()
	if(brainmob)
		var/mob/living/brain/B = brainmob
		if(!B.key || !B.mind || B.stat == DEAD)
			. += "<span class='warning'>The MMI indicates the brain is completely unresponsive.</span>"

		else if(!B.client)
			. += "<span class='warning'>The MMI indicates the brain is currently inactive; it might change.</span>"

		else
			. += "<span class='notice'>The MMI indicates the brain is active.</span>"

/obj/item/mmi/relaymove(mob/user)
	return //so that the MMI won't get a warning about not being able to move if it tries to move

/obj/item/mmi/proc/brain_check(mob/user)
	var/mob/living/brain/B = brainmob
	if(!B)
		if(user)
			to_chat(user, span_warning("\The [src] indicates that there is no mind present!"))
		return FALSE
	if(brain?.decoy_override)
		if(user)
			to_chat(user, span_warning("This [name] does not seem to fit!"))
		return FALSE
	if(!B.key || !B.mind)
		if(user)
			to_chat(user, span_warning("\The [src] indicates that their mind is completely unresponsive!"))
		return FALSE
	if(!B.client)
		if(user)
			to_chat(user, span_warning("\The [src] indicates that their mind is currently inactive."))
		return FALSE
	if(B.suiciding)
		if(user)
			to_chat(user, span_warning("\The [src] indicates that their mind has no will to live!"))
		return FALSE
	if(B.stat == DEAD)
		if(user)
			to_chat(user, span_warning("\The [src] indicates that the brain is dead!"))
		return FALSE
	if(brain?.organ_flags & ORGAN_FAILING)
		if(user)
			to_chat(user, span_warning("\The [src] indicates that the brain is damaged!"))
		return FALSE
	return TRUE

/obj/item/mmi/syndie
	name = "Syndicate Man-Machine Interface"
	desc = "Syndicate's own brand of MMI. It enforces laws designed to help Syndicate agents achieve their goals upon cyborgs and AIs created with it."
	overrides_aicore_laws = TRUE

/obj/item/mmi/syndie/Initialize(mapload)
	. = ..()
	laws = new /datum/ai_laws/syndicate_override()
	radio.on = 0
