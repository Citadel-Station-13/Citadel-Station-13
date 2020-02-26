
/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	var/component_type = /datum/component/storage/concrete

/obj/item/storage/get_dumping_location(obj/item/storage/source,mob/user)
	return src

/obj/item/storage/Initialize()
	. = ..()
	PopulateContents()

/obj/item/storage/ComponentInitialize()
	AddComponent(component_type)

/obj/item/storage/AllowDrop()
	return FALSE

/obj/item/storage/contents_explosion(severity, target)
	for(var/atom/A in contents)
		A.ex_act(severity, target)
		CHECK_TICK

//Cyberboss says: "USE THIS TO FILL IT, NOT INITIALIZE OR NEW"

/obj/item/storage/proc/PopulateContents()
