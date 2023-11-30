/obj/item/broom
	name = "broom"
	desc = "This is my BROOMSTICK! It can be used manually or braced with two hands to sweep items as you move. It has a telescopic handle for compact storage."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "broom0"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 8
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("swept", "brushed off", "bludgeoned", "whacked")
	resistance_flags = FLAMMABLE

/obj/item/broom/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/broom/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=8, force_wielded=12, icon_wielded="broom1")

/obj/item/broom/update_icon_state()
	icon_state = "broom0"

/// triggered on wield of two handed item
/obj/item/broom/proc/on_wield(obj/item/source, mob/user)
	to_chat(user, "<span class='notice'>You brace the [src] against the ground in a firm sweeping stance.</span>")
	RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(sweep))

/// triggered on unwield of two handed item
/obj/item/broom/proc/on_unwield(obj/item/source, mob/user)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)

/obj/item/broom/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	sweep(user, A)

/obj/item/broom/proc/sweep(datum/source, atom/newLoc)
	if(!ismob(source) || !isturf(newLoc) || (get_dist(source, newLoc) > 1))
		return
	var/turf/target = newLoc
	var/atom/movable/AM
	var/sweep_dir = get_dir(source, target)
	if(!sweep_dir)
		return
	for(var/i in target.contents)
		AM = i
		if(AM.density)		// eh good enough heuristic check
			return
	var/i = 0
	for(var/obj/item/garbage in target.contents)
		if(!garbage.anchored)
			step(garbage, sweep_dir)
		if(++i > 20)
			break
	if(i)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 30, TRUE, -1)

/obj/item/broom/proc/janicart_insert(mob/user, obj/structure/janitorialcart/J) //bless you whoever fixes this copypasta
	J.put_in_cart(src, user)
	J.mybroom=src
	J.update_icon()
