/datum/export/stack
	unit_name = "sheet"
	k_elasticity = 0

/datum/export/stack/get_amount(obj/O)
	var/obj/item/stack/S = O
	if(istype(S))
		return S.amount
	return FALSE

// Hides

/datum/export/stack/leather
	cost = 30
	unit_name = "leather"
	export_types = list(/obj/item/stack/sheet/leather)

/datum/export/stack/skin/monkey
	cost = 30
	unit_name = "monkey hide"
	export_types = list(/obj/item/stack/sheet/animalhide/monkey)

/datum/export/stack/skin/human
	cost = 70
	export_category = EXPORT_CONTRABAND
	unit_name = "piece"
	message = "of human skin"
	export_types = list(/obj/item/stack/sheet/animalhide/human)

/datum/export/stack/skin/goliath_hide
	cost = 160
	unit_name = "goliath hide"
	export_types = list(/obj/item/stack/sheet/animalhide/goliath_hide)

/datum/export/stack/skin/cat
	cost = 120
	export_category = EXPORT_CONTRABAND
	unit_name = "cat hide"
	export_types = list(/obj/item/stack/sheet/animalhide/cat)

/datum/export/stack/skin/corgi
	cost = 140
	export_category = EXPORT_CONTRABAND
	unit_name = "corgi hide"
	export_types = list(/obj/item/stack/sheet/animalhide/corgi)

/datum/export/stack/skin/lizard
	cost = 50
	unit_name = "lizard hide"
	export_types = list(/obj/item/stack/sheet/animalhide/lizard)

/datum/export/stack/skin/gondola
	cost = 1000
	unit_name = "gondola hide"
	export_types = list(/obj/item/stack/sheet/animalhide/gondola)

/datum/export/stack/skin/xeno
	cost = 300
	unit_name = "alien hide"
	export_types = list(/obj/item/stack/sheet/animalhide/xeno)

/datum/export/stack/licenseplate
	cost = 25
	unit_name = "license plate"
	export_types = list(/obj/item/stack/license_plates/filled)

// Common materials.
// For base materials, see materials.dm

/datum/export/stack/plasteel
	cost = 105 // 2000u of plasma + 2000u of metal.
	message = "of plasteel"
	export_types = list(/obj/item/stack/sheet/plasteel)

/datum/export/material/plastitanium
	cost = 165 // plasma + titanium costs
	export_types = list(/obj/item/stack/sheet/mineral/plastitanium)
	message = "of plastitanium"

/datum/export/material/plastitanium_glass
	cost = 168 // plasma + titanium + glass costs
	export_types = list(/obj/item/stack/sheet/plastitaniumglass)
	message = "of plastitanium glass"

// 1 glass + 0.5 metal, cost is rounded up.
/datum/export/stack/rglass
	cost = 6
	message = "of reinforced glass"
	export_types = list(/obj/item/stack/sheet/rglass)

/datum/export/stack/plastitanium
	cost = 165 // plasma + titanium costs
	message = "of plastitanium"
	export_types = list(/obj/item/stack/sheet/mineral/plastitanium)

/datum/export/stack/wood
	cost = 15
	unit_name = "wood plank"
	export_types = list(/obj/item/stack/sheet/mineral/wood)

/datum/export/stack/log
	cost = 10
	unit_name = "raw wood"
	export_types = list(/obj/item/grown/log)

/datum/export/stack/cardboard
	cost = 2
	message = "of cardboard"
	export_types = list(/obj/item/stack/sheet/cardboard)

/datum/export/stack/sandstone
	cost = 1
	unit_name = "block"
	message = "of sandstone"
	export_types = list(/obj/item/stack/sheet/mineral/sandstone)

/datum/export/stack/cable
	cost = 0.2
	unit_name = "cable piece"
	export_types = list(/obj/item/stack/cable_coil)

/datum/export/stack/cloth
	cost = 20
	unit_name = "sheets"
	message = "of cloth"
	export_types = list(/obj/item/stack/sheet/cloth)

/datum/export/stack/duracloth
	cost = 40
	unit_name = "sheets"
	message = "of duracloth"
	export_types = list(/obj/item/stack/sheet/durathread)

// Weird Stuff

/datum/export/stack/abductor
	cost = 400
	message = "of alien alloy"
	export_types = list(/obj/item/stack/sheet/mineral/abductor)

/datum/export/stack/bone
	cost = 20
	message = "of bones"
	export_types = list(/obj/item/stack/sheet/bone)

/datum/export/stack/sheet/bronze
	unit_name = "tiles"
	cost = 5
	message = "of brozne"
	export_types = list(/obj/item/stack/sheet/bronze)

/datum/export/stack/brass
	unit_name = "tiles"
	cost = 50
	message = "of brass"
	export_types = list(/obj/item/stack/tile/brass)

/datum/export/stack/paper
	unit_name = "sheets"
	cost = 30
	message = "of paperframes"
	export_types = list(/obj/item/stack/sheet/paperframes)

/datum/export/stack/telecrystal
	unit_name = "raw"
	cost = 1000
	message = "telecrystals"
	export_types = list(/obj/item/stack/telecrystal)

