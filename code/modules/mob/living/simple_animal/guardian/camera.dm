/*
Just a camera for the spontaneous spirit event.
*/

/mob/camera/guardian
	name = "Spontaneous Spirit"
	real_name = "Spontaneous Spirit"
	desc = ""
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "marker"
	mouse_opacity = MOUSE_OPACITY_ICON
	move_on_shuttle = FALSE
	see_in_dark = 8
	invisibility = INVISIBILITY_OBSERVER
	layer = BELOW_MOB_LAYER
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	sight = SEE_SELF|SEE_THRU
	initial_language_holder = /datum/language_holder/universal

	var/freemove_end = 0
	var/const/freemove_time = 1200
	var/freemove_end_timerid

/mob/camera/guardian/Initialize(mapload)
	.= ..()
	freemove_end = world.time + freemove_time
	freemove_end_timerid = addtimer(CALLBACK(src, .proc/spawn_on_random), freemove_time, TIMER_STOPPABLE)

/mob/camera/guardian/Login()
	..()
	to_chat(src, "<span class='warning'>You have [DisplayTimeText(freemove_end - world.time)] to select your host. Click on a creature to select your host.</span>")


/mob/camera/guardian/get_status_tab_items()
	..()
	. += "Host Selection Time: [round((freemove_end - world.time)/10)]s"

/mob/camera/guardian/say(message, bubble_type, var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/camera/guardian/Move(NewLoc, Dir = 0)
	forceMove(NewLoc)

/mob/camera/guardian/proc/spawn_on_random(del_on_fail = TRUE)
	var/list/possible_hosts = list()
	var/list/afk_possible_hosts = list()
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(!L.client)
			continue
		if(L.stat == DEAD)
			continue
		if (HAS_TRAIT(L,TRAIT_EXEMPT_HEALTH_EVENTS))
			continue
		if(iscyborg(L))
			var/mob/living/silicon/robot/R = L
			if(R.shell)
				continue
		var/list/guardians = L.hasparasites()
		if(length(guardians))
			continue
		if(L.client.is_afk())
			afk_possible_hosts += L
		else
			possible_hosts += L

	shuffle_inplace(possible_hosts)
	shuffle_inplace(afk_possible_hosts)
	possible_hosts += afk_possible_hosts //ideally we want a not-afk person, but we will settle for an afk one if there are no others (mostly for testing)

	for (var/T in possible_hosts)
		var/mob/living/target = T
		if(force_spawn(target))
			return TRUE

	if(del_on_fail)
		to_chat(src, "<span class=userdanger'>No hosts were available for you.</span>")
		qdel(src)
	return FALSE

/mob/camera/guardian/proc/force_spawn(mob/living/L)
	if(freemove_end_timerid)
		deltimer(freemove_end_timerid)
	var/obj/item/guardiancreator/spontaneous/I = new
	. = I.spawn_guardian(L, key)
	qdel(I)
	qdel(src)

/mob/camera/guardian/ClickOn(var/atom/A, params)
	if(isliving(A))
		confirm_initial_possession(A)
	else
		..()

/mob/camera/guardian/proc/confirm_initial_possession(mob/living/L)
	set waitfor = FALSE
	if(alert(src, "Select [L.name] as your host?", "Select Host", "Yes", "No") != "Yes")
		return
	if(QDELETED(L) || !force_spawn(L))
		to_chat(src, "<span class='warning'>[L ? L.name : "Host"] cannot be selected.</span>")
