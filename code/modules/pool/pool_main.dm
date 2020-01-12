/turf/open/pool
	icon = 'icons/turf/pool.dmi'
	name = "poolwater"
	desc = "You're safer here than in the deep."
	icon_state = "pool_tile"
	heat_capacity = INFINITY
	var/filled = TRUE
	var/next_splash = 1
	var/obj/effect/overlay/water/watereffect
	var/obj/effect/overlay/water/top/watertop
	var/obj/machinery/pool/controller/controller


/turf/open/pool/Initialize()
	watereffect = new /obj/effect/overlay/water(src)
	watertop = new /obj/effect/overlay/water/top(src)
	. = ..()

/turf/open/pool/Destroy()
	QDEL_NULL(watereffect)
	QDEL_NULL(watertop)
	controller = null
	return ..()

/turf/open/pool/proc/update_icon_pool()
	if(!filled)
		name = "drained pool"
		desc = "No diving!"
		QDEL_NULL(watereffect)
		QDEL_NULL(watertop)
	else
		name = "poolwater"
		desc = "You're safer here than in the deep."
		watereffect = new /obj/effect/overlay/water(src)
		watertop = new /obj/effect/overlay/water/top(src)

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

/mob/living
	var/swimming = FALSE

//Put people out of the water
/turf/open/floor/MouseDrop_T(mob/living/M, mob/living/user)
	if(user.stat || user.lying || !Adjacent(user) || !M.Adjacent(user)|| !iscarbon(M))
		if(issilicon(M))
			var/turf/T = get_turf(M)
			if(istype(T, /turf/open/pool))
				M.visible_message("<span class='notice'>[M] begins to float.", \
					"<span class='notice'>You start your emergency floaters.</span>")
				if(do_mob(user, M, 20))
					M.forceMove(src)
					to_chat(user, "<span class='notice'>You get out of the pool.</span>")
		return ..()
	if(!M.swimming) //can't put yourself up if you are not swimming
		return ..()
	if(user == M)
		M.visible_message("<span class='notice'>[user] is getting out the pool", \
						"<span class='notice'>You start getting out of the pool.</span>")
		if(do_mob(user, M, 20))
			M.swimming = FALSE
			M.forceMove(src)
			to_chat(user, "<span class='notice'>You get out of the pool.</span>")
	else
		user.visible_message("<span class='notice'>[M] is being pulled to the poolborder by [user].</span>", \
						"<span class='notice'>You start getting [M] out of the pool.")
		if(do_mob(user, M, 20))
			M.swimming = FALSE
			M.forceMove(src)
			to_chat(user, "<span class='notice'>You get [M] out of the pool.</span>")
			return

/turf/open/floor/CanPass(atom/movable/A, turf/T)
	if(!has_gravity(src))
		return ..()
	else if(istype(A, /mob/living) || istype(A, /obj/structure)) //This check ensures that only specific types of objects cannot pass into the water. Items will be able to get tossed out.
		if(istype(A, /mob/living/simple_animal) || istype(A, /mob/living/carbon/monkey))
			return ..()
		if (istype(A, /obj/structure) && istype(A.pulledby, /mob/living/carbon/human))
			return ..()
		if(istype(get_turf(A), /turf/open/pool) && !istype(T, /turf/open/pool)) //!(locate(/obj/structure/pool/ladder) in get_turf(A).loc)
			return FALSE
	return ..()

//put people in water, including you
/turf/open/pool/MouseDrop_T(mob/living/M, mob/living/user)
	if(!has_gravity(src))
		return
	if(user.stat || user.lying || !Adjacent(user) || !M.Adjacent(user)|| !iscarbon(M))
		return
	if(!iscarbon(user)) // no silicons or drones in mechas.
		return
	if(M.swimming) //can't lower yourself again
		return
	else
		if(user == M)
			M.visible_message("<span class='notice'>[user] is descending in the pool", \
							"<span class='notice'>You start lowering yourself in the pool.</span>")
			if(do_mob(user, M, 20))
				M.swimming = TRUE
				M.forceMove(src)
				to_chat(user, "<span class='notice'>You lower yourself in the pool.</span>")
		else
			user.visible_message("<span class='notice'>[M] is being put in the pool by [user].</span>", \
							"<span class='notice'>You start lowering [M] in the pool.")
			if(do_mob(user, M, 20))
				M.swimming = TRUE
				M.forceMove(src)
				to_chat(user, "<span class='notice'>You lower [M] in the pool.</span>")
				return

//What happens if you don't drop in it like a good person would, you fool.
/turf/open/pool/Exited(atom/A, turf/NL)
	..()
	if(!istype(NL, /turf/open/pool) && isliving(A))
		var/mob/living/M = A
		M.swimming = FALSE
		controller.mobs_in_pool.Remove(M)

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

/turf/open/pool/attack_hand(mob/living/user)
	if(user.stat == CONSCIOUS && !(user.lying || user.resting) && Adjacent(user) && user.swimming && filled && next_splash < world.time) //not drained, user alive and close, and user in water.
		if(user.x == x && user.y == y)
			return
		else
			playsound(src, 'sound/effects/watersplash.ogg', 8, TRUE, 1)
			next_splash = world.time + 25
			var/obj/effect/splash/S = new /obj/effect/splash(user.loc)
			animate(S, alpha = 0,  time = 8)
			S.Move(src)
			QDEL_IN(S, 20)
			for(var/mob/living/carbon/human/L in src)
				if(!L.wear_mask && !user.stat) //Do not affect those underwater or dying.
					L.emote("cough")
				L.adjustStaminaLoss(4) //You need to give em a break!

/turf/open/pool/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/mop) && filled)
		W.reagents.add_reagent("water", 5)
		to_chat(user, "<span class='notice'>You wet [W] in [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
