//TODO: OBTAILABILITY, ANVIL TYPES, HAMMER TYPES, INGOTS



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


/obj/item/melee/smith/twohand/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 70) //decent in a pinch, but pretty bad.
	AddElement(/datum/element/sword_point)



///////////////////////////
//        Mining         //
///////////////////////////
/obj/item/mining_scanner/prospector
	name = "prospector's pickaxe"
	desc = "A pickaxe that can sound rocks to find mineral deposits and stop gibtonite detonations."
	icon = 'icons/obj/smith.dmi'
	icon_state = "pickaxe" //todo:sprite

/obj/item/mining_scanner/prospector/Initialize()
	..()
	var/mutable_appearance/overlay
	desc = "A handmade [name]."
	overlay = mutable_appearance(icon, "minihandle")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0

/obj/item/pickaxe/smithed
	name = "pickaxe"
	desc = "A pickaxe."
	icon = 'icons/obj/smith.dmi'
	icon_state = "pickaxe"

/obj/item/pickaxe/smithed/Initialize()
	..()
	desc = "A handmade [name]."
	var/mutable_appearance/overlay
	overlay = mutable_appearance(icon, "stick")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0

/obj/item/shovel/smithed
	name = "shovel"
	desc = "A shovel."
	icon = 'icons/obj/smith.dmi'
	icon_state = "shovel"

/obj/item/shovel/smithed/Initialize()
	..()
	desc = "A handmade [name]."
	var/mutable_appearance/overlay
	overlay = mutable_appearance(icon, "shovelhandle")
	overlay.appearance_flags = RESET_COLOR
	add_overlay(overlay)
	if(force < 0)
		force = 0


///////////////////////////
//        Spears         //
///////////////////////////


/obj/item/melee/smith/twohand/halberd
	name = "halberd"
	icon_state = "halberd"
	overlay_state = "spearhandle"

/obj/item/melee/smith/twohand/halberd/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/jousting)

/obj/item/melee/smith/twohand/javelin
	name = "javelin"
	icon_state = "javelin"
	overlay_state = "longhandle"
	wielded_mult = 1.5


/obj/item/melee/smith/twohand/javelin/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/jousting)

/obj/item/melee/smith/twohand/glaive
	name = "glaive"
	icon_state = "glaive"
	overlay_state = "longhandle"

/obj/item/melee/smith/twohand/glaive/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/jousting)
//////////////////////////
//      Other Melee     //
///////////////////////////

/obj/item/melee/smith/axe
	name = "axe"

/obj/item/melee/smith/hammer//blacksmithing, not warhammer.
	name = "hammer"
	icon_state = "hammer"
	overlay_state = "hammerhandle"
	var/qualitymod = 0

/obj/item/scythe/smithed //we need to inherit scythecode, but that's about it.
	material_flags = MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS


/obj/item/melee/smith/cogheadclub
	name = "coghead club"

/obj/item/melee/smith/shortsword
	name = "gladius"
	icon_state = "gladius"
	overlay_state = "gladiushilt"

/obj/item/melee/smith/twohand/broadsword
	name = "broadsword"
	icon_state = "broadsword"
	overlay_state = "broadhilt"
	force = 15
	wielded_mult = 1.8
