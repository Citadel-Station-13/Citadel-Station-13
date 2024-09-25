
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
////////////////////////////////// Toys //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/costumes_toys
	group = "Costumes & Toys"

/datum/supply_pack/costumes_toys/randomised/fill(obj/structure/closet/crate/C)
	var/list/L = contains.Copy()
	for(var/i in 1 to num_contained)
		var/item = pick_n_take(L)
		new item(C)

/datum/supply_pack/costumes_toys/randomised
	name = "Collectable Hats Crate"
	desc = "Flaunt your status with three unique, highly-collectable hats!"
	cost = 20000
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/HoP,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	crate_name = "collectable hats crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/contraband
	name = "Contraband Crate"
	desc = "Psst.. bud... want some contraband? I can get you a poster, some nice cigs, dank, even some sponsored items...you know, the good stuff. Just keep it away from the cops, kay?"
	contraband = TRUE
	cost = 3000
	num_contained = 5 //SOME
	contains = list(/obj/item/poster/random_contraband,
					/obj/item/poster/random_contraband,
					/obj/item/reagent_containers/food/snacks/grown/cannabis,
					/obj/item/reagent_containers/food/snacks/grown/cannabis/rainbow,
					/obj/item/reagent_containers/food/snacks/grown/cannabis/white,
					/obj/item/storage/pill_bottle/zoom,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/storage/pill_bottle/lsd,
					/obj/item/storage/pill_bottle/aranesp,
					/obj/item/storage/pill_bottle/stimulant,
					/obj/item/toy/cards/deck/syndicate,
					/obj/item/reagent_containers/food/drinks/bottle/absinthe,
					/obj/item/clothing/under/syndicate/tacticool,
					/obj/item/clothing/under/syndicate/skirt,
					/obj/item/clothing/under/syndicate,
					/obj/item/suppressor,
					/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
					/obj/item/storage/fancy/cigarettes/cigpack_shadyjims,
					/obj/item/clothing/mask/gas/syndicate,
					/obj/item/clothing/neck/necklace/dope,
					/obj/item/vending_refill/donksoft,
					/obj/item/circuitboard/computer/arcade/amputation,
					/obj/item/storage/bag/ammo)
	crate_name = "crate"

/datum/supply_pack/costumes_toys/foamforce
	name = "Foam Force Crate"
	desc = "Break out the big guns with eight Foam Force shotguns!"
	cost = 1000
	contains = list(/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy)
	crate_name = "foam force crate"

/datum/supply_pack/costumes_toys/foamforce/bonus
	name = "Foam Force Pistols Crate"
	desc = "Psst.. hey bud... remember those old foam force pistols that got discontinued for being too cool? Well I got two of those right here with your name on em. I'll even throw in a spare mag for each, waddya say?"
	contraband = TRUE
	cost = 4000
	contains = list(/obj/item/gun/ballistic/automatic/toy/pistol,
					/obj/item/gun/ballistic/automatic/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol)
	crate_name = "foam force crate"

/datum/supply_pack/costumes_toys/clownpin
	name = "Hilarious Firing Pin Crate"
	desc = "I uh... I'm not really sure what this does. Wanna buy it?"
	cost = 5000
	contraband = TRUE
	contains = list(/obj/item/firing_pin/clown)
	crate_name = "toy crate" // It's /technically/ a toy. For the clown, at least.
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/lasertag
	name = "Laser Tag Crate"
	desc = "Foam Force is for boys. Laser Tag is for men. Contains three sets of red suits, blue suits, matching helmets, and matching laser tag guns."
	cost = 3500
	contains = list(/obj/item/gun/energy/laser/redtag,
					/obj/item/gun/energy/laser/redtag,
					/obj/item/gun/energy/laser/redtag,
					/obj/item/gun/energy/laser/bluetag,
					/obj/item/gun/energy/laser/bluetag,
					/obj/item/gun/energy/laser/bluetag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/head/helmet/redtaghelm,
					/obj/item/clothing/head/helmet/redtaghelm,
					/obj/item/clothing/head/helmet/redtaghelm,
					/obj/item/clothing/head/helmet/bluetaghelm,
					/obj/item/clothing/head/helmet/bluetaghelm,
					/obj/item/clothing/head/helmet/bluetaghelm)
	crate_name = "laser tag crate"

/datum/supply_pack/costumes_toys/lasertag/pins
	name = "Laser Tag Firing Pins Crate"
	desc = "Three laser tag firing pins used in laser-tag units to ensure users are wearing their vests."
	cost = 3000
	contraband = TRUE
	contains = list(/obj/item/storage/box/lasertagpins)
	crate_name = "laser tag crate"

