/* Backpacks
 * Contains:
 *		Backpack
 *		Backpack Types
 *		Satchel Types
 */

/*
 * Backpack
 */

/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "backpack"
	item_state = "backpack"
	w_class = 4
	slot_flags = SLOT_BACK	//ERROOOOO
	max_w_class = 3
	max_combined_w_class = 21
	storage_slots = 21
	burn_state = FLAMMABLE
	burntime = 20

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W, mob/user, params)
	playsound(src.loc, "rustle", 50, 1, -5)
	return ..()

/*
 * Backpack Types
 */

/obj/item/weapon/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = "bluespace=5;materials=4;engineering=4;plasmatech=5"
	icon_state = "holdingpack"
	max_w_class = 6
	max_combined_w_class = 35
	burn_state = FIRE_PROOF
	var/pshoom = 'sound/items/PSHOOM.ogg'
	var/alt_sound = 'sound/items/PSHOOM_2.ogg'

/obj/item/weapon/storage/backpack/holding/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is jumping into [src]! It looks like \he's trying to commit suicide.</span>")
	user.drop_item()
	user.Stun(5)
	sleep(20)
	playsound(src, "rustle", 50, 1, -5)
	qdel(user)
	return

/obj/item/weapon/storage/backpack/holding/content_can_dump(atom/dest_object, mob/user)
	if(Adjacent(user))
		if(get_dist(user, dest_object) < 8)
			if(dest_object.storage_contents_dump_act(src, user))
				if(alt_sound && prob(1))
					playsound(src, alt_sound, 40, 1)
				else
					playsound(src, pshoom, 40, 1)
				user.Beam(dest_object,icon_state="rped_upgrade",icon='icons/effects/effects.dmi',time=5)
				return 1
		user << "The [src.name] buzzes."
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
	return 0

/obj/item/weapon/storage/backpack/holding/handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
	if((istype(W, /obj/item/weapon/storage/backpack/holding) || count_by_type(W.GetAllContents(), /obj/item/weapon/storage/backpack/holding)))
		var/safety = alert(user, "Doing this will have extremely dire consequences for the station and its crew. Be sure you know what you're doing.", "Put in [name]?", "Proceed", "Abort")
		if(safety == "Abort" || !in_range(src, user) || !src || !W || user.incapacitated())
			return
		investigate_log("has become a singularity. Caused by [user.key]","singulo")
		user << "<span class='danger'>The Bluespace interfaces of the two devices catastrophically malfunction!</span>"
		qdel(W)
		var/obj/singularity/singulo = new /obj/singularity (get_turf(src))
		singulo.energy = 300 //should make it a bit bigger~
		message_admins("[key_name_admin(user)] detonated a bag of holding")
		log_game("[key_name(user)] detonated a bag of holding")
		qdel(src)
		singulo.process()
		return
	. = ..()

/obj/item/weapon/storage/backpack/holding/singularity_act(current_size)
	var/dist = max((current_size - 2),1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return


/obj/item/weapon/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 60

/obj/item/weapon/storage/backpack/santabag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] places the [src.name] over their head and pulls it tight! It looks like they aren't in the Christmas spirit...</span>")
	return (OXYLOSS)

/obj/item/weapon/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"
	item_state = "backpack"

/obj/item/weapon/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state = "clownpack"

/obj/item/weapon/storage/backpack/explorer
	name = "explorer bag"
	desc = "A robust backpack for stashing your loot."
	icon_state = "explorerpack"
	item_state = "explorerpack"

/obj/item/weapon/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "A silent backpack made for those silent workers. Silence Co."
	icon_state = "mimepack"
	item_state = "mimepack"

/obj/item/weapon/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for Nanotrasen officers."
	icon_state = "captainpack"
	item_state = "captainpack"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state = "engiepack"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/botany
	name = "botany backpack"
	desc = "It's a backpack made of all-natural fibers."
	icon_state = "botpack"
	item_state = "botpack"

/obj/item/weapon/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "A backpack specially designed to repel stains and hazardous liquids."
	icon_state = "chempack"
	item_state = "chempack"

/obj/item/weapon/storage/backpack/genetics
	name = "genetics backpack"
	desc = "A bag designed to be super tough, just in case someone hulks out on you."
	icon_state = "genepack"
	item_state = "genepack"

/obj/item/weapon/storage/backpack/science
	name = "science backpack"
	desc = "A specially designed backpack. It's fire resistant and smells vaguely of plasma."
	icon_state = "toxpack"
	item_state = "toxpack"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/virology
	name = "virology backpack"
	desc = "A backpack made of hypo-allergenic fibers. It's designed to help prevent the spread of disease. Smells like monkey."
	icon_state = "viropack"
	item_state = "viropack"


/*
 * Satchel Types
 */

/obj/item/weapon/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/satchel/withwallet/New()
	..()
	new /obj/item/weapon/storage/wallet/random( src )

