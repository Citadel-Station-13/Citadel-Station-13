/////////////////
//Large Objects//
/////////////////

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = 	list(/obj/item/stack/sheet/cloth = 2,
				 /obj/item/stack/sheet/plastic = 2,
				 /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	subcategory = CAT_FURNITURE
	category = CAT_MISC

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
		        /obj/item/stack/sheet/mineral/wood = 20,
		        /obj/item/stack/cable_coil = 10)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/femur_breaker
	name = "Femur Breaker"
	result = /obj/structure/femur_breaker
	time = 150
	reqs = list(/obj/item/stack/sheet/metal = 20,
		        /obj/item/stack/cable_coil = 30)
	tools = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

// Blood Sucker stuff //
/datum/crafting_recipe/bloodsucker/blackcoffin
	name = "Black Coffin"
	result = /obj/structure/closet/crate/coffin/blackcoffin
	tools = list(/obj/item/weldingtool,
				 /obj/item/screwdriver)
	reqs = list(/obj/item/stack/sheet/cloth = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/sheet/metal = 1)
				///obj/item/stack/packageWrap = 8,
				///obj/item/pipe = 2)
	time = 150
	subcategory = CAT_FURNITURE
	category = CAT_MISC
	always_availible = TRUE

/datum/crafting_recipe/bloodsucker/meatcoffin
	name = "Meat Coffin"
	result =/obj/structure/closet/crate/coffin/meatcoffin
	tools = list(/obj/item/kitchen/knife,
				 /obj/item/kitchen/rollingpin)
	reqs = list(/obj/item/reagent_containers/food/snacks/meat/slab = 5,
				/obj/item/restraints/handcuffs/cable = 1)
	time = 150
	subcategory = CAT_FURNITURE
	category = CAT_MISC
	always_availible = TRUE

/datum/crafting_recipe/bloodsucker/metalcoffin
	name = "Metal Coffin"
	result =/obj/structure/closet/crate/coffin/metalcoffin
	tools = list(/obj/item/weldingtool,
				 /obj/item/screwdriver)
	reqs = list(/obj/item/stack/sheet/metal = 5)
	time = 100
	subcategory = CAT_FURNITURE
	category = CAT_MISC
	always_availible = TRUE

/datum/crafting_recipe/bloodsucker/vassalrack
	name = "Persuasion Rack"
	//desc = "For converting crewmembers into loyal Vassals."
	result = /obj/structure/bloodsucker/vassalrack
	tools = list(/obj/item/weldingtool,
				 	//obj/item/screwdriver,
					/obj/item/wrench
					 )
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/restraints/handcuffs/cable = 2,
				//obj/item/storage/belt = 1,
				//obj/item/stack/sheet/animalhide = 1,
				//obj/item/stack/sheet/leather = 1,
				//obj/item/stack/sheet/plasteel = 5
				)
		//parts = list(/obj/item/storage/belt = 1
		//			 )
	time = 150
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC
	always_availible = FALSE	// Disabled til learned


/datum/crafting_recipe/bloodsucker/candelabrum
	name = "Candelabrum"
	//desc = "For converting crewmembers into loyal Vassals."
	result = /obj/structure/bloodsucker/candelabrum
	tools = list(/obj/item/weldingtool,
				 /obj/item/wrench
				)
	reqs = list(/obj/item/stack/sheet/metal = 3,
				/obj/item/stack/rods = 1,
				/obj/item/candle = 1
				)
	time = 100
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC
	always_availible = FALSE	// Disabled til learned

///////////////////
//Tools & Storage//
///////////////////

/datum/crafting_recipe/upgraded_gauze
	name = "Improved Gauze"
	result = /obj/item/stack/medical/gauze/adv/one
	time = 1
	reqs = list(/obj/item/stack/medical/gauze = 1,
				/datum/reagent/space_cleaner/sterilizine = 10)
	category = CAT_MISC
	subcategory = CAT_TOOL

