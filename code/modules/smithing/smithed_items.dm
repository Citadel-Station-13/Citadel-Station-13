/obj/item/smithing
	name = "base class /obj/item/smithing"
	desc = "A [src]."
	var/quality = 0 //quality. Changed by the smithing process.
	var/obj/item/finishingitem = /obj/item/stick //What this item needs to be hit by to create finalitem
	var/obj/item/finalitem = /obj/item

/obj/item/smithing/axehead
	name = "smithed axe head"
	finalitem = /obj/item/hatchet/smithed

/obj/item/smithing/hammerhead
	name = "smithed hammer head"
	finalitem = /obj/item/melee/hammer

/obj/item/smithing/scytheblade
	name = "smithed scythe head"
	finalitem = /obj/item/scythe/smithed

/obj/item/smithing/shovelhead
	name = "smithed shovel head"
	finalitem = /obj/item/shovel/smithed

/obj/item/smithing/cogheadclubhead
	name = "smithed coghead club head"
	finalitem = /obj/item/melee/cleric_mace/cogheadclub

/obj/item/smithing/javelinhead
	name = "smithed javelin head"
	finalitem = /obj/item/spear/javelin

/obj/item/smithing/pickaxehead
	name = "smithed pickaxe head"
	finalitem = /obj/item/pickaxe/smithed

/obj/item/smithing/prospectingpickhead
	name = "smithed prospector's pickaxe head"
	finalitem = /obj/item/mining_scanner/prospector

/obj/item/smithing/shortswordblade
	name = "smithed shortsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/shortsword

/obj/item/smithing/knifeblade
	name = "smithed knife blade"
	finishingitem = /obj/item/swordhandle
	finalitem =

/obj/item/smithing/broadblade
	name = "smithed broadsword blade"
	finishingitem = /obj/item/swordhandle
	finalitem = /obj/item/melee/smith/broadsword

/obj/item/smithing/halberdhead
	name = "smithed halberd head"
	finalitem = /obj/item/spear/halberd
