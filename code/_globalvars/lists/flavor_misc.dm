//Preferences stuff
	//Hairstyles
GLOBAL_LIST_EMPTY(hair_styles_list)			//stores /datum/sprite_accessory/hair indexed by name
GLOBAL_LIST_EMPTY(hair_styles_male_list)		//stores only hair names
GLOBAL_LIST_EMPTY(hair_styles_female_list)	//stores only hair names
GLOBAL_LIST_EMPTY(facial_hair_styles_list)	//stores /datum/sprite_accessory/facial_hair indexed by name
GLOBAL_LIST_EMPTY(facial_hair_styles_male_list)	//stores only hair names
GLOBAL_LIST_EMPTY(facial_hair_styles_female_list)	//stores only hair names
	//Underwear
GLOBAL_LIST_EMPTY_TYPED(underwear_list, /datum/sprite_accessory/underwear/bottom)		//stores bottoms indexed by name
GLOBAL_LIST_EMPTY(underwear_m)	//stores only underwear name
GLOBAL_LIST_EMPTY(underwear_f)	//stores only underwear name
	//Undershirts
GLOBAL_LIST_EMPTY_TYPED(undershirt_list, /datum/sprite_accessory/underwear/top) 	//stores tops indexed by name
GLOBAL_LIST_EMPTY(undershirt_m)	 //stores only undershirt name
GLOBAL_LIST_EMPTY(undershirt_f)	 //stores only undershirt name
	//Socks
GLOBAL_LIST_EMPTY_TYPED(socks_list, /datum/sprite_accessory/underwear/socks)		//stores socks indexed by name
	//Lizard Bits (all datum lists indexed by name)
GLOBAL_LIST_EMPTY(tails_list_lizard)
GLOBAL_LIST_EMPTY(animated_tails_list_lizard)
GLOBAL_LIST_EMPTY(snouts_list)
GLOBAL_LIST_EMPTY(horns_list)
GLOBAL_LIST_EMPTY(frills_list)
GLOBAL_LIST_EMPTY(spines_list)
GLOBAL_LIST_EMPTY(legs_list)
GLOBAL_LIST_EMPTY(animated_spines_list)

	//Mutant Human bits
GLOBAL_LIST_EMPTY(tails_list_human)
GLOBAL_LIST_EMPTY(animated_tails_list_human)
GLOBAL_LIST_EMPTY(ears_list)
GLOBAL_LIST_EMPTY(wings_list)
GLOBAL_LIST_EMPTY(wings_open_list)
GLOBAL_LIST_EMPTY(deco_wings_list)
GLOBAL_LIST_EMPTY(r_wings_list)
GLOBAL_LIST_EMPTY(insect_wings_list)
GLOBAL_LIST_EMPTY(insect_fluffs_list)
GLOBAL_LIST_EMPTY(insect_markings_list)
GLOBAL_LIST_EMPTY(arachnid_legs_list)
GLOBAL_LIST_EMPTY(arachnid_spinneret_list)
GLOBAL_LIST_EMPTY(arachnid_mandibles_list)
GLOBAL_LIST_EMPTY(caps_list)

//a way to index the right bodypart list given the type of bodypart
GLOBAL_LIST_INIT(mutant_reference_list, list(
	"tail_lizard" = GLOB.tails_list_lizard,
	"waggingtail_lizard" = GLOB.animated_tails_list_lizard,
	"tail_human" = GLOB.tails_list_human,
	"waggingtail_human" = GLOB.animated_tails_list_human,
	"spines" = GLOB.spines_list,
	"waggingspines" = GLOB.animated_spines_list,
	"snout" = GLOB.snouts_list,
	"frills" = GLOB.frills_list,
	"horns" = GLOB.horns_list,
	"ears" = GLOB.ears_list,
	"wings" = GLOB.wings_list,
	"wingsopen" = GLOB.wings_open_list,
	"deco_wings" = GLOB.deco_wings_list,
	"legs" = GLOB.legs_list,
	"insect_wings" = GLOB.insect_wings_list,
	"insect_fluff" = GLOB.insect_fluffs_list,
	"insect_markings" = GLOB.insect_markings_list,
	"arachnid_legs" = GLOB.arachnid_legs_list,
	"arachnid_spinneret" = GLOB.arachnid_spinneret_list,
	"arachnid_mandibles" = GLOB.arachnid_mandibles_list,
	"caps" = GLOB.caps_list,
	"ipc_screen" = GLOB.ipc_screens_list,
	"ipc_antenna" = GLOB.ipc_antennas_list,
	"mam_tail" = GLOB.mam_tails_list,
	"mam_waggingtail" = GLOB.mam_tails_animated_list,
	"mam_body_markings" = GLOB.mam_body_markings_list,
	"mam_ears" = GLOB.mam_ears_list,
	"mam_snouts" = GLOB.mam_snouts_list,
	"taur" = GLOB.taur_list,
	"xenodorsal" = GLOB.xeno_dorsal_list,
	"xenohead" = GLOB.xeno_head_list,
	"xenotail" = GLOB.xeno_tail_list))

