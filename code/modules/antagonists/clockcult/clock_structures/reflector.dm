/obj/structure/destructible/clockwork/reflector
	name = "reflector"
	desc = "A large mirror-like structure made of thin brass on one side. It looks fragile."
	clockwork_desc = "A large mirror-like structure made of thin brass on one side. It can redirect laser fire on one side"
	icon_state = "reflector"
	unanchored_icon = "reflector_unwrenched"
	max_integrity = 40
	construction_value = 5
	layer = WALL_OBJ_LAYER
	break_message = "<span class='warning'>The reflectors's fragile shield shatters into pieces!</span>"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	light_color = "#DAAA18"
	var/list/allowed_projectile_typecache = list(
		/obj/item/projectile/beam
	)

	var/ini_dir = null

/obj/structure/destructible/clockwork/reflector/Initialize(mapload)
	. = ..()
	allowed_projectile_typecache = typecacheof(allowed_projectile_typecache)

/obj/structure/destructible/clockwork/reflector/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS ,null,CALLBACK(src, PROC_REF(can_be_rotated)),CALLBACK(src,PROC_REF(after_rotation)))

/obj/structure/destructible/clockwork/reflector/bullet_act(obj/item/projectile/P)
	if(!anchored || !allowed_projectile_typecache[P.type] || !(P.dir in GLOB.cardinals))
		return ..()

	if(auto_reflect(P, P.dir, get_turf(P), P.Angle) != -1)
		return ..()

	return BULLET_ACT_FORCE_PIERCE

/obj/structure/destructible/clockwork/reflector/proc/auto_reflect(obj/item/projectile/P, pdir, turf/ploc, pangle)

	 //Yell at me if this exists already.

	var/real_angle = 0

	switch(dir)
		if(NORTH)
			real_angle = 0
		if(EAST)
			real_angle = 90
		if(SOUTH)
			real_angle = 180
		if(WEST)
			real_angle = 270

	var/incidence = GET_ANGLE_OF_INCIDENCE(real_angle, (P.Angle + 180))
	if(abs(incidence) > 90 && abs(incidence) < 270)
		return FALSE
	var/new_angle = SIMPLIFY_DEGREES(real_angle + incidence)
	P.setAngle(new_angle)
	P.ignore_source_check = TRUE
	P.range = P.decayedRange
	P.decayedRange = max(P.decayedRange--, 0)
	return -1

/obj/structure/destructible/clockwork/reflector/proc/can_be_rotated(mob/user,rotation_type)
	if(anchored)
		to_chat(user, "<span class='warning'>[src] cannot be rotated while it is fastened to the floor!</span>")
		return FALSE

	return TRUE

/obj/structure/destructible/clockwork/reflector/Move()
	. = ..()
	setDir(ini_dir)

/obj/structure/destructible/clockwork/reflector/proc/after_rotation(mob/user,rotation_type)
	ini_dir = dir
	add_fingerprint(user)


/obj/structure/destructible/clockwork/reflector/wrench_act(mob/living/user, obj/item/I)

	if(!is_servant_of_ratvar(user))
		return ..()

	anchored = !anchored
	to_chat(user, "<span class='notice'>You [anchored ? "secure" : "unsecure"] \the [src].</span>")
	I.play_tool_sound(src)
	return TRUE
