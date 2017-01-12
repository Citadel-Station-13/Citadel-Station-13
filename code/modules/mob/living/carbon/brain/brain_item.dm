/obj/item/organ/brain
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	icon_state = "brain"
	throw_speed = 3
	throw_range = 5
	layer = ABOVE_MOB_LAYER
	zone = "head"
	slot = "brain"
	vital = 1
	origin_tech = "biotech=5"
	attack_verb = list("attacked", "slapped", "whacked")
	var/mob/living/carbon/brain/brainmob = null
	var/damaged_brain = 0 //whether the brain organ is damaged.

/obj/item/organ/brain/Insert(mob/living/carbon/M, special = 0)
	..()
	name = "brain"
	if(brainmob)
		if(M.key)
			M.ghostize()

		if(brainmob.mind)
			brainmob.mind.transfer_to(M)
		else
			M.key = brainmob.key

		qdel(brainmob)

	//Update the body's icon so it doesnt appear debrained anymore
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_hair(0)

/obj/item/organ/brain/Remove(mob/living/carbon/M, special = 0)
	..()
	if(!special)
		transfer_identity(M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_hair(0)

/obj/item/organ/brain/prepare_eat()
	return // Too important to eat.

/obj/item/organ/brain/proc/transfer_identity(mob/living/L)
	name = "[L.name]'s brain"
	brainmob = new(src)
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	brainmob.timeofhostdeath = L.timeofdeath
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.dna)
			brainmob.dna = new /datum/dna(brainmob)
		C.dna.copy_dna(brainmob.dna)
	if(L.mind && L.mind.current && (L.mind.current.stat == DEAD))
		L.mind.transfer_to(brainmob)
	brainmob << "<span class='notice'>You feel slightly disoriented. That's normal when you're just a brain.</span>"

/obj/item/organ/brain/attackby(obj/item/O, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if(brainmob)
		O.attack(brainmob, user) //Oh noooeeeee

/obj/item/organ/brain/examine(mob/user)
	..()

	if(brainmob)
		if(brainmob.client)
			if(brainmob.health <= config.health_threshold_dead)
				user << "It's lifeless and severely damaged."
			else
				user << "You can feel the small spark of life still left in this one."
		else
			user << "This one seems particularly lifeless. Perhaps it will regain some of its luster later."
	else
		user << "This one is completely devoid of life."

/obj/item/organ/brain/attack(mob/living/carbon/M, mob/user)
	if(!istype(M))
		return ..()

	add_fingerprint(user)

	if(user.zone_selected != "head")
		return ..()

	var/mob/living/carbon/human/H = M
	if(istype(H) && ((H.head && H.head.flags_cover & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags_cover & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
		user << "<span class='warning'>You're going to need to remove their head cover first!</span>"
		return

//since these people will be dead M != usr

	if(!M.getorgan(/obj/item/organ/brain))
		if(istype(H) && !H.get_bodypart("head"))
			return
		user.drop_item()
		var/msg = "[M] has [src] inserted into \his head by [user]."
		if(M == user)
			msg = "[user] inserts [src] into \his head!"

		M.visible_message("<span class='danger'>[msg]</span>",
						"<span class='userdanger'>[msg]</span>")

		if(M != user)
			M << "<span class='notice'>[user] inserts [src] into your head.</span>"
			user << "<span class='notice'>You insert [src] into [M]'s head.</span>"
		else
			user << "<span class='notice'>You insert [src] into your head.</span>"	//LOL

		Insert(M)
	else
		..()

/obj/item/organ/brain/Destroy() //copypasted from MMIs.
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	return ..()

/obj/item/organ/brain/alien
	name = "alien brain"
	desc = "We barely understand the brains of terrestial animals. Who knows what we may find in the brain of such an advanced species?"
	icon_state = "brain-x"
	origin_tech = "biotech=6"
