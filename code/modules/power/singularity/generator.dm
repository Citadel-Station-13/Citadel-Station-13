/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "Gravitational Singularity Generator"
	desc = "An odd device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = TRUE
	use_power = NO_POWER_USE
	resistance_flags = FIRE_PROOF

	// You can buckle someone to the singularity generator, then start the engine. Fun!
	can_buckle = TRUE
	buckle_lying = FALSE
	buckle_requires_restraints = TRUE

	var/energy = 0
	var/creation_type = /obj/singularity

/obj/machinery/the_singularitygen/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wrench))
		default_unfasten_wrench(user, W, 0)
	else
		return ..()
	if(istype(W, /obj/item/screwdriver))
		panel_open = !panel_open
		playsound(loc, W.usesound, 50, 1)
		visible_message("<span class='notice'>\The [user] adjusts \the [src]'s mechanisms.</span>")
		if(panel_open && do_after(user, 30))
			to_chat(user, "<span class='notice'>\The [src] looks like it could be modified.</span>")
			if(panel_open && do_after(user, 80 * W.toolspeed))	// We don't have screwdriving skill yet, so a delayed hint for engineers will have to do for now. (Panel open check for sanity)
				playsound(loc, W.usesound, 50, 1)
				to_chat(user, "<span class='cult'>\The [src] looks like it could be adapted to forge advanced materials via particle acceleration, somehow..</span>")
		else
			to_chat(user, "<span class='notice'>\The [src]'s mechanisms look secure.</span>")
	if(istype(W, /obj/item/twohanded/rcl) && panel_open) //We dont care if theirs cable or not.
		visible_message("<span class='notice'>\The [user] begins to modify \the [src] with \the [W].</span>")
		if(do_after(user, 300))
			visible_message("<span class='notice'>\The [user] installs \the [W] onto \the [src].</span>")
			qdel(W)
			var/turf/T = get_turf(src)
			var/new_machine = /obj/machinery/particle_smasher
			new new_machine(T)
			qdel(src)

/obj/machinery/the_singularitygen/process()
	if(energy > 0)
		if(energy >= 200)
			var/turf/T = get_turf(src)
			SSblackbox.record_feedback("tally", "engine_started", 1, type)
			var/obj/singularity/S = new creation_type(T, 50)
			transfer_fingerprints_to(S)
			qdel(src)
		else
			energy -= 1
