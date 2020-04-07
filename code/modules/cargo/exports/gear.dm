/datum/export/gear
	include_subtypes = FALSE

//blanket
/datum/export/gear/hat
	cost = 3
	unit_name = "clothing"
	export_types = list(/obj/item/clothing)
	include_subtypes = TRUE

//Hats

//Blanket
/datum/export/gear/hat
	cost = 5
	unit_name = "hat"
	export_types = list(/obj/item/clothing/head)
	include_subtypes = TRUE

/datum/export/gear/sec_helmet
	cost = 70
	unit_name = "helmet"
	export_types = list(/obj/item/clothing/head/helmet/sec)

/datum/export/gear/sec_soft
	cost = 50
	unit_name = "soft sec cap"
	export_types = list(/obj/item/clothing/head/soft/sec)

/datum/export/gear/sec_helmetalt
	cost = 50
	unit_name = "bullet proof helmet"
	export_types = list(/obj/item/clothing/head/helmet/alt)

/datum/export/gear/sec_helmetold
	cost = 10
	unit_name = "old helmet"
	export_types = list(/obj/item/clothing/head/helmet/old)

/datum/export/gear/sec_helmetblue
	cost = 75
	unit_name = "blue helmet"
	export_types = list(/obj/item/clothing/head/helmet/blueshirt)

/datum/export/gear/sec_helmetriot
	cost = 100
	unit_name = "riot helmet"
	export_types = list(/obj/item/clothing/head/helmet/riot)

/datum/export/gear/sec_helmet_light
	cost = 20
	unit_name = "justice helmet"
	export_types = list(/obj/item/clothing/head/helmet/justice/escape)
	include_subtypes = TRUE

/datum/export/gear/syndicate_helmetswat
	cost = 250
	unit_name = "syndicate helmet"
	export_types = list(/obj/item/clothing/head/helmet/swat)

/datum/export/gear/sec_helmetswat
	cost = 150
	unit_name = "swat helmet"
	export_types = list(/obj/item/clothing/head/helmet/swat/nanotrasen)

/datum/export/gear/thunder_helmet
	cost = 120
	unit_name = "thunder dome helmet"
	export_types = list(/obj/item/clothing/head/helmet/thunderdome)

/datum/export/gear/roman_real
	cost = 30
	unit_name = "roman helmet"
	export_types = list(/obj/item/clothing/head/helmet/roman)

/datum/export/gear/roman_realalt
	cost = 60
	unit_name = "legionnaire helmet"
	export_types = list(/obj/item/clothing/head/helmet/roman/legionnaire)

/datum/export/gear/roman_fake
	cost = 10
	unit_name = "toy roman helmet"
	export_types = list(/obj/item/clothing/head/helmet/roman/fake)

/datum/export/gear/roman_fakealt
	cost = 20
	unit_name = "toy legionnaire helmet"
	export_types = list(/obj/item/clothing/head/helmet/roman/legionnaire/fake)

/datum/export/gear/ash_walker_helm
	cost = 70
	unit_name = "gladiator helmet"
	export_types = list(/obj/item/clothing/head/helmet/gladiator)

/datum/export/gear/lasertag
	cost = 30 //Has armor
	unit_name = "lasertag helmet"
	export_types = list(/obj/item/clothing/head/helmet/redtaghelm)

/datum/export/gear/lasertag/blue
	export_types = list(/obj/item/clothing/head/helmet/bluetaghelm)

/datum/export/gear/knight_helmet
	cost = 200
	k_elasticity = 1/5 //Rare, dont flood it
	unit_name = "knight helmet"
	export_types = list(/obj/item/clothing/head/helmet/knight, /obj/item/clothing/head/helmet/knight/blue, /obj/item/clothing/head/helmet/knight/yellow, /obj/item/clothing/head/helmet/knight/red)

/datum/export/gear/skull_hat
	cost = 70
	k_elasticity = 1/15 //Its just a skull
	unit_name = "skull"
	export_types = list(/obj/item/clothing/head/helmet/skull)

/datum/export/gear/durathread_helm
	cost = 100
	k_elasticity = 1/15
	unit_name = "durathread hat"
	export_types = list(/obj/item/clothing/head/helmet/durathread, /obj/item/clothing/head/beret/durathread, /obj/item/clothing/head/beanie/durathread)

