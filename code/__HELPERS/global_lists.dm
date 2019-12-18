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
	GLOB.mutant_features_list[FEAT_MARKINGS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/body_markings)
	GLOB.mutant_features_list[FEAT_TAIL_LIZARD] = init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/lizard)
	GLOB.mutant_features_list[FEAT_TAIL_LIZARD_WAG] = init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/lizard)
	GLOB.mutant_features_list[FEAT_TAIL_HUMAN] = init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/human, GLOB.tails_list_human)
	GLOB.mutant_features_list[FEAT_TAIL_HUMAN_WAG] = init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/human)
	GLOB.mutant_features_list[FEAT_SNOUT] = init_sprite_accessory_subtypes(/datum/sprite_accessory/snouts)
	GLOB.mutant_features_list[FEAT_HORNS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/horns)
	GLOB.mutant_features_list[FEAT_EARS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/ears)
	GLOB.mutant_features_list[FEAT_WINGS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/wings)
	GLOB.mutant_features_list[FEAT_WINGS_OPEN] = init_sprite_accessory_subtypes(/datum/sprite_accessory/wings_open)
	GLOB.mutant_features_list[FEAT_FRILLS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/frills)
	GLOB.mutant_features_list[FEAT_SPINES] = init_sprite_accessory_subtypes(/datum/sprite_accessory/spines)
	GLOB.mutant_features_list[FEAT_SPINES_WAG] = init_sprite_accessory_subtypes(/datum/sprite_accessory/spines_animated)
	GLOB.mutant_features_list[FEAT_LEGS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/legs)
	GLOB.mutant_features_list[FEAT_CAPS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/caps)
	GLOB.mutant_features_list[FEAT_INSECT_WINGS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/insect_wings)
	GLOB.mutant_features_list[FEAT_INSECT_FLUFF] = init_sprite_accessory_subtypes(/datum/sprite_accessory/insect_fluff)
	GLOB.mutant_features_list[FEAT_DECO_WINGS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/deco_wings)

//CIT CHANGES START HERE, ADDS SNOWFLAKE BODYPARTS AND MORE
	//mammal bodyparts (fucking furries)
	GLOB.mutant_features_list[FEAT_MAM_MARKINGS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_body_markings)
	GLOB.mutant_features_list[FEAT_TAIL_MAM] = init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_tails)
	GLOB.mutant_features_list[FEAT_MAM_EARS] = init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_ears)
	GLOB.mutant_features_list[FEAT_MAM_SNOUT] = init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_snouts)
	GLOB.mutant_features_list[FEAT_TAIL_MAM_WAG] = init_sprite_accessory_subtypes(/datum/sprite_accessory/mam_tails_animated)
	GLOB.mutant_features_list[FEAT_TAUR] = init_sprite_accessory_subtypes(/datum/sprite_accessory/taur)
	//xeno parts (hiss?)
	GLOB.mutant_features_list[FEAT_XENO_HEAD] = init_sprite_accessory_subtypes(/datum/sprite_accessory/xeno_head)
	GLOB.mutant_features_list[FEAT_XENO_TAIL] = init_sprite_accessory_subtypes(/datum/sprite_accessory/xeno_tail)
	GLOB.mutant_features_list[FEAT_XENO_DORSAL] = init_sprite_accessory_subtypes(/datum/sprite_accessory/xeno_dorsal)
	//ipcs
	GLOB.mutant_features_list[FEAT_IPC_SCREEN] = init_sprite_accessory_subtypes(/datum/sprite_accessory/screen)
	GLOB.mutant_features_list[FEAT_IPC_ANTENNA] = init_sprite_accessory_subtypes(/datum/sprite_accessory/antenna)
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

	for(var/gpath in subtypesof(/obj/item/organ/genital))
		var/obj/item/organ/genital/G = gpath
		if(!CHECK_BITFIELD(initial(G.genital_flags), GENITAL_BLACKLISTED))
			GLOB.genitals_list[initial(G.name)] = gpath
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

	//Uplink Items
	for(var/path in subtypesof(/datum/uplink_item))
		var/datum/uplink_item/I = path
		if(!initial(I.item)) //We add categories to a separate list.
			GLOB.uplink_categories |= initial(I.category)
			continue
		GLOB.uplink_items += path
	//(sub)typesof entries are listed by the order they are loaded in the code, so we'll have to rearrange them here.
	GLOB.uplink_items = sortList(GLOB.uplink_items, /proc/cmp_uplink_items_dsc)

	init_subtypes(/datum/crafting_recipe, GLOB.crafting_recipes)

	//Generates unrestricted counterpart of mutant_features_list, used on random_features() et similar.
	for(var/feat in GLOB.mutant_features_list)
		GLOB.unrestricted_mutant_features_list[feat] = selectable_accessories(GLOB.mutant_features_list[feat])

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
