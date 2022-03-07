/datum/ghostrole/cybersun
	abstract_type = /datum/ghostrole/cybersun
	assigned_role = "Space Syndicate"

/datum/ghostrole/cybersun/ship
	name = "Cybersun Ship Operative"
	name = "Syndicate Battlecruiser Ship Operative"
	desc = "You are a crewmember aboard the syndicate flagship: the SBC Starfury."
	spawntext = "Your job is to follow your captain's orders, maintain the ship, and keep the engine running. If you are not familiar with how the supermatter engine functions: do not attempt to start it. \
	<br>Furthermore, the armory is not a candy store, and your role is not to assault the station directly, leave that work to the assault operatives."
	instantiator = /datum/ghostrole_instantiator/human/random/cybersun/ship

/datum/ghostrole/cybersun/assault
	name = "Cybersun Assault Operative"
	desc = "You are an assault operative aboard the syndicate flagship: the SBC Starfury."
	spawntext = "Your job is to follow your captain's orders, keep intruders out of the ship, and assault Space Station 13. There is an armory, multiple assault ships, and beam cannons to attack the station with. \
	<br>Work as a team with your fellow operatives and work out a plan of attack. If you are overwhelmed, escape back to your ship!"
	instantiator = /datum/ghostrole_instantiator/human/random/cybersun/assault

/datum/ghostrole/cybersun/captain
	name = "Cybersun Ship Captain"
	desc = "You are the captain aboard the syndicate flagship: the SBC Starfury."
	spawntext = "Your job is to oversee your crew, defend the ship, and destroy Space Station 13. The ship has an armory, multiple ships, beam cannons, and multiple crewmembers to accomplish this goal. \
		<br>As the captain, this whole operation falls on your shoulders. You do not need to nuke the station, causing sufficient damage and preventing your ship from being destroyed will be enough."
	instantiator = /datum/ghostrole_instantiator/human/random/cybersun/captain

/datum/ghostrole_instantiator/human/random/cybersun

/datum/ghostrole_instantiator/human/random/cybersun/Create(client/C, atom/location)
	. = ..()
	if(!.)
		return
	var/mob/M = .
	M.faction |= ROLE_SYNDICATE

/datum/ghostrole_instantiator/human/random/cybersun/ship
	equip_outfit = /datum/outfit/syndicate_empty/SBC

/datum/ghostrole_instantiator/human/random/cybersun/assault
	equip_outfit = /datum/outfit/syndicate_empty/SBC/assault

/datum/ghostrole_instantiator/human/random/cybersun/captain
	equip_outfit = /datum/outfit/syndicate_empty/SBC/assault/captain

/obj/structure/ghost_role_spawner/syndicate
	name = "Syndicate Operative"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	qdel_on_deplete = TRUE
	role_type = null

/obj/structure/ghost_role_spawner/syndicate/battlecruiser
	role_type = /datum/ghostrole/cybersun/ship

/obj/structure/ghost_role_spawner/syndicate/battlecruiser/assault
	role_type = /datum/ghostrole/cybersun/assault

/obj/structure/ghost_role_spawner/syndicate/battlecruiser/captain
	role_type = /datum/ghostrole/cybersun/captain

/datum/outfit/syndicate_empty
	name = "Syndicate Operative Empty"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/syndicate/alt
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/weapons_auth)
	id = /obj/item/card/id/syndicate

/datum/outfit/syndicate_empty/SBC
	name = "Syndicate Battlecruiser Ship Operative"
	l_pocket = /obj/item/gun/ballistic/automatic/pistol
	r_pocket = /obj/item/kitchen/knife/combat/survival
	belt = /obj/item/storage/belt/military/assault

/datum/outfit/syndicate_empty/SBC/assault
	name = "Syndicate Battlecruiser Assault Operative"
	uniform = /obj/item/clothing/under/syndicate/combat
	l_pocket = /obj/item/ammo_box/magazine/m10mm
	r_pocket = /obj/item/kitchen/knife/combat/survival
	belt = /obj/item/storage/belt/military
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/automatic/pistol
	back = /obj/item/storage/backpack/security
	mask = /obj/item/clothing/mask/gas/syndicate

/datum/outfit/syndicate_empty/SBC/assault/captain
	name = "Syndicate Battlecruiser Captain"
	l_pocket = /obj/item/melee/transforming/energy/sword/saber/red
	r_pocket = /obj/item/melee/classic_baton/telescopic
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	suit_store = /obj/item/gun/ballistic/revolver/mateba
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/HoS/syndicate
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	access_add = list(
		ACCESS_SYNDICATE,
		ACCESS_SYNDICATE_LEADER
	)
