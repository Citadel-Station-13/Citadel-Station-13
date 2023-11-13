/obj/vehicle/sealed/vectorcraft/boot
	name = "Hovertruck"
	desc = "An all-terrain vehicle built for traversing rough terrain with ease. This one comes equipt with a sizeable boot that can store up to 3 items!"
	icon_state = "truck"
	max_integrity = 200
	var/obj/structure/boot = list()//Trunkspace of craft
	var/boot_size = 3
	max_acceleration = 3
	accel_step = 0.15
	acceleration = 0.3
	max_deceleration = 5
	max_velocity = 80
	boost_power = 20
	enginesound_delay = 0
	var/static/radial_heal = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_heal")
	var/static/radial_eject_car = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject_car")
	var/static/radial_eject_key = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject_key")
	var/static/radial_eject_boot = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject_boot")

/obj/vehicle/sealed/vectorcraft/boot/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/))
		if(LAZYLEN(boot) < boot_size)
			boot += dropping
			to_chat(user, "<span class='notice'>You add the [dropping] to the [src]'s boot!</span>")
			return TRUE
	if(iscarbon(dropping))
		var/mob/living/carbon/M = dropping
		mob_try_enter(M)
		to_chat(user, "<span class='notice'>You put [M] into the [src]!</span>")
		return TRUE

/obj/vehicle/sealed/vectorcraft/boot/proc/eject_boot()
	for(var/obj/o in boot)
		o.forceMove(drop_location())

/obj/vehicle/sealed/vectorcraft/boot/ambulance //weewoos have to go fast
	name = "Ambulance"
	var/obj/machinery/sleeper/Sl
	max_acceleration = 3
	accel_step = 0.15
	acceleration = 0.3
	max_deceleration = 5
	max_velocity = 100
	boost_power = 25
	enginesound_delay = 0
	icon_state = "ambutruck"
	var/weewoo = FALSE
	var/weewoocount = 0

/obj/vehicle/sealed/vectorcraft/boot/ambulance/Initialize(mapload)
	. = ..()
	Sl = new /obj/machinery/sleeper

/obj/vehicle/sealed/vectorcraft/boot/ambulance/process()
	..()
	if(weewoo)
		weewoo()

/obj/vehicle/sealed/vectorcraft/boot/ambulance/MouseDrop_T(mob/living/L, mob/user)
	if(isliving(L))
		Sl.close_machine(L)
		to_chat(user, "<span class='notice'>You put [L] into the [src]'s emergency sleeper!</span>")
		return TRUE
	..()

/obj/vehicle/sealed/vectorcraft/boot/ambulance/proc/weewoo()
	if(weewoocount>10)
		weewoocount = 0

		return
	weewoo++

/obj/vehicle/sealed/vectorcraft/boot/ambulance/ui_interact(mob/user) // taken from the microwave/grinder
	. = ..()

	var/list/options = list()

	if(isAI(user))
		options["radial_eject_car"] = radial_eject_car
	else
		if(vector["y"] == 0 && vector["x"] == 0)
			options["radial_eject_car"] = radial_eject_car
		if(Sl.occupant)
			options["radial_heal"] = radial_heal
		if(inserted_key)
			if(!driver)
				options["radial_eject_key"] = radial_eject_key
		if(length(boot))
			options["radial_eject_boot"] = radial_eject_boot

	var/choice

	if(length(options) < 1)
		return
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))

	// post choice verification
	if(isAI(user) || !user.canUseTopic(src, !issilicon(user)))
		return

	switch(choice)
		if("eject_car")
			if(driver)
				remove_occupant(driver)
			else
				for(var/mob/m in occupants)
					remove_occupant(m)
		if("radial_heal")
			Sl.ui_interact(user)
		if("eject_key")
			to_chat(user, "<span class='notice'>You remove \the [inserted_key] from \the [src].</span>")
			inserted_key.forceMove(drop_location())
			user.put_in_hands(inserted_key)
			inserted_key = null
		if("eject_boot")
			eject_boot(user)


/obj/vehicle/sealed/vectorcraft/boot/ambulance/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/sleeper_buffer))
		var/obj/item/reagent_containers/sleeper_buffer/SB = I
		if((SB.reagents.total_volume + Sl.reagents.total_volume) < Sl.reagents.maximum_volume)
			SB.reagents.trans_to(Sl.reagents, SB.reagents.total_volume)
			visible_message("[user] places the [SB] into the [src].")
			qdel(SB)
			return
		else
			SB.reagents.trans_to(Sl.reagents, SB.reagents.total_volume)
			visible_message("[user] adds as much as they can to the [src] from the [SB].")
			return
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = I
		if(RC.reagents.total_volume == 0)
			to_chat(user, "<span class='notice'>The [I] is empty!</span>")
		for(var/datum/reagent/R in RC.reagents.reagent_list)
			if((obj_flags & EMAGGED) || (allowed(usr)))
				break
			if(!istype(R, /datum/reagent/medicine))
				visible_message("The [src] gives out a hearty boop and rejects the [I]. The Sleeper's screen flashes with a pompous \"Medicines only, please.\"")
				return
		RC.reagents.trans_to(Sl.reagents, 1000)
		visible_message("[user] adds as much as they can to the [src] from the [I].")
		return
