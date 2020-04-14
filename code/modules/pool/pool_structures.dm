/obj/structure/pool
	name = "pool"
	icon = 'icons/obj/machines/pool.dmi'
	anchored = TRUE
	resistance_flags = UNACIDABLE|INDESTRUCTIBLE

/obj/structure/pool/ladder
	name = "Ladder"
	icon_state = "ladder"
	desc = "Are you getting in or are you getting out?."
	layer = ABOVE_MOB_LAYER
	dir = EAST

/obj/structure/pool/ladder/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!HAS_TRAIT(user, TRAIT_SWIMMING))
		if(user.CanReach(src))
			user.AddElement(/datum/element/swimming)
			user.forceMove(get_step(src, dir))
	else
		if(user.loc == loc)
			user.forceMove(get_step(src, turn(dir, 180)))		//If this moves them out the element cleans up after itself.

/obj/structure/pool/Rboard
	name = "JumpBoard"
	density = FALSE
	icon_state = "boardright"
	desc = "The less-loved portion of the jumping board."
	dir = EAST

/obj/structure/pool/Lboard
	name = "JumpBoard"
	icon_state = "boardleft"
	desc = "Get on there to jump!"
	layer = FLY_LAYER
	dir = WEST
	var/jumping = FALSE
	var/timer

/obj/structure/pool/Lboard/proc/backswim()
	if(jumping)
		for(var/mob/living/jumpee in loc) //hackzors.
			playsound(jumpee, 'sound/effects/splash.ogg', 60, TRUE, 1)
			if(!HAS_TRAIT(jumpee, TRAIT_SWIMMING))
				jumpee.AddElement(/datum/element/swimming)
			jumpee.Stun(2)

/obj/structure/pool/Lboard/proc/reset_position(mob/user, initial_layer, initial_px, initial_py)
	user.layer = initial_layer
	user.pixel_x = initial_px
	user.pixel_y = initial_py

/obj/structure/pool/Lboard/attack_hand(mob/living/user)
	if(iscarbon(user))
		var/mob/living/carbon/jumper = user
		if(jumping)
			to_chat(user, "<span class='notice'>Someone else is already making a jump!</span>")
			return
		var/turf/T = get_turf(src)
		if(HAS_TRAIT(user, TRAIT_SWIMMING))
			return
		else
			if(Adjacent(jumper))
				jumper.visible_message("<span class='notice'>[user] climbs up \the [src]!</span>", \
									 "<span class='notice'>You climb up \the [src] and prepares to jump!</span>")
				jumper.Stun(40)
				jumping = TRUE
				var/original_layer = jumper.layer
				var/original_px = jumper.pixel_x
				var/original_py = jumper.pixel_y
				jumper.layer = RIPPLE_LAYER
				jumper.pixel_x = 3
				jumper.pixel_y = 7
				jumper.dir = WEST
				jumper.AddElement(/datum/element/swimming)
				sleep(1)
				jumper.forceMove(T)
				addtimer(CALLBACK(src, .proc/dive, jumper, original_layer, original_px, original_py), 10)

/obj/structure/pool/Lboard/proc/dive(mob/living/carbon/jumper, original_layer, original_px, original_py)
	switch(rand(1, 100))
		if(1 to 20)
			jumper.visible_message("<span class='notice'>[jumper] goes for a small dive!</span>", \
								 "<span class='notice'>You go for a small dive.</span>")
			sleep(15)
			backswim()
			var/atom/throw_target = get_edge_target_turf(src, dir)
			jumper.throw_at(throw_target, 1, 1, callback = CALLBACK(src, .proc/on_finish_jump, jumper))

		if(21 to 40)
			jumper.visible_message("<span class='notice'>[jumper] goes for a dive!</span>", \
								 "<span class='notice'>You're going for a dive!</span>")
			sleep(20)
			backswim()
			var/atom/throw_target = get_edge_target_turf(src, dir)
			jumper.throw_at(throw_target, 2, 1, callback = CALLBACK(src, .proc/on_finish_jump, jumper))

		if(41 to 60)
			jumper.visible_message("<span class='notice'>[jumper] goes for a long dive! Stay far away!</span>", \
					"<span class='notice'>You're going for a long dive!!</span>")
			sleep(25)
			backswim()
			var/atom/throw_target = get_edge_target_turf(src, dir)
			jumper.throw_at(throw_target, 3, 1, callback = CALLBACK(src, .proc/on_finish_jump, jumper))

		if(61 to 80)
			jumper.visible_message("<span class='notice'>[jumper] goes for an awesome dive! Don't stand in [jumper.p_their()] way!</span>", \
								 "<span class='notice'>You feel like this dive will be awesome</span>")
			sleep(30)
			backswim()
			var/atom/throw_target = get_edge_target_turf(src, dir)
			jumper.throw_at(throw_target, 4, 1, callback = CALLBACK(src, .proc/on_finish_jump, jumper))
		if(81 to 91)
			sleep(20)
			backswim()
			jumper.visible_message("<span class='danger'>[jumper] misses [jumper.p_their()] step!</span>", \
							 "<span class='userdanger'>You misstep!</span>")
			var/atom/throw_target = get_edge_target_turf(src, dir)
			jumper.throw_at(throw_target, 0, 1, callback = CALLBACK(src, .proc/on_finish_jump, jumper))
			jumper.DefaultCombatKnockdown(100)
			jumper.adjustBruteLoss(10)

		if(91 to 100)
			jumper.visible_message("<span class='notice'>[jumper] is preparing for the legendary dive! Can [jumper.p_they()] make it?</span>", \
								 "<span class='userdanger'>You start preparing for a legendary dive!</span>")
			jumper.SpinAnimation(7,1)

			sleep(30)
			if(prob(75))
				backswim()
				jumper.visible_message("<span class='notice'>[jumper] fails!</span>", \
						 "<span class='userdanger'>You can't quite do it!</span>")
				var/atom/throw_target = get_edge_target_turf(src, dir)
				jumper.throw_at(throw_target, 1, 1, callback = CALLBACK(src, .proc/on_finish_jump, jumper))
			else
				jumper.fire_stacks = min(1,jumper.fire_stacks + 1)
				jumper.IgniteMob()
				sleep(5)
				backswim()
				jumper.visible_message("<span class='danger'>[jumper] bursts into flames of pure awesomness!</span>", \
					 "<span class='userdanger'>No one can stop you now!</span>")
				var/atom/throw_target = get_edge_target_turf(src, dir)
				jumper.throw_at(throw_target, 6, 1, callback = CALLBACK(src, .proc/on_finish_jump, jumper))
	addtimer(CALLBACK(src, .proc/togglejumping), 35)
	reset_position(jumper, original_layer, original_px, original_py)

/obj/structure/pool/Lboard/proc/togglejumping()
	jumping = FALSE

/obj/structure/pool/Lboard/proc/on_finish_jump(mob/living/victim)
	if(istype(victim.loc, /turf/open/pool))
		var/turf/open/pool/P = victim.loc
		if(!P.filled)		//you dun fucked up now
			to_chat(victim, "<span class='warning'>That was stupid of you..</span>")
			victim.visible_message("<span class='danger'>[victim] smashes into the ground!</span>")
			victim.apply_damage(50)
			victim.DefaultCombatKnockdown(200)
