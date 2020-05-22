#define SNAKE_SPAM_TICKS 600 //how long between cardboard box openings that trigger the '!'
/obj/structure/closet/cardboard
	name = "large cardboard box"
	desc = "Just a box..."
	icon_state = "cardboard"
	mob_storage_capacity = 1
	resistance_flags = FLAMMABLE
	max_integrity = 70
	integrity_failure = 0
	can_weld_shut = 0
	cutting_tool = /obj/item/wirecutters
	open_sound = "rustle"
	material_drop = /obj/item/stack/sheet/cardboard
	delivery_icon = "deliverybox"
	anchorable = FALSE
	var/move_speed_multiplier = 1
	var/move_delay = FALSE
	var/egged = 0
	var/use_mob_movespeed = FALSE //Citadel adds snowflake box handling

/obj/structure/closet/cardboard/relaymove(mob/living/user, direction)
	if(opened || move_delay || !CHECK_MOBILITY(user, MOBILITY_MOVE) || !isturf(loc) || !has_gravity(loc))
		return
	move_delay = TRUE
	var/oldloc = loc
	step(src, direction)
	user.setDir(direction)
	if(oldloc != loc)
		addtimer(CALLBACK(src, .proc/ResetMoveDelay), (use_mob_movespeed ? user.movement_delay() : CONFIG_GET(number/movedelay/walk_delay)) * move_speed_multiplier)
	else
		ResetMoveDelay()

/obj/structure/closet/cardboard/proc/ResetMoveDelay()
	move_delay = FALSE

/obj/structure/closet/cardboard/open()
	if(opened || !can_open())
		return 0
	var/list/alerted = null
	if(egged < world.time)
		var/mob/living/Snake = null
		for(var/mob/living/L in src.contents)
			Snake = L
			break
		if(Snake)
			alerted = fov_viewers(world.view,src)
	..()
	if(LAZYLEN(alerted))
		egged = world.time + SNAKE_SPAM_TICKS
		for(var/mob/living/L in alerted)
			if(!L.stat)
				if(!L.incapacitated(ignore_restraints = 1))
					L.face_atom(src)
				L.do_alert_animation(L)
		playsound(loc, 'sound/machines/chime.ogg', 50, FALSE, -5)

/mob/living/proc/do_alert_animation(atom/A)
	var/image/I = image('icons/obj/closet.dmi', A, "cardboard_special", A.layer+1)
	flick_overlay_view(I, A, 8)
	I.alpha = 0
	animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)

/obj/structure/closet/cardboard/handle_lock_addition() //Whoever heard of a lockable cardboard box anyway
	return

/obj/structure/closet/cardboard/handle_lock_removal()
	return

/obj/structure/closet/cardboard/metal
	name = "large metal box"
	desc = "THE COWARDS! THE FOOLS!"
	icon_state = "metalbox"
	max_integrity = 500
	mob_storage_capacity = 5
	resistance_flags = NONE
	move_speed_multiplier = 2
	cutting_tool = /obj/item/weldingtool
	open_sound = 'sound/machines/click.ogg'
	material_drop = /obj/item/stack/sheet/plasteel
#undef SNAKE_SPAM_TICKS
