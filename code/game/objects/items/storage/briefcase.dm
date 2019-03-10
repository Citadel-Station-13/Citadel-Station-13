/obj/item/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 8
	hitsound = "swing_hit"
	throw_speed = 2
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	resistance_flags = FLAMMABLE
	max_integrity = 150
	var/folder_path = /obj/item/folder //this is the path of the folder that gets spawned in New()

/obj/item/storage/briefcase/ComponentInitialize()
	. = ..()
	GET_COMPONENT(STR, /datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 21

/obj/item/storage/briefcase/PopulateContents()
	new /obj/item/pen(src)
	var/obj/item/folder/folder = new folder_path(src)
	for(var/i in 1 to 6)
		new /obj/item/paper(folder)

/obj/item/storage/briefcase/lawyer
	folder_path = /obj/item/folder/blue

/obj/item/storage/briefcase/lawyer/family 
	name = "battered  briefcase"
	desc = "An old briefcase, this one has seen better days in its time. It's clear they don't make them nowadays as good as they used to. The corners are modified with metal trim adding in weight!"

/obj/item/storage/briefcase/lawyer/family/PopulateContents()
	new /obj/item/stamp/law(src)
	new /obj/item/pen/fountain(src)
	new /obj/item/paper_bin(src)
	new /obj/item/storage/box/evidence(src)
	new /obj/item/storage/box/lawyer(src)

/obj/item/storage/box/lawyer
	name = "Box of lawyer tools"
	desc = "A custom made box, full of items used by a Lawyer, all packed into one box!"

/obj/item/storage/box/lawyer/PopulateContents()
		new /obj/item/clothing/gloves/color/white(src)
		new /obj/item/folder/white(src)
		new /obj/item/clothing/glasses/regular(src)
		new /obj/item/folder/red(src)
		new /obj/item/gavelhammer(src)
		new /obj/item/stack/sheet/cloth(src)
		new /obj/item/reagent_containers/glass/beaker/waterbottle(src)

/obj/item/storage/briefcase/lawyer/PopulateContents()
	new /obj/item/stamp/law(src)
	..()

/obj/item/storage/briefcase/sniperbundle
	desc = "It's label reads genuine hardened Captain leather, but suspiciously has no other tags or branding. Smells like L'Air du Temps."
	force = 10

/obj/item/storage/briefcase/sniperbundle/PopulateContents()
	..() // in case you need any paperwork done after your rampage
	new /obj/item/gun/ballistic/automatic/sniper_rifle/syndicate(src)
	new /obj/item/clothing/neck/tie/red(src)
	new /obj/item/clothing/under/syndicate/sniper(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/soporific(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/soporific(src)
	new /obj/item/suppressor/specialoffer(src)

