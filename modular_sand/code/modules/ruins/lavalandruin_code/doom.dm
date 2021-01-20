/obj/item/stack/sheet/animalhide/goliath_hide/vest
	name = "green armor vest"
	desc = "100% armor pickup. Can be used to improve some types of armor."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "armoralt"
	item_state = "armoralt"
	color = "#00FF00"
	light_power = 1
	light_range = 2
	light_color = "#00FF00"

/obj/item/stack/sheet/animalhide/goliath_hide/vest/blue
	name = "mega armor vest"
	desc = "200% armor pickup. Can be used to improve some types of armor."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "armoralt"
	item_state = "armoralt"
	color = "#0000FF"
	light_power = 2
	light_range = 3
	light_color = "#0000FF"

/obj/item/reagent_containers/glass/beaker/synthflesh/healthvial
	name = "health potion"
	desc = "+1% health. Can be splashed to heal brute and burn damage."
	color = "#0000FF"
	light_power = 1
	light_range = 2
	light_color = "#0000FF"

/obj/effect/mine/pickup/bloodbath/berserk
	duration = 100
	var/extraduration = 1100

/obj/effect/mine/pickup/bloodbath/berserk/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='reallybig redtext'><b>RIP AND TEAR</b></span>")
	var/old_color = victim.client.color
	var/static/list/red_splash = list(1,0,0,0.8,0.2,0, 0.8,0,0.2,0.1,0,0)
	var/static/list/pure_red = list(0,0,0,0,0,0,0,0,0,1,0,0)

	victim.log_message("entered a berserk frenzy", LOG_ATTACK)
	victim.reagents.add_reagent(/datum/reagent/medicine/adminordrazine,50)
	to_chat(victim, "<span class='warning'>KILL, KILL, KILL!</span>")
	victim.client.color = pure_red
	animate(victim.client,color = red_splash, time = 10, easing = SINE_EASING|EASE_OUT)
	sleep(duration)
	victim.client.color = old_color
	sleep(extraduration)
	victim.log_message("exited a berserk frenzy", LOG_ATTACK)
	qdel(src)

/turf/open/floor/carpet/blue/doomed
	name = "marine base carpet"
	desc = "Carpet, so barefoot demons can have some comfort."
	floor_tile = null
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/closed/wall/mineral/plastitanium/doomed
	name = "marine base wall"
	desc = "A very doomed wall."
	explosion_block = 50

/obj/machinery/door/airlock/titanium/doomed
	name = "marine base airlock"
	desc = "Knee deep in the dead."

/obj/machinery/door/airlock/titanium/doomed/locked
	name = "jammed airlock"
	desc = "It seems to be functional... there has to be a way to open it."
	explosion_block = 50
	var/list/candylist = list()
	var/shouldunlock = FALSE

/obj/machinery/door/airlock/titanium/doomed/locked/obj/machinery/door/airlock/titanium/doomed/locked/Initialize()
	. = ..()
	for(var/mob/living/simple_animal/hostile/asteroid/elite/candy/C in view(15))
		candylist += C
	if(candylist.len)
		close()
		addtimer(CALLBACK(src, .proc/bolt), 5)

/obj/machinery/door/airlock/titanium/doomed/locked/obj/machinery/door/airlock/titanium/doomed/locked/process()
	. = ..()
	candylist = list()
	for(var/mob/living/simple_animal/hostile/asteroid/elite/candy/C in view(15))
		if(C.stat != DEAD)
			candylist += C
		return
	if(!candylist.len)
		STOP_PROCESSING(SSprocessing, src)
		unbolt()

/obj/item/gun/ballistic/shotgun/doomed
	name = "classic pump-action shotgun"
	desc = "Shotguns can deliver a heavy punch at close range and a generous pelting from a distance. Not nearly as powerful as it's super variant."
	icon = 'modular_sand/icons/obj/doom.dmi'
	icon_state = "pumpshotgun"
	w_class = WEIGHT_CLASS_NORMAL

/obj/structure/fermenting_barrel/doom
	name = "toxic waste barrel"
	desc = "Filled with bad stuff. Probably explodes."
	icon = 'modular_sand/icons/obj/doom.dmi'
	icon_state = "barrel"

/obj/structure/fermenting_barrel/doom/Initialize()
	..()
	src.reagents.add_reagent(pick(subtypesof(/datum/reagent/toxin)), 300)

/obj/structure/fermenting_barrel/doom/Destroy()
	. = ..()
	explosion(src.loc, -1, -1, 1, -1, 0, 3)

/area/ruin/powered/e1m1
	name = "Hangar"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	icon_state = "dk_yellow"
