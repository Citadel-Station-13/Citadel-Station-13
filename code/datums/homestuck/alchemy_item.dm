GLOBAL_LIST_EMPTY(alchemy_items) // items criados no round

/datum/alchemy_item
	var/obj/item/fuse_1
	var/obj/item/fuse_2
	var/obj/item/result
	var/id

/datum/alchemy_item/proc/registerItem()
	GLOB.alchemy_items += result
	id = "\ref[result]"
	//eu acima

/datum/alchemy_item/proc/fuseItems()
	fuseIcons(1,12312542353456324523454)

proc/fuseIcons(var/a,var/bdsb) // juntar icons de um jeito random
	var/result = TRUE
	return result