/obj/machinery/kilm
	name = "kilm"
	desc = "A stone kilm, can be filled with logs for fuel."
	icon = 'icons/obj/fireplace.dmi'
	icon_state = "kilm"

	use_power = NO_POWER_USE
	density = TRUE

	var/on = FALSE
	var/filled = FALSE
	var/charges = 0
	var/making = null

/obj/machinery/kilm/attackby(obj/item/T, mob/user)
	if(istype(T, /obj/item/grown/log))
		charges ++
		qdel(T)

/obj/machinery/kilm/attackby(obj/item/stack/ore/S, mob/user)
	if(istype(S, /obj/item/stack/ore/glass))
		if(S.amount <= 5)
			user.show_message("<span class='notice'>You add the sand to the kilm.</span>", 1)
			filled = TRUE
			S.amount = (S.amount - 5)
			if(S.amount < 5)
				qdel(S)
			else
				user.show_message("<span class='notice'>You need a at lest five sand piles to make anything of use.</span>", 1)

/obj/machinery/kilm/attack_hand(mob/living/carbon/user)
	. = ..()
	if(.)
		return
	if(charges == 0)
		to_chat(user, "The Kilm needs fuel to use.")
		making = null
		return

	if(charges == 1)
		to_chat(user, "The Kilm has some fuel and can be used to make a small flask.")
		making = /obj/item/reagent_containers/glass/beaker/flask_small
		return

	if(charges == 2)
		to_chat(user, "The Kilm has some fuel and can be used to make a honey jar.")
		making = /obj/item/reagent_containers/glass/beaker/jar
		return

	if(charges == 3)
		to_chat(user, "The Kilm has fuel and can be used to make a large flask.")
		making = /obj/item/reagent_containers/glass/beaker/flask_large
		return

	if(charges == 4)
		to_chat(user, "The Kilm has fuel and can be used to make a spouty flask.")
		making = /obj/item/reagent_containers/glass/beaker/flaskspouty
		return

	if(charges == 5)
		to_chat(user, "The Kilm has fuel and can be used to make a glass disk.")
		making = /obj/item/reagent_containers/glass/beaker/glass_dish
		return

	if(charges >= 6) //You may want glass slug!
		to_chat(user, "The Kilm has a lot of fuel and will make glass slug...")
		making = null
		return

	return
