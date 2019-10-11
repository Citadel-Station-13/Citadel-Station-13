//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_references_lists()
	//hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/hair, GLOB.hair_styles_list, GLOB.hair_styles_male_list, GLOB.hair_styles_female_list)
	//facial hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, GLOB.facial_hair_styles_list, GLOB.facial_hair_styles_male_list, GLOB.facial_hair_styles_female_list)
	//underwear
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear/bottom, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
	//undershirt
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear/top, GLOB.undershirt_list, GLOB.undershirt_m, GLOB.undershirt_f)
	//socks
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear/socks, GLOB.socks_list)
	//bodypart accessories (blizzard intensifies)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/body_markings, GLOB.body_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/lizard, GLOB.tails_list_lizard)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/lizard, GLOB.animated_tails_list_lizard)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/human, GLOB.tails_list_human)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/human, GLOB.animated_tails_list_human)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/snouts, GLOB.snouts_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/horns,GLOB.horns_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ears, GLOB.ears_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.wings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings_open, GLOB.wings_open_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/frills, GLOB.frills_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spines, GLOB.spines_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spines_animated, GLOB.animated_spines_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/legs, GLOB.legs_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.r_wings_list,roundstart = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/caps, GLOB.caps_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/insect_wings, GLOB.insect_wings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/insect_fluff, GLOB.insect_fluffs_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/deco_wings, GLOB.deco_wings_list)

//CIT CHANGES START HERE, ADDS SNOWFLAKE BODYPARTS AND MORE
	//mammal bodyparts (fucking furries)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_body_markings, GLOB.mam_body_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_tails, GLOB.mam_tails_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_ears, GLOB.mam_ears_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_snouts, GLOB.mam_snouts_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_tails_animated, GLOB.mam_tails_animated_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/taur, GLOB.taur_list)
	//xeno parts (hiss?)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/xeno_head, GLOB.xeno_head_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/xeno_tail, GLOB.xeno_tail_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/xeno_dorsal, GLOB.xeno_dorsal_list)
	//ipcs
	init_sprite_accessory_subtypes(/datum/sprite_accessory/screen, GLOB.ipc_screens_list, roundstart = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/antenna, GLOB.ipc_antennas_list, roundstart = TRUE)
	//genitals
	init_sprite_accessory_subtypes(/datum/sprite_accessory/penis, GLOB.cock_shapes_list)
	for(var/K in GLOB.cock_shapes_list)
		var/datum/sprite_accessory/penis/value = GLOB.cock_shapes_list[K]
		GLOB.cock_shapes_icons[K] = value.icon_state

	init_sprite_accessory_subtypes(/datum/sprite_accessory/vagina, GLOB.vagina_shapes_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/breasts, GLOB.breasts_shapes_list)
	GLOB.breasts_size_list = list ("a", "b", "c", "d", "e") //We need the list to choose from initialized, but it's no longer a sprite_accessory thing.
	GLOB.gentlemans_organ_names = list("phallus", "willy", "dick", "prick", "member", "tool", "gentleman's organ",
	"cock", "wang", "knob", "dong", "joystick", "pecker", "johnson", "weenie", "tadger", "schlong", "thirsty ferret",
	"baloney pony", "schlanger", "Mutton dagger", "old blind bob","Hanging Johnny", "fishing rod", "Tally whacker", "polly rocket",
	"One eyed trouser trout", "Ding dong", "ankle spanker", "Pork sword", "engine cranker", "Harry hot dog", "Davy Crockett",
	"Kidney cracker", "Heat seeking moisture missile", "Giggle stick", "love whistle", "Tube steak", "Uncle Dick", "Purple helmet warrior")
	for(var/K in GLOB.breasts_shapes_list)
		var/datum/sprite_accessory/breasts/value = GLOB.breasts_shapes_list[K]
		GLOB.breasts_shapes_icons[K] = value.icon_state

	init_sprite_accessory_subtypes(/datum/sprite_accessory/testicles, GLOB.balls_shapes_list)
	for(var/K in GLOB.balls_shapes_list)
		var/datum/sprite_accessory/testicles/value = GLOB.balls_shapes_list[K]
		GLOB.balls_shapes_icons[K] = value.icon_state

//END OF CIT CHANGES

	//Species
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		GLOB.species_list[S.id] = spath

	//Surgeries
	for(var/path in subtypesof(/datum/surgery))
		GLOB.surgeries_list += new path()

	//Materials
	for(var/path in subtypesof(/datum/material))
		var/datum/material/D = new path()
		GLOB.materials_list[D.id] = D

	//Emotes
	for(var/path in subtypesof(/datum/emote))
		var/datum/emote/E = new path()
		E.emote_list[E.key] = E

	init_subtypes(/datum/crafting_recipe, GLOB.crafting_recipes)

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L)
	if(!istype(L))
		L = list()
		for(var/path in subtypesof(prototype))
			L+= path
		return L
