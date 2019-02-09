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
	var/icon/item_icons

proc/fuseIcons(icon/i1,icon/i2)
	var/icon/j = new(i1)
	for(var/s in icon_states(i2))
		j.Insert(icon(i2,s),s)
	return j