/datum/export/gear/hard_hats
	cost = 50
	unit_name = "hard hat"
	export_types = list(/obj/item/clothing/head/hardhat, /obj/item/clothing/head/hardhat/orange, /obj/item/clothing/head/hardhat/white, /obj/item/clothing/head/hardhat/dblue)

/datum/export/gear/atmos_helm
	cost = 200 //Armored, fire proof, light, and presser proof
	unit_name = "atmos hard hat"
	export_types = list(/obj/item/clothing/head/hardhat/atmos)

/datum/export/gear/crowns
	cost = 350 //Armored, gold 300cr of gold to make so give them 50 more for working
	k_elasticity = 1/5 //Anti-floods
	unit_name = "crown"
	export_types = list(/obj/item/clothing/head/crown, /obj/item/clothing/head/crown/fancy)

/datum/export/gear/cchat
	cost = 40
	unit_name = "centcom hat"
	export_types = list(/obj/item/clothing/head/centhat)

/datum/export/gear/caphat
	cost = 150
	unit_name = "command hat"
	export_types = list(/obj/item/clothing/head/caphat, /obj/item/clothing/head/caphat/parade, /obj/item/clothing/head/caphat/beret)

/datum/export/gear/hophat
	cost = 130
	unit_name = "hop hat"
	export_types = list(/obj/item/clothing/head/hopcap, /obj/item/clothing/head/hopcap/beret)

/datum/export/gear/dechat
	cost = 75
	k_elasticity = 1/8 //Anti-floods
	unit_name = "fedora"
	export_types = list(/obj/item/clothing/head/fedora/det_hat, /obj/item/clothing/head/fedora/curator, /obj/item/clothing/head/fedora)

/datum/export/gear/hoshat
	cost = 140
	unit_name = "hos hat"
	export_types = list(/obj/item/clothing/head/HoS, /obj/item/clothing/head/HoS/beret, /obj/item/clothing/head/beret/sec/navyhos)

/datum/export/gear/syndahoshat
	cost = 300
	unit_name = "syndicate command hat"
	export_types = list(/obj/item/clothing/head/HoS/syndicate, /obj/item/clothing/head/HoS/beret/syndicate)

/datum/export/gear/wardenhat
	cost = 90
	unit_name = "warden hat"
	export_types = list(/obj/item/clothing/head/warden, /obj/item/clothing/head/warden/drill, /obj/item/clothing/head/beret/sec/navywarden)

/datum/export/gear/sechats
	cost = 60
	unit_name = "sec beret"
	export_types = list(/obj/item/clothing/head/beret/sec, /obj/item/clothing/head/beret/sec/navyofficer)

/datum/export/gear/berets
	cost = 30
	unit_name = "beret"
	export_types = list(/obj/item/clothing/head/beret/qm, /obj/item/clothing/head/beret/rd, /obj/item/clothing/head/beret/cmo, /obj/item/clothing/head/beret)

/datum/export/gear/berets
	cost = 30
	unit_name = "beret"
	export_types = list(/obj/item/clothing/head/beret/qm, /obj/item/clothing/head/beret/rd, /obj/item/clothing/head/beret/cmo, /obj/item/clothing/head/beret)

/datum/export/gear/collectable
	cost = 500
	unit_name = "collectable hat"
	k_elasticity = 1/10 //dont flood these
	export_types = list(/obj/item/clothing/head/collectable)
	include_subtypes = TRUE

/datum/export/gear/fancyhats
	cost = 75
	unit_name = "fancy hat"
	k_elasticity = 1/10 //dont flood these
	export_types = list(/obj/item/clothing/head/that, /obj/item/clothing/head/bowler, /obj/item/clothing/head/lizard, /obj/item/clothing/head/canada)

/datum/export/gear/welders
	cost = 30
	unit_name = "welder helm"
	k_elasticity = 1/20 //dont flood these
	export_types = list(/obj/item/clothing/head/welding)

/datum/export/gear/magichat //Magic as is Antags-Wiz/Cults
	cost = 450
	unit_name = "magic hat"
	export_types = list(/obj/item/clothing/head/wizard, /obj/item/clothing/head/culthood, /obj/item/clothing/head/magus, /obj/item/clothing/head/helmet/clockwork)
	exclude_types = list(/obj/item/clothing/head/wizard/fake, /obj/item/clothing/head/wizard/marisa/fake)
	include_subtypes = TRUE

//Shoes

