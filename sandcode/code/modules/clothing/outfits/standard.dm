/obj/item/radio/headset/headset_cent/commander/alt/generic
	name = "\improper bowman headset"
	desc = "A headset for emergency response personnel. Protects ears from flashbangs."
	icon_state = "cent_headset_alt"
	item_state = "cent_headset_alt"
	bowman = TRUE
	
/obj/item/gun/energy/taser/debug
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/debug)
	
/obj/item/ammo_casing/energy/electrode/debug
	e_cost = 1

/obj/item/clothing/suit/armor/vest/darkcarapace/debug
	name = "Bluespace Tech"
	desc = "A sleek piece of armour designed for Bluespace agents."
	icon = 'icons/obj/custom.dmi'
	mob_overlay_icon = 'icons/mob/clothing/custom_w.dmi'
	icon_state = "darkcarapace"
	item_state = "darkcarapace"
	blood_overlay_type = "armor"
	armor = list("melee" = 95, "bullet" = 95, "laser" = 95, "energy" = 95, "bomb" = 95, "bio" = 95, "rad" = 100, "fire" = 98, "acid" = 98) // Skyrat edit

/obj/item/clothing/suit/space/hardsuit/ert/alert/debug
	name = "Bluespace Tech hardsuit"
	desc = "A specialised hardsuit for Bluespace agents."
	armor = list("melee" = 98, "bullet" = 98, "laser" = 98, "energy" = 98, "bomb" = 98, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100) // Skyrat edit

/obj/item/clothing/shoes/combat/debug
	clothing_flags = NOSLIP

/obj/item/storage/belt/utility/chief/full/debug
	name = "\improper Bluespace Tech's belt"

/datum/outfit/debug/bst //Debug objs
	name = "Bluespace Tech"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/vest/darkcarapace/debug
	glasses = null
	ears = /obj/item/radio/headset/headset_cent/commander/alt/generic
	mask = null
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	belt = /obj/item/storage/belt/utility/chief/full/debug
	shoes = /obj/item/clothing/shoes/combat/debug
	id = /obj/item/card/id/debug/bst
	back = /obj/item/storage/backpack/holding
	box = /obj/item/storage/box/debugtools
	suit_store = /obj/item/gun/energy/pulse
	backpack_contents = list(
		/obj/item/melee/transforming/energy/axe=1,\
		/obj/item/storage/part_replacer/bluespace/tier4=1,\
		/obj/item/debug/human_spawner=1,\
		/obj/item/gun/energy/taser/debug=1,\
		/obj/item/clothing/glasses/debug,\
		/obj/item/clothing/mask/gas/welding/up,\
		/obj/item/tank/internals/oxygen,\
		)

/datum/outfit/debug/bsthardsuit //Debug objs plus hardsuit
	name = "Bluespace Tech (Hardsuit)"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/space/hardsuit/ert/alert/debug
	glasses = /obj/item/clothing/glasses/debug
	ears = /obj/item/radio/headset/headset_cent/commander/alt/generic
	mask = /obj/item/clothing/mask/gas/welding/up
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	belt = /obj/item/storage/belt/utility/chief/full/debug
	shoes = /obj/item/clothing/shoes/combat/debug
	id = /obj/item/card/id/debug/bst
	back = /obj/item/storage/backpack/holding
	box = /obj/item/storage/box/debugtools
	suit_store = /obj/item/tank/internals/oxygen
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = list(
		/obj/item/melee/transforming/energy/axe=1,\
		/obj/item/storage/part_replacer/bluespace/tier4=1,\
		/obj/item/debug/human_spawner=1,\
		/obj/item/gun/energy/pulse=1,\
		/obj/item/gun/energy/taser/debug,\
		)

/datum/outfit/chrono_agent
	name = "Timeline Eradication Agent"
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	suit = /obj/item/clothing/suit/space/chronos
	back = /obj/item/chrono_eraser
	head = /obj/item/clothing/head/helmet/space/chronos
	mask = /obj/item/clothing/mask/breath
	belt = /obj/item/storage/belt/military/abductor/full
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	glasses = /obj/item/clothing/glasses/night
	shoes = /obj/item/clothing/shoes/combat
	id = /obj/item/card/id
	suit_store = /obj/item/tank/internals/oxygen
	ears = /obj/item/radio/headset/headset_cent/alt

/datum/outfit/chrono_agent/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	var/obj/item/card/id/W = H.wear_id
	W.icon_state = "centcom"
	W.access = get_all_accesses()//They get full station access.
	W.access += get_centcom_access("TED Agent")//Let's add their alloted CentCom access.
	W.assignment = "Timeline Eradication Agent"
	W.registered_name = H.real_name
	W.update_label(W.registered_name, W.assignment)
