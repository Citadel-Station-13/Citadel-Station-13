GLOBAL_LIST_EMPTY(alchemy_items) // items criados no round

/datum/alchemy_item
	var/obj/item/fuse_1
	var/obj/item/fuse_2
	var/obj/item/result

/datum/alchemy_item/proc/registerItem()
	GLOB.alchemy_items += result