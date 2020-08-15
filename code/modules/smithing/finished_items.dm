/obj/item/melee/smith
	name = "base class obj/item/melee/smith" //tin. handles overlay and quality and shit.
	icon = 'icons/obj/smith.dmi'
	icon_state = "mace_greyscale"
	item_state = "mace_greyscale"
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	var/quality
	var/overlay_state = "stick"
	var/mutable_appearance/overlay


/obj/item/melee/smith/Initialize()
	desc = "A handmade [name]."
	. = ..()
	overlay = mutable_appearance(icon, overlay_state)
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)




///////////////////////////
//        Mining         //
///////////////////////////
/obj/item/mining_scanner/prospector
	name = "prospector's pickaxe"
	desc = "A pickaxe that can sound rocks to find mineral deposits and stop gibtonite detonations."
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe" //todo:sprite

/obj/item/pickaxe/smithed
	name = "pickaxe"
	desc = "A pickaxe that can sound rocks to find mineral deposits and stop gibtonite detonations."
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"

/obj/item/shovel/smithed
	name = "prospector's pickaxe"
	desc = "A pickaxe that can sound rocks to find mineral deposits and stop gibtonite detonations."
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"





///////////////////////////
//        Spears         //
///////////////////////////


/obj/item/melee/smith/halberd


/obj/item/melee/smith/javelin





//////////////////////////
//      Other Melee     //
///////////////////////////

/obj/item/melee/smith/axe

/obj/item/melee/smith/hammer//blacksmithing, not warhammer.
	var/qualitymod = 0

/obj/item/scythe/smithed //we need to inherit scythecode

/obj/item/melee/smith/cogheadclub

/obj/item/melee/smith/shortsword

/obj/item/melee/smith/shortsword
