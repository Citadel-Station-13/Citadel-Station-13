/obj/item/implant/abductor
	name = "recall implant"
	desc = "Returns you to the mothership."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "implant"
	activated = 1
	var/obj/machinery/abductor/pad/home
	var/next_use = 0

/obj/item/implant/abductor/activate()
	. = ..()
	if(next_use <= world.time)
		home.Retrieve(imp_in,1)
		next_use = world.time + 60 SECONDS
	else
		to_chat(imp_in, "<span class='warning'>You must wait [DisplayTimeText(next_use - world.time)] to use [src] again!</span>")

/obj/item/implant/abductor/implant(mob/living/target, mob/user)
	. = ..()
	if(!.)
		return
	var/obj/machinery/abductor/console/console
	if(ishuman(target))
		var/datum/antagonist/abductor/A = target.mind.has_antag_datum(/datum/antagonist/abductor)
		if(A)
			console = get_abductor_console(A.team.team_number)
			home = console.pad

	if(!home)
		var/list/consoles = list()
		for(var/obj/machinery/abductor/console/C in GLOB.machines)
			consoles += C
		console = pick(consoles)
		home = console.pad
