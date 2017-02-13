/obj/effect/fun_balloon
	name = "fun balloon"
	desc = "This is going to be a laugh riot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	anchored = TRUE
	var/popped = FALSE

/obj/effect/fun_balloon/New()
	. = ..()
	SSobj.processing |= src

/obj/effect/fun_balloon/Destroy()
	SSobj.processing -= src
	. = ..()

/obj/effect/fun_balloon/process()
	if(!popped && check() && !QDELETED(src))
		popped = TRUE
		effect()
		pop()

/obj/effect/fun_balloon/proc/check()
	return FALSE

/obj/effect/fun_balloon/proc/effect()
	return

/obj/effect/fun_balloon/proc/pop()
	visible_message("[src] pops!")
	playsound(get_turf(src), 'sound/items/party_horn.ogg', 50, 1, -1)
	qdel(src)

/obj/effect/fun_balloon/attack_ghost(mob/user)
	if(!user.client || !user.client.holder || popped)
		return
	switch(alert("Pop [src]?","Fun Balloon","Yes","No"))
		if("Yes")
			effect()
			pop()

/obj/effect/fun_balloon/sentience
	name = "sentience fun balloon"
	desc = "When this pops, things are gonna get more aware around here."
	var/effect_range = 3
	var/group_name = "a bunch of giant spiders"

/obj/effect/fun_balloon/sentience/effect()
	var/list/bodies = list()
	for(var/mob/living/M in range(effect_range, get_turf(src)))
		bodies += M

	var/question = "Would you like to be [group_name]?"
	var/list/candidates = pollCandidatesForMobs(question, "pAI", null, FALSE, 100, bodies)
	while(candidates.len && bodies.len)
		var/mob/dead/observer/ghost = pick_n_take(candidates)
		var/mob/living/body = pick_n_take(bodies)

		body << "Your mob has been taken over by a ghost!"
		message_admins("[key_name_admin(ghost)] has taken control of ([key_name_admin(body)])")
		body.ghostize(0)
		body.key = ghost.key
		new /obj/effect/overlay/temp/gravpush(get_turf(body))

/obj/effect/fun_balloon/sentience/emergency_shuttle
	name = "shuttle sentience fun balloon"
	var/trigger_time = 60

/obj/effect/fun_balloon/sentience/emergency_shuttle/check()
	. = FALSE
	if(SSshuttle.emergency && (SSshuttle.emergency.timeLeft() <= trigger_time) && (SSshuttle.emergency.mode == SHUTTLE_CALL))
		. = TRUE

/obj/effect/fun_balloon/scatter
	name = "scatter fun balloon"
	desc = "When this pops, you're not going to be around here anymore."
	var/effect_range = 5

/obj/effect/fun_balloon/scatter/effect()
	for(var/mob/living/M in range(effect_range, get_turf(src)))
		var/turf/T = find_safe_turf()
		new /obj/effect/overlay/temp/gravpush(get_turf(M))
		M.forceMove(T)
		M << "<span class='notice'>Pop!</span>"

/obj/effect/station_crash
	name = "station crash"
	desc = "With no survivors!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	anchored = TRUE

/obj/effect/station_crash/New()
	for(var/S in SSshuttle.stationary)
		var/obj/docking_port/stationary/SM = S
		if(SM.id == "emergency_home")
			var/new_dir = turn(SM.dir, 180)
			SM.loc = get_ranged_target_turf(SM, new_dir, rand(3,15))
			break
	qdel(src)


//Shuttle Build

/obj/effect/shuttle_build
	name = "shuttle_build"
	desc = "Some assembly required"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	anchored = TRUE

/obj/effect/shuttle_build/New()
	SSshuttle.emergency.dock(SSshuttle.getDock("emergency_home"))
	qdel(src)

//Arena

/obj/effect/forcefield/arena_shuttle
	name = "portal"
	var/list/warp_points = list()


/obj/effect/forcefield/arena_shuttle/Bumped(mob/M as mob|obj)
	if(!warp_points.len)
		warp_points = get_area_turfs(/area/shuttle/escape)
		for(var/turf/T in warp_points)
			for(var/atom/movable/AM in T)
				if(AM.density && AM.anchored)
					warp_points -= T
					break
	if(!isliving(M))
		return
	else
		var/mob/living/L = M
		if(L.pulling && istype(L.pulling, /obj/item/bodypart/head))
			L << "Your offering is accepted. You may pass."
			qdel(L.pulling)
			var/turf/LA = pick(warp_points)
			L.forceMove(LA)
			L.hallucination = 0
			L << "<span class='reallybig redtext'>The battle is won. Your bloodlust subsides.</span>"
			for(var/obj/item/weapon/twohanded/required/chainsaw/doomslayer/chainsaw in L)
				qdel(chainsaw)
		else
			L << "You are not yet worthy of passing. Drag a severed head to the barrier to be allowed entry to the hall of champions."

/obj/effect/landmark/shuttle_arena_safe
	name = "hall of champions"
	desc = "For the winners."

/obj/effect/landmark/shuttle_arena_entrance
	name = "the arena"
	desc = "A lava filled battlefield."


/obj/effect/forcefield/arena_shuttle_entrance
	name = "portal"
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle_entrance/Bumped(mob/M as mob|obj)
	if(!warp_points.len)
		for(var/obj/effect/landmark/shuttle_arena_entrance/S in landmarks_list)
			warp_points |= S
	if(!isliving(M))
		return

	var/obj/effect/landmark/LA = pick(warp_points)

	M.forceMove(get_turf(LA))
	M << "<span class='reallybig redtext'>You're trapped in a deadly arena! To escape, you'll need to drag a severed head to the escape portals.</span>"
	spawn()
		var/obj/effect/mine/pickup/bloodbath/B = new(M)
		B.mineEffect(M)


/area/shuttle_arena
	name = "arena"
	has_gravity = 1
	requires_power = 0
