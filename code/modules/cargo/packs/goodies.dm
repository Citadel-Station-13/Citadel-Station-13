
/datum/supply_pack/goody
	access = NONE
	group = "Goodies"
	goody = PACK_GOODY_PRIVATE

/datum/supply_pack/goody/combatknives_single
	name = "Combat Knife Single-Pack"
	desc = "Contains one sharpened combat knive. Guaranteed to fit snugly inside any Nanotrasen-standard boot."
	cost = 800
	contains = list(/obj/item/kitchen/knife/combat)

/datum/supply_pack/goody/sologamermitts
	name = "Insulated Gloves Single-Pack"
	desc = "The backbone of modern society. Barely ever ordered for actual engineering."
	cost = 800
	contains = list(/obj/item/clothing/gloves/color/yellow)

/datum/supply_pack/goody/firstaidbruises_single
	name = "Bruise Treatment Kit Single-Pack"
	desc = "A single brute first-aid kit, perfect for recovering from being crushed in an airlock. Did you know people get crushed in airlocks all the time? Interesting..."
	cost = 330
	contains = list(/obj/item/storage/firstaid/brute)

/datum/supply_pack/goody/firstaidburns_single
	name = "Burn Treatment Kit Single-Pack"
	desc = "A single burn first-aid kit. The advertisement displays a winking atmospheric technician giving a thumbs up, saying \"Mistakes happen!\""
	cost = 330
	contains = list(/obj/item/storage/firstaid/fire)

/datum/supply_pack/goody/firstaid_single
	name = "First Aid Kit Single-Pack"
	desc = "A single first-aid kit, fit for healing most types of bodily harm."
	cost = 250
	contains = list(/obj/item/storage/firstaid/regular)

/datum/supply_pack/goody/firstaidoxygen_single
	name = "Oxygen Deprivation Kit Single-Pack"
	desc = "A single oxygen deprivation first-aid kit, marketed heavily to those with crippling fears of asphyxiation."
	cost = 330
	contains = list(/obj/item/storage/firstaid/o2)

/datum/supply_pack/goody/firstaidtoxins_single
	name = "Toxin Treatment Kit Single-Pack"
	desc = "A single first aid kit focused on healing damage dealt by heavy toxins."
	cost = 330
	contains = list(/obj/item/storage/firstaid/toxin)

/datum/supply_pack/goody/toolbox // mostly just to water down coupon probability
	name = "Mechanical Toolbox"
	desc = "A fully stocked mechanical toolbox, for when you're too lazy to just print them out."
	cost = 300
	contains = list(/obj/item/storage/toolbox/mechanical)

/datum/supply_pack/goody/electrical_toolbox
	name = "Electrical Toolbox"
	desc = "A fully stocked electrical toolbox, for when you're too lazy to just print them out."
	cost = 300
	contains = list(/obj/item/storage/toolbox/electrical)

/datum/supply_pack/goody/valentine
	name = "Valentine Card"
	desc = "Make an impression on that special someone! Comes with one valentine card and a free candy heart!"
	cost = 150
	contains = list(/obj/item/valentine, /obj/item/reagent_containers/food/snacks/candyheart)

/datum/supply_pack/goody/beeplush
	name = "Bee Plushie"
	desc = "The most important thing you could possibly spend your hard-earned money on."
	cost = 1500
	contains = list(/obj/item/toy/plush/beeplushie)

/datum/supply_pack/goody/dyespray
	name = "Hair Dye Spray"
	desc = "A cool spray to dye your hair with awesome colors!"
	cost = PAYCHECK_EASY * 2
	contains = list(/obj/item/dyespray)

/datum/supply_pack/goody/beach_ball
	name = "Beach Ball"
	desc = "The simple beach ball is one of Nanotrasen's most popular products. 'Why do we make beach balls? Because we can! (TM)' - Nanotrasen"
	cost = 200
	contains = list(/obj/item/toy/beach_ball)

/datum/supply_pack/goody/medipen_twopak
	name = "Medipen Two-Pak"
	desc = "Contains one standard epinephrine medipen and one standard emergency first-aid kit medipen. For when you want to prepare for the worst."
	cost = 500
	contains = list(/obj/item/reagent_containers/hypospray/medipen, /obj/item/reagent_containers/hypospray/medipen/ekit)

