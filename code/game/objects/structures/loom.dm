#define FABRIC_PER_SHEET 4

/obj/structure/loom
	name = "loom"
	desc = "A simple device used to weave cloth and other thread-based fabrics together into usable material."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "loom"
	density = TRUE
	anchored = TRUE

/obj/structure/loom/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE

/obj/structure/loom/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/W = I
		if(W.is_fabric && W.amount > 3)
			user.show_message("<span class='notice'>You start weaving the [W.name] through the loom..</span>", 1)
			if(W.use_tool(src, user, W.pull_effort))
				new W.loom_result(drop_location())
				user.show_message("<span class='notice'>You weave the [W.name] into a workable fabric.</span>", 1)
				W.amount = (W.amount - FABRIC_PER_SHEET)
				if(W.amount < 1)
					qdel(W)
		else
			user.show_message("<span class='notice'>You need a valid fabric and at least [FABRIC_PER_SHEET] of said fabric before using this.</span>")
	else
		return ..()

#undef FABRIC_PER_SHEET