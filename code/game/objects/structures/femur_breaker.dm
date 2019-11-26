#define BREAKER_ANIMATION_LENGTH 32
#define BREAKER_SLAT_RAISED     1
#define BREAKER_SLAT_MOVING     2
#define BREAKER_SLAT_DROPPED    3
#define BREAKER_ACTIVATE_DELAY   30
#define BREAKER_WRENCH_DELAY     10
#define BREAKER_ACTION_INUSE      5
#define BREAKER_ACTION_WRENCH     6

/obj/structure/femur_breaker
	name = "femur breaker"
	desc = "A large structure used to break the femurs of traitors and treasonists."
	icon = 'icons/obj/femur_breaker.dmi'
	icon_state = "breaker_raised"
	can_buckle = TRUE
	anchored = TRUE
	density = TRUE
	max_buckled_mobs = 1
	buckle_lying = TRUE
	buckle_prevents_pull = TRUE
	layer = ABOVE_MOB_LAYER
	var/slat_status = BREAKER_SLAT_RAISED
	var/current_action = 0 // What's currently happening to the femur breaker

/obj/structure/femur_breaker/examine(mob/user)
	. = ..()
	. += "It is [anchored ? "secured to the floor." : "unsecured."]"
	if (slat_status == BREAKER_SLAT_RAISED)
		. += "The breaker slat is in a neutral position."
	else
		. += "The breaker slat is lowered, and must be raised."
	if (LAZYLEN(buckled_mobs))
		. += "Someone appears to be strapped in. You can help them unbuckle, or activate the femur breaker."

/obj/structure/femur_breaker/attack_hand(mob/user)
	add_fingerprint(user)

	// Currently being used
	if (current_action)
		return

	switch (slat_status)
		if (BREAKER_SLAT_MOVING)
			return
		if (BREAKER_SLAT_DROPPED)
			slat_status = BREAKER_SLAT_MOVING
			icon_state = "breaker_raise"
			addtimer(CALLBACK(src, .proc/raise_slat), BREAKER_ANIMATION_LENGTH)
			return
		if (BREAKER_SLAT_RAISED)
			if (LAZYLEN(buckled_mobs))
				if (user.a_intent == INTENT_HARM)
					user.visible_message("<span class='warning'>[user] begins to pull the lever!</span>",
						                 "<span class='warning'>You begin to the pull the lever.</span>")
					current_action = BREAKER_ACTION_INUSE

					if (do_after(user, BREAKER_ACTIVATE_DELAY, target = src) && slat_status == BREAKER_SLAT_RAISED)
						current_action = 0
						slat_status = BREAKER_SLAT_MOVING
						icon_state = "breaker_drop"
						drop_slat(user)
					else
						current_action = 0
				else
					var/mob/living/carbon/human/H = buckled_mobs[1]

					if (H)
						H.regenerate_icons()

					unbuckle_all_mobs()
			else //HERE
				slat_status = BREAKER_SLAT_DROPPED
				icon_state = "breaker_drop"

/obj/structure/femur_breaker/proc/damage_leg(mob/living/carbon/human/H)
		H.emote("scream")
		H.apply_damage(150, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		H.adjustBruteLoss(rand(5,20) + (max(0, H.health))) //Make absolutely sure they end up in crit, so that they can succumb if they wish.

/obj/structure/femur_breaker/proc/raise_slat()
	slat_status = BREAKER_SLAT_RAISED
	icon_state = "breaker_raised"

/obj/structure/femur_breaker/proc/drop_slat(mob/user)
	if (buckled_mobs.len)
		var/mob/living/carbon/human/H = buckled_mobs[1]

		if (!H)
			return

		playsound(src, 'sound/effects/femur_breaker.ogg', 100, FALSE)
		H.Stun(BREAKER_ANIMATION_LENGTH)
		addtimer(CALLBACK(src, .proc/damage_leg, H), BREAKER_ANIMATION_LENGTH, TIMER_UNIQUE)
		log_combat(user, H, "femur broke", src)

	slat_status = BREAKER_SLAT_DROPPED
	icon_state = "breaker"

/obj/structure/femur_breaker/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if (!anchored)
		to_chat(usr, "<span class='warning'>The [src] needs to be wrenched to the floor!</span>")
		return FALSE

	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, "<span class='warning'>It doesn't look like [M.p_they()] can fit into this properly!</span>")
		return FALSE

	if (slat_status != BREAKER_SLAT_RAISED)
		to_chat(usr, "<span class='warning'>The femur breaker must be in its neutral position before buckling someone in!</span>")
		return FALSE

	return ..(M, force, FALSE)

/obj/structure/femur_breaker/post_buckle_mob(mob/living/M)
	if (!istype(M, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = M

	if (H.dna)
		if (H.dna.species)
			var/datum/species/S = H.dna.species

			if (!istype(S))
				unbuckle_all_mobs()
		else
			unbuckle_all_mobs()
	else
		unbuckle_all_mobs()

	..()

/obj/structure/femur_breaker/can_be_unfasten_wrench(mob/user, silent)
	if (LAZYLEN(buckled_mobs))
		if (!silent)
			to_chat(user, "<span class='warning'>Can't unfasten, someone's strapped in!</span>")
		return FAILED_UNFASTEN

	if (current_action)
		return FAILED_UNFASTEN

	return ..()

/obj/structure/femur_breaker/wrench_act(mob/living/user, obj/item/I)
	if (current_action)
		return

	current_action = BREAKER_ACTION_WRENCH

	if (do_after(user, BREAKER_WRENCH_DELAY, target = src))
		current_action = 0
		default_unfasten_wrench(user, I, 0)
		setDir(SOUTH)
		return TRUE
	else
		current_action = 0

#undef BREAKER_ANIMATION_LENGTH
#undef BREAKER_SLAT_RAISED
#undef BREAKER_SLAT_MOVING
#undef BREAKER_SLAT_DROPPED
#undef BREAKER_ACTIVATE_DELAY
#undef BREAKER_WRENCH_DELAY
#undef BREAKER_ACTION_INUSE
#undef BREAKER_ACTION_WRENCH