/datum/supply_pack/costumes_toys/randomised/toys
	name = "Toy Crate"
	desc = "Who cares about pride and accomplishment? Skip the gaming and get straight to the sweet rewards with this product! Contains five random toys. Warranty void if used to prank research directors."
	cost = 1500 // or play the arcade machines ya lazy bum
	num_contained = 5
	contains = list(/obj/item/storage/box/snappops,
					/obj/item/toy/talking/AI,
					/obj/item/toy/talking/codex_gigas,
					/obj/item/clothing/under/syndicate/tacticool,
					/obj/item/toy/sword,
					/obj/item/toy/gun,
					/obj/item/gun/ballistic/shotgun/toy/crossbow,
					/obj/item/storage/box/fakesyndiesuit,
					/obj/item/storage/crayons,
					/obj/item/toy/spinningtoy,
					/obj/item/toy/mecha/ripley,
					/obj/item/toy/mecha/ripleymkii,
					/obj/item/toy/mecha/hauler,
					/obj/item/toy/mecha/clarke,
					/obj/item/toy/mecha/odysseus,
					/obj/item/toy/mecha/gygax,
					/obj/item/toy/mecha/durand,
					/obj/item/toy/mecha/savannahivanov,
					/obj/item/toy/mecha/phazon,
					/obj/item/toy/mecha/honk,
					/obj/item/toy/mecha/darkgygax,
					/obj/item/toy/mecha/mauler,
					/obj/item/toy/mecha/darkhonk,
					/obj/item/toy/mecha/deathripley,
					/obj/item/toy/mecha/reticence,
					/obj/item/toy/mecha/marauder,
					/obj/item/toy/mecha/seraph,
					/obj/item/toy/mecha/firefighter,
					/obj/item/toy/cards/deck,
					/obj/item/toy/nuke,
					/obj/item/toy/minimeteor,
					/obj/item/toy/redbutton,
					/obj/item/toy/talking/owl,
					/obj/item/toy/talking/griffin,
					/obj/item/coin/antagtoken,
					/obj/item/stack/tile/fakespace/loaded,
					/obj/item/stack/tile/fakepit/loaded,
					/obj/item/toy/toy_xeno,
					/obj/item/storage/box/actionfigure,
					/obj/item/restraints/handcuffs/fake,
					/obj/item/grenade/chem_grenade/glitter/pink,
					/obj/item/grenade/chem_grenade/glitter/blue,
					/obj/item/grenade/chem_grenade/glitter/white,
					/obj/item/toy/eightball,
					/obj/item/toy/windupToolbox,
					/obj/item/toy/clockwork_watch,
					/obj/item/toy/toy_dagger,
					/obj/item/extendohand/acme,
					/obj/item/hot_potato/harmless/toy,
					/obj/item/card/emagfake,
					/obj/item/clothing/shoes/wheelys,
					/obj/item/clothing/shoes/kindleKicks,
					/obj/item/storage/belt/military/snack,
					/obj/item/toy/eightball,
					/obj/item/vending_refill/donksoft)
	crate_name = "toy crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/plush
	name = "Plush Crate"
	desc = "Plush tide station wide. Contains 5 random plushies for you to love. Warranty void if your love violates the terms of use."
	cost = 1500 // or play the arcade machines ya lazy bum
	num_contained = 5
	contains = list(/obj/item/toy/plush/random,
					/obj/item/toy/plush/random,
					/obj/item/toy/plush/random,
					/obj/item/toy/plush/random,
					/obj/item/toy/plush/random) //I'm lazy
	crate_name = "plushie crate"
	crate_type = /obj/structure/closet/crate/wooden