//references wag types to regular types, wings open to wings, etc
GLOBAL_LIST_INIT(mutant_transform_list, list("wingsopen" = "wings",
	"waggingtail_human" = "tail_human",
	"waggingtail_lizard" = "tail_lizard",
	"waggingspines" = "spines",
	"mam_waggingtail" = "mam_tail"))

GLOBAL_LIST_INIT(ghost_forms_with_directions_list, list("ghost")) //stores the ghost forms that support directional sprites
GLOBAL_LIST_INIT(ghost_forms_with_accessories_list, list("ghost")) //stores the ghost forms that support hair and other such things

GLOBAL_LIST_INIT(ai_core_display_screens, list(
	":thinking:",
	"Alien",
	"Angel",
	"Angryface",
	"AtlantisCZE",
	"Banned",
	"Bliss",
	"Blue",
	"Boy",
	"Boy-Malf",
	"Girl",
	"Girl-Malf",
	"Database",
	"Dorf",
	"Firewall",
	"Fuzzy",
	"Gentoo",
	"Glitchman",
	"Gondola",
	"Goon",
	"Hades",
	"Heartline",
	"Helios",
	"Hotdog",
	"Hourglass",
	"House",
	"Inverted",
	"Jack",
	"Matrix",
	"Monochrome",
	"Mothman",
	"Murica",
	"Nanotrasen",
	"Not Malf",
	"Patriot",
	"Pirate",
	"Portrait",
	"President",
	"Rainbow",
	"Clown",
	"Random",
	"Ravensdale",
	"Red October",
	"Red",
	"Royal",
	"Searif",
	"Serithi",
	"SilveryFerret",
	"Smiley",
	"Static",
	"Syndicat Meow",
	"TechDemon",
	"Terminal",
	"Text",
	"Too Deep",
	"Triumvirate",
	"Triumvirate-M",
	"Wasp",
	"Weird",
	"Xerxes",
	"Yes-Man"
	))

/proc/resolve_ai_icon(input, radial_preview = FALSE)
	if(!input || !(input in GLOB.ai_core_display_screens))
		return "ai"
	if(radial_preview)
		return "ai-[lowertext(input)]"

	if(input == "Random")
		input = pick(GLOB.ai_core_display_screens - "Random")
	if(input == "Portrait")
		var/datum/portrait_picker/tgui = new(usr)//create the datum
		tgui.ui_interact(usr)//datum has a tgui component, here we open the window
		return "ai-portrait" //just take this until they decide
	return "ai-[lowertext(input)]"

GLOBAL_LIST_INIT(security_depts_prefs, list(SEC_DEPT_RANDOM, SEC_DEPT_NONE, SEC_DEPT_ENGINEERING, SEC_DEPT_MEDICAL, SEC_DEPT_SCIENCE, SEC_DEPT_SUPPLY))

//Backpacks
#define DBACKPACK "Department Backpack"
#define DSATCHEL "Department Satchel"
#define DDUFFELBAG "Department Duffel Bag"
GLOBAL_LIST_INIT(backbaglist, list(DBACKPACK, DSATCHEL, DDUFFELBAG, //everything after this point is a non-department backpack
	"Grey Backpack" = /obj/item/storage/backpack,
	"Grey Satchel" = /obj/item/storage/backpack/satchel,
	"Grey Duffel Bag" = /obj/item/storage/backpack/duffelbag,
	"Leather Satchel" = /obj/item/storage/backpack/satchel/leather,
	"Snail Shell" = /obj/item/storage/backpack/snail))

