/turf/open/pool
	icon = 'icons/turf/pool.dmi'
	name = "poolwater"
	desc = "You're safer here than in the deep."
	icon_state = "pool_tile"
	heat_capacity = INFINITY
	var/filled = TRUE
	var/next_splash = 0
	var/obj/machinery/pool/controller/controller

/turf/open/pool/Destroy()
	controller = null
	return ..()

/turf/open/pool/proc/update_icon_pool()
	if(!filled)
		name = "drained pool"
		desc = "No diving!"
		cut_overlay(/obj/effect/overlay/water)
		cut_overlay(/obj/effect/overlay/water/top)
	else
		name = "poolwater"
		desc = "You're safer here than in the deep."
		add_overlay(/obj/effect/overlay/water)
		add_overlay(/obj/effect/overlay/water/top)

/obj/effect/overlay/water
	name = "water"
	icon = 'icons/turf/pool.dmi'
	icon_state = "bottom"
	density = 0
	mouse_opacity = 0
	layer = ABOVE_MOB_LAYER
	anchored = TRUE

/obj/effect/overlay/water/top
	icon_state = "top"
	layer = BELOW_MOB_LAYER

// Mousedrop hook to normal turfs to get out of pools.
/turf/open/MouseDrop_T(atom/from, mob/user)
	// I could make this /open/floor and not have the !istype but ehh - kev
	if(SEND_SIGNAL(from, COMSIG_IS_SWIMMING) && isliving(user) && ((user == from) || user.CanReach(from)) && CHECK_MOBILITY(user, MOBILITY_USE) && !istype(src, /turf/open/pool))
		var/mob/living/L = from
		//The element only exists if you're on water and a living mob, so let's skip those checks.
		var/pre_msg
		var/post_msg
		if(user == from)
			pre_msg = "<span class='notice'>[from] is getting out of the pool.</span>"
			post_msg = "<span class='notice'>[from] gets out of the pool.</span>"
		else
			pre_msg = "<span class='notice'>[from] is being pulled out of the pool by [user].</span>"
			post_msg = "<span class='notice'>[user] pulls [from] out of the pool.</span>"
		from.visible_message(pre_msg)
		if(do_mob(user, from, 20))
			from.visible_message(post_msg)
			from.forceMove(src)
	else
		return ..()

// Exit check
/turf/open/pool/Exit(atom/movable/AM, atom/newloc)
	if(!AM.has_gravity(src))
		return ..()
	if(isliving(AM) || istype(AM, /obj/structure))
		if(AM.throwing)
			return ..()			//WHEEEEEEEEEEE
		if(istype(AM, /obj/structure) && isliving(AM.pulledby))
			return ..()			//people pulling stuff out of pool
		if(!ishuman(AM))
			return ..()			//human weak, monkey (and anyone else) ook ook eek eek strong
		return istype(newloc, type)
	return ..()

// Exited logic
/turf/open/pool/Exited(atom/A, atom/newLoc)
	. = ..()
	if(isliving(A))
		controller?.mobs_in_pool -= A

// Entered logic
/turf/open/pool/Entered(atom/movable/AM, atom/oldloc)
	if(!AM.has_gravity(src))
		return ..()


/turf/open/pool/Entered(atom/A, turf/OL)
	..()
	if(isliving(A))
		var/mob/living/M = A
		if(!M.mob_has_gravity())
			return
		if(!M.swimming)
			M.swimming = TRUE
			controller.mobs_in_pool.Add(M)
			if(locate(/obj/structure/pool/ladder) in M.loc)
				return
			if(iscarbon(M))
				var/mob/living/carbon/H = M
				if(filled)
					if (H.wear_mask && H.wear_mask.flags_cover & MASKCOVERSMOUTH)
						H.visible_message("<span class='danger'>[H] falls in the water!</span>",
											"<span class='userdanger'>You fall in the water!</span>")
						playsound(src, 'sound/effects/splash.ogg', 60, TRUE, 1)
						H.Knockdown(20)
						return
					else
						H.Knockdown(60)
						H.adjustOxyLoss(5)
						H.emote("cough")
						H.visible_message("<span class='danger'>[H] falls in and takes a drink!</span>",
											"<span class='userdanger'>You fall in and swallow some water!</span>")
						playsound(src, 'sound/effects/splash.ogg', 60, TRUE, 1)
				else if(!istype(H.head, /obj/item/clothing/head/helmet))
					if(prob(75))
						H.visible_message("<span class='danger'>[H] falls in the drained pool!</span>",
													"<span class='userdanger'>You fall in the drained pool!</span>")
						H.adjustBruteLoss(7)
						H.Knockdown(80)
						playsound(src, 'sound/effects/woodhit.ogg', 60, TRUE, 1)
					else
						H.visible_message("<span class='danger'>[H] falls in the drained pool, and cracks his skull!</span>",
													"<span class='userdanger'>You fall in the drained pool, and crack your skull!</span>")
						H.apply_damage(15, BRUTE, "head")
						H.Knockdown(200) // This should hurt. And it does.
						playsound(src, 'sound/effects/woodhit.ogg', 60, TRUE, 1)
						playsound(src, 'sound/misc/crack.ogg', 100, TRUE)
				else
					H.visible_message("<span class='danger'>[H] falls in the drained pool, but had an helmet!</span>",
										"<span class='userdanger'>You fall in the drained pool, but you had an helmet!</span>")
					H.Knockdown(40)
					playsound(src, 'sound/effects/woodhit.ogg', 60, TRUE, 1)
		else if(filled)
			M.adjustStaminaLoss(1)
			playsound(src, "water_wade", 20, TRUE)
			return



/turf/open/pool/MouseDrop_T(atom/from, mob/user)
	. = ..()
	if(!isliving(from))
		return
	if(user.stat || user.lying || !Adjacent(user) || !from.Adjacent(user) || !iscarbon(user) || !victim.has_gravity(src) || SEND_SIGNAL(victim, COMSIG_IS_SWIMMING))
		return
	var/mob/living/victim = from
	var/victimname = victim == user? "themselves" : "[victim]"
	var/starttext = victim == user? "[user] is descending into [src]." : "[user] is lowering [victim] into [src]."
	user.visible_message("<span class='notice'>[starttext]</span>")
	if(do_mob(user, victim, 20))
		user.visible_message("<span class='notice'>[user] lowers [victimname] into [src].</span>")
		victim.AddElement(/datum/element/swimming)		//make sure they have it so they don't fall/whatever
		victim.forceMove(src)

/turf/open/pool/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/mop) && filled)
		W.reagents.add_reagent("water", 5)
		to_chat(user, "<span class='notice'>You wet [W] in [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
	else
		return ..()

/turf/open/pool/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if((user.loc != src) && CHECK_MOBILITY(user, MOBILITY_USE) && Adjacent(user) && SEND_SIGNAL(user, COMSIG_IS_SWIMMING) && filled && (next_splash < world.time))
		playsound(src, 'sound/effects/watersplash.ogg', 8, TRUE, 1)
		next_splash = world.time + 25
		var/obj/effect/splash/S = new(src)
		animate(S, alpha = 0, time = 8)
		QDEL_IN(S, 10)
		for(var/mob/living/carbon/human/H in src)
			if(!H.wear_mask && (H.stat == CONSCIOUS))
				H.emote("cough")
			H.adjustStaminaLoss(4)
