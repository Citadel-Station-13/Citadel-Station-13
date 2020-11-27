// Closets for specific jobs

/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	icon_door = "black"

/obj/structure/closet/gmcloset/PopulateContents()
	..()
	new /obj/item/clothing/head/that(src)
	new /obj/item/radio/headset/headset_srv(src)
	new /obj/item/radio/headset/headset_srv(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/under/suit/sl(src)
	new /obj/item/clothing/under/suit/sl(src)
	new /obj/item/clothing/under/rank/civilian/bartender(src)
	new /obj/item/clothing/under/rank/civilian/bartender(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/reagent_containers/rag(src)
	new /obj/item/reagent_containers/rag(src)
	new /obj/item/storage/box/beanbag(src)
	new /obj/item/clothing/suit/armor/vest/alt(src)
	new /obj/item/circuitboard/machine/dish_drive(src)
	new /obj/item/clothing/glasses/sunglasses/reagent(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/storage/belt/bandolier(src)

/obj/structure/closet/chefcloset
	name = "\proper chef's closet"
	desc = "It's a storage unit for foodservice garments and mouse traps."
	icon_door = "black"

/obj/structure/closet/chefcloset/PopulateContents()
	..()
	new /obj/item/clothing/under/suit/waiter(src)
	new /obj/item/clothing/under/suit/waiter(src)
	new /obj/item/radio/headset/headset_srv(src)
	new /obj/item/radio/headset/headset_srv(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/apron/chef(src)
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/storage/box/mousetraps(src)
	new /obj/item/storage/box/mousetraps(src)
	new /obj/item/circuitboard/machine/dish_drive(src)
	new /obj/item/clothing/suit/toggle/chef(src)
	new /obj/item/clothing/under/rank/civilian/chef(src)
	new /obj/item/clothing/head/chefhat(src)
	new /obj/item/reagent_containers/rag(src)

/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	icon_door = "mixed"

/obj/structure/closet/jcloset/PopulateContents()
	..()
	new /obj/item/clothing/under/rank/civilian/janitor(src)
	new /obj/item/cartridge/janitor(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/head/soft/purple(src)
	new /obj/item/paint/paint_remover(src)
	new /obj/item/melee/flyswatter(src)
	new /obj/item/flashlight(src)
	for(var/i in 1 to 3)
		new /obj/item/caution(src)
	new /obj/item/holosign_creator(src)
	new /obj/item/lightreplacer(src)
	new /obj/item/soap(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/watertank/janitor(src)
	new /obj/item/storage/belt/janitor(src)


/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	icon_door = "blue"

/obj/structure/closet/lawcloset/PopulateContents()
	..()
	new /obj/item/clothing/under/rank/civilian/lawyer/female(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/black(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/red(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/bluesuit(src)
	new /obj/item/clothing/suit/toggle/lawyer(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/purpsuit(src)
	new /obj/item/clothing/suit/toggle/lawyer/purple(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/black(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/accessory/lawyers_badge(src)
	new /obj/item/clothing/accessory/lawyers_badge(src)

/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for Nanotrasen-approved religious attire."
	icon_door = "black"

/obj/structure/closet/wardrobe/chaplain_black/PopulateContents()
	new /obj/item/choice_beacon/holy(src)
	new /obj/item/clothing/accessory/pocketprotector/cosmetology(src)
	new /obj/item/clothing/under/rank/civilian/chaplain(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/suit/chaplain/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/chaplain/holidaypriest(src)
	new /obj/item/storage/backpack/cultpack(src)
	new /obj/item/storage/fancy/candle_box(src)
	new /obj/item/storage/fancy/candle_box(src)
	return

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_door = "red"

/obj/structure/closet/wardrobe/red/PopulateContents()
	new /obj/item/clothing/suit/hooded/wintercoat/security(src)
	new /obj/item/storage/backpack/security(src)
	new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/storage/backpack/duffelbag/sec(src)
	new /obj/item/storage/backpack/duffelbag/sec(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/under/rank/security/officer(src)
	for(var/i in 1 to 2)
		new /obj/item/clothing/under/rank/security/officer/skirt(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/shoes/jackboots(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/beret/sec(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	return


/obj/structure/closet/wardrobe/cargotech
	name = "cargo wardrobe"
	icon_door = "orange"

/obj/structure/closet/wardrobe/cargotech/PopulateContents()
	new /obj/item/clothing/suit/hooded/wintercoat/cargo(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/under/rank/cargo/tech(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/shoes/sneakers/black(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/gloves/fingerless(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/soft(src)
	new /obj/item/radio/headset/headset_cargo(src)

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_door = "atmos_wardrobe"

/obj/structure/closet/wardrobe/atmospherics_yellow/PopulateContents()
	new /obj/item/clothing/accessory/pocketprotector(src)
	new /obj/item/storage/backpack/duffelbag/engineering(src)
	new /obj/item/storage/backpack/satchel/eng(src)
	new /obj/item/storage/backpack/industrial(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/hooded/wintercoat/engineering/atmos(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/under/rank/engineering/atmospheric_technician(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/shoes/sneakers/black(src)
	return

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/PopulateContents()
	new /obj/item/clothing/accessory/pocketprotector(src)
	new /obj/item/storage/backpack/duffelbag/engineering(src)
	new /obj/item/storage/backpack/industrial(src)
	new /obj/item/storage/backpack/satchel/eng(src)
	new /obj/item/clothing/suit/hooded/wintercoat/engineering(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/under/rank/engineering/engineer(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/hazardvest(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/shoes/workboots(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/hardhat(src)
	return

/obj/structure/closet/wardrobe/white/medical
	name = "medical doctor's wardrobe"

/obj/structure/closet/wardrobe/white/medical/PopulateContents()
	new /obj/item/clothing/accessory/pocketprotector(src)
	new /obj/item/storage/backpack/duffelbag/med(src)
	new /obj/item/storage/backpack/medic(src)
	new /obj/item/storage/backpack/satchel/med(src)
	new /obj/item/clothing/suit/hooded/wintercoat/medical(src)
	new /obj/item/clothing/under/rank/medical/doctor/nurse(src)
	new /obj/item/clothing/head/nursehat(src)
	new /obj/item/clothing/under/rank/medical/doctor/blue(src)
	new /obj/item/clothing/under/rank/medical/doctor/green(src)
	new /obj/item/clothing/under/rank/medical/doctor/purple(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/under/rank/medical/doctor(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/toggle/labcoat(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/toggle/labcoat/paramedic(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/shoes/sneakers/white(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/soft/emt(src)
	return

/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/robotics_black/PopulateContents()
	new /obj/item/clothing/glasses/hud/diagnostic(src)
	new /obj/item/clothing/glasses/hud/diagnostic(src)
	new /obj/item/clothing/under/rank/rnd/roboticist(src)
	new /obj/item/clothing/under/rank/rnd/roboticist(src)
	new /obj/item/clothing/suit/toggle/labcoat(src)
	new /obj/item/clothing/suit/toggle/labcoat(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	return


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/chemistry_white/PopulateContents()
	new /obj/item/clothing/under/rank/medical/chemist(src)
	new /obj/item/clothing/under/rank/medical/chemist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/suit/toggle/labcoat/chemist(src)
	new /obj/item/clothing/suit/toggle/labcoat/chemist(src)
	new /obj/item/storage/backpack/chemistry(src)
	new /obj/item/storage/backpack/chemistry(src)
	new /obj/item/storage/backpack/satchel/chem(src)
	new /obj/item/storage/backpack/satchel/chem(src)
	new /obj/item/storage/bag/chemistry(src)
	new /obj/item/storage/bag/chemistry(src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/genetics_white/PopulateContents()
	new /obj/item/clothing/under/rank/medical/geneticist(src)
	new /obj/item/clothing/under/rank/medical/geneticist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/suit/toggle/labcoat/genetics(src)
	new /obj/item/clothing/suit/toggle/labcoat/genetics(src)
	new /obj/item/storage/backpack/genetics(src)
	new /obj/item/storage/backpack/genetics(src)
	new /obj/item/storage/backpack/satchel/gen(src)
	new /obj/item/storage/backpack/satchel/gen(src)
	return


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/virology_white/PopulateContents()
	new /obj/item/clothing/under/rank/medical/virologist(src)
	new /obj/item/clothing/under/rank/medical/virologist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/suit/toggle/labcoat/virologist(src)
	new /obj/item/clothing/suit/toggle/labcoat/virologist(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/storage/backpack/virology(src)
	new /obj/item/storage/backpack/virology(src)
	new /obj/item/storage/backpack/satchel/vir(src)
	new /obj/item/storage/backpack/satchel/vir(src)
	return

/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/science_white/PopulateContents()
	new /obj/item/clothing/accessory/pocketprotector(src)
	new /obj/item/storage/backpack/science(src)
	new /obj/item/storage/backpack/science(src)
	new /obj/item/storage/backpack/satchel/tox(src)
	new /obj/item/storage/backpack/satchel/tox(src)
	new /obj/item/clothing/suit/hooded/wintercoat/science(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/under/rank/rnd/scientist(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/toggle/labcoat/science(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/radio/headset/headset_sci(src)
	new /obj/item/radio/headset/headset_sci(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/mask/gas(src)
	return

/obj/structure/closet/wardrobe/botanist
	name = "botanist wardrobe"
	icon_door = "green"

/obj/structure/closet/wardrobe/botanist/PopulateContents()
	new /obj/item/storage/backpack/botany(src)
	new /obj/item/storage/backpack/botany(src)
	new /obj/item/storage/backpack/satchel/hyd(src)
	new /obj/item/storage/backpack/satchel/hyd(src)
	new /obj/item/clothing/suit/hooded/wintercoat/hydro(src)
	new /obj/item/clothing/suit/apron(src)
	new /obj/item/clothing/suit/apron(src)
	new /obj/item/clothing/suit/apron/overalls(src)
	new /obj/item/clothing/suit/apron/overalls(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/under/rank/civilian/hydroponics(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/mask/bandana(src)


/obj/structure/closet/wardrobe/curator
	name = "treasure hunting wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/curator/PopulateContents()
	new /obj/item/clothing/accessory/pocketprotector/full(src)
	new /obj/item/clothing/head/fedora/curator(src)
	new /obj/item/clothing/suit/curator(src)
	new /obj/item/clothing/under/rank/civilian/curator/treasure_hunter(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/storage/backpack/satchel/explorer(src)

/obj/structure/closet/coffin/handle_lock_addition()
	return

/obj/structure/closet/coffin/handle_lock_removal()
	return
