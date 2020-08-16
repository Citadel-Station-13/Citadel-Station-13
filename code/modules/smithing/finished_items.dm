/obj/item/melee/smith
	name = "base class obj/item/melee/smith" //tin. handles overlay and quality and shit.
	icon = 'icons/obj/smith.dmi'
	icon_state = "mace_greyscale"
	item_state = "mace_greyscale"
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	force = 10
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	var/quality
	var/overlay_state = "stick"
	var/mutable_appearance/overlay
	var/wielded_mult = 1
	var/wield_force = 15

/obj/item/melee/smith/Initialize()
	..()
	desc = "A handmade [name]."
	overlay = mutable_appearance(icon, overlay_state)
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0


/obj/item/melee/smith/twohand
	wielded_mult = 1.75


/obj/item/melee/smith/twohand/Initialize()
	..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.
	AddComponent(/datum/component/jousting)
	AddElement(/datum/element/sword_point)
	AddComponent(/datum/component/two_handed, force_unwielded=force, force_wielded=wield_force, icon_wielded="[icon_state]_wield")


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
	desc = "A pickaxe."
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"

/obj/item/shovel/smithed
	name = "shovel"
	desc = "A shovel."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"





///////////////////////////
//        Spears         //
///////////////////////////


/obj/item/melee/smith/twohand/halberd
	name = "halberd"

/obj/item/melee/smith/twohand/halberd/Initialize()
	..()
	throwforce = force/3


/obj/item/melee/smith/twohand/javelin
	name = "javelin"
	wielded_mult = 1.5

/obj/item/melee/smith/twohand/javelin/Initialize()
	..()
	throwforce = force*2


//////////////////////////
//      Other Melee     //
///////////////////////////

/obj/item/melee/smith/axe
	name = "axe"

/obj/item/melee/smith/hammer//blacksmithing, not warhammer.
	name = "hammer"
	var/qualitymod = 0

/obj/item/scythe/smithed //we need to inherit scythecode, but that's about it.
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS


/obj/item/melee/smith/cogheadclub
	name = "coghead club"

/obj/item/melee/smith/shortsword
	name = "shortsword"

/obj/item/melee/smith/twohand/broadsword
	name = "broadsword"
	force = 15
	wielded_mult = 1.8
