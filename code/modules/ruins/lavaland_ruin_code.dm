//If you're looking for spawners like ash walker eggs, check ghost_role_spawners.dm

/obj/structure/fans/tiny/invisible //For blocking air in ruin doorways
	invisibility = INVISIBILITY_ABSTRACT

//lavaland_surface_seed_vault.dmm
//Seed Vault

/obj/effect/spawner/lootdrop/seed_vault
	name = "seed vault seeds"
	lootcount = 1

	loot = list(/obj/item/seeds/gatfruit = 10,
				/obj/item/seeds/cherry = 15,
				/obj/item/seeds/berry/glow = 10,
				/obj/item/seeds/sunflower/moonflower = 8
				)

//Free Golems

/obj/item/weapon/disk/design_disk/golem_shell
	name = "Golem Creation Disk"
	desc = "A gift from the Liberator."
	icon_state = "datadisk1"
	max_blueprints = 1

/obj/item/weapon/disk/design_disk/golem_shell/New()
	..()
	var/datum/design/golem_shell/G = new
	blueprints[1] = G

/datum/design/golem_shell
	name = "Golem Shell Construction"
	desc = "Allows for the construction of a Golem Shell."
	id = "golem"
	req_tech = list("materials" = 12)
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 40000)
	build_path = /obj/item/golem_shell
	category = list("Imported")

/obj/item/golem_shell
	name = "incomplete golem shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "The incomplete body of a golem. Add ten sheets of any mineral to finish."
	var/shell_type = /obj/effect/mob_spawn/human/golem
	var/has_owner = FALSE //if the resulting golem obeys someone

/obj/item/golem_shell/attackby(obj/item/I, mob/user, params)
	..()
	var/species
	if(istype(I, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/O = I

		if(istype(O, /obj/item/stack/sheet/metal))
			species = /datum/species/golem

		if(istype(O, /obj/item/stack/sheet/glass))
			species = /datum/species/golem/glass

		if(istype(O, /obj/item/stack/sheet/plasteel))
			species = /datum/species/golem/plasteel

		if(istype(O, /obj/item/stack/sheet/mineral/sandstone))
			species = /datum/species/golem/sand

		if(istype(O, /obj/item/stack/sheet/mineral/plasma))
			species = /datum/species/golem/plasma

		if(istype(O, /obj/item/stack/sheet/mineral/diamond))
			species = /datum/species/golem/diamond

		if(istype(O, /obj/item/stack/sheet/mineral/gold))
			species = /datum/species/golem/gold

		if(istype(O, /obj/item/stack/sheet/mineral/silver))
			species = /datum/species/golem/silver

		if(istype(O, /obj/item/stack/sheet/mineral/uranium))
			species = /datum/species/golem/uranium

		if(istype(O, /obj/item/stack/sheet/mineral/bananium))
			species = /datum/species/golem/bananium

		if(istype(O, /obj/item/stack/sheet/mineral/titanium))
			species = /datum/species/golem/titanium

		if(istype(O, /obj/item/stack/sheet/mineral/plastitanium))
			species = /datum/species/golem/plastitanium

		if(istype(O, /obj/item/stack/sheet/mineral/abductor))
			species = /datum/species/golem/alloy

		if(istype(O, /obj/item/stack/sheet/mineral/wood))
			species = /datum/species/golem/wood

		if(istype(O, /obj/item/stack/sheet/bluespace_crystal))
			species = /datum/species/golem/bluespace

		if(species)
			if(O.use(10))
				user << "You finish up the golem shell with ten sheets of [O]."
				new shell_type(get_turf(src), species, has_owner, user)
				qdel(src)
			else
				user << "You need at least ten sheets to finish a golem."
		else
			user << "You can't build a golem out of this kind of material."

//made with xenobiology, the golem obeys its creator
/obj/item/golem_shell/artificial
	name = "incomplete artificial golem shell"
	has_owner = TRUE


///Syndicate Listening Post
/obj/effect/mob_spawn/human/lavaland_syndicate
	r_hand = /obj/item/weapon/gun/ballistic/automatic/sniper_rifle
	name = "Syndicate Bioweapon Scientist"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	radio = /obj/item/device/radio/headset/syndicate/alt
	back = /obj/item/weapon/storage/backpack
	pocket1 = /obj/item/weapon/gun/ballistic/automatic/pistol
	roundstart = FALSE
	death = FALSE
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper"
	has_id = 1
	flavour_text = "<font size=3>You are a syndicate agent, employed in a top secret research facility developing biological weapons. Unfortunatley, your hated enemy, Nanotrasen, has begun mining in this sector. <b>Continue your research as best you can, and try to keep a low profile. Do not abandon the base without good cause.</b> The base is rigged with explosives should the worst happen, do not let the base fall into enemy hands!</b>"
	id_access_list = list(access_syndicate)
	
/obj/effect/mob_spawn/human/lavaland_syndicate/comms
	name = "Syndicate Comms Agent"
	r_hand = /obj/item/weapon/melee/energy/sword/saber
	mask = /obj/item/clothing/mask/chameleon
	suit = /obj/item/clothing/suit/armor/vest
	flavour_text = "<font size=3>You are a syndicate agent, employed in a top secret research facility developing biological weapons. Unfortunatley, your hated enemy, Nanotrasen, has begun mining in this sector. <b>Monitor enemy activity as best you can, and try to keep a low profile. Do not abandon the base without good cause.</b> Use the communication equipment to provide support to any field agents, and sow disinformation to throw Nanotrasen off your trail. Do not let the base fall into enemy hands!</b>"
	pocket2 = /obj/item/weapon/card/id/syndicate/anyone
