
///////////
//COLLARS//
///////////

/obj/item/clothing/neck/petcollar
	name = "pet collar"
	desc = "It's for pets. Though you probably could wear it yourself, you'd doubtless be the subject of ridicule."
	icon_state = "petcollar"
	item_color = "petcollar"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/collar
	var/tagname = null

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = copytext(sanitize(input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"


/obj/item/clothing/neck/petcollar/locked
	name = "locked collar"
	desc = "A collar that has a small lock on it to keep it from being removed."
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/collar/locked
	var/lock = FALSE

/obj/item/clothing/neck/petcollar/locked/attackby(obj/item/key/collar, mob/user, params)
	if(lock != FALSE)
		to_chat(user, "<span class='warning'>With a click the collar unlocks!</span>")
		lock = FALSE
		item_flags = NONE
	else
		to_chat(user, "<span class='warning'>With a click the collar locks!</span>")
		lock = TRUE
		item_flags = NODROP
	return

/obj/item/clothing/neck/petcollar/locked/attack_hand(mob/user)
	if(loc == user && user.get_item_by_slot(SLOT_NECK) && lock != FALSE)
		to_chat(user, "<span class='warning'>The collar is locked! You'll need unlock the collar before you can take it off!</span>")
		return
	..()

/obj/item/key/collar
	name = "Collar Key"
	desc = "A key for a tiny lock on a collar or bag."

/obj/item/clothing/neck/petcollar/Initialize()
	. = ..()
	new /obj/item/reagent_containers/food/snacks/cookie(src)

/obj/item/clothing/neck/petcollar/locked/Initialize()
	. = ..()
	new /obj/item/key/collar(src)
