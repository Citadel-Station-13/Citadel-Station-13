
//Borrowed from Skyrat, this is not sandstorm original content

//cheems, the true cargo pet
//note: will probably add hat and fluff functionality later
//note 2: will probably get a better sprite later
//note 3: ignore note 2 the sprite is actually good now
/mob/living/simple_animal/pet/dog/cheems
	name = "\proper Cheems"
	desc = "Cargo's overfed and slightly greasy disposal bin."
	icon = 'modular_sand/icons/mob/doges.dmi'
	icon_state = "cheems"
	icon_dead = "cheems_dead"
	icon_living = "cheems"
	speak = list("Borf!", "Boof!", "Bork!")
	butcher_results = list(/obj/item/reagent_containers/food/snacks/burger/cheese = 1, /obj/item/reagent_containers/food/snacks/meat/slab = 2, /obj/item/trash/syndi_cakes = 1)
	faction = list("dog", "doge")
	animal_species = /mob/living/simple_animal/pet/dog
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/simple_animal/pet/dog/cheems/Move(atom/newloc, direct)
	. = ..()
	if(.)
		for(var/obj/item/reagent_containers/food/snacks/burger/burbger in view(1, src))
			visible_message("<span class='danger'><b>\The [src]</b> consumes the [burbger]!</span>")
			qdel(burbger)
			revive(full_heal = 1)

/mob/living/simple_animal/pet/dog/cheems/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(.)
		if(istype(I, /obj/item/reagent_containers/food/snacks/burger))
			qdel(I)
			if(stat == DEAD)
				visible_message("<b>\The [src]</b> stands right back up after nibbling the [I]!")
			else 
				visible_message("<b>\The [src]</b> swallows the [I] whole!")
			revive(full_heal = 1)

//cheemgularity
/* disabled for now because error: maximum number of internal arrays exceeded (65535)
/obj/singularity/proc/consume(atom/A)
	var/gain = A.singularity_act(current_size, src)
	src.energy += gain
	if(istype(A, /obj/machinery/power/supermatter_crystal) && !consumedSupermatter)
		desc = "[initial(desc)] It glows fiercely with inner fire."
		name = "supermatter-charged [initial(name)]"
		consumedSupermatter = 1
		set_light(10)
	if(istype(A, /mob/living/simple_animal/pet/dog/cheems))
		new /obj/singularity/cheemgularity(get_turf(src))
		qdel(src)

/obj/singularity/cheemgularity
	name = "cheemgularity"
	desc = "Praise cheem."
	icon = 'modular_sand/icons/obj/singularity.dmi'
	icon_state = "cheemgulo_s1"

/obj/singularity/cheemgularity/expand(force_size)
	..()
	switch(force_size)
		if(STAGE_ONE to STAGE_TWO)
			icon = initial(icon)
			icon_state = "cheemgulo_s1"
		if(STAGE_TWO to STAGE_THREE)
			icon = 'modular_sand/icons/effects/96x96.dmi'
			icon_state = "cheemgulo_s3"
		if(STAGE_THREE to STAGE_FOUR)
			icon = 'modular_sand/icons/effects/160x160.dmi'
			icon_state = "cheemgulo_s5"
		if(STAGE_FOUR to STAGE_FIVE)
			icon = 'modular_sand/icons/effects/224x224.dmi'
			icon_state = "cheemgulo_s7"
		if(STAGE_FIVE to STAGE_SIX)
			icon = 'modular_sand/icons/effects/288x288.dmi'
			icon_state = "cheemgulo_s9"
		if(STAGE_SIX)
			icon = 'modular_sand/icons/effects/352x352.dmi'
			icon_state = "cheemgulo_s11"
*/
