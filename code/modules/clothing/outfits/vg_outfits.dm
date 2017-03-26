/datum/outfit/nazi_elite
	name = "Nazi Stormtrooper"

	uniform = /obj/item/clothing/under/soldieruniform
	suit = /obj/item/clothing/suit/space/hardsuit/nazi
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	back = /obj/item/weapon/storage/backpack/security
	l_pocket = /obj/item/weapon/melee/energy/sword/saber
	suit_store = /obj/item/weapon/tank/internals/emergency_oxygen
	belt = /obj/item/weapon/gun/ballistic/revolver/mateba
	r_hand = /obj/item/weapon/gun/energy/plasma/MP40k
	id = /obj/item/weapon/card/id
	ears = /obj/item/device/radio/headset/syndicate/alt

	backpack_contents = list(/obj/item/weapon/storage/box=1,\
		/obj/item/ammo_box/a357=1,\
		/obj/item/weapon/storage/firstaid/regular=1,\
		/obj/item/weapon/storage/box/flashbangs=1,\
		/obj/item/device/flashlight=1,\
		/obj/item/weapon/grenade/plastic/x4=1)

/datum/outfit/nazi_elite/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/device/radio/R = H.ears
	R.freqlock = 1

	var/obj/item/weapon/card/id/W = H.wear_id
	W.access = get_all_accesses()
	W.registered_name = H.real_name
	W.assignment = "Nazi Stormtrooper"
	W.update_label(W.registered_name, W.assignment)


/datum/outfit/soviet_elite
	name = "Soviet Stormtrooper"

	uniform = /obj/item/clothing/under/soviet
	suit = /obj/item/clothing/suit/space/hardsuit/soviet
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	glasses = /obj/item/clothing/glasses/hud/toggle/thermal
	back = /obj/item/weapon/storage/backpack/security
	l_pocket = /obj/item/weapon/melee/energy/sword/saber
	suit_store = /obj/item/weapon/tank/internals/emergency_oxygen
	belt = /obj/item/weapon/gun/ballistic/revolver/mateba
	r_hand = /obj/item/weapon/gun/energy/laser/LaserAK
	id = /obj/item/weapon/card/id
	ears = /obj/item/device/radio/headset/syndicate/alt

	backpack_contents = list(/obj/item/weapon/storage/box=1,\
		/obj/item/ammo_box/a357=1,\
		/obj/item/weapon/storage/firstaid/regular=1,\
		/obj/item/weapon/storage/box/flashbangs=1,\
		/obj/item/device/flashlight=1,\
		/obj/item/weapon/grenade/plastic/x4=1)

/datum/outfit/soviet_elite/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/device/radio/R = H.ears
	R.freqlock = 1

	var/obj/item/weapon/card/id/W = H.wear_id
	W.access = get_all_accesses()
	W.registered_name = H.real_name
	W.assignment = "Soviet Stormtrooper"
	W.update_label(W.registered_name, W.assignment)

