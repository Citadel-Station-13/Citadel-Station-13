/obj/item/vending_refill/wardrobe
	icon_state = "refill_clothes"

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper SecDrobe"
	desc = "A vending machine for security and security-related clothing!"
	icon_state = "secdrobe"
	product_ads = "Beat perps in style!;It's red so you can't see the blood!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	vend_reply = "Thank you for using the SecDrobe!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/security = 2,
					/obj/item/storage/backpack/security = 2,
					/obj/item/storage/backpack/satchel/sec = 2,
					/obj/item/storage/backpack/duffelbag/sec = 3,
					/obj/item/clothing/under/rank/security/officer = 5,
					/obj/item/clothing/shoes/jackboots = 5,
					/obj/item/clothing/head/beret/sec =5,
					/obj/item/clothing/head/soft/sec = 5,
					/obj/item/clothing/mask/bandana/red = 5,
					/obj/item/clothing/under/rank/security/officer/skirt = 5,
					/obj/item/clothing/under/rank/security/officer/grey = 5,
					/obj/item/clothing/under/pants/khaki = 5)
	premium = list(/obj/item/clothing/under/rank/security/officer/formal = 5,
					/obj/item/clothing/head/beret/sec/navyofficer = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/sec_wardrobe

/obj/item/vending_refill/wardrobe/sec_wardrobe
	machine_name = "SecDrobe"

/obj/machinery/vending/wardrobe/medi_wardrobe
	name = "\improper MediDrobe"
	desc = "A vending machine rumoured to be capable of dispensing clothing for medical personnel."
	icon_state = "medidrobe"
	product_ads = "Make those blood stains look fashionable!!"
	vend_reply = "Thank you for using the MediDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 5,
					/obj/item/clothing/head/beret/med = 5,
					/obj/item/storage/backpack/duffelbag/med = 5,
					/obj/item/storage/backpack/medic = 5,
					/obj/item/storage/backpack/satchel/med = 5,
					/obj/item/clothing/suit/hooded/wintercoat/medical = 5,
					/obj/item/clothing/under/rank/medical/doctor/nurse = 5,
					/obj/item/clothing/head/nursehat = 5,
					/obj/item/clothing/under/rank/medical/doctor/skirt= 5,
					/obj/item/clothing/under/rank/medical/doctor/blue = 5,
					/obj/item/clothing/under/rank/medical/doctor/green = 5,
					/obj/item/clothing/under/rank/medical/doctor/purple = 5,
					/obj/item/clothing/under/rank/medical/doctor = 5,
					/obj/item/clothing/under/rank/medical/paramedic = 5,
					/obj/item/clothing/under/rank/medical/paramedic/light = 5,
					/obj/item/clothing/under/rank/medical/paramedic/skirt = 5,
					/obj/item/clothing/under/rank/medical/paramedic/skirt/light = 5,
					/obj/item/clothing/suit/toggle/labcoat = 5,
					/obj/item/clothing/suit/toggle/labcoat/paramedic = 5,
					/obj/item/clothing/suit/toggle/labcoat/emt = 5,
					/obj/item/clothing/shoes/sneakers/white = 5,
					/obj/item/clothing/head/soft/emt = 5,
					/obj/item/clothing/suit/apron/surgical = 5,
					/obj/item/clothing/mask/surgical = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/medi_wardrobe

/obj/item/vending_refill/wardrobe/medi_wardrobe
	machine_name = "MediDrobe"

/obj/machinery/vending/wardrobe/engi_wardrobe
	name = "EngiDrobe"
	desc = "A vending machine renowned for vending industrial grade clothing."
	icon_state = "engidrobe"
	product_ads = "Guaranteed to protect your feet from industrial accidents!;Afraid of radiation? Then wear yellow!"
	vend_reply = "Thank you for using the EngiDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 5,
					/obj/item/clothing/head/beret/eng = 3,
					/obj/item/storage/backpack/duffelbag/engineering = 3,
					/obj/item/storage/backpack/industrial = 3,
					/obj/item/storage/backpack/satchel/eng = 3,
					/obj/item/clothing/suit/hooded/wintercoat/engineering = 3,
					/obj/item/clothing/under/rank/engineering/engineer = 5,
					/obj/item/clothing/under/rank/engineering/engineer/skirt = 5,
					/obj/item/clothing/suit/hazardvest = 5,
					/obj/item/clothing/shoes/workboots = 5,
					/obj/item/clothing/head/hardhat = 5,
					/obj/item/clothing/head/hardhat/weldhat = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/engi_wardrobe

/obj/item/vending_refill/wardrobe/engi_wardrobe
	machine_name = "EngiDrobe"

/obj/machinery/vending/wardrobe/atmos_wardrobe
	name = "AtmosDrobe"
	desc = "This relatively unknown vending machine delivers clothing for Atmospherics Technicians, an equally unknown job."
	icon_state = "atmosdrobe"
	product_ads = "Get your inflammable clothing right here!!!"
	vend_reply = "Thank you for using the AtmosDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 3,
					/obj/item/clothing/head/beret/atmos = 3,
					/obj/item/storage/backpack/duffelbag/engineering = 3,
					/obj/item/storage/backpack/satchel/eng = 3,
					/obj/item/storage/backpack/industrial = 3,
					/obj/item/clothing/head/hardhat/weldhat/dblue = 3,
					/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos = 3,
					/obj/item/clothing/under/rank/engineering/atmospheric_technician = 5,
					/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt = 5,
					/obj/item/clothing/shoes/sneakers/black = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/atmos_wardrobe

/obj/item/vending_refill/wardrobe/atmos_wardrobe
	machine_name = "AtmosDrobe"

/obj/machinery/vending/wardrobe/cargo_wardrobe
	name = "CargoDrobe"
	desc = "A highly advanced vending machine for buying cargo related clothing for free."
	icon_state = "cargodrobe"
	product_ads = "Upgraded Assistant Style! Pick yours today!;These shorts are comfy and easy to wear, get yours now!"
	vend_reply = "Thank you for using the CargoDrobe!"
	products = list(/obj/item/clothing/suit/hooded/wintercoat/cargo = 3,
					/obj/item/clothing/under/rank/cargo/tech = 5,
					/obj/item/clothing/under/rank/cargo/tech/skirt = 5,
					/obj/item/clothing/shoes/sneakers/black = 5,
					/obj/item/clothing/gloves/fingerless = 5,
					/obj/item/clothing/head/soft = 5,
					/obj/item/radio/headset/headset_cargo = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/cargo_wardrobe

/obj/item/vending_refill/wardrobe/cargo_wardrobe
	machine_name = "CargoDrobe"

/obj/machinery/vending/wardrobe/robo_wardrobe
	name = "RoboDrobe"
	desc = "A vending machine designed to dispense clothing known only to roboticists."
	icon_state = "robodrobe"
	product_ads = "You turn me TRUE, use defines!;0110001101101100011011110111010001101000011001010111001101101000011001010111001001100101"
	vend_reply = "Thank you for using the RoboDrobe!"
	products = list(/obj/item/clothing/glasses/hud/diagnostic = 3,
					/obj/item/clothing/head/beret/robo = 3,
					/obj/item/clothing/under/rank/rnd/roboticist = 3,
					/obj/item/clothing/under/rank/rnd/roboticist/skirt = 3,
					/obj/item/clothing/suit/hooded/wintercoat/robotics = 3,
					/obj/item/clothing/suit/toggle/labcoat = 3,
					/obj/item/clothing/shoes/sneakers/black = 3,
					/obj/item/clothing/gloves/fingerless = 3,
					/obj/item/clothing/head/soft/black = 3,
					/obj/item/clothing/mask/bandana/skull = 2)
	contraband = list(/obj/item/clothing/suit/hooded/techpriest = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/robo_wardrobe

/obj/item/vending_refill/wardrobe/robo_wardrobe
	machine_name = "RoboDrobe"

/obj/machinery/vending/wardrobe/science_wardrobe
	name = "SciDrobe"
	desc = "A simple vending machine suitable to dispense well tailored science clothing. Endorsed by Cubans."
	icon_state = "scidrobe"
	product_ads = "Longing for the smell of flesh plasma? Buy your science clothing now!;Made with 10% Auxetics, so you don't have to worry losing your arm!"
	vend_reply = "Thank you for using the SciDrobe!"
	products = list(/obj/item/clothing/accessory/pocketprotector = 5,
					/obj/item/clothing/head/beret/sci = 3,
					/obj/item/storage/backpack/science = 3,
					/obj/item/storage/backpack/satchel/tox = 3,
					/obj/item/clothing/suit/hooded/wintercoat/science = 3,
					/obj/item/clothing/under/rank/rnd/scientist = 4,
					/obj/item/clothing/under/rank/rnd/scientist/skirt = 4,
					/obj/item/clothing/suit/toggle/labcoat/science = 4,
					/obj/item/clothing/shoes/sneakers/white = 4,
					/obj/item/radio/headset/headset_sci = 4,
					/obj/item/clothing/mask/gas = 5)
	refill_canister = /obj/item/vending_refill/wardrobe/science_wardrobe

/obj/item/vending_refill/wardrobe/science_wardrobe
	machine_name = "SciDrobe"

/obj/machinery/vending/wardrobe/hydro_wardrobe
	name = "Hydrobe"
	desc = "A machine with a catchy name. It dispenses botany related clothing and gear."
	icon_state = "hydrobe"
	product_ads = "Do you love soil? Then buy our clothes!;Get outfits to match your green thumb here!"
	vend_reply = "Thank you for using the Hydrobe!"
	products = list(/obj/item/storage/backpack/botany = 3,
					/obj/item/storage/backpack/satchel/hyd = 3,
					/obj/item/clothing/suit/hooded/wintercoat/hydro = 2,
					/obj/item/clothing/suit/apron = 3,
					/obj/item/clothing/suit/apron/overalls = 5,
					/obj/item/clothing/under/rank/civilian/hydroponics = 5,
					/obj/item/clothing/under/rank/civilian/hydroponics/skirt = 5,
					/obj/item/clothing/mask/bandana = 4)
	refill_canister = /obj/item/vending_refill/wardrobe/hydro_wardrobe

/obj/item/vending_refill/wardrobe/hydro_wardrobe
	machine_name = "HyDrobe"

/obj/machinery/vending/wardrobe/curator_wardrobe
	name = "CuraDrobe"
	desc = "A lowstock vendor only capable of vending clothing for curators and librarians."
	icon_state = "curadrobe"
	product_ads = "Glasses for your eyes and literature for your soul, Curadrobe has it all!; Impress & enthrall your library guests with Curadrobe's extended line of pens!"
	vend_reply = "Thank you for using the CuraDrobe!"
	products = list(/obj/item/pen = 4,
					/obj/item/pen/red = 2,
					/obj/item/pen/blue = 2,
					/obj/item/pen/fourcolor = 1,
					/obj/item/pen/fountain = 2,
					/obj/item/clothing/accessory/pocketprotector = 2,
					/obj/item/clothing/under/rank/civilian/curator/skirt = 2,
					/obj/item/clothing/under/rank/captain/suit/skirt = 2,
					/obj/item/clothing/under/rank/civilian/head_of_personnel/suit/skirt = 2,
					/obj/item/storage/backpack/satchel/explorer = 1,
					/obj/item/clothing/glasses/regular = 2,
					/obj/item/clothing/glasses/regular/jamjar = 1,
					/obj/item/storage/bag/books = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/curator_wardrobe

/obj/item/vending_refill/wardrobe/curator_wardrobe
	machine_name = "CuraDrobe"

/obj/machinery/vending/wardrobe/bar_wardrobe
	name = "BarDrobe"
	desc = "A stylish vendor to dispense the most stylish bar clothing!"
	icon_state = "bardrobe"
	product_ads = "Guaranteed to prevent stains from spilled drinks!"
	vend_reply = "Thank you for using the BarDrobe!"
	products = list(/obj/item/clothing/head/that = 3,
					/obj/item/radio/headset/headset_srv = 3,
					/obj/item/clothing/under/suit/sl = 3,
					/obj/item/clothing/under/rank/civilian/bartender = 3,
					/obj/item/clothing/under/rank/civilian/bartender/skirt = 2,
					/obj/item/clothing/under/rank/civilian/bartender/purple = 2,
					/obj/item/clothing/accessory/waistcoat = 3,
					/obj/item/clothing/suit/apron/purple_bartender = 2,
					/obj/item/clothing/head/soft/black = 4,
					/obj/item/clothing/shoes/sneakers/black = 4,
					/obj/item/reagent_containers/rag = 4,
					/obj/item/storage/box/beanbag = 1,
					/obj/item/clothing/suit/armor/vest/alt = 1,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/glasses/sunglasses/reagent = 1,
					/obj/item/clothing/neck/petcollar = 3,
					/obj/item/storage/belt/bandolier = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/bar_wardrobe

/obj/item/vending_refill/wardrobe/bar_wardrobe
	machine_name = "BarDrobe"

/obj/machinery/vending/wardrobe/chef_wardrobe
	name = "ChefDrobe"
	desc = "This vending machine might not dispense meat, but it certainly dispenses chef related clothing."
	icon_state = "chefdrobe"
	product_ads = "Our clothes are guaranteed to protect you from food splatters!;Now stocking recipe books!"
	vend_reply = "Thank you for using the ChefDrobe!;Just like your grandmother's old recipes!"
	products = list(/obj/item/clothing/under/suit/waiter = 3,
					/obj/item/radio/headset/headset_srv = 4,
					/obj/item/clothing/accessory/waistcoat = 3,
					/obj/item/clothing/suit/apron/chef = 3,
					/obj/item/clothing/head/soft/mime = 2,
					/obj/item/storage/box/mousetraps = 2,
					/obj/item/circuitboard/machine/dish_drive = 1,
					/obj/item/clothing/suit/toggle/chef = 2,
					/obj/item/clothing/under/rank/civilian/chef = 2,
					/obj/item/clothing/under/rank/civilian/chef/skirt = 2,
					/obj/item/clothing/head/chefhat = 2,
					/obj/item/reagent_containers/rag = 3,
					/obj/item/book/granter/crafting_recipe/cooking_sweets_101 = 2,
					/obj/item/book/granter/crafting_recipe/coldcooking = 2)
	refill_canister = /obj/item/vending_refill/wardrobe/chef_wardrobe

/obj/item/vending_refill/wardrobe/chef_wardrobe
	machine_name = "ChefDrobe"

/obj/machinery/vending/wardrobe/jani_wardrobe
	name = "JaniDrobe"
	desc = "A self cleaning vending machine capable of dispensing clothing for janitors."
	icon_state = "janidrobe"
	product_ads = "Come and get your janitorial clothing, now endorsed by lizard janitors everywhere!"
	vend_reply = "Thank you for using the JaniDrobe!"
	products = list(/obj/item/clothing/under/rank/civilian/janitor = 2,
					/obj/item/clothing/under/rank/civilian/janitor/skirt = 2,
					/obj/item/clothing/suit/hooded/wintercoat/janitor = 3,
					/obj/item/cartridge/janitor = 3,
					/obj/item/clothing/gloves/color/black = 2,
					/obj/item/clothing/head/soft/purple = 2,
					/obj/item/twohanded/broom = 2,
					/obj/item/paint/paint_remover = 2,
					/obj/item/melee/flyswatter = 2,
					/obj/item/flashlight = 2,
					/obj/item/caution = 8,
					/obj/item/holosign_creator = 2,
					/obj/item/lightreplacer = 2,
					/obj/item/soap = 2,
					/obj/item/storage/bag/trash = 2,
					/obj/item/clothing/shoes/galoshes = 2,
					/obj/item/watertank/janitor = 2,
					/obj/item/storage/belt/janitor = 2,
					/obj/item/screwdriver = 2,
					/obj/item/stack/cable_coil/random = 4)
	refill_canister = /obj/item/vending_refill/wardrobe/jani_wardrobe

/obj/item/vending_refill/wardrobe/jani_wardrobe
	machine_name = "JaniDrobe"

/obj/machinery/vending/wardrobe/law_wardrobe
	name = "LawDrobe"
	desc = "Objection! This wardrobe dispenses the rule of law... and lawyer clothing."
	icon_state = "lawdrobe"
	product_ads = "OBJECTION! Get the rule of law for yourself!"
	vend_reply = "Thank you for using the LawDrobe!"
	products = list(/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/purpsuit = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/female = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/female/skirt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/really_black = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/really_black/skirt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/blue = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/blue/skirt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/red = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/red/skirt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/black = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/black/skirt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/black/alt = 3,
					/obj/item/clothing/under/rank/civilian/lawyer/black/alt/skirt = 3,
					/obj/item/clothing/suit/toggle/lawyer = 3,
					/obj/item/clothing/suit/toggle/lawyer/purple = 3,
					/obj/item/clothing/suit/toggle/lawyer/black = 3,
					/obj/item/clothing/shoes/laceup = 3,
					/obj/item/clothing/accessory/lawyers_badge = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/law_wardrobe

/obj/item/vending_refill/wardrobe/law_wardrobe
	machine_name = "LawDrobe"

/obj/machinery/vending/wardrobe/chap_wardrobe
	name = "ChapDrobe"
	desc = "This most blessed and holy machine vends clothing only suitable for chaplains to gaze upon."
	icon_state = "chapdrobe"
	product_ads = "Are you being bothered by cultists or pesky revenants? Then come and dress like the holy man!;Clothes for men of the cloth!"
	vend_reply = "Thank you for using the ChapDrobe!"
	products = list(/obj/item/choice_beacon/holy = 1,
					/obj/item/storage/backpack/cultpack = 2,
					/obj/item/clothing/accessory/pocketprotector/cosmetology = 2,
					/obj/item/clothing/under/rank/civilian/chaplain = 2,
					/obj/item/clothing/under/rank/civilian/chaplain/skirt = 2,
					/obj/item/clothing/shoes/sneakers/black = 2,
					/obj/item/clothing/suit/chaplain/nun = 2,
					/obj/item/clothing/head/nun_hood = 2,
					/obj/item/clothing/suit/chaplain/holidaypriest = 2,
					/obj/item/clothing/suit/chaplain/pharaoh = 2,
					/obj/item/clothing/head/nemes = 1,
					/obj/item/clothing/head/pharaoh = 1,
					/obj/item/storage/fancy/candle_box = 3)
	premium = list(/obj/item/toy/plush/plushvar = 1,
					/obj/item/toy/plush/narplush = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/chap_wardrobe

/obj/item/vending_refill/wardrobe/chap_wardrobe
	machine_name = "ChapDrobe"

/obj/machinery/vending/wardrobe/chem_wardrobe
	name = "ChemDrobe"
	desc = "A vending machine for dispensing chemistry related clothing."
	icon_state = "chemdrobe"
	product_ads = "Our clothes are 0.5% more resistant to acid spills! Get yours now!"
	vend_reply = "Thank you for using the ChemDrobe!"
	products = list(/obj/item/clothing/under/rank/medical/chemist = 3,
					/obj/item/clothing/head/beret/chem = 3,
					/obj/item/clothing/under/rank/medical/chemist/skirt = 3,
					/obj/item/clothing/suit/hooded/wintercoat/chemistry = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/clothing/suit/toggle/labcoat/chemist = 3,
					/obj/item/storage/backpack/chemistry = 3,
					/obj/item/storage/backpack/satchel/chem = 3,
					/obj/item/storage/bag/chemistry = 3,
					/obj/item/fermichem/pHbooklet = 3)//pH indicator)
	refill_canister = /obj/item/vending_refill/wardrobe/chem_wardrobe

/obj/item/vending_refill/wardrobe/chem_wardrobe
	machine_name = "ChemDrobe"

/obj/machinery/vending/wardrobe/gene_wardrobe
	name = "GeneDrobe"
	desc = "A machine for dispensing clothing related to genetics."
	icon_state = "genedrobe"
	product_ads = "Perfect for the mad scientist in you!"
	vend_reply = "Thank you for using the GeneDrobe!"
	products = list(/obj/item/clothing/under/rank/medical/geneticist = 3,
					/obj/item/clothing/under/rank/medical/geneticist/skirt = 3,
					/obj/item/clothing/suit/hooded/wintercoat/genetics = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/clothing/suit/toggle/labcoat/genetics = 3,
					/obj/item/storage/backpack/genetics = 3,
					/obj/item/storage/backpack/satchel/gen = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/gene_wardrobe

/obj/item/vending_refill/wardrobe/gene_wardrobe
	machine_name = "GeneDrobe"

/obj/machinery/vending/wardrobe/viro_wardrobe
	name = "ViroDrobe"
	desc = "An unsterilized machine for dispending virology related clothing."
	icon_state = "virodrobe"
	product_ads = " Viruses getting you down? Then upgrade to sterilized clothing today!"
	vend_reply = "Thank you for using the ViroDrobe"
	products = list(/obj/item/clothing/head/beret/viro = 3,
					/obj/item/clothing/under/rank/medical/virologist = 3,
					/obj/item/clothing/under/rank/medical/virologist/skirt = 3,
					/obj/item/clothing/suit/hooded/wintercoat/viro = 3,
					/obj/item/clothing/shoes/sneakers/white = 3,
					/obj/item/clothing/suit/toggle/labcoat/virologist = 3,
					/obj/item/clothing/mask/surgical = 3,
					/obj/item/storage/backpack/virology = 3,
					/obj/item/storage/backpack/satchel/vir = 3)
	refill_canister = /obj/item/vending_refill/wardrobe/viro_wardrobe

/obj/item/vending_refill/wardrobe/viro_wardrobe
	machine_name = "ViroDrobe"

/obj/machinery/vending/wardrobe/cap_wardrobe
	name = "Captain's Wardrobe"
	desc = "The latest and greatest in Nanotrasen fashion for your great leader."
	icon_state = "capsdrobe"
	icon_deny = "capsdrobe-deny"
	product_ads = "Only the greatest for a commander such as ours."
	req_access = list(ACCESS_CAPTAIN)
	vend_reply = "A wonderful day to you, great leader."
	products = list(/obj/item/clothing/suit/hooded/wintercoat/captain = 1,
					/obj/item/storage/backpack/captain = 1,
					/obj/item/storage/backpack/satchel/cap = 1,
					/obj/item/storage/backpack/duffelbag/captain = 1,
					/obj/item/clothing/neck/cloak/cap = 1,
					/obj/item/clothing/shoes/sneakers/brown = 2,
					/obj/item/clothing/under/rank/captain = 1,
					/obj/item/clothing/under/rank/captain/skirt = 1,
					/obj/item/clothing/head/caphat = 1,
					/obj/item/clothing/head/caphat/parade = 1,
					/obj/item/clothing/head/caphat/beret = 1,
					/obj/item/clothing/head/caphat/beret/white = 1,
					/obj/item/clothing/under/rank/captain/parade = 1,
					/obj/item/clothing/suit/captunic = 1,
					/obj/item/clothing/under/rank/captain/femformal = 1,
					/obj/item/clothing/glasses/sunglasses/gar/supergar = 1,
					/obj/item/clothing/gloves/color/captain = 1)
	refill_canister = /obj/item/vending_refill/wardrobe/cap_wardrobe

/obj/item/vending_refill/wardrobe/cap_wardrobe
	machine_name = "Captain's Wardrobe"
	icon_state = "refill_caps"
