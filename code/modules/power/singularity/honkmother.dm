/obj/singularity/narsie/honkmother
	name = "THE HONKMOTHER"
	desc = "Oh no."
	icon = 'icons/obj/honkmother.dmi'
	pixel_x = -236
	pixel_y = -256
	current_size = 12
	grav_pull = 10
	consume_range = 12 //How many tiles out do we eat
	
	var/max_mobs = 50
	var/spawn_time = 30 //30 seconds default
	var/mob_types = list(/mob/living/simple_animal/hostile/retaliate/clown, /mob/living/simple_animal/hostile/retaliate/clown/fleshclown, /mob/living/simple_animal/hostile/retaliate/clown/clownhulk, /mob/living/simple_animal/hostile/retaliate/clown/longface, /mob/living/simple_animal/hostile/retaliate/clown/clownhulk/chlown, /mob/living/simple_animal/hostile/retaliate/clown/clownhulk/honcmunculus, /mob/living/simple_animal/hostile/retaliate/clown/mutant/blob, /mob/living/simple_animal/hostile/retaliate/clown/banana, /mob/living/simple_animal/hostile/retaliate/clown/honkling, /mob/living/simple_animal/hostile/retaliate/clown/lube)
	var/spawn_text = "emerges from"
	var/faction = list("clown")
	var/spawner_type = /datum/component/spawner

/obj/singularity/narsie/honkmother/Initialize()
	. = ..()
	send_to_playing_players("<span class='clown'>IT'S HONKIN' TIME!</span>")
	sound_to_playing_players('sound/items/AirHorn.ogg')

	var/area/A = get_area(src)
	if(A)
		var/mutable_appearance/alert_overlay = mutable_appearance('icons/effects/cult_effects.dmi', "ghostalertsie")
		notify_ghosts("The Honkmother has risen in \the [A.name]. Reach out to the Honkmother to be given a new shell for your soul, I guess. You probably shouldn't.", source = src, alert_overlay = alert_overlay, action=NOTIFY_ATTACK)
	INVOKE_ASYNC(src, .proc/narsie_spawn_animation)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/singularity/narsie/honkmother/attack_ghost(mob/dead/observer/user as mob)
	makeNewConstruct(/mob/living/simple_animal/hostile/retaliate/clown/honkling, user, cultoverride = TRUE, loc_override = src.loc)


/obj/singularity/narsie/Bump(atom/A)
	var/turf/T = get_turf(A)
	if(T == loc)
		T = get_step(A, A.dir)
	forceMove(T)


/obj/singularity/narsie/mezzer()
	for(var/mob/living/carbon/M in fov_viewers(consume_range, src))
		if(M.stat == CONSCIOUS)
			if(!iscultist(M))
				to_chat(M, "<span class='clown'>As you gaze upon [src.name], your thoughts are drowned out by a deafening HONK!</span>")
				M.apply_effect(60, EFFECT_STUN)


/obj/singularity/narsie/consume(atom/A)
	if(isturf(A))
		A.honkmother_act()


/obj/singularity/narsie/ex_act() //No throwing bombs at her either.
	return


/obj/singularity/narsie/proc/pickcultist() //leaving this in just in case removing it will break things
	var/list/cultists = list()
	var/list/noncultists = list()
	
	for(var/mob/living/carbon/food in GLOB.alive_mob_list) //we don't care about constructs or cult-Ians or whatever. cult-monkeys are fair game i guess
		var/turf/pos = get_turf(food)
		if(!pos || (pos.z != z))
			continue

		if(iscultist(food))
			cultists += food
		else
			noncultists += food

		if(cultists.len) //cultists get higher priority
			acquire(pick(cultists))
			return

		if(noncultists.len)
			acquire(pick(noncultists))
			return

	//no living humans, follow a ghost instead.
	for(var/mob/dead/observer/ghost in GLOB.player_list)
		if(!ghost.client)
			continue
		var/turf/pos = get_turf(ghost)
		if(!pos || (pos.z != z))
			continue
		cultists += ghost
	if(cultists.len)
		acquire(pick(cultists))
		return


/obj/singularity/narsie/proc/acquire(atom/food)
	if(food == target)
		return
	to_chat(target, "<span class='clown'>The Honkmother is bored of you.</span>")
	target = food
	if(ishuman(target))
		to_chat(target, "<span class ='clown'>HONK!</span>")
	else
		to_chat(target, "<span class ='clown'>HOOOOOOOOOOOOOONK!</span>")

/obj/singularity/narsie/proc/narsie_spawn_animation()
	icon = 'icons/obj/narsie_spawn_anim.dmi'
	setDir(SOUTH)
	move_self = 0
	flick("narsie_spawn_anim",src)
	sleep(11)
	move_self = 1
	icon = initial(icon)