/datum/crafting_recipe/bruise_pack
	name = "Bruise Pack"
	result = /obj/item/stack/medical/bruise_pack/one
	time = 1
	reqs = list(/obj/item/stack/medical/gauze = 1,
				/datum/reagent/medicine/styptic_powder = 10)
	category = CAT_MISC
	subcategory = CAT_TOOL

/datum/crafting_recipe/burn_pack
	name = "Burn Ointment"
	result = /obj/item/stack/medical/ointment/one
	time = 1
	reqs = list(/obj/item/stack/medical/gauze = 1,
				/datum/reagent/medicine/silver_sulfadiazine = 10)
	category = CAT_MISC
	subcategory = CAT_TOOL

/datum/crafting_recipe/ghettojetpack
	name = "Improvised Jetpack"
	result = /obj/item/tank/jetpack/improvised
	time = 30
	reqs = list(/obj/item/tank/internals/oxygen = 2,
				/obj/item/extinguisher = 1,
				/obj/item/pipe = 3,
				/obj/item/stack/cable_coil = 30)
	category = CAT_MISC
	subcategory = CAT_TOOL
	tools = list(TOOL_WRENCH, TOOL_WELDER, TOOL_WIRECUTTER)

/datum/crafting_recipe/goldenbox
	name = "Gold Plated Toolbox"
	result = /obj/item/storage/toolbox/gold_fake
	tools = list(/obj/item/stock_parts/cell/high)
	reqs = list(/obj/item/stack/sheet/cardboard = 1, //so we dont null items in crafting
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/sheet/mineral/gold = 1,
				/datum/reagent/water  = 15)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/papersack
	name = "Paper Sack"
	result = /obj/item/storage/box/papersack
	time = 10
	reqs = list(/obj/item/paper = 5)
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/smallcarton
	name = "Small Carton"
	result = /obj/item/reagent_containers/food/drinks/sillycup/smallcarton
	time = 10
	reqs = list(/obj/item/stack/sheet/cardboard = 1)
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/bronze_driver
	name = "Bronze Plated Screwdriver"
	tools = list(/obj/item/stock_parts/cell/high)
	result = /obj/item/screwdriver/bronze
	reqs = list(/obj/item/screwdriver = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/tile/bronze = 1,
				/datum/reagent/water  = 15)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/bronze_welder
	name = "Bronze Plated Welding Tool"
	tools = list(/obj/item/stock_parts/cell/high)
	result = /obj/item/weldingtool/bronze
	reqs = list(/obj/item/weldingtool = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/tile/bronze = 1,
				/datum/reagent/water  = 15)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/bronze_wirecutters
	name = "Bronze Plated Wirecutters"
	tools = list(/obj/item/stock_parts/cell/high)
	result = /obj/item/wirecutters/bronze
	reqs = list(/obj/item/wirecutters = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/tile/bronze = 1,
				/datum/reagent/water  = 15)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/bronze_crowbar
	name = "Bronze Plated Crowbar"
	tools = list(/obj/item/stock_parts/cell/high)
	result = /obj/item/crowbar/bronze
	reqs = list(/obj/item/crowbar = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/tile/bronze = 1,
				/datum/reagent/water  = 15)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/bronze_wrench
	name = "Bronze Plated Wrench"
	tools = list(/obj/item/stock_parts/cell/high)
	result = /obj/item/wrench/bronze
	reqs = list(/obj/item/wrench = 1,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/tile/bronze = 1,
				/datum/reagent/water  = 15)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/rcl
	name = "Makeshift Rapid Cable Layer"
	result = /obj/item/twohanded/rcl/ghetto
	time = 40
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/metal = 15)
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/picket_sign
	name = "Picket Sign"
	result = /obj/item/picket_sign
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/cardboard = 2)
	time = 80
	subcategory = CAT_TOOL
	category = CAT_MISC

/datum/crafting_recipe/electrochromatic_kit
	name = "Electrochromatic Kit"
	result = /obj/item/electronics/electrochromatic_kit
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1)
	time = 5
	subcategory = CAT_TOOL
	category = CAT_MISC