/obj/item/weapon/storage/backpack/satchel_norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/weapon/storage/backpack/satchel_eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state = "engiepack"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/satchel_med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/satchel_vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"
	item_state = "satchel-vir"

/obj/item/weapon/storage/backpack/satchel_chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"
	item_state = "satchel-chem"

/obj/item/weapon/storage/backpack/satchel_gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"
	item_state = "satchel-gen"

/obj/item/weapon/storage/backpack/satchel_tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"
	item_state = "satchel-tox"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/satchel_hyd
	name = "botanist satchel"
	desc = "A satchel made of all natural fibers."
	icon_state = "satchel-hyd"
	item_state = "satchel-hyd"

/obj/item/weapon/storage/backpack/satchel_sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/satchel_explorer
	name = "explorer satchel"
	desc = "A robust satchel for stashing your loot."
	icon_state = "satchel-explorer"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/satchel_cap
	name = "captain's satchel"
	desc = "An exclusive satchel for Nanotrasen officers."
	icon_state = "satchel-cap"
	item_state = "captainpack"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/satchel_flat
	name = "smuggler's satchel"
	desc = "A very slim satchel that can easily fit into tight spaces."
	icon_state = "satchel-flat"
	w_class = 3 //Can fit in backpacks itself.
	max_combined_w_class = 15
	level = 1
	cant_hold = list(/obj/item/weapon/storage/backpack/satchel_flat) //muh recursive backpacks

/obj/item/weapon/storage/backpack/satchel_flat/hide(var/intact)
	if(intact)
		invisibility = INVISIBILITY_MAXIMUM
		anchored = 1 //otherwise you can start pulling, cover it, and drag around an invisible backpack.
		icon_state = "[initial(icon_state)]2"
	else
		invisibility = initial(invisibility)
		anchored = 0
		icon_state = initial(icon_state)

/obj/item/weapon/storage/backpack/satchel_flat/New()
	..()
	PoolOrNew(/obj/item/stack/tile/plasteel, src)
	new /obj/item/weapon/crowbar(src)

/obj/item/weapon/storage/backpack/dufflebag
	name = "dufflebag"
	desc = "A large dufflebag for holding extra things."
	icon_state = "duffle"
	item_state = "duffle"
	slowdown = 1
	max_combined_w_class = 30

/obj/item/weapon/storage/backpack/dufflebag/captain
	name = "captain's dufflebag"
	desc = "A large dufflebag for holding extra captainly goods."
	icon_state = "duffle-captain"
	item_state = "duffle-captain"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/dufflebag/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra medical supplies."
	icon_state = "duffle-med"
	item_state = "duffle-med"

/obj/item/weapon/storage/backpack/dufflebag/sec
	name = "security dufflebag"
	desc = "A large dufflebag for holding extra security supplies and ammunition."
	icon_state = "duffle-sec"
	item_state = "duffle-sec"

/obj/item/weapon/storage/backpack/dufflebag/engineering
	name = "industrial dufflebag"
	desc = "A large dufflebag for holding extra tools and supplies."
	icon_state = "duffle-eng"
	item_state = "duffle-eng"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/dufflebag/drone
	name = "drone dufflebag"
	desc = "A large dufflebag for holding tools and hats."
	icon_state = "duffle-drone"
	item_state = "duffle-drone"
	burn_state = FIRE_PROOF

