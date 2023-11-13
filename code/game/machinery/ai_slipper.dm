/obj/machinery/ai_slipper
	name = "foam dispenser"
	desc = "A remotely-activatable dispenser for crowd-controlling foam."
	icon = 'icons/obj/device.dmi'
	icon_state = "ai-slipper0"
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	plane = FLOOR_PLANE
	max_integrity = 200
	armor = list(MELEE = 50, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

	var/uses = 20
	var/cooldown = 0
	var/cooldown_time = 100
	req_access = list(ACCESS_AI_UPLOAD)

/obj/machinery/ai_slipper/Initialize(mapload)
	. = ..()
	register_context()

/obj/machinery/ai_slipper/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(issilicon(user))
		LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_ANY, "Dispense foam")
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/ai_slipper/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It has <b>[uses]</b> uses of foam remaining.</span>"

/obj/machinery/ai_slipper/power_change()
	if(stat & BROKEN)
		return
	else
		if(powered())
			stat &= ~NOPOWER
		else
			stat |= NOPOWER
		if((stat & (NOPOWER|BROKEN)) || cooldown_time > world.time || !uses)
			icon_state = "ai-slipper0"
		else
			icon_state = "ai-slipper1"

/obj/machinery/ai_slipper/interact(mob/user)
	if(!allowed(user))
		to_chat(user, "<span class='danger'>Access denied.</span>")
		return
	if(!uses)
		to_chat(user, "<span class='danger'>[src] is out of foam and cannot be activated.</span>")
		return
	if(cooldown_time > world.time)
		to_chat(user, "<span class='danger'>[src] cannot be activated for <b>[DisplayTimeText(world.time - cooldown_time)]</b>.</span>")
		return
	new /obj/effect/particle_effect/foam(loc)
	uses--
	to_chat(user, "<span class='notice'>You activate [src]. It now has <b>[uses]</b> uses of foam remaining.</span>")
	cooldown = world.time + cooldown_time
	power_change()
	addtimer(CALLBACK(src, .proc/power_change), cooldown_time)
