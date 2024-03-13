//Bomb
/mob/living/simple_animal/hostile/guardian/bomb
	melee_damage_lower = 15
	melee_damage_upper = 15
	damage_coeff = list(BRUTE = 0.6, BURN = 0.6, TOX = 0.6, CLONE = 0.6, STAMINA = 0, OXY = 0.6)
	playstyle_string = "<span class='holoparasite'>As an <b>explosive</b> type, you have moderate close combat abilities, take half damage, may explosively teleport targets on attack, and are capable of converting nearby items and objects into disguised bombs via alt click.</span>"
	magic_fluff_string = "<span class='holoparasite'>..And draw the Scientist, master of explosive death.</span>"
	tech_fluff_string = "<span class='holoparasite'>Boot sequence complete. Explosive modules active. Holoparasite swarm online.</span>"
	carp_fluff_string = "<span class='holoparasite'>CARP CARP CARP! Caught one! It's an explosive carp! Boom goes the fishy.</span>"
	var/bomb_cooldown = 0

/mob/living/simple_animal/hostile/guardian/bomb/get_status_tab_items()
	. = ..()
	if(bomb_cooldown >= world.time)
		. += "Bomb Cooldown Remaining: [DisplayTimeText(bomb_cooldown - world.time)]"

/mob/living/simple_animal/hostile/guardian/bomb/AttackingTarget()
	. = ..()
	if(. && prob(40) && isliving(target))
		var/mob/living/M = target
		if(!M.anchored && M != summoner && !hasmatchingsummoner(M))
			new /obj/effect/temp_visual/guardian/phase/out(get_turf(M))
			do_teleport(M, M, 10, channel = TELEPORT_CHANNEL_BLUESPACE)
			for(var/mob/living/L in range(1, M))
				if(hasmatchingsummoner(L)) //if the summoner matches don't hurt them
					continue
				if(L != src && L != summoner)
					L.apply_damage(15, BRUTE)
			new /obj/effect/temp_visual/explosion(get_turf(M))

/mob/living/simple_animal/hostile/guardian/bomb/AltClickOn(atom/movable/A)
	if(!istype(A))
		AltClickNoInteract(src, A)
		return
	if(loc == summoner)
		to_chat(src, "<span class='danger'><B>You must be manifested to create bombs!</span></B>")
		return
	if(isobj(A) && Adjacent(A))
		if(bomb_cooldown <= world.time && !stat)
			var/datum/component/killerqueen/K = A.AddComponent(/datum/component/killerqueen, EXPLODE_HEAVY, CALLBACK(src, PROC_REF(on_explode)), CALLBACK(src, PROC_REF(on_failure)), \
			examine_message = "<span class='holoparasite'>It glows with a strange <font color=\"[guardiancolor]\">light</font>!</span>")
			QDEL_IN(K, 1 MINUTES)
			to_chat(src, "<span class='danger'><B>Success! Bomb armed!</span></B>")
			bomb_cooldown = world.time + 200
		else
			to_chat(src, "<span class='danger'><B>Your powers are on cooldown! You must wait 20 seconds between bombs.</span></B>")

/mob/living/simple_animal/hostile/guardian/bomb/proc/on_explode(atom/bomb, atom/victim)
	if((victim == src) || (victim == summoner) || (hasmatchingsummoner(victim)))
		to_chat(victim, "<span class='holoparasite'>[src] glows with a strange <font color=\"[guardiancolor]\">light</font>, and you don't touch it.</span>")
		return FALSE
	to_chat(src, "<span class='danger'>One of your explosive traps caught [victim]!</span>")
	to_chat(victim, "<span class='danger'>[bomb] was boobytrapped!</span>")
	return TRUE

/mob/living/simple_animal/hostile/guardian/bomb/proc/on_failure(atom/bomb)
	to_chat(src, "<span class='danger'><b>Failure! Your trap didn't catch anyone this time.</span></B>")