//Blanket
/datum/export/gear/shoes
	cost = 1 //Really dont want to sell EVERY SHOE EVER - yet*
	unit_name = "shoes"
	export_types = list(/obj/item/clothing/shoes)
	include_subtypes = TRUE

/datum/export/gear/clown_shoesmk
	cost = 600
	unit_name = "mk-honk prototype shoes"
	export_types = list(/obj/item/clothing/shoes/clown_shoes/banana_shoes)

/datum/export/gear/magboots
	cost = 50
	unit_name = "magboots"
	export_types = list(/obj/item/clothing/shoes/magboots)

/datum/export/gear/nosellboots
	cost = -5000 //We DONT want scew antags
	unit_name = "error shipment stolen"
	export_types = list(/obj/item/clothing/shoes/magboots/advance)

/datum/export/gear/syndamagboots
	cost = 250
	unit_name = "blood redmagboots"
	export_types = list(/obj/item/clothing/shoes/magboots/syndie)

/datum/export/gear/combatboots
	cost = 30
	unit_name = "combat boots"
	export_types = list(/obj/item/clothing/shoes/combat)

/datum/export/gear/swatboots
	cost = 45
	unit_name = "swat boots"
	export_types = list(/obj/item/clothing/shoes/combat/swat)

/datum/export/gear/galoshes
	cost = 50
	unit_name = "galoshes"
	export_types = list(/obj/item/clothing/shoes/galoshes, /obj/item/clothing/shoes/galoshes/dry)

/datum/export/gear/clown
	cost = 10
	unit_name = "clown shoes"
	export_types = list(/obj/item/clothing/shoes/clown_shoes, /obj/item/clothing/shoes/clown_shoes/jester)

/datum/export/gear/dressshoes
	cost = 10
	unit_name = "dress shoes"
	export_types = list(/obj/item/clothing/shoes/laceup, /obj/item/clothing/shoes/singerb, /obj/item/clothing/shoes/singery)

/datum/export/gear/working
	cost = 15
	unit_name = "boots"
	export_types = list(/obj/item/clothing/shoes/jackboots/fast, /obj/item/clothing/shoes/winterboots, /obj/item/clothing/shoes/jackboots, /obj/item/clothing/shoes/workboots, /obj/item/clothing/shoes/workboots/mining)

/datum/export/gear/hopboots
	cost = 350 //costs 1000 credits for miners to get
	unit_name = "jump boots"
	export_types = list(/obj/item/clothing/shoes/bhop)

/datum/export/gear/magicboots //Magic as in Antag - Wiz/Cults
	cost = 450
	unit_name = "magic shoes"
	export_types = list(/obj/item/clothing/shoes/sandal/marisa, /obj/item/clothing/shoes/sandal/magic, /obj/item/clothing/shoes/cult, /obj/item/clothing/shoes/clockwork, /obj/item/clothing/shoes/clown_shoes/taeclowndo)
	include_subtypes = TRUE

//Headsets/Ears

//Blanket
/datum/export/gear/ears
	cost = 2 //We dont want to sell every headset ever
	unit_name = "ear gear"
	export_types = list(/obj/item/clothing/ears, /obj/item/radio/headset)
	include_subtypes = TRUE

//Gloves

//Blanket
/datum/export/gear/gloves
	cost = 4 //Glove crafting can be done
	unit_name = "gloves"
	export_types = list(/obj/item/clothing/gloves)
	include_subtypes = TRUE

/datum/export/gear/boxing
	cost = 10 //Padding as well as a weapon
	unit_name = "boxing gloves"
	export_types = list(/obj/item/clothing/gloves/boxing)
	include_subtypes = TRUE

/datum/export/gear/combatgloves
	cost = 80
	unit_name = "combat gloves"
	export_types = list(/obj/item/clothing/gloves/combat, /obj/item/clothing/gloves/rapid, /obj/item/clothing/gloves/krav_maga)
	include_subtypes = TRUE

/datum/export/gear/bonegloves
	cost = 30
	unit_name = "bone bracers"
	export_types = list(/obj/item/clothing/gloves/bracer)

/datum/export/gear/yellowgloves
	cost = 50
	unit_name = "insulated gloves"
	export_types = list(/obj/item/clothing/gloves/color/yellow, /obj/item/clothing/gloves/color/red/insulated)

/datum/export/gear/leathergloves
	cost = 20
	unit_name = "leather gloves"
	export_types = list(/obj/item/clothing/gloves/botanic_leather)

