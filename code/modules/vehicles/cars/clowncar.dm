/obj/vehicle/sealed/car/clowncar
	name = "clown car"
	desc = "How someone could even fit in there is beyond me."
	icon_state = "clowncar"
	max_integrity = 150
	armor = list("melee" = 70, "bullet" = 40, "laser" = 40, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	enter_delay = 20
	max_occupants = 50
	movedelay = 0.6
	car_traits = CAN_KIDNAP
	key_type = /obj/item/bikehorn
	key_type_exact = FALSE
	var/droppingoil = FALSE
	var/RTDcooldown = 150
	var/lastRTDtime = 0

/obj/vehicle/sealed/car/clowncar/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/sealed/horn/clowncar, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/car/clowncar/driver_move(mob/user, direction) //Prevent it from moving onto space
	if(isspaceturf(get_step(src, direction)))
		return FALSE
	else
		return ..()

/obj/vehicle/sealed/car/clowncar/auto_assign_occupant_flags(mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.mind && HAS_TRAIT(H.mind, TRAIT_CLOWN_MENTALITY)) //Ensures only clowns can drive the car. (Including more at once)
			add_control_flags(M, VEHICLE_CONTROL_DRIVE|VEHICLE_CONTROL_PERMISSION)
			return
	add_control_flags(M, VEHICLE_CONTROL_KIDNAPPED)

/obj/vehicle/sealed/car/clowncar/mob_forced_enter(mob/M, silent = FALSE)
	. = ..()
	playsound(src, pick('sound/vehicles/clowncar_load1.ogg', 'sound/vehicles/clowncar_load2.ogg'), 75)

/obj/vehicle/sealed/car/clowncar/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(prob(33))
		visible_message("<span class='danger'>[src] spews out a ton of space lube!</span>")
		new /obj/effect/particle_effect/foam(loc) //YEET

/obj/vehicle/sealed/car/clowncar/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/banana))
		var/obj/item/reagent_containers/food/snacks/grown/banana/banana = I
		obj_integrity += min(banana.seed.potency, max_integrity-obj_integrity)
		to_chat(user, "<span class='danger'>You use the [banana] to repair the [src]!</span>")
		qdel(banana)

/obj/vehicle/sealed/car/clowncar/Bump(atom/movable/M)
	. = ..()
	if(isliving(M))
		if(ismegafauna(M))
			return
		var/mob/living/L = M
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			C.DefaultCombatKnockdown(40) //I play to make sprites go horizontal
		L.visible_message("<span class='warning'>[src] rams into [L] and sucks him up!</span>") //fuck off shezza this isn't ERP.
		mob_forced_enter(L)
		playsound(src, pick('sound/vehicles/clowncar_ram1.ogg', 'sound/vehicles/clowncar_ram2.ogg', 'sound/vehicles/clowncar_ram3.ogg'), 75)
	else if(istype(M, /turf/closed) || istype(M, /obj/machinery/door/airlock/external))
		visible_message("<span class='warning'>[src] rams into [M] and crashes!</span>")
		playsound(src, pick('sound/vehicles/clowncar_crash1.ogg', 'sound/vehicles/clowncar_crash2.ogg'), 75)
		playsound(src, 'sound/vehicles/clowncar_crashpins.ogg', 75)
		DumpMobs(TRUE)

/obj/vehicle/sealed/car/clowncar/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='danger'>You scramble the clowncar child safety lock and a panel with 6 colorful buttons appears!</span>")
	initialize_controller_action_type(/datum/action/vehicle/sealed/RollTheDice, VEHICLE_CONTROL_DRIVE)
	return TRUE

/obj/vehicle/sealed/car/clowncar/Destroy()
	playsound(src, 'sound/vehicles/clowncar_fart.ogg', 100)
	return ..()

/obj/vehicle/sealed/car/clowncar/after_move(direction)
	. = ..()
	if(droppingoil)
		new /obj/effect/decal/cleanable/oil/slippery(loc)

/obj/vehicle/sealed/car/clowncar/proc/RollTheDice(mob/user)
	if(world.time - lastRTDtime < RTDcooldown)
		to_chat(user, "<span class='notice'>The button panel is currently recharging.</span>")
		return
	lastRTDtime = world.time
	var/randomnum = rand(1,6)
	switch(randomnum)
		if(1)
			visible_message("<span class='danger'>[user] has pressed one of the colorful buttons on [src] and a special banana peel drops out of it.</span>")
			new /obj/item/grown/bananapeel/specialpeel(loc)
		if(2)
			visible_message("<span class='danger'>[user] has pressed one of the colorful buttons on [src] and unknown chemicals flood out of it.</span>")
			var/datum/reagents/R = new/datum/reagents(300)
			R.my_atom = src
			R.add_reagent(get_random_reagent_id(), 100)
			var/datum/effect_system/foam_spread/foam = new
			foam.set_up(200, loc, R)
			foam.start()
		if(3)
			visible_message("<span class='danger'>[user] has pressed one of the colorful buttons on [src] and the clown car turns on its singularity disguise system.</span>")
			icon = 'icons/obj/singularity.dmi'
			icon_state = "singularity_s1"
			addtimer(CALLBACK(src, .proc/ResetIcon), 100)
		if(4)
			visible_message("<span class='danger'>[user] has pressed one of the colorful buttons on [src] and the clown car spews out a cloud of laughing gas.</span>")
			var/datum/reagents/R = new/datum/reagents(300)
			R.my_atom = src
			R.add_reagent(/datum/reagent/consumable/superlaughter, 50)
			var/datum/effect_system/smoke_spread/chem/smoke = new()
			smoke.set_up(R, 4)
			smoke.attach(src)
			smoke.start()
		if(5)
			visible_message("<span class='danger'>[user] has pressed one of the colorful buttons on [src] and the clown car starts dropping an oil trail.</span>")
			droppingoil = TRUE
			addtimer(CALLBACK(src, .proc/StopDroppingOil), 30)
		if(6)
			visible_message("<span class='danger'>[user] has pressed one of the colorful buttons on [src] and the clown car lets out a comedic toot.</span>")
			playsound(src, 'sound/vehicles/clowncar_fart.ogg', 100)
			for(var/mob/living/L in orange(loc, 6))
				L.emote("laughs")
			for(var/mob/living/L in occupants)
				L.emote("laughs")

/obj/vehicle/sealed/car/clowncar/proc/ResetIcon()
	icon = initial(icon)
	icon_state = initial(icon_state)

/obj/vehicle/sealed/car/clowncar/proc/StopDroppingOil()
	droppingoil = FALSE

/obj/vehicle/sealed/car/clowncar/twitch_plays
	key_type = null

/obj/vehicle/sealed/car/clowncar/twitch_plays/Initialize()
	. = ..()
	AddComponent(/datum/component/twitch_plays/simple_movement)
	START_PROCESSING(SSfastprocess, src)
	GLOB.poi_list |= src
	notify_ghosts("Twitch Plays: Clown Car")

/obj/vehicle/sealed/car/clowncar/twitch_plays/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	GLOB.poi_list -= src
	return ..()

/obj/vehicle/sealed/car/clowncar/twitch_plays/process()
	var/dir = SEND_SIGNAL(src, COMSIG_TWITCH_PLAYS_MOVEMENT_DATA, TRUE)
	if(!dir)
		return
	driver_move(null, dir)
