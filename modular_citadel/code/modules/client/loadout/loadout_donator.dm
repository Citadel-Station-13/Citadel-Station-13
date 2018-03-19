//This is the file that handles donator loadout items.

/datum/gear/donor
	donor_only = TRUE
	sort_category = "Donor"
	subtype_path = /datum/gear/donor

/datum/gear/donor/pingcoderfailsafe
	name = "IF YOU SEE THIS, PING A CODER RIGHT NOW!"
	slot = slot_in_backpack
	path = /obj/item/bikehorn/golden
	ckeywhitelist = list("This entry should never appear with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard

/datum/gear/donor/donortestingbikehorn
	name = "Donor item testing bikehorn"
	slot = slot_in_backpack
	path = /obj/item/bikehorn
	ckeywhitelist = list("jayehh","deathride58","poojawa")

/datum/gear/donor/kevhorn
	name = "Airhorn"
	slot = slot_in_backpack
	path = /obj/item/bikehorn/airhorn
	ckeywhitelist = list("kevinz000")

/datum/gear/donor/cebusoap
	name = "Cebutris' soap"
	slot = slot_in_backpack
	path = /obj/item/custom/ceb_soap
	ckeywhitelist = list("cebutris")

/datum/gear/donor/kiaracloak
	name = "Kiara's cloak"
	slot = slot_neck
	path = /obj/item/clothing/neck/cloak/inferno
	ckeywhitelist = list("inferno707")

/datum/gear/donor/kiaracollar
	name = "Kiara's collar"
	slot = slot_neck
	path = /obj/item/clothing/neck/petcollar/inferno
	ckeywhitelist = list("inferno707")

/datum/gear/donor/kiaramedal
	name = "Insignia of Steele"
	slot = slot_in_backpack
	path = /obj/item/clothing/accessory/medal/steele
	ckeywhitelist = list("inferno707")

/datum/gear/donor/sexymimemask
	name = "The hollow heart"
	slot = slot_wear_mask
	path = /obj/item/clothing/mask/sexymime
	ckeywhitelist = list("inferno707")

/datum/gear/donor/engravedzippo
	name = "Engraved zippo"
	slot = slot_hands
	path = /obj/item/lighter/gold
	ckeywhitelist = list("dirtyoldharry")

/datum/gear/donor/geisha
	name = "Geisha suit"
	slot = slot_w_uniform
	path = /obj/item/clothing/under/geisha
	ckeywhitelist = list("atiefling")

/datum/gear/donor/specialscarf
	name = "Special scarf"
	slot = slot_neck
	path = /obj/item/clothing/neck/scarf/zomb
	ckeywhitelist = list("zombierobin")

/datum/gear/donor/redmadcoat
	name = "The Mad's labcoat"
	slot = slot_wear_suit
	path = /obj/item/clothing/suit/toggle/labcoat/mad/red
	ckeywhitelist = list("zombierobin")

/datum/gear/donor/santahat
	name = "Santa hat"
	slot = slot_head
	path = /obj/item/clothing/head/santa/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/donor/reindeerhat
	name = "Reindeer hat"
	slot = slot_head
	path = /obj/item/clothing/head/hardhat/reindeer/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/donor/treeplushie
	name = "Christmas tree plushie"
	slot = slot_in_backpack
	path = /obj/item/toy/plush/tree
	ckeywhitelist = list("illotafv")

/datum/gear/donor/santaoutfit
	name = "Santa costume"
	slot = slot_wear_suit
	path = /obj/item/clothing/suit/space/santa/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/donor/treecloak
	name = "Christmas tree cloak"
	slot = slot_neck
	path = /obj/item/clothing/neck/cloak/festive
	ckeywhitelist = list("illotafv")

/datum/gear/donor/carrotplush
	name = "Carrot plushie"
	slot = slot_in_backpack
	path = /obj/item/toy/plush/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donor/carrotcloak
	name = "Carrot cloak"
	slot = slot_neck
	path = /obj/item/clothing/neck/cloak/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donor/albortorosamask
	name = "Alborto Rosa mask"
	slot = slot_wear_mask
	path = /obj/item/clothing/mask/luchador/zigfie
	ckeywhitelist = list("zigfie")

/datum/gear/donor/mankini
	name = "Mankini"
	slot = slot_w_uniform
	path = /obj/item/clothing/under/mankini
	ckeywhitelist = list("zigfie")

/datum/gear/donor/pinkshoes
	name = "Pink shoes"
	slot = slot_shoes
	path = /obj/item/clothing/shoes/sneakers/pink
	ckeywhitelist = list("zigfie")

/datum/gear/donor/reecesgreatcoat
	name = "Reece's Great Coat"
	slot = slot_wear_suit
	path = /obj/item/clothing/suit/trenchcoat/green
	ckeywhitelist = list("geemiesif")

/datum/gear/donor/russianflask
	name = "Russian flask"
	slot = slot_in_backpack
	path = /obj/item/reagent_containers/food/drinks/flask/russian
	cost = 2
	ckeywhitelist = list("slomka")

/datum/gear/donor/stalkermask
	name = "S.T.A.L.K.E.R. mask"
	slot = slot_wear_mask
	path = /obj/item/clothing/mask/gas/stalker
	ckeywhitelist = list("slomka")

/datum/gear/donor/stripedcollar
	name = "Striped collar"
	slot = slot_neck
	path = /obj/item/clothing/neck/petcollar/stripe
	ckeywhitelist = list("jademanique")

/datum/gear/donor/performersoutfit
	name = "Bluish performer's outfit"
	slot = slot_w_uniform
	path = /obj/item/clothing/under/singery/custom
	ckeywhitelist = list("killer402402")

/datum/gear/donor/vermillion
	name = "Vermillion clothing"
	slot = slot_w_uniform
	path = /obj/item/clothing/suit/vermillion
	ckeywhitelist = list("fractious")

/datum/gear/donor/AM4B
	name = "Foam Force AM4-B"
	slot = slot_in_backpack
	path = /obj/item/gun/ballistic/automatic/AM4B
	ckeywhitelist = list("zeronetalpha")

/datum/gear/donor/carrotsatchel
	name = "Carrot Satchel"
	slot = slot_hands
	path = /obj/item/storage/backpack/satchel/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donor/naomisweater
	name = "worn black sweater"
	slot = slot_w_uniform
	path = /obj/item/clothing/under/bb_sweater/black/naomi
	ckeywhitelist = list("technicalmagi")

/datum/gear/donor/naomicollar
	name = "worn pet collar"
	slot = slot_neck
	path = /obj/item/clothing/neck/petcollar/naomi
	ckeywhitelist = list("technicalmagi")

/datum/gear/donor/gladiator
    name = "Gladiator Armor"
    slot = slot_wear_suit
    path = /obj/item/clothing/under/gladiator
    ckeywhitelist = list("aroche")

/datum/gear/donor/bloodredtie
    name = "Blood Red Tie"
    slot = slot_neck
    path = /obj/item/clothing/neck/tie/bloodred
    ckeywhitelist = list("kyutness")

/datum/gear/donor/puffydress
    name = "Puffy Dress"
    slot = slot_wear_suit
    path = /obj/item/clothing/suit/puffydress
    //ckeywhitelist = //Don't know their ckey yet

/datum/gear/donor/labredblack
    name = "Black and Red Coat"
    slot = slot_wear_suit
    path = /obj/item/clothing/suit/toggle/labcoat/labredblack
    ckeywhitelist = list("blakeryan")
