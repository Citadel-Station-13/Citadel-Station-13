//This is the file that handles donator loadout items.

/datum/gear/donator
	name = "IF YOU SEE THIS, PING A CODER RIGHT NOW!"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/bikehorn/golden
	category = LOADOUT_CATEGORY_DONATOR
	ckeywhitelist = list("This entry should never appear with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard

/datum/gear/donator/pet
	name = "Pet Beacon"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/choice_beacon/pet
	ckeywhitelist = list()
	donator_group_id = DONATOR_GROUP_TIER_1 // can be accessed by all donators

/datum/gear/donator/carpet
	name = "Carpet Beacon"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/choice_beacon/box/carpet
	ckeywhitelist = list()
	donator_group_id = DONATOR_GROUP_TIER_1

/datum/gear/donator/chameleon_bedsheet
	name = "Chameleon Bedsheet"
	slot = ITEM_SLOT_NECK
	path = /obj/item/bedsheet/chameleon
	ckeywhitelist = list()
	donator_group_id = DONATOR_GROUP_TIER_1

/datum/gear/donator/donortestingbikehorn
	name = "Donor item testing bikehorn"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/bikehorn
	geargroupID = list("DONORTEST") //This is a list mainly for the sake of testing, but geargroupID works just fine with ordinary strings

/datum/gear/donator/kevhorn
	name = "Airhorn"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/bikehorn/airhorn
	ckeywhitelist = list("kevinz000")

/datum/gear/donator/kiaracloak
	name = "Kiara's cloak"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/cloak/inferno
	ckeywhitelist = list("inferno707")

/datum/gear/donator/kiaracollar
	name = "Kiara's collar"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/petcollar/inferno
	ckeywhitelist = list("inferno707")

/datum/gear/donator/kiaramedal
	name = "Insignia of Steele"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/accessory/medal/steele
	ckeywhitelist = list("inferno707")

/datum/gear/donator/hheart
	name = "The Hollow Heart"
	slot = ITEM_SLOT_MASK
	path = /obj/item/clothing/mask/hheart
	ckeywhitelist = list("inferno707")

/datum/gear/donator/engravedzippo
	name = "Engraved zippo"
	slot = ITEM_SLOT_HANDS
	path = /obj/item/lighter/gold
	ckeywhitelist = list("dirtyoldharry")

/datum/gear/donator/geisha
	name = "Geisha suit"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/costume/geisha
	ckeywhitelist = list("atiefling")

/datum/gear/donator/specialscarf
	name = "Special scarf"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/scarf/zomb
	ckeywhitelist = list("zombierobin")

/datum/gear/donator/redmadcoat
	name = "The Mad's labcoat"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/toggle/labcoat/mad/red
	ckeywhitelist = list("zombierobin")

/datum/gear/donator/santahat
	name = "Santa hat"
	slot = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/santa/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/donator/reindeerhat
	name = "Reindeer hat"
	slot = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/hardhat/reindeer/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/donator/treeplushie
	name = "Christmas tree plushie"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/plush/tree
	ckeywhitelist = list("illotafv")

/datum/gear/donator/santaoutfit
	name = "Santa costume"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/space/santa/fluff
	ckeywhitelist = list("illotafv")

/datum/gear/donator/treecloak
	name = "Christmas tree cloak"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/cloak/festive
	ckeywhitelist = list("illotafv")

/datum/gear/donator/carrotplush
	name = "Carrot plushie"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/plush/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donator/carrotcloak
	name = "Carrot cloak"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/cloak/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donator/albortorosamask
	name = "Alborto Rosa mask"
	slot = ITEM_SLOT_MASK
	path = /obj/item/clothing/mask/luchador/zigfie
	ckeywhitelist = list("zigfie")

/datum/gear/donator/mankini
	name = "Mankini"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/misc/stripper/mankini
	ckeywhitelist = list("zigfie")

/datum/gear/donator/pinkshoes
	name = "Pink shoes"
	slot = ITEM_SLOT_FEET
	path = /obj/item/clothing/shoes/sneakers/pink
	ckeywhitelist = list("zigfie")

/datum/gear/donator/reecesgreatcoat
	name = "Reece's Great Coat"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/trenchcoat/green
	ckeywhitelist = list("geemiesif")

/datum/gear/donator/russianflask
	name = "Russian flask"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/reagent_containers/food/drinks/flask/russian
	cost = 2
	ckeywhitelist = list("slomka")

/datum/gear/donator/stalkermask
	name = "S.T.A.L.K.E.R. mask"
	slot = ITEM_SLOT_MASK
	path = /obj/item/clothing/mask/gas/stalker
	ckeywhitelist = list("slomka")

/datum/gear/donator/stripedcollar
	name = "Striped collar"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/petcollar/stripe
	ckeywhitelist = list("jademanique")

/datum/gear/donator/performersoutfit
	name = "Bluish performer's outfit"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/costume/singer/yellow/custom
	ckeywhitelist = list("killer402402")

/datum/gear/donator/vermillion
	name = "Vermillion clothing"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/suit/vermillion
	ckeywhitelist = list("fractious")

/datum/gear/donator/AM4B
	name = "Foam Force AM4-B"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/gun/ballistic/automatic/AM4B
	ckeywhitelist = list("zeronetalpha")

/datum/gear/donator/carrotsatchel
	name = "Carrot Satchel"
	slot = ITEM_SLOT_HANDS
	path = /obj/item/storage/backpack/satchel/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donator/naomisweater
	name = "worn black sweater"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/sweater/black/naomi
	ckeywhitelist = list("technicalmagi")

/datum/gear/donator/naomicollar
	name = "worn pet collar"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/petcollar/naomi
	ckeywhitelist = list("technicalmagi")

/datum/gear/donator/gladiator
	name = "Gladiator Armor"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/under/costume/gladiator
	ckeywhitelist = list("aroche")

/datum/gear/donator/bloodredtie
	name = "Blood Red Tie"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/tie/bloodred
	ckeywhitelist = list("kyutness")

/datum/gear/donator/puffydress
	name = "Puffy Dress"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/puffydress
	ckeywhitelist = list("stallingratt")

/datum/gear/donator/labredblack
	name = "Black and Red Coat"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/toggle/labcoat/labredblack
	ckeywhitelist = list("blakeryan", "durandalphor")

/datum/gear/donator/torisword
	name = "Rainbow Zweihander"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/dualsaber/hypereutactic/toy/rainbow
	ckeywhitelist = list("annoymous35")

/datum/gear/donator/darksabre
	name = "Dark Sabre"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/darksabre
	ckeywhitelist = list("inferno707")

/datum/gear/donator/darksabresheath
	name = "Dark Sabre Sheath"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/storage/belt/sabre/darksabre
	ckeywhitelist = list("inferno707")

/datum/gear/donator/toriball
	name = "Rainbow Tennis Ball"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/fluff/tennis_poly/tri/squeak/rainbow
	ckeywhitelist = list("annoymous35")

/datum/gear/donator/izzyball
	name = "Katlin's Ball"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/fluff/tennis_poly/tri/squeak/izzy
	ckeywhitelist = list("izzyinbox")

/datum/gear/donator/cloak
	name = "Green Cloak"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/cloak/green
	ckeywhitelist = list("killer402402")

/datum/gear/donator/steelflask
	name = "Steel Flask"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/reagent_containers/food/drinks/flask/steel
	cost = 2
	ckeywhitelist = list("nik707")

/datum/gear/donator/paperhat
	name = "Paper Hat"
	slot = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/paperhat
	ckeywhitelist = list("kered2")

/datum/gear/donator/cloakce
	name = "Polychromic CE Cloak"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/neck/cloak/polychromic/polyce
	ckeywhitelist = list("worksbythesea", "blakeryan")
	loadout_flags = LOADOUT_CAN_COLOR_POLYCHROMIC
	loadout_initial_colors = list("#808080", "#8CC6FF", "#FF3535")

/datum/gear/donator/ssk
	name = "Stun Sword Kit"
	slot = ITEM_SLOT_BACKPACK
	path = 	/obj/item/ssword_kit
	ckeywhitelist = list("phillip458")

/datum/gear/donator/techcoat
	name = "Techomancers Labcoat"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/suit/toggle/labcoat/mad/techcoat
	ckeywhitelist = list("wilchen")

/datum/gear/donator/leechjar
	name = "Jar of Leeches"
	slot = ITEM_SLOT_BACKPACK
	path = 	/obj/item/custom/leechjar
	ckeywhitelist = list("sgtryder")

/datum/gear/donator/darkarmor
	name = "Dark Armor"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/suit/armor/vest/darkcarapace
	ckeywhitelist = list("inferno707")

/datum/gear/donator/devilwings
	name = "Strange Wings"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/devilwings
	ckeywhitelist = list("kitsun")

/datum/gear/donator/flagcape
	name = "US Flag Cape"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/neck/flagcape
	ckeywhitelist = list("darnchacha")

/datum/gear/donator/luckyjack
	name = "Lucky Jackboots"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/shoes/lucky
	ckeywhitelist = list("donaldtrumpthecommunist")

/datum/gear/donator/raiqbawks
	name = "Miami Boombox"
	slot = ITEM_SLOT_HANDS
	cost = 2
	path = /obj/item/boombox/raiq
	ckeywhitelist = list("chefferz")

/datum/gear/donator/m41
	name = "Toy M41"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/gun/m41
	ckeywhitelist = list("thalverscholen")

/datum/gear/donator/Divine_robes
	name = "Divine robes"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/custom/lunasune
	ckeywhitelist = list("invader4352")

/datum/gear/donator/gothcoat
	name = "Goth Coat"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/gothcoat
	ckeywhitelist = list("norko")

/datum/gear/donator/corgisuit
	name = "Corgi Suit"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/hooded/ian_costume
	ckeywhitelist = list("cathodetherobot")

/datum/gear/donator/sharkcloth
	name = "Leon's Skimpy Outfit"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/under/custom/leoskimpy
	ckeywhitelist = list("spectrosis")

/datum/gear/donator/mimemask
	name = "Mime Mask"
	slot = ITEM_SLOT_MASK
	path = /obj/item/clothing/mask/gas/mime
	ckeywhitelist = list("pireamaineach")

/datum/gear/donator/mimeoveralls
	name = "Mime's Overalls"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/under/custom/mimeoveralls
	ckeywhitelist = list("pireamaineach")

/datum/gear/donator/soulneck
	name = "Soul Necklace"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/undertale
	ckeywhitelist = list("twilightic")

/datum/gear/donator/frenchberet
	name = "French Beret"
	slot = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/frenchberet
	ckeywhitelist = list("notazoltan")

/datum/gear/donator/zuliecloak
	name = "Project: Zul-E"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/hooded/cloak/zuliecloak
	ckeywhitelist = list("asky")

/datum/gear/donator/blackredgold
	name = "Black, Red, and Gold Coat"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/blackredgold
	ckeywhitelist = list("ttbnc")

/datum/gear/donator/fritzplush
	name = "Fritz Plushie"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/plush/mammal/dog/fritz
	ckeywhitelist = list("analwerewolf")

/datum/gear/donator/kimono
	name = "Kimono"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/kimono
	ckeywhitelist = list("sfox63")

/datum/gear/donator/commjacket
	name = "Dusty Commisar's Cloak"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/commjacket
	ckeywhitelist = list("sadisticbatter")

/datum/gear/donator/mw2_russian_para
	name = "Russian Paratrooper Jumper"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/custom/mw2_russian_para
	ckeywhitelist = list("investigator77")

/datum/gear/donator/longblackgloves
	name = "Luna's Gauntlets"
	slot = ITEM_SLOT_GLOVES
	path = /obj/item/clothing/gloves/longblackgloves
	ckeywhitelist = list("bigmanclancy")

/datum/gear/donator/trendy_fit
	name = "Trendy Fit"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/custom/trendy_fit
	ckeywhitelist = list("midgetdragon")

/datum/gear/donator/singery
	name = "Yellow Performer Outfit"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/costume/singer/yellow
	ckeywhitelist = list("maxlynchy")

/datum/gear/donator/csheet
	name = "NT Bedsheet"
	slot = ITEM_SLOT_NECK
	path = /obj/item/bedsheet/captain
	ckeywhitelist = list("tikibomb")

/datum/gear/donator/borgplush
	name = "Robot Plush"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/toy/plush/borgplushie
	ckeywhitelist = list("nicholaiavenicci")

/datum/gear/donator/donorberet
	name = "Atmos Beret"
	slot = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/blueberet
	ckeywhitelist = list("foxystalin")

/datum/gear/donator/donorgoggles
	name = "Flight Goggles"
	slot = ITEM_SLOT_HEAD
	path = /obj/item/clothing/head/flight
	ckeywhitelist = list("maxlynchy")

/datum/gear/donator/onionneck
	name = "Onion Necklace"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/necklace/onion
	ckeywhitelist = list("cdrcross")

/datum/gear/donator/mikubikini
	name = "starlight singer bikini"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/custom/mikubikini
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikujacket
	name = "starlight singer jacket"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/mikujacket
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikuhair
	name = "starlight singer hair"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/head/mikuhair
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikugloves
	name = "starlight singer gloves"
	slot = ITEM_SLOT_GLOVES
	path = /obj/item/clothing/gloves/mikugloves
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikuleggings
	name = "starlight singer leggings"
	slot = ITEM_SLOT_FEET
	path = /obj/item/clothing/shoes/sneakers/mikuleggings
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/cosmos
	name = "cosmic space bedsheet"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/bedsheet/cosmos
	ckeywhitelist = list("grunnyyy")

/datum/gear/donator/customskirt
	name = "custom atmos skirt"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/under/custom/customskirt
	ckeywhitelist = list("thakyz")

/datum/gear/donator/hisakaki
	name = "halo"
	slot = ITEM_SLOT_HEAD
	path = 	/obj/item/clothing/head/halo
	ckeywhitelist = list("hisakaki")

/datum/gear/donator/vest
	name = "vest and shirt"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/custom/vest
	ckeywhitelist = list("maylowfox")

/datum/gear/donator/exo
	name = "exo frame"
	slot = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/custom/exo
	ckeywhitelist = list("jesterz7")

/datum/gear/donator/choker
	name = "NT Choker"
	slot = ITEM_SLOT_NECK
	path = /obj/item/clothing/neck/petcollar/donorchoker
	ckeywhitelist = list("trigillass")

/datum/gear/donator/strangemask
	name = "Strange Metal Mask"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/mask/breath/mmask
	ckeywhitelist = list("sneka")

/datum/gear/donator/smaiden
	name = "shrine maiden outfit"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/smaiden
	ckeywhitelist = list("ultimarifox")

/datum/gear/donator/mgasmask
	name = "Military Gas Mask"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/clothing/mask/gas/military
	ckeywhitelist = list("unclebourbon")

/datum/gear/donator/clownmask
	name = "Clown Mask"
	path = ITEM_SLOT_MASK
	path = /obj/item/clothing/mask/gas/clown_hat
	ckeywhitelist = list("djkouta")

/datum/gear/donator/spacehoodie
	name = "Space Hoodie"
	path = ITEM_SLOT_OCLOTHING
	path = /obj/item/clothing/suit/spacehoodie
	ckeywhitelist = list("bidlink2")

/datum/gear/donator/pokerchips
	name = "pokerchip set"
	slot = ITEM_SLOT_BACKPACK
	path = /obj/item/storage/box/pockerchips
	ckeywhitelist = list("greed2323")

/datum/gear/donator/psychedelicjumpsuit
	name = "psychedelic jumpsuit"
	slot = ITEM_SLOT_ICLOTHING
	path = /obj/item/clothing/under/misc/psyche
	ckeywhitelist = list("commandnotrecognized")