/datum/export/gear/fancy
	cost = 25
	unit_name = "fancy gloves"
	export_types = list(/obj/item/clothing/gloves/color/black, /obj/item/clothing/gloves/color/captain, /obj/item/clothing/gloves/color/white)

/datum/export/gear/magicgloves//Magic as in Antag - Wiz/Cults
	cost = 400
	unit_name = "magic gloves"
	export_types = list(/obj/item/clothing/gloves/clockwork)
	include_subtypes = TRUE

//Ties/neck

//Blanket
/datum/export/gear/neck
	cost = 5 //Fancy!
	unit_name = "neck based gear"
	export_types = list(/obj/item/clothing/neck)
	include_subtypes = TRUE

/datum/export/gear/collar
	cost = 7
	unit_name = "collar"
	export_types = list(/obj/item/clothing/neck/petcollar)
	include_subtypes = TRUE

/datum/export/gear/bling
	cost = 15 //Needs a coin
	unit_name = "gold plated necklace"
	export_types = list(/obj/item/clothing/neck/necklace/dope)

//masks

//Blanket
/datum/export/gear/masks
	cost = 3 //Mostly just fake stuff and clowngear
	unit_name = "face gear"
	export_types = list(/obj/item/clothing/mask)
	include_subtypes = TRUE

/datum/export/gear/gasmask
	cost = 4
	unit_name = "gas mask"
	export_types = list(/obj/item/clothing/mask/gas, /obj/item/clothing/mask/gas/glass)

/datum/export/gear/minermask
	cost = 10
	unit_name = "armored mask"
	export_types = list(/obj/item/clothing/mask/gas/welding, /obj/item/clothing/mask/gas/explorer, /obj/item/clothing/mask/gas/syndicate)

/datum/export/gear/sechailer
	cost = 6
	unit_name = "sec hailer"
	export_types = list(/obj/item/clothing/mask/gas/sechailer)
	include_subtypes = TRUE

/datum/export/gear/mask/breath
	cost = 2
	unit_name = "breath mask"
	export_types = list(/obj/item/clothing/mask/breath)

//Hardsuits //If you steal/fine more they are worth selling

//Blanket
/datum/export/gear/hardsuit
	cost = 250 //Its just metal/plastic after all
	unit_name = "unknown hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit)
	include_subtypes = TRUE

/datum/export/gear/engi_hardsuit
	cost = 500
	unit_name = "engine hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/engine)

/datum/export/gear/atmos_hardsuit
	cost = 600
	unit_name = "atmos hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/engine/atmos)

/datum/export/gear/engi_hardsuit
	cost = 1000
	unit_name = "elite engine hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/engine/elite)

/datum/export/gear/mining_hardsuit
	cost = 350 //common
	unit_name = "mining hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/mining)

/datum/export/gear/sec_hardsuit
	cost = 750
	unit_name = "sec hardsuit"
	export_types = list(/obj/item/clothing/head/helmet/space/hardsuit/mining, /obj/item/clothing/head/helmet/space/hardsuit/syndi/owl)

/datum/export/gear/syndi_hardsuit
	cost = 1250
	unit_name = "syndi hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/syndi)

/datum/export/gear/syndi_hardsuit
	cost = 2750
	unit_name = "elite syndi hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/syndi/elite)

/datum/export/gear/medical_hardsuit
	cost = 350 //Not all that good
	unit_name = "meidcal hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/medical)

/datum/export/gear/rd_hardsuit
	cost = 850 //rare
	unit_name = "prototype hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/rd)

/datum/export/gear/sec_hardsuit
	cost = 750
	unit_name = "sec hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/security)

/datum/export/gear/command_hardsuit
	cost = 1300
	unit_name = "command hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/security/hos, /obj/item/clothing/suit/space/hardsuit/captain)

/datum/export/gear/magic_hardsuit
	cost = 3000
	unit_name = "magic hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/wizard, /obj/item/clothing/suit/space/hardsuit/shielded/wizard, /obj/item/clothing/suit/space/hardsuit/cult)
	include_subtypes = TRUE

/datum/export/gear/shield_hardsuit
	cost = 2000
	unit_name = "shielded hardsuit"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/shielded)
	include_subtypes = TRUE

/datum/export/gear/rigs
	cost = 2750
	unit_name = "RIG"
	export_types = list(/obj/item/clothing/suit/space/hardsuit/ancient, /obj/item/clothing/suit/space/hardsuit/ancient/mason)

