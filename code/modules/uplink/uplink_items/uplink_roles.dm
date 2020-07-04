
/*
	Uplink Items:
	Unlike categories, uplink item entries are automatically sorted alphabetically on server init in a global list,
	When adding new entries to the file, please keep them sorted by category.
*/

// Role-specific items

/datum/uplink_item/role_restricted/ancient_jumpsuit
	name = "Ancient Jumpsuit"
	desc = "A tattered old jumpsuit that will provide absolutely no benefit to you. It fills the wearer with a strange compulsion to blurt out 'glorf'."
	item = /obj/item/clothing/under/color/grey/glorf
	cost = 20
	restricted_roles = list("Assistant")

/datum/uplink_item/role_restricted/pie_cannon
	name = "Banana Cream Pie Cannon"
	desc = "A special pie cannon for a special clown, this gadget can hold up to 20 pies and automatically fabricates one every two seconds!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/blastcannon
	name = "Blast Cannon"
	desc = "A highly specialized weapon, the Blast Cannon is actually relatively simple. It contains an attachment for a tank transfer valve mounted to an angled pipe specially constructed \
			withstand extreme pressure and temperatures, and has a mechanical trigger for triggering the transfer valve. Essentially, it turns the explosive force of a bomb into a narrow-angle \
			blast wave \"projectile\". Aspiring scientists may find this highly useful, as forcing the pressure shockwave into a narrow angle seems to be able to bypass whatever quirk of physics \
			disallows explosive ranges above a certain distance, allowing for the device to use the theoretical yield of a transfer valve bomb, instead of the factual yield."
	item = /obj/item/gun/blastcannon
	cost = 14							//High cost because of the potential for extreme damage in the hands of a skilled gas masked scientist.
	restricted_roles = list("Research Director", "Scientist")

/datum/uplink_item/role_restricted/alientech
	name = "Alien Research Disk"
	desc = "A technology disk holding a terabyte of highly confidential abductor technology. \
			Simply insert into research console of choice and import the files from the disk. Because of its foreign nature, it may require multiple uploads to work properly."
	item = /obj/item/disk/tech_disk/abductor
	cost = 12
	restricted_roles = list("Research Director", "Scientist", "Roboticist")

/datum/uplink_item/role_restricted/clown_bomb
	name = "Clown Bomb"
	desc = "The Clown bomb is a hilarious device capable of massive pranks. It has an adjustable timer, \
			with a minimum of 60 seconds, and can be bolted to the floor with a wrench to prevent \
			movement. The bomb is bulky and cannot be moved; upon ordering this item, a smaller beacon will be \
			transported to you that will teleport the actual bomb to it upon activation. Note that this bomb can \
			be defused, and some crew may attempt to do so. \
			The bomb core can be pried out and manually detonated with other explosives."
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	restricted_roles = list("Clown")

/*
/datum/uplink_item/role_restricted/clowncar
	name = "Clown Car"
	desc = "The Clown Car is the ultimate transportation method for any worthy clown! \
			Simply insert your bikehorn and get in, and get ready to have the funniest ride of your life! \
			You can ram any spacemen you come across and stuff them into your car, kidnapping them and locking them inside until \
			someone saves them or they manage to crawl out. Be sure not to ram into any walls or vending machines, as the springloaded seats \
			are very sensetive. Now with our included lube defense mechanism which will protect you against any angry shitcurity!"
	item = /obj/vehicle/sealed/car/clowncar
	cost = 15
	restricted_roles = list("Clown")
*/

/datum/uplink_item/role_restricted/haunted_magic_eightball
	name = "Haunted Magic Eightball"
	desc = "Most magic eightballs are toys with dice inside. Although identical in appearance to the harmless toys, this occult device reaches into the spirit world to find its answers. \
			Be warned, that spirits are often capricious or just little assholes. To use, simply speak your question aloud, then begin shaking."
	item = /obj/item/toy/eightball/haunted
	cost = 2
	restricted_roles = list("Curator")
	limited_stock = 1 //please don't spam deadchat

