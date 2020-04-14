/obj/item/grenade/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "flashbang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	var/flashbang_range = 7 //how many tiles away the mob will be stunned.

/obj/item/grenade/flashbang/prime()
	update_mob()
	var/flashbang_turf = get_turf(src)
	if(!flashbang_turf)
		return
	do_sparks(rand(5, 9), FALSE, src)
	playsound(flashbang_turf, 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)
	new /obj/effect/dummy/lighting_obj (flashbang_turf, LIGHT_COLOR_WHITE, (flashbang_range + 2), 4, 2)
	flashbang_mobs(flashbang_turf, flashbang_range)
	qdel(src)

/obj/item/grenade/flashbang/proc/flashbang_mobs(turf/source, range)
	var/list/banged = get_hearers_in_view(range, source)
	var/list/flashed = viewers(range, source)
	for(var/mob/living/l in banged)
		bang(l, source)
	for(var/mob/living/l in flashed)
		flash(l, source)

/obj/item/grenade/flashbang/proc/bang(mob/living/M, turf/source)
	if(M.stat == DEAD)	//They're dead!
		return
	M.show_message("<span class='warning'>BANG</span>", MSG_AUDIBLE)
	var/distance = get_dist(get_turf(M), source)
	if(!distance || loc == M || loc == M.loc)	//Stop allahu akbarring rooms with this.
		M.DefaultCombatKnockdown(200)
		M.soundbang_act(1, 200, 10, 15)
	else
		M.soundbang_act(1, max(200/max(1,distance), 60), rand(0, 5))

/obj/item/grenade/flashbang/proc/flash(mob/living/M, turf/source)
	if(M.stat == DEAD)	//They're dead!
		return
	var/distance = get_dist(get_turf(M), source)
	if(M.flash_act(affect_silicon = 1))
		M.DefaultCombatKnockdown(max(200/max(1,distance), 60))
