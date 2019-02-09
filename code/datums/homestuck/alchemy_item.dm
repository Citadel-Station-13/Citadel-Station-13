GLOBAL_LIST_EMPTY(alchemy_items) // items criados no round

/datum/alchemy_item
	var/obj/item/fuse_1
	var/obj/item/fuse_2
	var/obj/item/result
	var/id

/datum/alchemy_item/proc/registerItem()
	GLOB.alchemy_items += result
	id = "\ref[result]"
	var/icon/icon_1 = new(fuse_1.icon || fuse_2.icon)
	var/icon/icon_2 = new(fuse_2.icon || fuse_1.icon)

	var/icon/fused_icon = fuseIcons(icon_1, icon_2)
	//eu acima

/datum/alchemy_item/proc/fuseItems()
	var/icon/item_icons

#define ICON_RANDOM 1 // bitflags pra geraçao dos icons :)
#define ICON_NOISE 2 // usar noise pra definir os pixels clonados (?)
#define ICON_NORMAL_FUSE 4 // só juntar

proc/fuseIcons(icon/i1,icon/i2, var/flags = ICON_NORMAL_FUSE)
	var/icon/j = new(i1)
	for(var/s in icon_states(i2))
		j.Insert(icon(i2,s),s)
	return j