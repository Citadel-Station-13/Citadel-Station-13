/**
 * Move up or down - only checks enters/exits, not powered zmovement/if we can overcome gravity
 */
/atom/movable/proc/ZMove(dir, force, allow_blocking_actions)
	if(!isturf(loc))
		return FALSE
	var/turf/T = loc
	if(!loc.CanZPass(src, dir))
		return FALSE
	if(!ProcessZMove(has_gravity(), TRUE, FALSE, allow_blocking_actions, force))
		return FALSE
	// check again if we allowed blocking actions
	if(allow_blocking_actions && !loc.CanZPass(src, dir))
		return FALSE
	// >>forcemove
	// wish there was a better way
	forceMove(dir == UP? T.Above() : T.Below())
	return TRUE


/**
 * @params
 * gravity - gravity force
 * visible - show others
 * silent - message self
 * allow_blocking_actions - fail instantly, silently, if we can't move in that direction without a wait
 * force - this is here because feedback is also done here.
 *
 * **Visual feedback should be done in this proc!**
 * Force will remove all delays and bypass all special checks like flying!
 *
 * WARNING: This proc can, infact, block.
 * @return
 * null for fail, true for instant generic "x moves up"/silent, list("verb in motion", "verb present" delay) otherwise
 */
/atom/movable/proc/ProcessZMove(gravity, visible, silent, allow_blocking_actions, force)
	#warn rethink this proc
	return dir == DOWN

/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(ZMove(UP, null, TRUE))
		to_chat(src, "<span class='notice'>You move upwards.</span>")

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(ZMove(DOWN, null, TRUE))
		to_chat(src, "<span class='notice'>You move down.</span>")


//FALLING STUFF

/atom/movable/proc/Handle

/atom/movable/proc/TakeFallDamage(amount, levels = 1)
	return





/atom/movable/proc/handle_fall(var/turf/landing)
	var/turf/previous = get_turf(loc)
	forceMove(landing)
	if(locate(/obj/structure/stairs) in landing)
		return 1
	handle_fall_effect(landing)

/atom/movable/proc/handle_fall_effect(var/turf/landing)
	SHOULD_CALL_PARENT(TRUE)
	if(istype(landing) && landing.is_open())
		visible_message("\The [src] falls through \the [landing]!", "You hear a whoosh of displaced air.")
	else
		visible_message("\The [src] slams into \the [landing]!", "You hear something slam into the [global.using_map.ground_noun].")
		var/fall_damage = fall_damage()
		if(fall_damage > 0)
			for(var/mob/living/M in landing.contents)
				if(M == src)
					continue
				visible_message("\The [src] hits \the [M.name]!")
				M.take_overall_damage(fall_damage)

/atom/movable/proc/fall_damage()
	return 0

/obj/fall_damage()
	if(w_class == ITEM_SIZE_TINY)
		return 0
	if(w_class >= ITEM_SIZE_NO_CONTAINER)
		return 100
	return BASE_STORAGE_COST(w_class)

/mob/living/carbon/human/apply_fall_damage(var/turf/landing)
	if(species && species.handle_fall_special(src, landing))
		return
	var/min_damage = 7
	var/max_damage = 14
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_HEAD, armor_pen = 50)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_CHEST, armor_pen = 50)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_GROIN, armor_pen = 75)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_LEG, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_LEG, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_FOOT, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_FOOT, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_ARM, armor_pen = 75)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_ARM, armor_pen = 75)
	SET_STATUS_MAX(src, STAT_WEAK, 3)

	updatehealth()

/mob/living/carbon/human/proc/climb_up(atom/A)
	if(!isturf(loc) || !bound_overlay || bound_overlay.destruction_timer || is_physically_disabled())	// This destruction_timer check ideally wouldn't be required, but I'm not awake enough to refactor this to not need it.
		return FALSE

	var/turf/T = get_turf(A)
	var/turf/above = GetAbove(src)
	if(above && T.Adjacent(bound_overlay) && above.CanZPass(src, UP)) //Certain structures will block passage from below, others not
		if(loc.has_gravity() && !can_overcome_gravity())
			return FALSE

		visible_message("<span class='notice'>[src] starts climbing onto \the [A]!</span>", "<span class='notice'>You start climbing onto \the [A]!</span>")
		if(do_after(src, 50, A))
			visible_message("<span class='notice'>[src] climbs onto \the [A]!</span>", "<span class='notice'>You climb onto \the [A]!</span>")
			src.Move(T)
		else
			visible_message("<span class='warning'>[src] gives up on trying to climb onto \the [A]!</span>", "<span class='warning'>You give up on trying to climb onto \the [A]!</span>")
		return TRUE