//////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Costumes  //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/costumes_toys/formalwear
	name = "Formalwear Crate"
	desc = "You're gonna like the way you look, I guaranteed it. Contains an asston of fancy clothing."
	cost = 4750 //Lots of fancy clothing that can be sold back!
	contains = list(/obj/item/clothing/under/dress/blacktango,
					/obj/item/clothing/under/misc/assistantformal,
					/obj/item/clothing/under/misc/assistantformal,
					/obj/item/clothing/under/rank/civilian/lawyer/bluesuit,
					/obj/item/clothing/suit/toggle/lawyer,
					/obj/item/clothing/under/rank/civilian/lawyer/purpsuit,
					/obj/item/clothing/suit/toggle/lawyer/purple,
					/obj/item/clothing/under/suit/black,
					/obj/item/clothing/suit/toggle/lawyer/black,
					/obj/item/clothing/accessory/waistcoat,
					/obj/item/clothing/neck/tie/blue,
					/obj/item/clothing/neck/tie/red,
					/obj/item/clothing/neck/tie/black,
					/obj/item/clothing/head/bowler,
					/obj/item/clothing/head/fedora,
					/obj/item/clothing/head/flatcap,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/head/that,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/under/suit/charcoal,
					/obj/item/clothing/under/suit/navy,
					/obj/item/clothing/under/suit/burgundy,
					/obj/item/clothing/under/suit/checkered,
					/obj/item/clothing/under/suit/tan,
					/obj/item/lipstick/random)
	crate_name = "formalwear crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume_original
	name = "Original Costume Crate"
	desc = "Reenact Shakespearean plays with this assortment of outfits. Contains eight different costumes!"
	cost = 1750
	contains = list(/obj/item/clothing/head/snowman,
					/obj/item/clothing/suit/snowman,
					/obj/item/clothing/head/chicken,
					/obj/item/clothing/suit/chickensuit,
					/obj/item/clothing/mask/gas/monkeymask,
					/obj/item/clothing/suit/monkeysuit,
					/obj/item/clothing/head/cardborg,
					/obj/item/clothing/suit/cardborg,
					/obj/item/clothing/head/xenos,
					/obj/item/clothing/suit/xenos,
					/obj/item/clothing/suit/hooded/ian_costume,
					/obj/item/clothing/suit/hooded/carp_costume,
					/obj/item/clothing/suit/hooded/bee_costume)
	crate_name = "original costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume
	name = "Standard Costume Crate"
	desc = "Supply the station's entertainers with the equipment of their trade with these Nanotrasen-approved costumes! Contains a full clown and mime outfit, along with a bike horn and a bottle of nothing."
	cost = 1300
	access = ACCESS_THEATRE
	contains = list(/obj/item/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/civilian/clown,
					/obj/item/bikehorn,
					/obj/item/clothing/under/rank/civilian/mime,
					/obj/item/clothing/shoes/sneakers/black,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/suit/suspenders,
					/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
					/obj/item/storage/backpack/mime)
	crate_name = "standard costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/wizard
	name = "Wizard Costume Crate"
	desc = "Pretend to join the Wizard Federation with this full wizard outfit! Nanotrasen would like to remind its employees that actually joining the Wizard Federation is subject to termination of job and life."
	cost = 2000
	contains = list(/obj/item/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	crate_name = "wizard costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/wedding
	name = "Wedding Crate"
	desc = "Tie the knot IN SPACE! Hold your own extravagant wedding with this crate of suits and bridal gowns. Complete with champagne, cake, and the luxurious cost you would expect for an event to remember."
	cost = 10000 // weddings are absurdly expensive and so is this crate
	contains = list(/obj/item/clothing/under/suit/black_really, //we don't actually need suits since you can vend them but the crate should feel "complete"
					/obj/item/clothing/under/suit/black_really,
					/obj/item/clothing/under/suit/charcoal,
					/obj/item/clothing/under/suit/charcoal,
					/obj/item/clothing/under/suit/navy,
					/obj/item/clothing/under/suit/navy,
					/obj/item/clothing/under/suit/burgundy,
					/obj/item/clothing/under/suit/burgundy, // A pair of each "fancy suit" color for variety
					/obj/item/clothing/under/suit/white,
					/obj/item/clothing/under/suit/white, // white is a weird color for a groom but some people are weird
					/obj/item/clothing/under/suit/polychromic,
					/obj/item/clothing/under/suit/polychromic, // in case you can't be satisfied with the most fitting choices, of course.
					/obj/item/clothing/under/dress/wedding,
					/obj/item/clothing/under/dress/wedding, // this is what you actually bought the crate for. You can't get these anywhere else.
					/obj/item/clothing/under/dress/wedding/orange,
					/obj/item/clothing/under/dress/wedding/orange,
					/obj/item/clothing/under/dress/wedding/purple,
					/obj/item/clothing/under/dress/wedding/purple,
					/obj/item/clothing/under/dress/wedding/blue,
					/obj/item/clothing/under/dress/wedding/blue,
					/obj/item/clothing/under/dress/wedding/red,
					/obj/item/clothing/under/dress/wedding/red, // two of each
					/obj/item/reagent_containers/food/drinks/bottle/champagne, //appropriate booze for a wedding
					/obj/item/reagent_containers/food/snacks/store/cake/vanilla_cake, // we don't have a full wedding cake but this will do
					/obj/item/storage/fancy/ringbox/silver,
					/obj/item/storage/fancy/ringbox/silver) //diamond rings cost the same price as this crate via cargo so we're not giving you two for free. Wedding rings are traditionally less valuable anyway.
	crate_name = "wedding crate"

/datum/supply_pack/costumes_toys/randomised/tcg
	name = "Big-Ass Booster Pack Pack"
	desc = "A bumper load of NT TCG Booster Packs of varying series. Collect them all!"
	cost = 3000
	contains = list()
	crate_name = "booster pack pack"

/datum/supply_pack/costumes_toys/randomised/tcg/generate()
	. = ..()
	var/list/cardtypes = subtypesof(/obj/item/cardpack)
	for(var/cardtype in cardtypes)
		var/obj/item/cardpack/pack = new cardtype(.)
		if(pack.illegal)
			cardtypes.Remove(cardtype)
		qdel(pack)
	for(var/i in 1 to 10)
		var/cardpacktype = pick(cardtypes)
		new cardpacktype(.)
