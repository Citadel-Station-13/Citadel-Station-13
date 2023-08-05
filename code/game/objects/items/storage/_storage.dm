
/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	var/component_type = /datum/component/storage/concrete

/obj/item/storage/get_dumping_location(obj/item/storage/source,mob/user)
	return src

/obj/item/storage/Initialize(mapload)
	. = ..()
	PopulateContents()

/obj/item/storage/ComponentInitialize()
	AddComponent(component_type)

/obj/item/storage/AllowDrop()
	return !QDELETED(src)

/obj/item/storage/contents_explosion(severity, target, origin)
	var/in_storage = istype(loc, /obj/item/storage)? (max(0, severity - 1)) : (severity)
	for(var/atom/A in contents)
		A.ex_act(in_storage, target, origin)
		CHECK_TICK

//Cyberboss says: "USE THIS TO FILL IT, NOT INITIALIZE OR NEW"

/obj/item/storage/proc/PopulateContents()