/datum/uplink_item/role_restricted/his_grace
	name = "His Grace"
	desc = "An incredibly dangerous weapon recovered from a station overcome by the grey tide. Once activated, He will thirst for blood and must be used to kill to sate that thirst. \
	His Grace grants gradual regeneration and complete stun immunity to His wielder, but be wary: if He gets too hungry, He will become impossible to drop and eventually kill you if not fed. \
	However, if left alone for long enough, He will fall back to slumber. \
	To activate His Grace, simply unlatch Him."
	item = /obj/item/his_grace
	cost = 20
	restricted_roles = list("Chaplain")
	surplus = 5 //Very low chance to get it in a surplus crate even without being the chaplain

/datum/uplink_item/role_restricted/clockwork_slab
	name = "Clockwork Slab"
	desc = "A reverse engineered clockwork slab. Is this really a good idea?."
	item = /obj/item/clockwork/slab/traitor
	cost = 20
	player_minimum = 20
	refundable = TRUE
	restricted_roles = list("Chaplain")

/datum/uplink_item/role_restricted/arcane_tome
	name = "Arcane Tome"
	desc = "A replica of a Nar'sian tome. This is probably a bad idea.."
	item = /obj/item/tome/traitor
	cost = 20
	player_minimum = 20
	refundable = TRUE
	restricted_roles = list("Chaplain")

/datum/uplink_item/role_restricted/explosive_hot_potato
	name = "Exploding Hot Potato"
	desc = "A potato rigged with explosives. On activation, a special mechanism is activated that prevents it from being dropped. \
			The only way to get rid of it if you are holding it is to attack someone else with it, causing it to latch to that person instead."
	item = /obj/item/hot_potato/syndicate
	cost = 4
	restricted_roles = list("Cook", "Botanist", "Clown", "Mime")

/datum/uplink_item/role_restricted/strange_seeds_10pack
	name = "Pack of strange seeds"
	desc = "Mysterious seeds as strange as their name implies. Spooky. These come in bulk"
	item = /obj/item/storage/box/strange_seeds_10pack
	cost = 10
	restricted_roles = list("Botanist")

/datum/uplink_item/role_restricted/ez_clean_bundle
	name = "EZ Clean Grenade Bundle"
	desc = "A box with three cleaner grenades using the trademark Waffle Co. formula. Serves as a cleaner and causes acid damage to anyone standing nearby. \
			The acid only affects carbon-based creatures."
	item = /obj/item/storage/box/syndie_kit/ez_clean
	cost = 6
	surplus = 20
	restricted_roles = list("Janitor")

/datum/uplink_item/role_restricted/goldenbox
	name = "Gold Toolbox"
	desc = "A gold plated plastitanium toolbox. It comes loaded with a full tool set including a AI detector multitool and combat gloves."
	item = /obj/item/storage/toolbox/plastitanium/gold_real
	cost = 4 // Has syndie tools + gloves + a robust weapon
	restricted_roles = list("Assistant", "Curator") //Curator due to this being made of gold - It fits the theme

/datum/uplink_item/role_restricted/mimery
	name = "Guide to Advanced Mimery Series"
	desc = "The classical two part series on how to further hone your mime skills. Upon studying the series, the user should be able to make 3x1 invisible walls, and shoot bullets out of their fingers. \
			Obviously only works for Mimes."
	cost = 12
	item = /obj/item/storage/box/syndie_kit/mimery
	restricted_roles = list("Mime")

/datum/uplink_item/role_restricted/ultrahonkpins
	name = "Hilarious firing pin"
	desc = "A single firing pin made for Clown agents, this firing pin makes any gun honk when fired if not a true clown! \
	This firing pin also helps you fire the gun correctly. May the HonkMother HONK you agent."
	item = /obj/item/firing_pin/clown/ultra
	cost = 2
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/pressure_mod
	name = "Kinetic Accelerator Pressure Mod"
	desc = "A modification kit which allows Kinetic Accelerators to do greatly increased damage while indoors. \
			Occupies 35% mod capacity."
	item = /obj/item/borg/upgrade/modkit/indoors
	cost = 5 //you need two for full damage, so total of 10 for maximum damage
	limited_stock = 2 //you can't use more than two!
	restricted_roles = list("Shaft Miner")