//Soft Suits

//Blanket
datum/export/gear/space/helmet
	cost = 55
	unit_name = "space helmet"
	export_types = list(/obj/item/clothing/head/helmet/space)
	include_subtypes = TRUE

/datum/export/gear/space/suit
	cost = 60
	unit_name = "space suit"
	export_types = list(/obj/item/clothing/suit/space)
	include_subtypes = TRUE

datum/export/gear/space/helmet/plasma
	cost = 100
	unit_name = "plasmaman space helmet"
	export_types = list(/obj/item/clothing/suit/space/eva/plasmaman)

/datum/export/gear/space/suit/plasma
	cost = 100
	unit_name = "plasmaman space suit"
	export_types = list(/obj/item/clothing/suit/space/eva/plasmaman)

datum/export/gear/space/helmet/synda
	cost = 150 //Flash proof
	unit_name = "syndicate space helmet"
	export_types = list(/obj/item/clothing/head/helmet/space/syndicate)
	include_subtypes = TRUE

/datum/export/gear/space/suit/synda
	cost = 150
	unit_name = "syndicate space suit"
	export_types = list(/obj/item/clothing/head/helmet/space/syndicate)
	include_subtypes = TRUE

//Glasses

//Blanket
datum/export/gear/glasses //glasses are not worth selling
	cost = 3
	unit_name = "glasses"
	export_types = list(/obj/item/clothing/glasses)
	include_subtypes = TRUE

/datum/export/gear/mesons
	cost = 6
	unit_name = "mesons"
	export_types = list(/obj/item/clothing/glasses/meson, /obj/item/clothing/glasses/material/mining)
	include_subtypes = TRUE

/datum/export/gear/scigoggles
	cost = 8
	unit_name = "chem giggles"
	export_types = list(/obj/item/clothing/glasses/science)
	include_subtypes = TRUE

/datum/export/gear/nvgoggles
	cost = 20
	unit_name = "night vison giggles"
	export_types = list(/obj/item/clothing/glasses/night)
	include_subtypes = TRUE

/datum/export/gear/sunglasses
	cost = 12
	unit_name = "sunglasses"
	export_types = list(/obj/item/clothing/glasses/sunglasses)
	include_subtypes = TRUE

/datum/export/gear/huds
	cost = 10
	unit_name = "huds"
	export_types = list(/obj/item/clothing/glasses/hud)
	include_subtypes = TRUE

/datum/export/gear/huds/glasses
	cost = 22
	export_types = list(/obj/item/clothing/glasses/hud/health/sunglasses, /obj/item/clothing/glasses/hud/security/sunglasses)

/datum/export/gear/weldinggoggles
	cost = 20
	unit_name = "welding goggles"
	export_types = list(/obj/item/clothing/glasses/welding)
	include_subtypes = TRUE

/datum/export/gear/thermals
	cost = 30
	unit_name = "heat seeing goggles"
	export_types = list(/obj/item/clothing/glasses/thermal, /obj/item/clothing/glasses/hud/toggle/thermal)
	include_subtypes = TRUE

/datum/export/gear/magic_glasses
	cost = 140
	unit_name = "magic goggles"
	export_types = list(/obj/item/clothing/glasses/godeye, /obj/item/clothing/glasses/hud/health/night/cultblind, /obj/item/clothing/glasses/wraith_spectacles, /obj/item/clothing/glasses/judicial_visor)
	include_subtypes = TRUE

//////////
//UNDER///
//////////

/datum/export/gear/jumpsuit
	cost = 3
	unit_name = "jumpsuit"
	k_elasticity = 1/100 //you can craft white jumpsuits, if someone does that 300 times, they deserve the 800 credits
	export_types = list(/obj/item/clothing/under)
	include_subtypes = TRUE

/datum/export/gear/fancy_jumpsuit
	cost = 10
	unit_name = "fancy clothing"
	k_elasticity = 1/90 //These will be what sells
	export_types = list(/obj/item/clothing/under/suit/white_on_white, /obj/item/clothing/under/suit/sl, /obj/item/clothing/under/misc/vice_officer, /obj/item/clothing/under/suit/black, \
						/obj/item/clothing/under/misc/burial, /obj/item/clothing/under/dress/skirt, /obj/item/clothing/under/rank/captain/parade, /obj/item/clothing/under/rank/security/head_of_security/parade, \
						/obj/item/clothing/under/rank/security/head_of_security/parade/female, /obj/item/clothing/under/misc/assistantformal, /obj/item/clothing/under/dress/striped, /obj/item/clothing/under/dress/redeveninggown, \
						/obj/item/clothing/under/dress/skirt/plaid, /obj/item/clothing/under/costume/geisha, /obj/item/clothing/under/trek, /obj/item/clothing/under/rank)
	include_subtypes = TRUE

