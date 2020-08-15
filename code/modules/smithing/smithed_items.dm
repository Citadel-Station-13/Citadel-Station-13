/obj/item/smithing
	name = "base class /obj/item/smithing"
	icon = 'icons/obj/smith.dmi'
	icon_state = "unfinished"
	material_flags = MATERIAL_COLOR | MATERIAL_ADD_PREFIX
	var/quality = 0 //quality. Changed by the smithing process.
	var/obj/item/finishingitem = /obj/item/stick //What this item needs to be hit by to create finalitem
	var/obj/item/finalitem = /obj/item/melee/smith

/obj/item/ingot
	name = "ingot"
	icon = 'icons/obj/smith.dmi'
	icon_state = "unfinished"
	material_flags = MATERIAL_COLOR | MATERIAL_ADD_PREFIX
	var/workability = "shapeable"

/obj/item/ingot/iron
	custom_materials = list(/datum/material/iron=12000)

/obj/item/smithing/Initialize()
	desc = "A [src]. Hit it with a [finishingitem] to create a [finalitem]."
/obj/item/smithing/attackby(obj/item/I, mob/user)
	if(istype(I, finishingitem))
		to_chat(user, "You finish the [src].")
		qdel(I)
		dofinish()
	else
		return ..()


/obj/item/smithing/proc/dofinish()
	var/turf/T = get_turf(src)
	. = new finalitem(T)
	finalitem.set_custom_materials(custom_materials)
	var/qualname
	switch(quality)
		if(-1000 to -5)
			qualname = "awful"
		if(-1000 to -2)
			qualname = "shoddy"
		if(-1000 to 0)
			qualname =  "poor"
		if(0)
			qualname = "normal"
		if(10 to INFINITY)
			qualname = "legendary"
		if(8,9)
			qualname = "masterwork"
		if(6,7)
			qualname = "excellent"
		if(4,5)
			qualname = "good"
		if(1,2,3)
			qualname = "above-average"
	var/datum/material/mat = custom_materials[1]
	mat = mat.name
	finalitem.name = "[qualname] [mat] [finalitem.name]."
	qdel(src)
	return

/obj/item/smithing/axehead
	name = "smithed axe head"
	finalitem = /obj/item/melee/smith/axe

/obj/item/smithing/axehead/dofinish()
	finalitem.force += quality
	..()

/obj/item/smithing/hammerhead
	name = "smithed hammer head"
	var/obj/item/melee/smith/hammer/finalforreal = /obj/item/melee/smith/hammer

/obj/item/smithing/hammerhead/dofinish()
	finalforreal.force += quality/2
	finalforreal.qualitymod = quality/4
	finalitem = finalforreal
	..()

/obj/item/smithing/scytheblade
	name = "smithed scythe head"
	finalitem = /obj/item/scythe/smithed

/obj/item/smithing/scytheblade/dofinish()
	finalitem.force += quality
	..()

/obj/item/smithing/shovelhead
	name = "smithed shovel head"
	finalitem = /obj/item/shovel/smithed

/obj/item/smithing/shovelhead/dofinish()
	finalitem.force += quality/2
	finalitem.toolspeed /= quality
	..()

/obj/item/smithing/cogheadclubhead
	name = "smithed coghead club head"
	finalitem = /obj/item/melee/smith/cogheadclub

/obj/item/smithing/cogheadclubhead/dofinish()
	finalitem.force += quality
	..()

/obj/item/smithing/javelinhead
	name = "smithed javelin head"
	finalitem = /obj/item/melee/smith/javelin

/obj/item/smithing/javelinhead/dofinish()
	finalitem.force += quality
	..()

/obj/item/smithing/pickaxehead
	name = "smithed pickaxe head"
	var/obj/item/pickaxe/smithed/finalforreal = /obj/item/pickaxe/smithed

/obj/item/smithing/pickaxehead/dofinish()
	finalforreal.force += quality/2
	finalforreal.toolspeed /= quality
	switch(quality)
		if(10 to INFINITY)
			finalforreal.digrange = 4
		if(5 to 9)
			finalforreal.digrange = 3
		if(3,4)
			finalforreal.digrange = 2
	finalitem = finalforreal
	..()

/obj/item/smithing/prospectingpickhead
	name = "smithed prospector's pickaxe head"
	var/obj/item/mining_scanner/prospector/finalforreal = /obj/item/mining_scanner/prospector

/obj/item/smithing/prospectingpickhead/dofinish()
	finalforreal.range = 2 + quality
	finalforreal.cooldown = 100/quality
	finalitem = finalforreal
	..()

/obj/item/smithing/shortswordblade
	name = "smithed shortsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword

/obj/item/smithing/shortswordblade/dofinish()
	finalitem.force += quality
	..()

/obj/item/smithing/knifeblade
	name = "smithed knife blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/kitchen/knife

/obj/item/smithing/knifehead/dofinish()
	finalitem.force += quality/2
	..()

/obj/item/smithing/broadblade
	name = "smithed broadsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword

/obj/item/smithing/broadblade/dofinish()
	finalitem.force += quality
	..()

/obj/item/smithing/halberdhead
	name = "smithed halberd head"
	finalitem = /obj/item/melee/smith/halberd

/obj/item/smithing/halberdhead/dofinish()
	finalitem.force += quality
	..()

/obj/item/stick
	name = "wooden rod"
	desc = "It's a rod, suitable for use of a handle of a tool. Also could serve as a weapon, in a pinch."
	icon = 'icons/obj/smith.dmi'
	icon_state = "stick"
	force = 7

/obj/item/swordhandle
	name = "sword handle"
	desc = "It's a rod, suitable for use of a handle of a tool. Also could serve as a weapon, in a pinch."
	icon = 'icons/obj/smith.dmi'
	icon_state = "stick"