/datum/uplink_item/role_restricted/kitchen_gun
	name = "Kitchen Gun (TM)"
	desc = "A revolutionary .45 caliber cleaning solution! Say goodbye to daily stains and dirty surfaces with Kitchen Gun (TM)! \
	Just three shots from Kitchen Gun (TM), and it'll sparkle like new! Includes two extra ammunition clips!"
	cost = 10
	surplus = 40
	restricted_roles = list("Cook", "Janitor")
	item = /obj/item/storage/box/syndie_kit/kitchen_gun

/datum/uplink_item/role_restricted/kitchen_gun_ammo
	name = "Kitchen Gun (TM) .45 Magazine"
	desc = "An extra eight bullets for an extra eight uses of Kitchen Gun (TM)!"
	cost = 1
	restricted_roles = list("Cook", "Janitor")
	item = /obj/item/ammo_box/magazine/m45/kitchengun

/datum/uplink_item/role_restricted/magillitis_serum
	name = "Magillitis Serum Autoinjector"
	desc = "A single-use autoinjector which contains an experimental serum that causes rapid muscular growth in Hominidae. \
			Side-affects may include hypertrichosis, violent outbursts, and an unending affinity for bananas."
	item = /obj/item/reagent_containers/hypospray/magillitis
	cost = 8
	restricted_roles = list("Geneticist", "Chief Medical Officer")

/datum/uplink_item/role_restricted/modified_syringe_gun
	name = "Modified Syringe Gun"
	desc = "A syringe gun that fires DNA injectors instead of normal syringes."
	item = /obj/item/gun/syringe/dna
	cost = 14
	restricted_roles = list("Geneticist", "Chief Medical Officer")

/datum/uplink_item/role_restricted/chemical_gun
	name = "Reagent Dartgun"
	desc = "A heavily modified syringe gun which is capable of synthesizing its own chemical darts using input reagents. Can hold 100u of reagents."
	item = /obj/item/gun/chem
	cost = 12
	restricted_roles = list("Chemist", "Chief Medical Officer")

/datum/uplink_item/role_restricted/reverse_bear_trap
	name = "Reverse Bear Trap"
	desc = "An ingenious execution device worn on (or forced onto) the head. Arming it starts a 1-minute kitchen timer mounted on the bear trap. When it goes off, the trap's jaws will \
	violently open, instantly killing anyone wearing it by tearing their jaws in half. To arm, attack someone with it while they're not wearing headgear, and you will force it onto their \
	head after three seconds uninterrupted."
	cost = 5
	item = /obj/item/reverse_bear_trap
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/reverse_revolver
	name = "Reverse Revolver"
	desc = "A revolver that always fires at its user. \"Accidentally\" drop your weapon, then watch as the greedy corporate pigs blow their own brains all over the wall. \
	The revolver itself is actually real. Only clumsy people, and clowns, can fire it normally. Comes in a box of hugs. Honk."
	cost = 14
	item = /obj/item/storage/box/hug/reverse_revolver
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/taeclowndo_shoes
	name = "Tae-clown-do Shoes"
	desc = "A pair of shoes for the most elite agents of the honkmotherland. They grant the mastery of taeclowndo with some honk-fu moves as long as they're worn."
	cost = 14
	item = /obj/item/clothing/shoes/clown_shoes/taeclowndo
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/emitter_cannon
	name = "Emitter Cannon"
	desc = "A small emitter fitted into a gun case, do to size constraints and safety it can only shoot about ten times when fully charged."
	cost = 5 //Low ammo, and deals same as 10mm but emp-able
	item = /obj/item/gun/energy/emitter
	restricted_roles = list("Chief Engineer", "Station Engineer", "Atmospheric Technician")

/datum/uplink_item/role_restricted/crushmagboots
	name = "Crushing Magboots"
	desc = "A pair of extra-strength magboots that crush anyone you walk over."
	cost = 2
	item = /obj/item/clothing/shoes/magboots/crushing
	restricted_roles = list("Chief Engineer", "Station Engineer", "Atmospheric Technician")