/datum/export/gear/armored_jumpsuit
	cost = 15
	unit_name = "armored_jumpsuit"
	k_elasticity = 1/90 //These will be what sells
	export_types = list(/obj/item/clothing/under/misc/durathread, /obj/item/clothing/under/rank/security/officer, /obj/item/clothing/under/plasmaman, /obj/item/clothing/under/syndicate, \
						/obj/item/clothing/under/rank/security/detective, /obj/item/clothing/under/rank/security/head_of_security, /obj/item/clothing/under/rank/security/officer/spacepol)
	exclude_types = list(/obj/item/clothing/under/syndicate/tacticool, /obj/item/clothing/under/syndicate/tacticool/skirt)
	include_subtypes = TRUE

/datum/export/gear/jumpsuit_addon
	cost = 12 //Few and rare as well as quick drop off of vaule
	unit_name = "jumpsuit add on"
	k_elasticity = 1/10
	export_types = list(/obj/item/clothing/accessory)
	include_subtypes = TRUE

/datum/export/gear/robes_magic
	cost = 120
	unit_name = "magic robes"
	export_types = list(/obj/item/clothing/suit/wizrobe, /obj/item/clothing/suit/cultrobes, /obj/item/clothing/suit/magusred, /obj/item/clothing/suit/hooded/cultrobes)
	exclude_types = list(/obj/item/clothing/suit/wizrobe/fake)
	include_subtypes = TRUE

//Amror
/datum/export/gear/armor
	cost = 80
	unit_name = "misc armor"
	export_types = list(/obj/item/clothing/suit/armor)
	include_subtypes = TRUE

/datum/export/gear/sec_armor
	cost = 180
	unit_name = "sec armor"
	export_types = list(/obj/item/clothing/suit/armor/vest/leather, /obj/item/clothing/suit/armor/bulletproof, /obj/item/clothing/suit/armor/vest/det_suit)
	include_subtypes = TRUE

/datum/export/gear/hosarmor
	cost = 380
	unit_name = "hos armor"
	export_types = list(/obj/item/clothing/suit/armor/hos)
	include_subtypes = TRUE

/datum/export/gear/wardenarmor
	cost = 280
	unit_name = "warden armor"
	export_types = list(/obj/item/clothing/suit/armor/vest/warden)
	include_subtypes = TRUE

/datum/export/gear/reflector
	cost = 500
	unit_name = "reflector armor"
	export_types = list(/obj/item/clothing/suit/armor/laserproof)
	include_subtypes = TRUE

/datum/export/gear/heavy_armor
	cost = 600 //REALY hard to fine/make takes lots of slimes
	unit_name = "heavy armor"
	export_types = list(/obj/item/clothing/suit/armor/heavy)
	include_subtypes = TRUE

/datum/export/gear/plate_armor
	cost = 200
	unit_name = "plate armor"
	export_types = list(/obj/item/clothing/suit/armor/riot/knight)
	include_subtypes = TRUE

/datum/export/gear/riot_armor
	cost = 250
	unit_name = "riot armor"
	export_types = list(/obj/item/clothing/suit/armor/riot)
	include_subtypes = TRUE

/datum/export/gear/bone_armor
	cost = 50
	unit_name = "bone armor"
	export_types = list(/obj/item/clothing/suit/armor/bone)
	include_subtypes = TRUE

/datum/export/gear/swat_armor
	cost = 350
	unit_name = "swat mki armor"
	export_types = list(/obj/item/clothing/suit/space/swat)
	include_subtypes = TRUE

/datum/export/gear/dragon_armor
	cost = 750
	unit_name = "drake bone armor"
	export_types = list(/obj/item/clothing/suit/hooded/cloak/drake)
	include_subtypes = TRUE

/datum/export/gear/commandamor
	cost = 480
	unit_name = "command armor"
	export_types = list(/obj/item/clothing/suit/armor/vest/capcarapace, /obj/item/clothing/suit/armor/centcom)
	include_subtypes = TRUE