/obj/item/weapon/storage/backpack/dufflebag/drone/New()
	..()

	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/stack/cable_coil/random(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/multitool(src)

/obj/item/weapon/storage/backpack/dufflebag/clown
	name = "clown's dufflebag"
	desc = "A large dufflebag for holding lots of funny gags!"
	icon_state = "duffle-clown"
	item_state = "duffle-clown"

/obj/item/weapon/storage/backpack/dufflebag/clown/cream_pie/New()
	. = ..()
	for(var/i in 1 to 10)
		new /obj/item/weapon/reagent_containers/food/snacks/pie/cream(src)

/obj/item/weapon/storage/backpack/dufflebag/syndie
	name = "suspicious looking dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies."
	icon_state = "duffle-syndie"
	item_state = "duffle-syndiemed"
	origin_tech = "syndicate=1"
	silent = 1
	slowdown = 0

/obj/item/weapon/storage/backpack/dufflebag/syndie/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra tactical medical supplies."
	icon_state = "duffle-syndiemed"
	item_state = "duffle-syndiemed"

/obj/item/weapon/storage/backpack/dufflebag/syndie/surgery
	name = "surgery dufflebag"
	desc = "A suspicious looking dufflebag for holding surgery tools."
	icon_state = "duffle-syndiemed"
	item_state = "duffle-syndiemed"

/obj/item/weapon/storage/backpack/dufflebag/syndie/surgery/New()
	..()
	contents = list()
	new /obj/item/weapon/scalpel(src)
	new /obj/item/weapon/hemostat(src)
	new /obj/item/weapon/retractor(src)
	new /obj/item/weapon/circular_saw(src)
	new /obj/item/weapon/surgicaldrill(src)
	new /obj/item/weapon/cautery(src)
	new /obj/item/weapon/surgical_drapes(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/device/mmi/syndie(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo
	name = "ammunition dufflebag"
	desc = "A large dufflebag for holding extra weapons ammunition and supplies."
	icon_state = "duffle-syndieammo"
	item_state = "duffle-syndieammo"

/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/shotgun
	desc = "A large dufflebag, packed to the brim with Bulldog shotgun ammo."

/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/shotgun/New()
	..()
	contents = list()
	for(var/i in 1 to 6)
		new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g/buckshot(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/dragon(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/smg
	desc = "A large dufflebag, packed to the brim with C20r magazines."

/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo/smg/New()
	..()
	contents = list()
	for(var/i in 1 to 9)
		new /obj/item/ammo_box/magazine/smgm45(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/c20rbundle
	desc = "A large dufflebag containing a C20r, some magazines, and a cheap looking suppressor."

/obj/item/weapon/storage/backpack/dufflebag/syndie/c20rbundle/New()
	..()
	contents = list()
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/weapon/gun/projectile/automatic/c20r(src)
	new /obj/item/weapon/suppressor/specialoffer(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/bulldogbundle
	desc = "A large dufflebag containing a Bulldog, several drums, and a collapsed hardsuit."

/obj/item/weapon/storage/backpack/dufflebag/syndie/bulldogbundle/New()
	..()
	contents = list()
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/weapon/gun/projectile/automatic/shotgun/bulldog(src)
	new /obj/item/ammo_box/magazine/m12g/buckshot(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/med/medicalbundle
	desc = "A large dufflebag containing a medical equipment, a Donksoft machine gun, a big jumbo box of darts, and a knock-off pair of magboots."

/obj/item/weapon/storage/backpack/dufflebag/syndie/med/medicalbundle/New()
	..()
	contents = list()
	new /obj/item/clothing/shoes/magboots/syndie(src)
	new /obj/item/weapon/storage/firstaid/tactical(src)
	new /obj/item/weapon/gun/projectile/automatic/l6_saw/toy(src)
	new /obj/item/ammo_box/foambox/riot(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/med/medicalbundle
	desc = "A large dufflebag containing a medical equipment, a Donksoft machine gun, a big jumbo box of darts, and a knock-off pair of magboots."

/obj/item/weapon/storage/backpack/dufflebag/syndie/med/medicalbundle/New()
	..()
	contents = list()
	new /obj/item/clothing/shoes/magboots/syndie(src)
	new /obj/item/weapon/storage/firstaid/tactical(src)
	new /obj/item/weapon/gun/projectile/automatic/l6_saw/toy(src)
	new /obj/item/ammo_box/foambox/riot(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/med/bioterrorbundle
	desc = "A large dufflebag containing a deadly chemicals, a chemical spray, chemical grenade, a Donksoft assault rifle, riot grade darts, a minature syringe gun, and a box of syringes"

/obj/item/weapon/storage/backpack/dufflebag/syndie/med/bioterrorbundle/New()
	..()
	contents = list()
	new /obj/item/weapon/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/weapon/storage/box/syndie_kit/chemical(src)
	new /obj/item/weapon/gun/syringe/syndicate(src)
	new /obj/item/weapon/gun/projectile/automatic/c20r/toy(src)
	new /obj/item/weapon/storage/box/syringes(src)
	new /obj/item/ammo_box/foambox/riot(src)
	new /obj/item/weapon/grenade/chem_grenade/bioterrorfoam(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/c4/New()
	..()
	contents = list()
	for(var/i in 1 to 10)
		new /obj/item/weapon/grenade/plastic/c4(src)
	return

/obj/item/weapon/storage/backpack/dufflebag/syndie/x4/New()
	..()
	contents = list()
	for(var/i in 1 to 3)
		new /obj/item/weapon/grenade/plastic/x4(src)

/obj/item/weapon/storage/backpack/dufflebag/syndie/firestarter
	desc = "A large dufflebag containing New Russian pyro backpack sprayer, a pistol, a pipebomb, fireproof hardsuit, ammo, and other equipment."

/obj/item/weapon/storage/backpack/dufflebag/syndie/firestarter/New()
	..()
	new /obj/item/clothing/under/syndicate/soviet(src)
	new /obj/item/weapon/watertank/operator(src)
	new /obj/item/clothing/suit/space/hardsuit/syndi/elite(src)
	new /obj/item/weapon/gun/projectile/automatic/pistol/APS(src)
	new /obj/item/ammo_box/magazine/pistolm9mm(src)
	new /obj/item/ammo_box/magazine/pistolm9mm(src)
	new /obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/badminka(src)
	new /obj/item/weapon/reagent_containers/syringe/stimulants(src)
	new /obj/item/weapon/grenade/syndieminibomb(src)
