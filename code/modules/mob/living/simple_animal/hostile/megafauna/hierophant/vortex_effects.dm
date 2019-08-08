/obj/effect/temp_visual/vortex_magic
	name = "vortex magic"
	icon = 'icons/obj/vortex_magic.dmi'
	layer = BELOW_MOB_LAYER
	var/datum/component/vortex_magic/parent

/obj/effect/temp_visual/vortex_magic/Initialize(mapload, datum/component/vortex_magic/C)
	parent = C
	C?.on_effect_new(src)
	return ..()

/obj/effect/temp_visual/vortex_magic/Destroy()
	parent?.on_effect_del(src)
	return ..()

/obj/effect/temp_visual/vortex_magic/proc/graceful_stop()
	qdel(src)

/obj/effect/temp_visual/vortex_magic/blast
	name = "vortex blast"
	desc = "Get out of the way!"
	icon_state = "vortex_blast"
	light_range = 2
	light_power = 2
	duration = 9
	var/damage = 10
	var/monster_damage_boost = 10
	var/list/hit_things		//prevents multi-hitting with the same blast.
	//ADVANCED
	var/list/hit_count		//tracks hit count for stuff like chasers.
	var/max_multi_hit = INFINITY		//multi hits with multiple blasts.
	//ENd
	var/bursting = FALSE		//currently bursting

/obj/effect/temp_visual/vortex_magic/blast/Initialize(mapload, datum/component/vortex_magic/C, damage = 10, monster_damage_boost = 10, list/blast_once, list/hit_count, max_multi_hit = INFINITY)
	src.damage = damage
	src.monster_damage_boost = monster_damage_boost
	src.hit_things = blast_once || list()
	src.hit_count = hit_count
	src.max_multi_hit = max_multi_hit
	. = ..()
	if(ismineralturf(loc))
		var/turf/closed/mineral/M = loc
		M.gets_drilled(C?.user)
	INVOKE_ASYNC(src, .proc/blast)

/obj/effect/temp_visual/vortex_magic/blast/Destroy()
	hit_things = null
	hit_count = null
	return ..()

/obj/effect/temp_visual/vortex_magic/blast/proc/blast()
	var/turf/T = get_turf(src)
	if(!T)
		return
	playsound(T, 'sound/magic/blind.ogg', 125, 1, -5) //make a sound
	sleep(6) //wait a little
	bursting = TRUE
	do_damage(T) //do damage and mark us as bursting
	sleep(1.3) //slightly forgiving; the burst animation is 1.5 deciseconds
	bursting = FALSE //we no longer damage crossers

/obj/effect/temp_visual/vortex_magic/blast/Crossed(atom/movable/AM)
	. = ..()
	if(bursting)
		damage_atom(AM)

