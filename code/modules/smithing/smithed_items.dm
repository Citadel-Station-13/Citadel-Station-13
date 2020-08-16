



/obj/item/smithing
	name = "base class /obj/item/smithing"
	icon = 'icons/obj/smith.dmi'
	icon_state = "unfinished"
	material_flags = MATERIAL_COLOR | MATERIAL_ADD_PREFIX
	var/quality = 0 //quality. Changed by the smithing process.
	var/obj/item/finishingitem = /obj/item/stick //What this item needs to be hit by to create finalitem
	var/obj/item/finalitem

/obj/item/ingot
	name = "ingot"
	icon = 'icons/obj/smith.dmi'
	icon_state = "unfinished"
	material_flags = MATERIAL_COLOR | MATERIAL_ADD_PREFIX
	var/workability = "shapeable"

/obj/item/ingot/iron
	custom_materials = list(/datum/material/iron=12000)

/obj/item/smithing/Initialize()
	..()
	desc = "A [src]. Hit it with a [finishingitem] to create a [finalitem]."


/obj/item/smithing/attackby(obj/item/I, mob/user)
	if(istype(I, finishingitem))
		qdel(I)
		startfinish()
	else
		return ..()

/obj/item/smithing/proc/startfinish()
	dofinish()

/obj/item/smithing/proc/dofinish()
	visible_message("The finishing of [src].")
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
	finalitem.name = "[qualname] [mat] [finalitem.name]"
	finalitem.forceMove(get_turf(src))
	qdel(src)


/obj/item/smithing/axehead
	name = "smithed axe head"
	finalitem = /obj/item/melee/smith/axe

/obj/item/smithing/axehead/startfinish()
	finalitem = new /obj/item/melee/smith/axe(src)
	finalitem.force += quality
	..()

/obj/item/smithing/hammerhead
	name = "smithed hammer head"
	finalitem = /obj/item/melee/smith/hammer

/obj/item/smithing/hammerhead/startfinish()
	var/obj/item/melee/smith/hammer/finalforreal = new /obj/item/melee/smith/hammer(src)
	finalforreal.force += quality/2
	finalforreal.qualitymod = quality/4
	finalitem = finalforreal
	..()



/obj/item/smithing/scytheblade
	name = "smithed scythe head"
	finalitem = /obj/item/scythe/smithed

/obj/item/smithing/scytheblade/startfinish()
	finalitem = new /obj/item/scythe/smithed(src)
	finalitem.force += quality
	..()

/obj/item/smithing/shovelhead
	name = "smithed shovel head"
	finalitem = /obj/item/shovel/smithed

/obj/item/smithing/shovelhead/startfinish()
	finalitem = new /obj/item/shovel/smithed(src)
	finalitem.force += quality/2
	if(quality)
		finalitem.toolspeed /= quality
	..()

/obj/item/smithing/cogheadclubhead
	name = "smithed coghead club head"
	finalitem = /obj/item/melee/smith/cogheadclub

/obj/item/smithing/cogheadclubhead/startfinish()
	finalitem = new /obj/item/melee/smith/cogheadclub(src)
	finalitem.force += quality
	..()

/obj/item/smithing/javelinhead
	name = "smithed javelin head"
	finalitem = /obj/item/melee/smith/twohand/javelin

/obj/item/smithing/javelinhead/startfinish()
	var/obj/item/melee/smith/twohand/javelin/finalforreal = new /obj/item/melee/smith/twohand/javelin(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalitem = finalforreal
	..()


/obj/item/smithing/pickaxehead
	name = "smithed pickaxe head"
	finalitem = /obj/item/pickaxe/smithed

/obj/item/smithing/pickaxehead/startfinish()
	var/obj/item/pickaxe/smithed/finalforreal = new /obj/item/pickaxe/smithed(src)
	finalforreal.force += quality/2
	if(quality)
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
	finalitem = /obj/item/mining_scanner/prospector

/obj/item/smithing/prospectingpickhead/startfinish()
	var/obj/item/mining_scanner/prospector/finalforreal = new /obj/item/mining_scanner/prospector(src)
	finalforreal.range = 2 + quality
	if(quality)
		finalforreal.cooldown = 100/quality
	finalitem = finalforreal
	..()


/obj/item/smithing/shortswordblade
	name = "smithed shortsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword

/obj/item/smithing/shortswordblade/startfinish()
	finalitem = new /obj/item/melee/smith/shortsword(src)
	finalitem.force += quality
	..()

/obj/item/smithing/knifeblade
	name = "smithed knife blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/kitchen/knife

/obj/item/smithing/knifehead/startfinish()
	finalitem = new /obj/item/kitchen/knife(src)
	finalitem.force += quality/2
	..()

/obj/item/smithing/broadblade
	name = "smithed broadsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/twohand/broadsword

/obj/item/smithing/broadblade/startfinish()
	var/obj/item/melee/smith/twohand/broadsword/finalforreal = new /obj/item/melee/smith/twohand/broadsword(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalitem = finalforreal
	..()

/obj/item/smithing/halberdhead
	name = "smithed halberd head"
	finalitem = /obj/item/melee/smith/twohand/halberd

/obj/item/smithing/halberdhead/startfinish()
	var/obj/item/melee/smith/twohand/halberd/finalforreal = new /obj/item/melee/smith/twohand/halberd(src)
	finalforreal.force += quality
	finalforreal.wield_force = finalforreal.force*finalforreal.wielded_mult
	finalitem = finalforreal
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
