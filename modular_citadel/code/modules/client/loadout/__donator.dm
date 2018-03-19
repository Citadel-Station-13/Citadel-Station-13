//This is the file that handles donator loadout items.

/datum/gear/pingcoderfailsafe
	name = "IF YOU SEE THIS, PING A CODER RIGHT NOW!"
	category = slot_in_backpack
	path = /obj/item/bikehorn/golden
	ckeywhitelist = list("This entry should never appear with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard

/datum/gear/donortestingbikehorn
	name = "Donor item testing bikehorn"
	category = slot_in_backpack
	path = /obj/item/bikehorn
	ckeywhitelist = list("jayehh","deathride58")

/datum/gear/kevhorn
	name = "Airhorn"
	category = slot_in_backpack
	path = /obj/item/bikehorn/airhorn
	ckeywhitelist = list("kevinz000")

/datum/gear/cebusoap
	name = "Cebutris' soap"
	category = slot_in_backpack
	path = /obj/item/custom/ceb_soap
	ckeywhitelist = list("cebutris")

/datum/gear/kiaracloak
	name = "Kiara's cloak"
	category = slot_neck
	path = /obj/item/clothing/neck/cloak/inferno
	ckeywhitelist = list("inferno707")

/datum/gear/kiaracollar
	name = "Kiara's collar"
	category = slot_neck
	path = /obj/item/clothing/neck/petcollar/inferno
	ckeywhitelist = list("inferno707")

/datum/gear/kiaramedal
	name = "Insignia of Steele"
	category = slot_in_backpack
	path = /obj/item/clothing/accessory/medal/steele
	ckeywhitelist = list("inferno707")

/datum/gear/sexymimemask
	name = "The hollow heart"
	category = slot_wear_mask
	path = /obj/item/clothing/mask/sexymime
	ckeywhitelist = list("inferno707")

/datum/gear/engravedzippo
	name = "Engraved zippo"
	category = slot_hands
	path = /obj/item/lighter/gold
	ckeywhitelist = list("dirtyoldharry")

/datum/gear/geisha
	name = "Geisha suit"
	category = slot_w_uniform
	path = /obj/item/clothing/under/geisha
	ckeywhitelist = list("atiefling")

/datum/gear/specialscarf
	name = "Special scarf"
	category = slot_neck
	path = /obj/item/clothing/neck/scarf/zomb
	ckeywhitelist = list("zombierobin")

/datum/gear/redmadcoat
	name = "The Mad's labcoat"
	category = slot_wear_suit
	path = /obj/item/clothing/suit/toggle/labcoat/mad/red
	ckeywhitelist = list("zombierobin")

/datum/gear/santahat
	name = "Santa hat"
	category = slot_head
	path = /obj/item/clothing/head/santa/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/reindeerhat
	name = "Reindeer hat"
	category = slot_head
	path = /obj/item/clothing/head/hardhat/reindeer/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/treeplushie
	name = "Christmas tree plushie"
	category = slot_in_backpack
	path = /obj/item/toy/plush/tree
	ckeywhitelist = list("illotafv")

/datum/gear/santaoutfit
	name = "Santa costume"
	category = slot_wear_suit
	path = /obj/item/clothing/suit/space/santa/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/treecloak
	name = "Christmas tree cloak"
	category = slot_neck
	path = /obj/item/clothing/neck/cloak/festive
	ckeywhitelist = list("illotafv")

/datum/gear/carrotplush
	name = "Carrot plushie"
	category = slot_in_backpack
	path = /obj/item/toy/plush/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/carrotcloak
	name = "Carrot cloak"
	category = slot_neck
	path = /obj/item/clothing/neck/cloak/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/albortorosamask
	name = "Alborto Rosa mask"
	category = slot_wear_mask
	path = /obj/item/clothing/mask/luchador/zigfie
	ckeywhitelist = list("zigfie")

/datum/gear/mankini
	name = "Mankini"
	category = slot_w_uniform
	path = /obj/item/clothing/under/mankini
	ckeywhitelist = list("zigfie")

/datum/gear/pinkshoes
	name = "Pink shoes"
	category = slot_shoes
	path = /obj/item/clothing/shoes/sneakers/pink
	ckeywhitelist = list("zigfie")

/datum/gear/reecesgreatcoat
	name = "Reece's Great Coat"
	category = slot_wear_suit
	path = /obj/item/clothing/suit/trenchcoat/green
	ckeywhitelist = list("geemiesif")

/datum/gear/russianflask
	name = "Russian flask"
	category = slot_in_backpack
	path = /obj/item/reagent_containers/food/drinks/flask/russian
	cost = 2
	ckeywhitelist = list("slomka")

/datum/gear/stalkermask
	name = "S.T.A.L.K.E.R. mask"
	category = slot_wear_mask
	path = /obj/item/clothing/mask/gas/stalker
	ckeywhitelist = list("slomka")

/datum/gear/stripedcollar
	name = "Striped collar"
	category = slot_neck
	path = /obj/item/clothing/neck/petcollar/stripe
	ckeywhitelist = list("jademanique")

/datum/gear/performersoutfit
	name = "Bluish performer's outfit"
	category = slot_w_uniform
	path = /obj/item/clothing/under/singery/custom
	ckeywhitelist = list("killer402402")

/datum/gear/vermillion
	name = "Vermillion clothing"
	category = slot_w_uniform
	path = /obj/item/clothing/suit/vermillion
	ckeywhitelist = list("fractious")

/datum/gear/AM4B
	name = "Foam Force AM4-B"
	category = slot_in_backpack
	path = /obj/item/gun/ballistic/automatic/AM4B
	ckeywhitelist = list("zeronetalpha")

/datum/gear/carrotsatchel
	name = "Carrot Satchel"
	category = slot_hands
	path = /obj/item/storage/backpack/satchel/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/naomisweater
	name = "worn black sweater"
	category = slot_w_uniform
	path = /obj/item/clothing/under/bb_sweater/black/naomi
	ckeywhitelist = list("technicalmagi")

/datum/gear/naomicollar
	name = "worn pet collar"
	category = slot_neck
	path = /obj/item/clothing/neck/petcollar/naomi
	ckeywhitelist = list("technicalmagi")

/datum/gear/gladiator
    name = "Gladiator Armor"
    category = slot_wear_suit
    path = /obj/item/clothing/under/gladiator
    ckeywhitelist = list("aroche")

/datum/gear/bloodredtie
    name = "Blood Red Tie"
    category = slot_neck
    path = /obj/item/clothing/neck/tie/bloodred
    ckeywhitelist = list("kyutness")

/datum/gear/puffydress
    name = "Puffy Dress"
    category = slot_wear_suit
    path = /obj/item/clothing/suit/puffydress
    //ckeywhitelist = //Don't know their ckey yet

/datum/gear/labredblack
    name = "Black and Red Coat"
    category = slot_wear_suit
    path = /obj/item/clothing/suit/toggle/labcoat/labredblack
    ckeywhitelist = list("blakeryan")