/obj/effect/temp_visual/vortex_magic/blast/proc/damage_atom(atom/A)
	hit_things[A] = TRUE		//hashmaps are fast!
	if(parent.is_blast_immune(A) || hit_things[A] || !damage)
		return
	if(hit_count)
		if(hit_count[A] >= max_multi_hit)
			return
		hit_count[A]++
	var/damage_done = damage * parent.effect_multiplier(A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.client)
			flash_color(L.client, "#660099", 1)
		to_chat(L, "<span class='userdanger'>You're struck by a [name]!</span>")
		var/limb_to_hit = L.get_bodypart(pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
		var/armor = L.run_armor_check(limb_to_hit, ARMOR_MAGIC, "Your armor absorbs [src]!", "Your armor blocks part of [src]!", 50, "Your armor was penetrated by [src]!")
		L.apply_damage(damage * parent.effect_multiplier(L), BURN, limb_to_hit, armor)
		if(ishostile(L))
			var/mob/living/simple_animal/hostile/H = L //mobs find and damage you...
			if(H.stat == CONSCIOUS && !H.target && H.AIStatus != AI_OFF && !H.client)
				if(!QDELETED(caster))
					if(get_dist(H, caster) <= H.aggro_vision_range)
						H.FindTarget(list(caster), 1)
					else
						H.Goto(get_turf(caster), H.move_to_delay, 3)
			if(monster_damage_boost && (ismegafauna(L) || istype(L, /mob/living/simple_animal/hostile/asteroid)))
				L.adjustBurnLoss(monster_damage_boost * parent.effect_multiplier(L))
				damage_done += monster_damage_boost * parent.effect_multiplier(L)
	else if(isobj(A))
		var/obj/O = A
		O.take_damage(damage * parent.effect_multiplier(O), burn, 0, 0)
		if(ismecha(O))
			var/obj/mecha/M = O
			to_chat(M.occupant, "<span class='userdanger'>Your [M.name] is struck by a [name]!</span>")
	parent.on_blast_hit(src, A, damage_done)
	playsound(A, 'sound/weapons/sear.ogg', 50, 1, -4)

/obj/effect/temp_visual/vortex_magic/blast/proc/blast_turf(turf/T)
	if(!damage)
		return
	for(var/i in T.contents)
		var/atom/A = i
		damage_atom(A)

/obj/effect/temp_visual/vortex_magic/squares
	icon_state = "vortex_squares"
	duration = 3
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	randomdir = FALSE

/obj/effect/temp_visual/vortex_magic/squares/Initialize(mapload, datum/component/vortex_magic/C)
	. = ..()
	if(ismineralturf(loc))
		var/turf/closed/mineral/M = loc
		M.gets_drilled(C?.user)

/obj/effect/temp_visual/vortex_magic/wall //smoothing and pooling were not friends, but pooling is dead.
	name = "vortex wall"
	icon = 'icons/turf/walls/vortex_magic_wall_temp.dmi'
	icon_state = "wall"
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	duration = 100
	smooth = SMOOTH_TRUE

/obj/effect/temp_visual/vortex_magic/wall/Initialize(mapload, datum/component/vortex_magic/C, duration = 100)
	src.duration = duration
	. = ..()
	queue_smooth_neighbors(src)
	queue_smooth(src)

/obj/effect/temp_visual/vortex_magic/wall/Destroy()
	queue_smooth_neighbors(src)
	return ..()

/obj/effect/temp_visual/vortex_magic/wall/CanPass(atom/movable/mover, turf/target)
	return parent && parent.can_pass_walls(mover)

/obj/effect/temp_visual/vortex_magic/chaser //a vortex_magic's chaser. follows target around, moving and producing a blast every speed deciseconds.
	duration = 98
	//state & target
	var/currently_seeking = FALSE
	var/allow_diagonals = FALSE		//don't use without a good reason, this is WACK.
	var/atom/target
	var/turf/targetturf
	var/list/hit_things				//tracks number of times we hit something.
	//which direction are we moving in, and which we were before that.
	var/moving_dir = NONE
	var/last_moving_dir = NONE
	var/last_last_moving_dir = NONE
	//steps before each direction recalc
	var/steps_left_before_recalc = 0	//current
	var/steps_before_recalc = 4
	//settings
	var/tiles_per_step = 1
	var/move_delay = 3
	var/damage = 10
	var/monster_damage_boost = 10
	var/max_hit_amount = INFINITY		//max times to hit a unique atom

/obj/effect/temp_visual/vortex_magic/chaser/Initialize(mapload, datum/component/vortex_magic/C, atom/target, duration = 98, damage = 10, monster_damage_boost = 10, move_delay = 3, tiles_per_step = 1, allow_diagonals = FALSE)
	src.duration = duration
	src.damage = damage
	src.monster_damage_boost = monster_damage_boost
	src.move_delay = move_delay
	src.tiles_per_step = tiles_per_step
	src.allow_diagonals = allow_diagonals
	. = ..()
	hit_things = list()
	INVOKE_ASYNC(src, .proc/seek_target)

/obj/effect/temp_visual/vortex_magic/chaser/Destroy()
	hit_things = null
	return ..()




/obj/effect/temp_visual/vortex_magic/chaser/proc/get_target_dir()
	. = allow_diagonals? get_dir(src, targetturf) : get_cardinal_dir(src, targetturf)
	if((. != previous_moving_dir && . == more_previouser_moving_dir) || . == 0) //we're alternating, recalculate
		var/list/cardinal_copy = GLOB.cardinals.Copy()
		cardinal_copy -= more_previouser_moving_dir
		. = pick(cardinal_copy)

/obj/effect/temp_visual/vortex_magic/chaser/proc/seek_target()
	if(!currently_seeking)
		currently_seeking = TRUE
		targetturf = get_turf(target)
		while(target && !QDELETED(src) && currently_seeking && isturf(loc) && targetturf) //can this target actually be sook out
			if(!moving) //we're out of tiles to move, find more and where the target is!
				more_previouser_moving_dir = previous_moving_dir
				previous_moving_dir = moving_dir
				moving_dir = get_target_dir()
				var/standard_target_dir = get_cardinal_dir(src, targetturf)
				if((standard_target_dir != previous_moving_dir && standard_target_dir == more_previouser_moving_dir) || standard_target_dir == 0)
					moving = 1 //we would be repeating, only move a tile before checking
				else
					moving = standard_moving_before_recalc
			if(moving) //move in the dir we're moving in right now
				var/turf/T = get_turf(src)
				for(var/i in 1 to tiles_per_step)
					var/maybe_new_turf = get_step(T, moving_dir)
					if(maybe_new_turf)
						T = maybe_new_turf
					else
						break
				forceMove(T)
				make_blast() //make a blast, too
				moving--
				sleep(move_delay)
			targetturf = get_turf(target)

/obj/effect/temp_visual/vortex_magic/chaser/proc/make_blast()
	var/obj/effect/temp_visual/vortex_magic/blast/B = new(loc, parent, damage, monster_damage_boost, null, hit_things, max_hit_count)

/obj/effect/temp_visual/vortex_magic/telegraph
	icon = 'icons/effects/96x96.dmi'
	icon_state = "vortex_magic_telegraph"
	pixel_x = -32
	pixel_y = -32
	duration = 3

/obj/effect/temp_visual/vortex_magic/telegraph/diagonal
	icon_state = "vortex_magic_telegraph_diagonal"

/obj/effect/temp_visual/vortex_magic/telegraph/cardinal
	icon_state = "vortex_magic_telegraph_cardinal"

/obj/effect/temp_visual/vortex_magic/telegraph/teleport
	icon_state = "vortex_magic_telegraph_teleport"
	duration = 9

/obj/effect/temp_visual/vortex_magic/telegraph/edge
	icon_state = "vortex_magic_telegraph_edge"
	duration = 40

/obj/effect/vortex_beacon
	name = "vortex beacon"
	icon = 'icons/obj/vortex_magic.dmi'
	desc = "A strange beacon, allowing mass teleportation for those able to use it."
	icon_state = "vortex_magic_tele_off"
	light_range = 2
	layer = LOW_OBJ_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | ACID_PROOF | FIRE_PROOF

/obj/effect/vortex_magic/ex_act()
	return

/obj/effect/vortex_magic/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/vortex_magic_club))
		var/obj/item/vortex_magic_club/H = I
		if(H.timer > world.time)
			return
		if(H.beacon == src)
			to_chat(user, "<span class='notice'>You start removing your vortex_magic beacon...</span>")
			H.timer = world.time + 51
			INVOKE_ASYNC(H, /obj/item/vortex_magic_club.proc/prepare_icon_update)
			if(do_after(user, 50, target = src))
				playsound(src,'sound/magic/blind.ogg', 200, 1, -4)
				new /obj/effect/temp_visual/vortex_magic/telegraph/teleport(get_turf(src), user)
				to_chat(user, "<span class='vortex_magic_warning'>You collect [src], reattaching it to the club!</span>")
				H.beacon = null
				user.update_action_buttons_icon()
				qdel(src)
			else
				H.timer = world.time
				INVOKE_ASYNC(H, /obj/item/vortex_magic_club.proc/prepare_icon_update)
		else
			to_chat(user, "<span class='vortex_magic_warning'>You touch the beacon with the club, but nothing happens.</span>")
	else
		return ..()