////////////
//Vehicles//
////////////

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/plasteel = 2,
				/obj/item/stack/rods = 8)
	time = 100
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/skateboard
	name = "Skateboard"
	result = /obj/vehicle/ridden/scooter/skateboard
	time = 60
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 10)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/scooter
	name = "Scooter"
	result = /obj/vehicle/ridden/scooter
	time = 65
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 12)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/////////
//Toys///
/////////

/datum/crafting_recipe/toysword
	name = "Toy Sword"
	reqs = list(/obj/item/light/bulb = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/sheet/plastic = 4)
	result = /obj/item/toy/sword
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/extendohand
	name = "Extendo-Hand"
	reqs = list(/obj/item/bodypart/r_arm/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/toyneb
	name = "Non-Euplastic Blade"
	reqs = list(/obj/item/light/tube = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/sheet/plastic = 4)
	result = /obj/item/toy/sword/cx
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

////////////
//Unsorted//
////////////

/datum/crafting_recipe/blackcarpet
	name = "Black Carpet"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/paperframes
	name = "Paper Frames"
	result = /obj/item/stack/sheet/paperframes/five
	time = 10
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5, /obj/item/paper = 20)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/naturalpaper
	name = "Hand-Pressed Paper"
	time = 30
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/sheet/mineral/wood = 1)
	tools = list(/obj/item/hatchet)
	result = /obj/item/paper_bin/bundlenatural
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/bluespacehonker
	name = "Bluespace Bike horn"
	result = /obj/item/bikehorn/bluespacehonker
	time = 10
	reqs = list(/obj/item/stack/ore/bluespace_crystal = 1,
				/obj/item/toy/crayon/blue = 1,
				/obj/item/bikehorn = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/mousetrap
	name = "Mouse Trap"
	result = /obj/item/assembly/mousetrap
	time = 10
	reqs = list(/obj/item/stack/sheet/cardboard = 1,
				/obj/item/stack/rods = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/flashlight_eyes
	name = "Flashlight Eyes"
	result = /obj/item/organ/eyes/robotic/flashlight
	time = 10
	reqs = list(
		/obj/item/flashlight = 2,
		/obj/item/restraints/handcuffs/cable = 1
	)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/pressureplate
	name = "Pressure Plate"
	result = /obj/item/pressure_plate
	time = 5
	reqs = list(/obj/item/stack/sheet/metal = 1,
				  /obj/item/stack/tile/plasteel = 1,
				  /obj/item/stack/cable_coil = 2,
				  /obj/item/assembly/igniter = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/gold_horn
	name = "Golden Bike Horn"
	result = /obj/item/bikehorn/golden
	time = 20
	reqs = list(/obj/item/stack/sheet/mineral/bananium = 5,
				/obj/item/bikehorn = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/spooky_camera
	name = "Camera Obscura"
	result = /obj/item/camera/spooky
	time = 15
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

/datum/crafting_recipe/coconut_bong
	name = "Coconut Bong"
	result = /obj/item/bong/coconut
	reqs = list(/obj/item/stack/sheet/mineral/bamboo = 2,
				/obj/item/reagent_containers/food/snacks/grown/coconut = 1)
	time = 70
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISC

//////////////
//Banners/////
//////////////

/datum/crafting_recipe/command_banner
	name = "Command Banner"
	result = /obj/item/banner/command/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/captain/parade = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISC

/datum/crafting_recipe/engineering_banner
	name = "Engitopia Banner"
	result = /obj/item/banner/engineering/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/engineering/engineer = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISC

/datum/crafting_recipe/cargo_banner
	name = "Cargonia Banner"
	result = /obj/item/banner/cargo/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/cargo/tech = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISC

/datum/crafting_recipe/science_banner
	name = "Sciencia Banner"
	result = /obj/item/banner/science/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/rnd/scientist = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISC

/datum/crafting_recipe/medical_banner
	name = "Meditopia Banner"
	result = /obj/item/banner/medical/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/medical/doctor = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISC

/datum/crafting_recipe/security_banner
	name = "Securistan Banner"
	result = /obj/item/banner/security/mundane
	time = 40
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/clothing/under/rank/security/officer = 1)
	subcategory = CAT_FURNITURE
	category = CAT_MISC
