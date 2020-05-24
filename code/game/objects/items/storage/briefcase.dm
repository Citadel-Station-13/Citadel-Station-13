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
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 21

/obj/item/storage/briefcase/PopulateContents()
	new /obj/item/pen(src)
	var/obj/item/folder/folder = new folder_path(src)
	for(var/i in 1 to 6)
		new /obj/item/paper(folder)

/obj/item/storage/briefcase/crafted
	desc = "Hand crafted suitcase made of leather and cloth."
	force = 6
	max_integrity = 50

/obj/item/storage/briefcase/crafted/PopulateContents()
	return //So we dont spawn items

/obj/item/storage/briefcase/lawyer
	folder_path = /obj/item/folder/blue

/obj/item/storage/briefcase/lawyer/family
	name = "battered  briefcase"
	icon_state = "gbriefcase"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	desc = "An old briefcase with a golden trim. It's clear they don't make them as good as they used to. Comes with an added belt clip!"
	slot_flags = ITEM_SLOT_BELT

/obj/item/storage/briefcase/lawyer/family/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 14

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
	desc = "Its label reads \"genuine hardened Captain leather\", but suspiciously has no other tags or branding. Smells like L'Air du Temps."
	force = 10
/obj/item/storage/briefcase/sniperbundle/PopulateContents()
	..() // in case you need any paperwork done after your rampage
	new /obj/item/gun/ballistic/automatic/sniper_rifle/syndicate(src)
	new /obj/item/clothing/neck/tie/red(src)
	new /obj/item/clothing/under/syndicate/sniper(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/soporific(src)
	new /obj/item/ammo_box/magazine/sniper_rounds/soporific(src)
	new /obj/item/suppressor/specialoffer(src)


/obj/item/storage/briefcase/modularbundle
	desc = "Its label reads \"genuine hardened Captain leather\", but suspiciously has no other tags or branding."
	force = 10

/obj/item/storage/briefcase/modularbundle/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/modular(src)
	new /obj/item/suppressor(src)
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/ammo_box/magazine/m10mm/soporific(src)
	new /obj/item/ammo_box/c10mm/soporific(src)
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/suit/toggle/lawyer/black/syndie(src)

/obj/item/storage/briefcase/medical
	name = "medical briefcase"
	icon_state = "medbriefcase"
	desc = "A white with a blue cross brieface, this is ment to hold medical gear that would not be able to normally fit in a bag."

/obj/item/storage/briefcase/medical/PopulateContents()
	new /obj/item/clothing/neck/stethoscope(src)
	new /obj/item/healthanalyzer(src)
	..() //In case of paperwork