/datum/export/gear/reactive_base
	cost = 600
	k_elasticity = 1/2 //Lets not go over board
	unit_name = "hollow reactive armor"
	export_types = list(/obj/item/reactive_armour_shell, /obj/item/clothing/suit/armor/reactive)

/datum/export/gear/reactive_active
	cost = 1200
	k_elasticity = 1/3 //Lets not go over board
	unit_name = "working reactive armor"
	export_types = list(/obj/item/clothing/suit/armor/reactive/repulse, /obj/item/clothing/suit/armor/reactive/tesla, /obj/item/clothing/suit/armor/reactive/teleport)

///////////////////////////
//Bomb/Rad/Bio Suits/Fire//
///////////////////////////

/datum/export/gear/radhelmet
	cost = 20
	unit_name = "radsuit hood"
	export_types = list(/obj/item/clothing/head/radiation)

/datum/export/gear/radsuit
	cost = 40
	unit_name = "radsuit"
	export_types = list(/obj/item/clothing/suit/radiation)

/datum/export/gear/firehelmet
	cost = 10
	unit_name = "firesuit helmet"
	export_types = list(/obj/item/clothing/head/hardhat/red)

/datum/export/gear/fireatmos
	cost = 120
	unit_name = "atmos firesuit"
	export_types = list(/obj/item/clothing/suit/fire/atmos)

/datum/export/gear/firesuit
	cost = 20
	unit_name = "firesuit"
	export_types = list(/obj/item/clothing/suit/fire, /obj/item/clothing/suit/fire/firefighter, /obj/item/clothing/suit/fire/heavy)

/datum/export/gear/biohood
	cost = 40
	unit_name = "biosuit hood"
	export_types = list(/obj/item/clothing/head/bio_hood)
	include_subtypes = TRUE

/datum/export/gear/biosuit
	cost = 60
	unit_name = "biosuit"
	export_types = list(/obj/item/clothing/suit/bio_suit)
	include_subtypes = TRUE

/datum/export/gear/bombhelmet
	cost = 40
	unit_name = "bomb suit hood"
	export_types = list(/obj/item/clothing/head/bomb_hood)
	include_subtypes = TRUE

/datum/export/gear/bombsuit
	cost = 60
	unit_name = "bomb suit"
	export_types = list(/obj/item/clothing/suit/bomb_suit)
	include_subtypes = TRUE

////////////////////
//Cloaks and Coats//
////////////////////

/datum/export/gear/cloaks
	cost = 30
	unit_name = "cloak"
	export_types = list(/obj/item/clothing/neck/cloak)
	include_subtypes = TRUE

/datum/export/gear/cloaksmining
	cost = 90
	unit_name = "lava land cloak"
	export_types = list(/obj/item/clothing/suit/hooded/cloak/goliath)
	include_subtypes = TRUE

/datum/export/gear/labcoats
	cost = 15
	unit_name = "labcoats"
	export_types = list(/obj/item/clothing/suit/toggle/labcoat)
	include_subtypes = TRUE

/datum/export/gear/wintercoats
	cost = 25
	unit_name = "wintercoats"
	export_types = list(/obj/item/clothing/suit/hooded/wintercoat)
	include_subtypes = TRUE

//////////
//SUITS///
//////////

/datum/export/gear/suits
	cost = 40
	unit_name = "suit"
	export_types = list(/obj/item/clothing/suit)
	include_subtypes = TRUE

//////////////////////
//Chameleon Gear//////
//////////////////////
/datum/export/gear/chameleon //Selling a full kit is easy money for 2 tc
	cost = 280
	k_elasticity = 0
	unit_name = "chameleon item"
	export_types = list(/obj/item/clothing/head/chameleon, /obj/item/clothing/mask/chameleon, /obj/item/clothing/under/chameleon, /obj/item/clothing/suit/chameleon, /obj/item/clothing/glasses/chameleon,\
						/obj/item/clothing/gloves/chameleon, /obj/item/clothing/head/chameleon, /obj/item/clothing/shoes/chameleon, /obj/item/storage/backpack/chameleon, \
						/obj/item/storage/belt/chameleon, /obj/item/radio/headset/chameleon, /obj/item/pda/chameleon, /obj/item/stamp/chameleon, /obj/item/clothing/neck/cloak/chameleon)
	include_subtypes = TRUE