//Suit/Skirt
#define PREF_SUIT "Jumpsuit"
#define PREF_SKIRT "Jumpskirt"
GLOBAL_LIST_INIT(jumpsuitlist, list(PREF_SUIT, PREF_SKIRT))

//Uplink spawn loc
#define UPLINK_PDA		"PDA"
#define UPLINK_RADIO	"Radio"
#define UPLINK_PEN		"Pen" //like a real spy!
GLOBAL_LIST_INIT(uplink_spawn_loc_list, list(UPLINK_PDA, UPLINK_RADIO, UPLINK_PEN))

//List of cached alpha masked icons.
GLOBAL_LIST_EMPTY(alpha_masked_worn_icons)

	//radical shit
GLOBAL_LIST_INIT(hit_appends, list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF"))

GLOBAL_LIST_INIT(scarySounds, list('sound/weapons/thudswoosh.ogg','sound/weapons/taser.ogg','sound/weapons/armbomb.ogg','sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg','sound/voice/hiss5.ogg','sound/voice/hiss6.ogg','sound/effects/glassbr1.ogg','sound/effects/glassbr2.ogg','sound/effects/glassbr3.ogg','sound/items/welder.ogg','sound/items/welder2.ogg','sound/machines/airlock.ogg','sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg'))


// Reference list for disposal sort junctions. Set the sortType variable on disposal sort junctions to
// the index of the sort department that you want. For example, sortType set to 2 will reroute all packages
// tagged for the Cargo Bay.

/* List of sortType codes for mapping reference
0 Waste
1 Disposals - All unwrapped items and untagged parcels get picked up by a junction with this sortType. Usually leads to the recycler.
2 Cargo Bay
3 QM Office
4 Engineering
5 CE Office
6 Atmospherics
7 Security
8 HoS Office
9 Medbay
10 CMO Office
11 Chemistry
12 Research
13 RD Office
14 Robotics
15 HoP Office
16 Library
17 Chapel
18 Theatre
19 Bar
20 Kitchen
21 Hydroponics
22 Janitor
23 Genetics
24 Circuitry
25 Toxins
26 Dormitories
27 Virology
28 Xenobiology
29 Law Office
30 Detective's Office
*/

//The whole system for the sorttype var is determined based on the order of this list,
//disposals must always be 1, since anything that's untagged will automatically go to disposals, or sorttype = 1 --Superxpdude

//If you don't want to fuck up disposals, add to this list, and don't change the order.
//If you insist on changing the order, you'll have to change every sort junction to reflect the new order. --Pete

GLOBAL_LIST_INIT(TAGGERLOCATIONS, list("Disposals",
	"Cargo Bay", "QM Office", "Engineering", "CE Office",
	"Atmospherics", "Security", "HoS Office", "Medbay",
	"CMO Office", "Chemistry", "Research", "RD Office",
	"Robotics", "HoP Office", "Library", "Chapel", "Theatre",
	"Bar", "Kitchen", "Hydroponics", "Janitor Closet","Genetics",
	"Circuitry", "Toxins", "Dormitories", "Virology",
	"Xenobiology", "Law Office","Detective's Office"))

GLOBAL_LIST_INIT(station_prefixes, world.file2list("strings/station_prefixes.txt") + "")

GLOBAL_LIST_INIT(station_names, world.file2list("strings/station_names.txt" + ""))

GLOBAL_LIST_INIT(station_suffixes, world.file2list("strings/station_suffixes.txt"))

GLOBAL_LIST_INIT(greek_letters, world.file2list("strings/greek_letters.txt"))

GLOBAL_LIST_INIT(phonetic_alphabet, world.file2list("strings/phonetic_alphabet.txt"))

GLOBAL_LIST_INIT(numbers_as_words, world.file2list("strings/numbers_as_words.txt"))

/proc/generate_number_strings()
	var/list/L[198]
	for(var/i in 1 to 99)
		L += "[i]"
		L += "\Roman[i]"
	return L

GLOBAL_LIST_INIT(station_numerals, greek_letters + phonetic_alphabet + numbers_as_words + generate_number_strings())

GLOBAL_LIST_INIT(admiral_messages, list("Do you know how expensive these stations are?","Stop wasting my time.","I was sleeping, thanks a lot.","Stand and fight you cowards!","You knew the risks coming in.","Stop being paranoid.","Whatever's broken just build a new one.","No.", "<i>null</i>","<i>Error: No comment given.</i>", "It's a good day to die!"))

GLOBAL_LIST_INIT(redacted_strings, list("\[REDACTED\]", "\[CLASSIFIED\]", "\[ARCHIVED\]", "\[EXPLETIVE DELETED\]", "\[EXPUNGED\]", "\[INFORMATION ABOVE YOUR SECURITY CLEARANCE\]", "\[MOVE ALONG CITIZEN\]", "\[NOTHING TO SEE HERE\]", "\[ACCESS DENIED\]"))

GLOBAL_LIST_INIT(wisdoms, world.file2list("strings/wisdoms.txt"))

//LANGUAGE CHARACTER CUSTOMIZATION
GLOBAL_LIST_INIT(speech_verbs, list("default","says","gibbers", "states", "chitters", "chimpers", "declares", "bellows", "buzzes" ,"beeps", "chirps", "clicks", "hisses" ,"poofs" , "puffs", "rattles", "mewls" ,"barks", "blorbles", "squeaks", "squawks", "flutters", "warbles", "caws", "gekkers", "clucks"))
GLOBAL_LIST_INIT(roundstart_tongues, list("default","human tongue" = /obj/item/organ/tongue, "lizard tongue" = /obj/item/organ/tongue/lizard, "skeleton tongue" = /obj/item/organ/tongue/bone, "fly tongue" = /obj/item/organ/tongue/fly, "ipc tongue" = /obj/item/organ/tongue/robot/ipc, "xeno tongue" = /obj/item/organ/tongue/alien))

/proc/get_roundstart_languages()
	var/list/languages = subtypesof(/datum/language)
	var/list/roundstart_languages = list("None") //default option for the list
	for(var/some_language in languages)
		var/datum/language/language = some_language
		if(initial(language.chooseable_roundstart))
			roundstart_languages[initial(language.name)] = some_language
	return roundstart_languages

GLOBAL_LIST_INIT(roundstart_languages, get_roundstart_languages())

//SPECIES BODYPART LISTS
//locked parts are those that your picked species requires to have
//unlocked parts are those that anyone can choose on customisation regardless
//parts not in unlocked, but in all, are thus locked
GLOBAL_LIST_INIT(all_mutant_parts, list("tail_lizard" = "Tail", "mam_tail" = "Tail", "tail_human" = "Tail", "snout" = "Snout", "frills" = "Frills", "spines" = "Spines", "mam_body_markings" = "Species Markings" , "mam_ears" = "Ears", "ears" = "Ears", "mam_snouts" = "Snout", "legs" = "Legs", "deco_wings" = "Decorative Wings", "insect_wings" = "Insect Wings", "insect_fluff" = "Insect Fluff", "taur" = "Tauric Body", "insect_markings" = "Insect Markings", "wings" = "Wings", "arachnid_legs" = "Arachnid Legs", "arachnid_spinneret" = "Spinneret", "arachnid_mandibles" = "Mandibles", "xenohead" = "Caste Head", "xenotail" = "Tail", "xenodorsal" = "Dorsal Spines", "ipc_screen" = "Screen", "ipc_antenna" = "Antenna", "meat_type" = "Meat Type", "horns" = "Horns"))
GLOBAL_LIST_INIT(unlocked_mutant_parts, list("horns", "insect_fluff"))

//parts in either of the above two lists that require a second option that allows them to be coloured
GLOBAL_LIST_INIT(colored_mutant_parts, list("insect_wings" = "wings_color", "deco_wings" = "wings_color", "horns" = "horns_color"))

//body ids that have greyscale sprites
GLOBAL_LIST_INIT(greyscale_limb_types, list("human","moth","lizard","pod","plant","jelly","slime","golem","slimelumi","stargazer","mush","ethereal","snail","c_golem","b_golem","mammal","xeno","ipc","insect","synthliz","avian","aquatic"))

//body ids that have prosthetic sprites
GLOBAL_LIST_INIT(prosthetic_limb_types, list("xion","bishop","cybersolutions","grayson","hephaestus","nanotrasen","talon"))

//FAMILY HEIRLOOM LIST
//this works by using the first number for the species as a probability to choose one of the items in the following list for their family heirloom
//if the probability fails, or the species simply isn't in the list, then it defaults to the next global list, which has its own list of items for each job
//the first item in the list is for if your job isn't in that list

//species-heirloom list (we categorise them by the species id var)
GLOBAL_LIST_INIT(species_heirlooms, list(
	"dwarf" = list(25, list(/obj/item/reagent_containers/food/drinks/dwarf_mug)), //example: 25% chance for dwarves to get a dwarf mug as their heirloom (normal container but has manly dorf icon)
	"insect" = list(25, list(/obj/item/flashlight/lantern/heirloom_moth)),
	"ipc" = list(25, list(/obj/item/stock_parts/cell/family)), //gives a broken powercell for flavor text!
	"synthliz" = list(25, list(/obj/item/stock_parts/cell/family)), //they're also robots
	"slimeperson" = list(25, list(/obj/item/toy/plush/slimeplushie)),
	"lizard" = list(25, list(/obj/item/toy/plush/lizardplushie)),
	))

//job-heirloom list
GLOBAL_LIST_INIT(job_heirlooms, list(
	"NO_JOB" = list(/obj/item/toy/cards/deck, /obj/item/lighter, /obj/item/dice/d20),
	"Clown" = list(/obj/item/paint/anycolor, /obj/item/bikehorn/golden),
	"Mime" = list(/obj/item/paint/anycolor, /obj/item/toy/dummy),
	"Cook" = list(/obj/item/kitchen/knife/scimitar),
	"Botanist" = list(/obj/item/cultivator, /obj/item/reagent_containers/glass/bucket, /obj/item/storage/bag/plants, /obj/item/toy/plush/beeplushie),
	"Medical Doctor" = list(/obj/item/healthanalyzer),
	"Paramedic" = list(/obj/item/lighter), //..why?
	"Station Engineer" = list(/obj/item/wirecutters/brass/family, /obj/item/crowbar/brass/family, /obj/item/screwdriver/brass/family, /obj/item/wrench/brass/family), //brass tools but without the tool speed modifier
	"Atmospheric Technician" = list(/obj/item/extinguisher/mini/family),
	"Lawyer" = list(/obj/item/storage/briefcase/lawyer/family),
	"Janitor" = list(/obj/item/mop),
	"Scientist" = list(/obj/item/toy/plush/slimeplushie),
	"Assistant" = list(/obj/item/clothing/gloves/cut/family),
	"Chaplain" = list(/obj/item/camera/spooky/family),
	"Head of Personnel" = list(/obj/item/pinpointer/ian)
	))

//body ids that have non-gendered bodyparts
GLOBAL_LIST_INIT(nongendered_limb_types, list("fly", "zombie" ,"synth", "shadow", "cultgolem", "agent", "plasmaman", "clockgolem", "clothgolem"))

//list of eye types, corresponding to a respective left and right icon state for the set of eyes
GLOBAL_LIST_INIT(eye_types, list("normal", "insect", "moth", "double", "double2", "double3", "cyclops"))

//list linking bodypart bitflags to their actual names
GLOBAL_LIST_INIT(bodypart_names, list(num2text(HEAD) = "Head", num2text(CHEST) = "Chest", num2text(LEG_LEFT) = "Left Leg", num2text(LEG_RIGHT) = "Right Leg", num2text(ARM_LEFT) = "Left Arm", num2text(ARM_RIGHT) = "Right Arm"))
// list linking bodypart names back to the bitflags
GLOBAL_LIST_INIT(bodypart_values, list("Head" = num2text(HEAD), "Chest" = num2text(CHEST), "Left Leg" = num2text(LEG_LEFT), "Right Leg" = num2text(LEG_RIGHT), "Left Arm" = num2text(ARM_LEFT), "Right Arm" = num2text(ARM_RIGHT)))
