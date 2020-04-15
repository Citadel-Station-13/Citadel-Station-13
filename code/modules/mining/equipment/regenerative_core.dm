/*********************Hivelord stabilizer****************/
/obj/item/hivelordstabilizer
	name = "stabilizing serum"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"
	desc = "Inject certain types of monster organs with this stabilizer to preserve their healing powers indefinitely."
	w_class = WEIGHT_CLASS_TINY

/obj/item/hivelordstabilizer/afterattack(obj/item/organ/M, mob/user)
	. = ..()
	var/obj/item/organ/regenerative_core/C = M
	if(!istype(C, /obj/item/organ/regenerative_core))
		to_chat(user, "<span class='warning'>The stabilizer only works on certain types of monster organs, generally regenerative in nature.</span>")
		return ..()

	C.preserved()
	to_chat(user, "<span class='notice'>You inject the [M] with the stabilizer. It will no longer go inert.</span>")
	qdel(src)

/************************Hivelord core*******************/
/obj/item/organ/regenerative_core
	name = "regenerative core"
	desc = "All that remains of a hivelord. It can be used to heal completely, but it will rapidly decay into uselessness."
	icon_state = "roro core 2"
	item_flags = NOBLUDGEON
	slot = "hivecore"
	force = 0
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/inert = 0
	var/preserved = 0

/obj/item/organ/regenerative_core/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/inert_check), 2400)

/obj/item/organ/regenerative_core/proc/inert_check()
	if(!preserved)
		go_inert()

/obj/item/organ/regenerative_core/proc/preserved(implanted = 0)
	inert = FALSE
	preserved = TRUE
	update_icon()
	desc = "All that remains of a hivelord. It is preserved, allowing you to use it to heal completely without danger of decay."
	if(implanted)
		SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "implanted"))
	else
		SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "stabilizer"))

/obj/item/organ/regenerative_core/proc/go_inert()
	inert = TRUE
	name = "decayed regenerative core"
	desc = "All that remains of a hivelord. It has decayed, and is completely useless."
	SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "inert"))
	update_icon()

/obj/item/organ/regenerative_core/ui_action_click()
	if(inert)
		to_chat(owner, "<span class='notice'>[src] breaks down as it tries to activate.</span>")
	else
		owner.revive(full_heal = 1)
		owner.log_message("[owner] used an implanted [src] to heal themselves! Keep fighting, it's just a flesh wound!", LOG_ATTACK, color="green") //Logging for implanted legion core use
	qdel(src)

/obj/item/organ/regenerative_core/on_life()
	..()
	if(owner.health < owner.crit_threshold)
		ui_action_click()

/obj/item/organ/regenerative_core/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag && ishuman(target))
		var/mob/living/carbon/human/H = target
		if(inert)
			to_chat(user, "<span class='notice'>[src] has decayed and can no longer be used to heal.</span>")
			return
		if(isvamp(user))
			to_chat(user, "<span class='notice'>[src] breaks down as it fails to heal your unholy self</span>")
			return
		else
			if(H.stat == DEAD)
				to_chat(user, "<span class='notice'>[src] are useless on the dead.</span>")
				return
			if(H != user)
				H.visible_message("[user] forces [H] to apply [src]... [H.p_they()] quickly regenerate all injuries!")
				SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "used", "other"))
			else
				to_chat(user, "<span class='notice'>You start to smear [src] on yourself. It feels and smells disgusting, but you feel amazingly refreshed in mere moments.</span>")
				SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "used", "self"))
			H.revive(full_heal = 1)
			qdel(src)
			user.log_message("[user] used [src] to heal [H]! Wake the fuck up, Samurai!", LOG_ATTACK, color="green") //Logging for 'old' style legion core use, when clicking on a sprite of yourself or another.

/obj/item/organ/regenerative_core/attack_self(mob/user) //Knouli's first hack! Allows for the use of the core in hand rather than needing to click on the target, yourself, to selfheal. Its a rip of the proc just above - but skips on distance check and only uses 'user' rather than 'target'
	if(ishuman(user)) //Check if user is human, no need for distance check as it's self heal
		var/mob/living/carbon/human/H = user //Set H to user rather than target
		if(inert) //Inert cores are useless
			to_chat(user, "<span class='notice'>[src] has decayed and can no longer be used to heal.</span>")
			return
		else //Skip on check if the target to be healed is dead as, if you are dead, you're not going to be able to use it on yourself!
			to_chat(user, "<span class='notice'>You start to smear [src] on yourself. It feels and smells disgusting, but you feel amazingly refreshed in mere moments.</span>")
			SSblackbox.record_feedback("nested tally", "hivelord_core", 1, list("[type]", "used", "self"))
		H.revive(full_heal = 1)
		qdel(src)
		H.log_message("[H] used [src] to heal themselves! Making use of Knouli's sexy and intelligent use-in-hand proc!", LOG_ATTACK, color="green") //Logging for 'new' style legion core use, when using the core in-hand.


/obj/item/organ/regenerative_core/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(!preserved && !inert)
		preserved(TRUE)
		owner.visible_message("<span class='notice'>[src] stabilizes as it's inserted.</span>")

/obj/item/organ/regenerative_core/Remove(special = FALSE)
	if(!inert && !special && !QDELETED(owner))
		owner.visible_message("<span class='notice'>[src] rapidly decays as it's removed.</span>")
		go_inert()
	return ..()

/obj/item/organ/regenerative_core/prepare_eat()
	return null

/*************************Legion core********************/
/obj/item/organ/regenerative_core/legion
	desc = "A strange rock that crackles with power. It can be used to heal completely, but it will rapidly decay into uselessness."
	icon_state = "legion_soul"

/obj/item/organ/regenerative_core/legion/Initialize()
	. = ..()
	update_icon()

/obj/item/organ/regenerative_core/update_icon_state()
	icon_state = inert ? "legion_soul_inert" : "legion_soul"

/obj/item/organ/regenerative_core/update_overlays()
	. = ..()
	if(!inert && !preserved)
		. += "legion_soul_crackle"

/obj/item/organ/regenerative_core/legion/go_inert()
	..()
	desc = "[src] has become inert. It has decayed, and is completely useless."

/obj/item/organ/regenerative_core/legion/preserved(implanted = 0)
	..()
	desc = "[src] has been stabilized. It is preserved, allowing you to use it to heal completely without danger of decay."
