#define FABRIC_PER_SHEET 4


///This is a loom. It's usually made out of wood and used to weave fabric like durathread or cotton into their respective cloth types.
/obj/structure/loom
	name = "loom"
	desc = "A simple device used to weave cloth and other thread-based fabrics together into usable material."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "loom"
	density = TRUE
	anchored = TRUE

/obj/structure/loom/attackby(obj/item/I, mob/user)
	if(weave(I, user))
		return
	return ..()

/obj/structure/loom/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE

///Handles the weaving.
/obj/structure/loom/proc/weave(obj/item/stack/sheet/S, mob/user)
	if(!istype(S) || !S.is_fabric)
		return FALSE
	if(!anchored)
		user.show_message("<span class='notice'>The loom needs to be wrenched down.</span>", MSG_VISUAL)
		return FALSE
	if(S.amount < FABRIC_PER_SHEET)
		user.show_message("<span class='notice'>You need at least [FABRIC_PER_SHEET] units of fabric before using this.</span>", 1)
		return FALSE
	user.show_message("<span class='notice'>You start weaving \the [S.name] through the loom..</span>", MSG_VISUAL)
	if(S.use_tool(src, user, S.pull_effort))
		if(S.amount >= FABRIC_PER_SHEET)
			new S.loom_result(drop_location())
			S.use(FABRIC_PER_SHEET)
			user.show_message("<span class='notice'>You weave \the [S.name] into a workable fabric.</span>", MSG_VISUAL)
	return TRUE

/obj/structure/loom/unanchored
	anchored = FALSE

#undef FABRIC_PER_SHEET