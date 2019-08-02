
/obj/machinery/processor
	name = "food processor"
	desc = "An industrial grinder used to process meat and other foods. Keep hands clear of intake area while operating."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "processor1"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 50
	circuit = /obj/item/circuitboard/machine/processor
	var/broken = FALSE
	var/processing = FALSE
	var/rating_speed = 1
	var/rating_amount = 1

/obj/machinery/processor/RefreshParts()
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		rating_amount = B.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		rating_speed = M.rating

/obj/machinery/processor/examine(mob/user)
	. = ..()
	if(LAZYLEN(contents))
		to_chat(user, "<span class='notice'>Alt-click to empty it.</span>")

/obj/machinery/processor/AltClick(mob/user)
	. = ..()
	if(user.canUseTopic(src, BE_CLOSE, FALSE))
		empty(user)

/obj/machinery/processor/emag_act(mob/user)
	. = ..()
	if(CHECK_BITFIELD(obj_flags, EMAGGED))
		return
	ENABLE_BITFIELD(obj_flags, EMAGGED)
	to_chat(user, "<span class='notice'>You activate \the [src]'s emergency humanitarian protocols.</span>")

/obj/machinery/processor/proc/process_food(datum/food_processor_process/recipe, atom/movable/what)
	if (!QDELETED(src))
		recipe.make_results(src, what)
	if (ismob(what))
		var/mob/themob = what
		themob.gib(TRUE,TRUE,TRUE)
	else
		qdel(what)

/obj/machinery/processor/proc/select_recipe(atom/movable/X, mob/user)
	if(!X)
		return
	var/datum/food_processor_process/recipe = GLOB.food_processor_recipes[X.type]
	if(recipe?.check_requirements(src, X, user))
		return recipe

/obj/machinery/processor/attackby(obj/item/O, mob/user, params)
	if(processing)
		to_chat(user, "<span class='warning'>[src] is in the process of processing!</span>")
		return TRUE
	if(default_deconstruction_screwdriver(user, "processor", "processor1", O))
		return

	if(default_pry_open(O))
		return

	if(default_unfasten_wrench(user, O))
		return

	if(default_deconstruction_crowbar(O))
		return

	if(istype(O, /obj/item/storage/bag/tray))
		var/obj/item/storage/T = O
		var/loaded = 0
		for(var/obj/item/reagent_containers/food/snacks/S in T.contents)
			var/datum/food_processor_process/P = select_recipe(S, user)
			if(P)
				if(SEND_SIGNAL(T, COMSIG_TRY_STORAGE_TAKE, S, src))
					loaded++

		if(loaded)
			to_chat(user, "<span class='notice'>You insert [loaded] items into [src].</span>")
		return

	var/datum/food_processor_process/P = select_recipe(O, user)
	if(P)
		user.visible_message("[user] put [O] into [src].", \
			"You put [O] into [src].")
		user.transferItemToLoc(O, src, TRUE)
		return 1
	else
		if(user.a_intent != INTENT_HARM)
			to_chat(user, "<span class='warning'>That probably won't blend!</span>")
			return 1
		else
			return ..()

/obj/machinery/processor/interact(mob/user)
	if(processing)
		to_chat(user, "<span class='warning'>[src] is in the process of processing!</span>")
		return TRUE
	if(user.a_intent == INTENT_GRAB && ismob(user.pulling) && select_recipe(user.pulling, user))
		var/mob/living/pushed_mob = user.pulling
		visible_message("<span class='warner'>[user] stuffs [pushed_mob] into [src]!</span>")
		pushed_mob.forceMove(src)
		user.stop_pulling()
		return
	if(contents.len == 0)
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return TRUE
	processing = TRUE
	user.visible_message("[user] turns on [src].", \
		"<span class='notice'>You turn on [src].</span>", \
		"<span class='italics'>You hear a food processor.</span>")
	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	use_power(500)
	var/total_time = 0
	var/list/processing_recipes
	for(var/i in contents)
		var/atom/movable/A = i
		var/datum/food_processor_process/P = select_recipe(A)
		if (!P)
			log_admin("DEBUG: [A] was found inside food processor while not having a suitable recipe.")
			A.forceMove(drop_location())
			continue
		total_time += P.time
		LAZYSET(processing_recipes, P, A)
		if(ismob(A)) //prevent sprinting out and exploding into gibs the next room cases.
			var/mob/M = A
			M.death(TRUE)
			M.ghostize()
	if(!processing_recipes)
		return
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = (total_time / rating_speed)*5) //start shaking
	addtimer(CALLBACK(src, .proc/finish_food, processing_recipes), total_time / rating_speed)

/obj/machinery/processor/proc/finish_food(list/processing_recipes)
	for(var/A in processing_recipes)
		process_food(A, processing_recipes[A])
	pixel_x = initial(pixel_x) //return to its spot after shaking
	processing = FALSE
	visible_message("\The [src] finishes processing.")

/obj/machinery/processor/verb/eject()
	set category = "Object"
	set name = "Eject Contents"
	set src in oview(1)

	if(usr.incapacitated())
		return
	empty(usr)
	add_fingerprint(usr)

/obj/machinery/processor/proc/empty(mob/user)
	if(LAZYLEN(contents))
		for (var/i in src)
			var/atom/movable/A
			A.forceMove(drop_location())
		to_chat(user, "<span class='notice'>You empty \the [src] of its contents.</span>")

/obj/machinery/processor/container_resist(mob/living/user)
	user.forceMove(drop_location())
	user.visible_message("<span class='notice'>[user] crawls free of the processor!</span>")

/obj/machinery/processor/slime
	name = "slime processor"
	desc = "An industrial grinder with a sticker saying appropriated for science department. Keep hands clear of intake area while operating."
	circuit = /obj/item/circuitboard/machine/processor/slime

/obj/machinery/processor/slime/adjust_item_drop_location(atom/movable/AM)
	var/static/list/slimecores = subtypesof(/obj/item/slime_extract)
	var/i = 0
	if(!(i = slimecores.Find(AM.type))) // If the item is not found
		return
	if (i <= 16) // If in the first 12 slots
		AM.pixel_x = -12 + ((i%4)*8)
		AM.pixel_y = -12 + (round(i/4)*8)
		return i
	var/ii = i - 16
	AM.pixel_x = -8 + ((ii%3)*8)
	AM.pixel_y = -8 + (round(ii/3)*8)
	return i

/obj/machinery/processor/slime/process()
	if(processing)
		return
	var/mob/living/simple_animal/slime/picked_slime
	for(var/mob/living/simple_animal/slime/slime in range(1,src))
		if(slime.loc == src)
			continue
		if(istype(slime, /mob/living/simple_animal/slime))
			if(slime.stat == DEAD)
				picked_slime = slime
				break
	if(!picked_slime)
		return
	var/datum/food_processor_process/P = select_recipe(picked_slime)
	if (!P)
		return

	visible_message("[picked_slime] is sucked into [src].")
	picked_slime.forceMove(src)
