/obj/item/binoculars
	name = "binoculars"
	desc = "Used for long-distance surveillance."
	item_state = "binoculars"
	icon_state = "binoculars"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/mob/listeningTo
	var/zoom_out_amt = 6
	var/zoom_amt = 10

/obj/item/binoculars/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/binoculars/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=8, force_wielded=12)

/obj/item/binoculars/Destroy()
	listeningTo = null
	return ..()

/obj/item/binoculars/proc/on_wield(obj/item/source, mob/user)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/on_walk)
	RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, .proc/rotate)
	listeningTo = user
	user.visible_message("<span class='notice'>[user] holds [src] up to [user.p_their()] eyes.</span>", "<span class='notice'>You hold [src] up to your eyes.</span>")
	item_state = "binoculars_wielded"
	user.regenerate_icons()
	user.client.view_size.zoomOut(zoom_out_amt, zoom_amt, user.dir)

/obj/item/binoculars/proc/rotate(atom/thing, old_dir, new_dir)
	if(ismob(thing))
		var/mob/lad = thing
		lad.regenerate_icons()
		lad.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)

/obj/item/binoculars/proc/on_walk()
	attack_self(listeningTo) //Yes I have sinned, why do you ask?

/obj/item/binoculars/proc/on_unwield(obj/item/source, mob/user)
	unwield(user)

/obj/item/binoculars/proc/unwield(mob/user)
	if(listeningTo)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		listeningTo = null
	user.visible_message("<span class='notice'>[user] lowers [src].</span>", "<span class='notice'>You lower [src].</span>")
	item_state = "binoculars"
	user.regenerate_icons()
	user.client.view_size.zoomIn()
