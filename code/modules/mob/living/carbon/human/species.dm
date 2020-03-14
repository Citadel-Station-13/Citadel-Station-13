// This code handles different species in the game.

GLOBAL_LIST_EMPTY(roundstart_races)
GLOBAL_LIST_EMPTY(roundstart_race_names)

/datum/species
	var/id	// if the game needs to manually check your race to do something not included in a proc here, it will use this
	var/limbs_id		//this is used if you want to use a different species limb sprites. Mainly used for angels as they look like humans.
	var/name	// this is the fluff name. these will be left generic (such as 'Lizardperson' for the lizard race) so servers can change them to whatever
	var/default_color = "#FFF"	// if alien colors are disabled, this is the color that will be used by that race

	var/sexes = 1 // whether or not the race has sexual characteristics. at the moment this is only 0 for skeletons and shadows

	//Species Icon Drawing Offsets - Pixel X, Pixel Y, Aka X = Horizontal and Y = Vertical, from bottom left corner
	var/list/offset_features = list(
		OFFSET_UNIFORM = list(0,0),
		OFFSET_ID = list(0,0),
		OFFSET_GLOVES = list(0,0),
		OFFSET_GLASSES = list(0,0),
		OFFSET_EARS = list(0,0),
		OFFSET_SHOES = list(0,0),
		OFFSET_S_STORE = list(0,0),
		OFFSET_FACEMASK = list(0,0),
		OFFSET_HEAD = list(0,0),
		OFFSET_EYES = list(0,0),
		OFFSET_LIPS = list(0,0),
		OFFSET_BELT = list(0,0),
		OFFSET_BACK = list(0,0),
		OFFSET_HAIR = list(0,0),
		OFFSET_FHAIR = list(0,0),
		OFFSET_SUIT = list(0,0),
		OFFSET_NECK = list(0,0),
		OFFSET_MUTPARTS = list(0,0)
		)

	var/hair_color	// this allows races to have specific hair colors... if null, it uses the H's hair/facial hair colors. if "mutcolor", it uses the H's mutant_color
	var/hair_alpha = 255	// the alpha used by the hair. 255 is completely solid, 0 is transparent.

	var/horn_color	//specific horn colors, because why not?
	var/wing_color

	var/use_skintones = 0	// does it use skintones or not? (spoiler alert this is only used by humans)
	var/exotic_blood = ""	// If your race wants to bleed something other than bog standard blood, change this to reagent id.
	var/exotic_bloodtype = "" //If your race uses a non standard bloodtype (A+, O-, AB-, etc)
	var/meat = /obj/item/reagent_containers/food/snacks/meat/slab/human //What the species drops on gibbing
	var/list/gib_types = list(/obj/effect/gibspawner/human, /obj/effect/gibspawner/human/bodypartless)
	var/skinned_type
	var/liked_food = NONE
	var/disliked_food = GROSS
	var/toxic_food = TOXIC
	var/list/no_equip = list()	// slots the race can't equip stuff to
	var/nojumpsuit = 0	// this is sorta... weird. it basically lets you equip stuff that usually needs jumpsuits without one, like belts and pockets and ids
	var/blacklisted = 0 //Flag to exclude from green slime core species.
	var/dangerous_existence //A flag for transformation spells that tells them "hey if you turn a person into one of these without preperation, they'll probably die!"
	var/say_mod = "says"	// affects the speech message
	var/list/default_features = list() // Default mutant bodyparts for this species. Don't forget to set one for every mutant bodypart you allow this species to have.
	var/list/mutant_bodyparts = list() 	// Visible CURRENT bodyparts that are unique to a species. DO NOT USE THIS AS A LIST OF ALL POSSIBLE BODYPARTS AS IT WILL FUCK SHIT UP! Changes to this list for non-species specific bodyparts (ie cat ears and tails) should be assigned at organ level if possible. Layer hiding is handled by handle_mutant_bodyparts() below.
	var/list/mutant_organs = list()		//Internal organs that are unique to this race.
	var/speedmod = 0	// this affects the race's speed. positive numbers make it move slower, negative numbers make it move faster
	var/armor = 0		// overall defense for the race... or less defense, if it's negative.
	var/brutemod = 1	// multiplier for brute damage
	var/burnmod = 1		// multiplier for burn damage
	var/coldmod = 1		// multiplier for cold damage
	var/heatmod = 1		// multiplier for heat damage
	var/stunmod = 1		// multiplier for stun duration
	var/punchdamagelow = 0       //lowest possible punch damage
	var/punchdamagehigh = 9      //highest possible punch damage
	var/punchstunthreshold = 9//damage at which punches from this race will stun //yes it should be to the attacked race but it's not useful that way even if it's logical
	var/siemens_coeff = 1 //base electrocution coefficient
	var/damage_overlay_type = "human" //what kind of damage overlays (if any) appear on our species when wounded?
	var/fixed_mut_color = "" //to use MUTCOLOR with a fixed color that's independent of dna.feature["mcolor"]
	var/inert_mutation = DWARFISM
	var/list/special_step_sounds //Sounds to override barefeet walkng
	var/grab_sound //Special sound for grabbing
	var/datum/outfit/outfit_important_for_life // A path to an outfit that is important for species life e.g. plasmaman outfit

	// species-only traits. Can be found in DNA.dm
	var/list/species_traits = list()
	// generic traits tied to having the species
	var/list/inherent_traits = list()
	var/inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID

	var/attack_verb = "punch"	// punch-specific attack verb
	var/sound/attack_sound = 'sound/weapons/punch1.ogg'
	var/sound/miss_sound = 'sound/weapons/punchmiss.ogg'

	var/list/mob/living/ignored_by = list()	// list of mobs that will ignore this species
	//Breathing!
	var/obj/item/organ/lungs/mutantlungs = null
	var/breathid = "o2"

	var/obj/item/organ/brain/mutant_brain = /obj/item/organ/brain
	var/obj/item/organ/heart/mutant_heart = /obj/item/organ/heart
	var/obj/item/organ/eyes/mutanteyes = /obj/item/organ/eyes
	var/obj/item/organ/ears/mutantears = /obj/item/organ/ears
	var/obj/item/mutanthands
	var/obj/item/organ/tongue/mutanttongue = /obj/item/organ/tongue
	var/obj/item/organ/tail/mutanttail = null

	var/obj/item/organ/liver/mutantliver
	var/obj/item/organ/stomach/mutantstomach
	var/override_float = FALSE

	//Citadel snowflake
	var/fixed_mut_color2 = ""
	var/fixed_mut_color3 = ""
	var/whitelisted = 0 		//Is this species restricted to certain players?
	var/whitelist = list() 		//List the ckeys that can use this species, if it's whitelisted.: list("John Doe", "poopface666", "SeeALiggerPullTheTrigger") Spaces & capitalization can be included or ignored entirely for each key as it checks for both.
	var/icon_limbs //Overrides the icon used for the limbs of this species. Mainly for downstream, and also because hardcoded icons disgust me. Implemented and maintained as a favor in return for a downstream's implementation of synths.

///////////
// PROCS //
///////////


/datum/species/New()

	if(!limbs_id)	//if we havent set a limbs id to use, just use our own id
		limbs_id = id
	..()


/proc/generate_selectable_species(clear = FALSE)
	if(clear)
		GLOB.roundstart_races = list()
		GLOB.roundstart_race_names = list()
	for(var/I in subtypesof(/datum/species))
		var/datum/species/S = new I
		if(S.check_roundstart_eligible())
			GLOB.roundstart_races |= S.id
			GLOB.roundstart_race_names["[S.name]"] = S.id
			qdel(S)
	if(!GLOB.roundstart_races.len)
		GLOB.roundstart_races += "human"

/datum/species/proc/check_roundstart_eligible()
	if(id in (CONFIG_GET(keyed_list/roundstart_races)))
		return TRUE
	return FALSE

/datum/species/proc/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_name(gender)

	var/randname
	if(gender == MALE)
		randname = pick(GLOB.first_names_male)
	else
		randname = pick(GLOB.first_names_female)

	if(lastname)
		randname += " [lastname]"
	else
		randname += " [pick(GLOB.last_names)]"

	return randname

//Called when cloning, copies some vars that should be kept
/datum/species/proc/copy_properties_from(datum/species/old_species)
	return

//Please override this locally if you want to define when what species qualifies for what rank if human authority is enforced.
/datum/species/proc/qualifies_for_rank(rank, list/features) //SPECIES JOB RESTRICTIONS
	//if(rank in GLOB.command_positions) Left as an example: The format qualifies for rank takes.
	//	return 0 //It returns false when it runs the proc so they don't get jobs from the global list.
	return 1 //It returns 1 to say they are a-okay to continue.

//Will regenerate missing organs
/datum/species/proc/regenerate_organs(mob/living/carbon/C,datum/species/old_species,replace_current=TRUE)
	var/obj/item/organ/brain/brain = C.getorganslot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/heart/heart = C.getorganslot(ORGAN_SLOT_HEART)
	var/obj/item/organ/lungs/lungs = C.getorganslot(ORGAN_SLOT_LUNGS)
	var/obj/item/organ/appendix/appendix = C.getorganslot(ORGAN_SLOT_APPENDIX)
	var/obj/item/organ/eyes/eyes = C.getorganslot(ORGAN_SLOT_EYES)
	var/obj/item/organ/ears/ears = C.getorganslot(ORGAN_SLOT_EARS)
	var/obj/item/organ/tongue/tongue = C.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/liver/liver = C.getorganslot(ORGAN_SLOT_LIVER)
	var/obj/item/organ/stomach/stomach = C.getorganslot(ORGAN_SLOT_STOMACH)
	var/obj/item/organ/tail/tail = C.getorganslot(ORGAN_SLOT_TAIL)

	var/should_have_brain = TRUE
	var/should_have_heart = !(NOBLOOD in species_traits)
	var/should_have_lungs = !(TRAIT_NOBREATH in inherent_traits)
	var/should_have_appendix = !(TRAIT_NOHUNGER in inherent_traits)
	var/should_have_eyes = TRUE
	var/should_have_ears = TRUE
	var/should_have_tongue = TRUE
	var/should_have_liver = !(NOLIVER in species_traits)
	var/should_have_stomach = !(NOSTOMACH in species_traits)
	var/should_have_tail = mutanttail

	if(brain && (replace_current || !should_have_brain))
		if(!brain.decoy_override)//Just keep it if it's fake
			brain.Remove(TRUE,TRUE)
			QDEL_NULL(brain)
	if(should_have_brain && !brain)
		brain = new mutant_brain()
		brain.Insert(C, TRUE, TRUE)

	if(heart && (!should_have_heart || replace_current))
		heart.Remove(TRUE)
		QDEL_NULL(heart)
	if(should_have_heart && !heart)
		heart = new mutant_heart()
		heart.Insert(C)

	if(lungs && (!should_have_lungs || replace_current))
		lungs.Remove(TRUE)
		QDEL_NULL(lungs)
	if(should_have_lungs && !lungs)
		if(mutantlungs)
			lungs = new mutantlungs()
		else
			lungs = new()
		lungs.Insert(C)

	if(liver && (!should_have_liver || replace_current))
		liver.Remove(TRUE)
		QDEL_NULL(liver)
	if(should_have_liver && !liver)
		if(mutantliver)
			liver = new mutantliver()
		else
			liver = new()
		liver.Insert(C)

	if(stomach && (!should_have_stomach || replace_current))
		stomach.Remove(TRUE)
		QDEL_NULL(stomach)
	if(should_have_stomach && !stomach)
		if(mutantstomach)
			stomach = new mutantstomach()
		else
			stomach = new()
		stomach.Insert(C)

	if(appendix && (!should_have_appendix || replace_current))
		appendix.Remove(TRUE)
		QDEL_NULL(appendix)
	if(should_have_appendix && !appendix)
		appendix = new()
		appendix.Insert(C)

	if(tail && (!should_have_tail || replace_current))
		tail.Remove(TRUE)
		QDEL_NULL(tail)
	if(should_have_tail && !tail)
		tail = new mutanttail()
		tail.Insert(C)

	if(C.get_bodypart(BODY_ZONE_HEAD))
		if(eyes && (replace_current || !should_have_eyes))
			eyes.Remove(TRUE)
			QDEL_NULL(eyes)
		if(should_have_eyes && !eyes)
			eyes = new mutanteyes
			eyes.Insert(C, TRUE)

		if(ears && (replace_current || !should_have_ears))
			ears.Remove(TRUE)
			QDEL_NULL(ears)
		if(should_have_ears && !ears)
			ears = new mutantears
			ears.Insert(C)

		if(tongue && (replace_current || !should_have_tongue))
			tongue.Remove(TRUE)
			QDEL_NULL(tongue)
		if(should_have_tongue && !tongue)
			tongue = new mutanttongue
			tongue.Insert(C)

	if(old_species)
		for(var/mutantorgan in old_species.mutant_organs)
			var/obj/item/organ/I = C.getorgan(mutantorgan)
			if(I)
				I.Remove()
				QDEL_NULL(I)

	for(var/path in mutant_organs)
		var/obj/item/organ/I = new path()
		I.Insert(C)

/datum/species/proc/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	// Drop the items the new species can't wear
	for(var/slot_id in no_equip)
		var/obj/item/thing = C.get_item_by_slot(slot_id)
		if(thing && (!thing.species_exception || !is_type_in_list(src,thing.species_exception)))
			C.dropItemToGround(thing)
	if(C.hud_used)
		C.hud_used.update_locked_slots()

	// this needs to be FIRST because qdel calls update_body which checks if we have DIGITIGRADE legs or not and if not then removes DIGITIGRADE from species_traits
	if(("legs" in C.dna.species.mutant_bodyparts) && (C.dna.features["legs"] == "Digitigrade" || C.dna.features["legs"] == "Avian"))
		species_traits |= DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(FALSE)

	C.mob_biotypes = inherent_biotypes

	regenerate_organs(C,old_species)

	if(exotic_bloodtype && C.dna.blood_type != exotic_bloodtype)
		C.dna.blood_type = exotic_bloodtype

	if(old_species.mutanthands)
		for(var/obj/item/I in C.held_items)
			if(istype(I, old_species.mutanthands))
				qdel(I)

	if(mutanthands)
		// Drop items in hands
		// If you're lucky enough to have a TRAIT_NODROP item, then it stays.
		for(var/V in C.held_items)
			var/obj/item/I = V
			if(istype(I))
				C.dropItemToGround(I)
			else	//Entries in the list should only ever be items or null, so if it's not an item, we can assume it's an empty hand
				C.put_in_hands(new mutanthands())

	for(var/X in inherent_traits)
		ADD_TRAIT(C, X, SPECIES_TRAIT)

	if(TRAIT_VIRUSIMMUNE in inherent_traits)
		for(var/datum/disease/A in C.diseases)
			A.cure(FALSE)

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(NOGENITALS in H.dna.species.species_traits)
			H.give_genitals(TRUE) //call the clean up proc to delete anything on the mob then return.
		if("meat_type" in default_features) //I can't believe it's come to the meat
			H.type_of_meat = GLOB.meat_types[H.dna.features["meat_type"]]

	C.add_movespeed_modifier(MOVESPEED_ID_SPECIES, TRUE, 100, override=TRUE, multiplicative_slowdown=speedmod, movetypes=(~FLYING))

	SEND_SIGNAL(C, COMSIG_SPECIES_GAIN, src, old_species)


// EDIT ENDS

/datum/species/proc/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	if(C.dna.species.exotic_bloodtype)
		if(!new_species.exotic_bloodtype)
			C.dna.blood_type = random_blood_type()
		else
			C.dna.blood_type = new_species.exotic_bloodtype
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(TRUE)
	for(var/X in inherent_traits)
		REMOVE_TRAIT(C, X, SPECIES_TRAIT)

	C.remove_movespeed_modifier(MOVESPEED_ID_SPECIES)

	if("meat_type" in default_features)
		C.type_of_meat = GLOB.meat_types[C.dna.features["meat_type"]]
	else
		C.type_of_meat = initial(meat)

	//If their inert mutation is not the same, swap it out
	if((inert_mutation != new_species.inert_mutation) && LAZYLEN(C.dna.mutation_index) && (inert_mutation in C.dna.mutation_index))
		C.dna.remove_mutation(inert_mutation)
		//keep it at the right spot, so we can't have people taking shortcuts
		var/location = C.dna.mutation_index.Find(inert_mutation)
		C.dna.mutation_index[location] = new_species.inert_mutation
		C.dna.mutation_index[new_species.inert_mutation] = create_sequence(new_species.inert_mutation)

	SEND_SIGNAL(C, COMSIG_SPECIES_LOSS, src)

/datum/species/proc/handle_hair(mob/living/carbon/human/H, forced_colour)
	H.remove_overlay(HAIR_LAYER)
	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)
	if(!HD) //Decapitated
		return
	if(HAS_TRAIT(H, TRAIT_HUSK))
		return

	var/datum/sprite_accessory/S
	var/list/standing = list()

	var/hair_hidden = FALSE //ignored if the matching dynamic_X_suffix is non-empty
	var/facialhair_hidden = FALSE // ^

	var/dynamic_hair_suffix = "" //if this is non-null, and hair+suffix matches an iconstate, then we render that hair instead
	var/dynamic_fhair_suffix = ""

	//for augmented heads
	if(HD.status == BODYPART_ROBOTIC)
		return

	//we check if our hat or helmet hides our facial hair.
	if(H.head)
		var/obj/item/I = H.head
		if(istype(I, /obj/item/clothing))
			var/obj/item/clothing/C = I
			dynamic_fhair_suffix = C.dynamic_fhair_suffix
		if(I.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		dynamic_fhair_suffix = M.dynamic_fhair_suffix //mask > head in terms of facial hair
		if(M.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(H.facial_hair_style && (FACEHAIR in species_traits) && (!facialhair_hidden || dynamic_fhair_suffix))
		S = GLOB.facial_hair_styles_list[H.facial_hair_style]
		if(S)
			//List of all valid dynamic_fhair_suffixes
			var/static/list/fextensions
			if(!fextensions)
				var/icon/fhair_extensions = icon('icons/mob/facialhair_extensions.dmi')
				fextensions = list()
				for(var/s in fhair_extensions.IconStates(1))
					fextensions[s] = TRUE
				qdel(fhair_extensions)

			//Is hair+dynamic_fhair_suffix a valid iconstate?
			var/fhair_state = S.icon_state
			var/fhair_file = S.icon
			if(fextensions[fhair_state+dynamic_fhair_suffix])
				fhair_state += dynamic_fhair_suffix
				fhair_file = 'icons/mob/facialhair_extensions.dmi'

			var/mutable_appearance/facial_overlay = mutable_appearance(fhair_file, fhair_state, -HAIR_LAYER)

			if(!forced_colour)
				if(hair_color)
					if(hair_color == "mutcolor")
						facial_overlay.color = "#" + H.dna.features["mcolor"]
					else
						facial_overlay.color = "#" + hair_color
				else
					facial_overlay.color = "#" + H.facial_hair_color
			else
				facial_overlay.color = forced_colour

			facial_overlay.alpha = hair_alpha

			if(OFFSET_FHAIR in H.dna.species.offset_features)
				facial_overlay.pixel_x += H.dna.species.offset_features[OFFSET_FHAIR][1]
				facial_overlay.pixel_y += H.dna.species.offset_features[OFFSET_FHAIR][2]

			standing += facial_overlay

	if(H.head)
		var/obj/item/I = H.head
		if(istype(I, /obj/item/clothing))
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix
		if(I.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		if(!dynamic_hair_suffix) //head > mask in terms of head hair
			dynamic_hair_suffix = M.dynamic_hair_suffix
		if(M.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(!hair_hidden || dynamic_hair_suffix)
		var/mutable_appearance/hair_overlay = mutable_appearance(layer = -HAIR_LAYER)
		if(!hair_hidden && !H.getorgan(/obj/item/organ/brain)) //Applies the debrained overlay if there is no brain
			if(!(NOBLOOD in species_traits))
				hair_overlay.icon = 'icons/mob/human_face.dmi'
				hair_overlay.icon_state = "debrained"

		else if(H.hair_style && (HAIR in species_traits))
			S = GLOB.hair_styles_list[H.hair_style]
			if(S)
				//List of all valid dynamic_hair_suffixes
				var/static/list/extensions
				if(!extensions)
					var/icon/hair_extensions = icon('icons/mob/hair_extensions.dmi') //hehe
					extensions = list()
					for(var/s in hair_extensions.IconStates(1))
						extensions[s] = TRUE
					qdel(hair_extensions)

				//Is hair+dynamic_hair_suffix a valid iconstate?
				var/hair_state = S.icon_state
				var/hair_file = S.icon
				if(extensions[hair_state+dynamic_hair_suffix])
					hair_state += dynamic_hair_suffix
					hair_file = 'icons/mob/hair_extensions.dmi'

				hair_overlay.icon = hair_file
				hair_overlay.icon_state = hair_state

				if(!forced_colour)
					if(hair_color)
						if(hair_color == "mutcolor")
							hair_overlay.color = "#" + H.dna.features["mcolor"]
						else
							hair_overlay.color = "#" + hair_color
					else
						hair_overlay.color = "#" + H.hair_color
				else
					hair_overlay.color = forced_colour
				hair_overlay.alpha = hair_alpha

				if(OFFSET_HAIR in H.dna.species.offset_features)
					hair_overlay.pixel_x += H.dna.species.offset_features[OFFSET_HAIR][1]
					hair_overlay.pixel_y += H.dna.species.offset_features[OFFSET_HAIR][2]

		if(hair_overlay.icon)
			standing += hair_overlay

	if(standing.len)
		H.overlays_standing[HAIR_LAYER] = standing

	H.apply_overlay(HAIR_LAYER)

/datum/species/proc/handle_body(mob/living/carbon/human/H)
	H.remove_overlay(BODY_LAYER)

	var/list/standing = list()

	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)

	if(HD && !(HAS_TRAIT(H, TRAIT_HUSK)))
		// lipstick
		if(H.lip_style && (LIPS in species_traits))
			var/mutable_appearance/lip_overlay = mutable_appearance('icons/mob/human_face.dmi', "lips_[H.lip_style]", -BODY_LAYER)
			lip_overlay.color = H.lip_color

			if(OFFSET_LIPS in H.dna.species.offset_features)
				lip_overlay.pixel_x += H.dna.species.offset_features[OFFSET_LIPS][1]
				lip_overlay.pixel_y += H.dna.species.offset_features[OFFSET_LIPS][2]

			standing += lip_overlay

		// eyes
		if(!(NOEYES in species_traits))
			var/has_eyes = H.getorganslot(ORGAN_SLOT_EYES)
			var/mutable_appearance/eye_overlay
			if(!has_eyes)
				eye_overlay = mutable_appearance('icons/mob/human_face.dmi', "eyes_missing", -BODY_LAYER)
			else
				eye_overlay = mutable_appearance('icons/mob/human_face.dmi', "eyes", -BODY_LAYER)
			if((EYECOLOR in species_traits) && has_eyes)
				eye_overlay.color = "#" + H.eye_color

			if(OFFSET_EYES in H.dna.species.offset_features)
				eye_overlay.pixel_x += H.dna.species.offset_features[OFFSET_EYES][1]
				eye_overlay.pixel_y += H.dna.species.offset_features[OFFSET_EYES][2]

			standing += eye_overlay

	//Underwear, Undershirts & Socks
	if(!(NO_UNDERWEAR in species_traits))

		if(H.socks && H.get_num_legs(FALSE) >= 2)
			if(H.hidden_socks)
				H.socks = "Nude"
			else
				H.socks = H.saved_socks
				var/datum/sprite_accessory/underwear/socks/S = GLOB.socks_list[H.socks]
				if(S)
					var/digilegs = ((DIGITIGRADE in species_traits) && S.has_digitigrade) ? "_d" : ""
					var/mutable_appearance/MA = mutable_appearance(S.icon, "[S.icon_state][digilegs]", -BODY_LAYER)
					if(S.has_color)
						MA.color = "#[H.socks_color]"
					standing += MA

		if(H.underwear)
			if(H.hidden_underwear)
				H.underwear = "Nude"
			else
				H.underwear = H.saved_underwear
				var/datum/sprite_accessory/underwear/bottom/B = GLOB.underwear_list[H.underwear]
				if(B)
					var/digilegs = ((DIGITIGRADE in species_traits) && B.has_digitigrade) ? "_d" : ""
					var/mutable_appearance/MA = mutable_appearance(B.icon, "[B.icon_state][digilegs]", -BODY_LAYER)
					if(B.has_color)
						MA.color = "#[H.undie_color]"
					standing += MA

		if(H.undershirt)
			if(H.hidden_undershirt)
				H.undershirt = "Nude"
			else
				H.undershirt = H.saved_undershirt
				var/datum/sprite_accessory/underwear/top/T = GLOB.undershirt_list[H.undershirt]
				if(T)
					var/state = "[T.icon_state][((DIGITIGRADE in species_traits) && T.has_digitigrade) ? "_d" : ""]"
					var/mutable_appearance/MA
					if(H.dna.species.sexes && H.gender == FEMALE)
						MA = wear_female_version(state, T.icon, BODY_LAYER)
					else
						MA = mutable_appearance(T.icon, state, -BODY_LAYER)
					if(T.has_color)
						MA.color = "#[H.shirt_color]"
					standing += MA

	if(standing.len)
		H.overlays_standing[BODY_LAYER] = standing

	H.apply_overlay(BODY_LAYER)
	handle_mutant_bodyparts(H)

/datum/species/proc/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	var/list/bodyparts_to_add = mutant_bodyparts.Copy()
	var/list/relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER, BODY_TAUR_LAYER)
	var/list/standing	= list()

	H.remove_overlay(BODY_BEHIND_LAYER)
	H.remove_overlay(BODY_ADJ_LAYER)
	H.remove_overlay(BODY_FRONT_LAYER)
	//CITADEL EDIT - Do not forget to add this to relevent_layers list just above too!
	H.remove_overlay(BODY_TAUR_LAYER)
	//END EDIT

	if(!mutant_bodyparts)
		return

	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)
	var/tauric = H.dna.features["taur"] && H.dna.features["taur"] != "None"

	if("tail_lizard" in mutant_bodyparts)
		if((H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)) || tauric)
			bodyparts_to_add -= "tail_lizard"

	if("waggingtail_lizard" in mutant_bodyparts)
		if((H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)) || tauric)
			bodyparts_to_add -= "waggingtail_lizard"
		else if ("tail_lizard" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_lizard"

	if("tail_human" in mutant_bodyparts)
		if((H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)) || tauric)
			bodyparts_to_add -= "tail_human"

	if("waggingtail_human" in mutant_bodyparts)
		if((H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)) || tauric)
			bodyparts_to_add -= "waggingtail_human"
		else if ("tail_human" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_human"

	if("spines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR))
			bodyparts_to_add -= "spines"

	if("waggingspines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR))
			bodyparts_to_add -= "waggingspines"
		else if ("tail" in mutant_bodyparts)
			bodyparts_to_add -= "waggingspines"

	if("snout" in mutant_bodyparts) //Take a closer look at that snout!
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDESNOUT)) || (H.head && (H.head.flags_inv & HIDESNOUT)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "snout"

	if("frills" in mutant_bodyparts)
		if(!H.dna.features["frills"] || H.dna.features["frills"] == "None" || H.head && (H.head.flags_inv & HIDEEARS) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "frills"

	if("horns" in mutant_bodyparts)
		if(!H.dna.features["horns"] || H.dna.features["horns"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "horns"

	if("ears" in mutant_bodyparts)
		if(!H.dna.features["ears"] || H.dna.features["ears"] == "None" || H.head && (H.head.flags_inv & HIDEEARS) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEEARS)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "ears"

	if("wings" in mutant_bodyparts)
		if(!H.dna.features["wings"] || H.dna.features["wings"] == "None" || (H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))
			bodyparts_to_add -= "wings"

	if("wings_open" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception)))
			bodyparts_to_add -= "wings_open"
		else if ("wings" in mutant_bodyparts)
			bodyparts_to_add -= "wings_open"

	if("insect_fluff" in mutant_bodyparts)
		if(!H.dna.features["insect_fluff"] || H.dna.features["insect_fluff"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "insect_fluff"

//CITADEL EDIT
	//Race specific bodyparts:
	//Xenos
	if("xenodorsal" in mutant_bodyparts)
		if(!H.dna.features["xenodorsal"] || H.dna.features["xenodorsal"] == "None" || (H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT)))
			bodyparts_to_add -= "xenodorsal"
	if("xenohead" in mutant_bodyparts)//This is an overlay for different castes using different head crests
		if(!H.dna.features["xenohead"] || H.dna.features["xenohead"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "xenohead"
	if("xenotail" in mutant_bodyparts)
		if(!H.dna.features["xenotail"] || H.dna.features["xenotail"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "xenotail"

	//Other Races
	if("mam_tail" in mutant_bodyparts)
		if((H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)) || tauric)
			bodyparts_to_add -= "mam_tail"

	if("mam_waggingtail" in mutant_bodyparts)
		if((H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)) || tauric)
			bodyparts_to_add -= "mam_waggingtail"
		else if ("mam_tail" in mutant_bodyparts)
			bodyparts_to_add -= "mam_waggingtail"

	if("mam_ears" in mutant_bodyparts)
		if(!H.dna.features["mam_ears"] || H.dna.features["mam_ears"] == "None" || H.head && (H.head.flags_inv & HIDEEARS) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEEARS)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "mam_ears"

	if("mam_snouts" in mutant_bodyparts) //Take a closer look at that snout!
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDESNOUT)) || (H.head && (H.head.flags_inv & HIDESNOUT)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "mam_snouts"

	if("taur" in mutant_bodyparts)
		if(!tauric || (H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)))
			bodyparts_to_add -= "taur"

//END EDIT

	//Digitigrade legs are stuck in the phantom zone between true limbs and mutant bodyparts. Mainly it just needs more agressive updating than most limbs.
	var/update_needed = FALSE
	var/not_digitigrade = TRUE
	for(var/X in H.bodyparts)
		var/obj/item/bodypart/O = X
		if(!O.use_digitigrade)
			continue
		not_digitigrade = FALSE
		if(!(DIGITIGRADE in species_traits)) //Someone cut off a digitigrade leg and tacked it on
			species_traits += DIGITIGRADE
		var/should_be_squished = FALSE
		if(H.wear_suit)
			if(!(H.wear_suit.mutantrace_variation & STYLE_DIGITIGRADE) || (tauric && (H.wear_suit.mutantrace_variation & STYLE_ALL_TAURIC))) //digitigrade/taur suits
				should_be_squished = TRUE
		if(H.w_uniform && !H.wear_suit)
			if(!(H.w_uniform.mutantrace_variation & STYLE_DIGITIGRADE))
				should_be_squished = TRUE
		if(O.use_digitigrade == FULL_DIGITIGRADE && should_be_squished)
			O.use_digitigrade = SQUISHED_DIGITIGRADE
			update_needed = TRUE
		else if(O.use_digitigrade == SQUISHED_DIGITIGRADE && !should_be_squished)
			O.use_digitigrade = FULL_DIGITIGRADE
			update_needed = TRUE
	if(update_needed)
		H.update_body_parts()
	if(not_digitigrade && (DIGITIGRADE in species_traits)) //Curse is lifted
		species_traits -= DIGITIGRADE

	if(!bodyparts_to_add)
		return

	var/g = (H.gender == FEMALE) ? "f" : "m"

	for(var/layer in relevent_layers)
		var/layertext = mutant_bodyparts_layertext(layer)

		for(var/bodypart in bodyparts_to_add)
			var/datum/sprite_accessory/S
			switch(bodypart)
				if("tail_lizard")
					S = GLOB.tails_list_lizard[H.dna.features["tail_lizard"]]
				if("waggingtail_lizard")
					S = GLOB.animated_tails_list_lizard[H.dna.features["tail_lizard"]]
				if("tail_human")
					S = GLOB.tails_list_human[H.dna.features["tail_human"]]
				if("waggingtail_human")
					S = GLOB.animated_tails_list_human[H.dna.features["tail_human"]]
				if("spines")
					S = GLOB.spines_list[H.dna.features["spines"]]
				if("waggingspines")
					S = GLOB.animated_spines_list[H.dna.features["spines"]]
				if("snout")
					S = GLOB.snouts_list[H.dna.features["snout"]]
				if("frills")
					S = GLOB.frills_list[H.dna.features["frills"]]
				if("horns")
					S = GLOB.horns_list[H.dna.features["horns"]]
				if("ears")
					S = GLOB.ears_list[H.dna.features["ears"]]
				if("body_markings")
					S = GLOB.body_markings_list[H.dna.features["body_markings"]]
				if("wings")
					S = GLOB.wings_list[H.dna.features["wings"]]
				if("wingsopen")
					S = GLOB.wings_open_list[H.dna.features["wings"]]
				if("deco_wings")
					S = GLOB.deco_wings_list[H.dna.features["deco_wings"]]
				if("legs")
					S = GLOB.legs_list[H.dna.features["legs"]]
				if("insect_wings")
					S = GLOB.insect_wings_list[H.dna.features["insect_wings"]]
				if("insect_fluff")
					S = GLOB.insect_fluffs_list[H.dna.features["insect_fluff"]]
				if("insect_markings")
					S = GLOB.insect_markings_list[H.dna.features["insect_markings"]]
				if("caps")
					S = GLOB.caps_list[H.dna.features["caps"]]
				if("ipc_screen")
					S = GLOB.ipc_screens_list[H.dna.features["ipc_screen"]]
				if("ipc_antenna")
					S = GLOB.ipc_antennas_list[H.dna.features["ipc_antenna"]]
				if("mam_tail")
					S = GLOB.mam_tails_list[H.dna.features["mam_tail"]]
				if("mam_waggingtail")
					S = GLOB.mam_tails_animated_list[H.dna.features["mam_tail"]]
				if("mam_body_markings")
					S = GLOB.mam_body_markings_list[H.dna.features["mam_body_markings"]]
				if("mam_ears")
					S = GLOB.mam_ears_list[H.dna.features["mam_ears"]]
				if("mam_snouts")
					S = GLOB.mam_snouts_list[H.dna.features["mam_snouts"]]
				if("taur")
					S = GLOB.taur_list[H.dna.features["taur"]]
				if("xenodorsal")
					S = GLOB.xeno_dorsal_list[H.dna.features["xenodorsal"]]
				if("xenohead")
					S = GLOB.xeno_head_list[H.dna.features["xenohead"]]
				if("xenotail")
					S = GLOB.xeno_tail_list[H.dna.features["xenotail"]]

			if(!S || S.icon_state == "none")
				continue

			var/mutable_appearance/accessory_overlay = mutable_appearance(S.icon, layer = -layer)

			accessory_overlay.color = null //just because. reee.

			//A little rename so we don't have to use tail_lizard or tail_human when naming the sprites.
			if(bodypart == "tail_lizard" || bodypart == "tail_human" || bodypart == "mam_tail" || bodypart == "xenotail")
				bodypart = "tail"
			if(bodypart == "mam_waggingtail" || bodypart == "waggingtail_human" || bodypart == "waggingtail_lizard")
				bodypart = "tailwag"
			if(bodypart == "mam_ears" || bodypart == "ears")
				bodypart = "ears"
			if(bodypart == "mam_snouts" || bodypart == "snout")
				bodypart = "snout"
			if(bodypart == "xenohead")
				bodypart = "xhead"
			if(bodypart == "insect_wings" || bodypart == "deco_wings")
				bodypart = "insect_wings"

			if(S.gender_specific)
				accessory_overlay.icon_state = "[g]_[bodypart]_[S.icon_state]_[layertext]"
			else
				accessory_overlay.icon_state = "m_[bodypart]_[S.icon_state]_[layertext]"

			if(S.center)
				accessory_overlay = center_image(accessory_overlay, S.dimension_x, S.dimension_y)

			var/list/colorlist = list()
			colorlist.Cut()
			colorlist += ReadRGB("[H.dna.features["mcolor"]]0")
			colorlist += ReadRGB("[H.dna.features["mcolor2"]]0")
			colorlist += ReadRGB("[H.dna.features["mcolor3"]]0")
			colorlist += list(0,0,0, hair_alpha)
			for(var/index=1, index<=colorlist.len, index++)
				colorlist[index] = colorlist[index]/255

			if(!HAS_TRAIT(H, TRAIT_HUSK))
				if(!forced_colour)
					switch(S.color_src)
						if(SKINTONE)
							accessory_overlay.color = "#[skintone2hex(H.skin_tone)]"
						if(MUTCOLORS)
							if(fixed_mut_color)
								accessory_overlay.color = "#[fixed_mut_color]"
							else
								accessory_overlay.color = "#[H.dna.features["mcolor"]]"
						if(MUTCOLORS2)
							if(fixed_mut_color2)
								accessory_overlay.color = "#[fixed_mut_color2]"
							else
								accessory_overlay.color = "#[H.dna.features["mcolor2"]]"
						if(MUTCOLORS3)
							if(fixed_mut_color3)
								accessory_overlay.color = "#[fixed_mut_color3]"
							else
								accessory_overlay.color = "#[H.dna.features["mcolor3"]]"

						if(MATRIXED)
							accessory_overlay.color = list(colorlist)

						if(HAIR)
							if(hair_color == "mutcolor")
								accessory_overlay.color = "#[H.dna.features["mcolor"]]"
							else
								accessory_overlay.color = "#[H.hair_color]"
						if(FACEHAIR)
							accessory_overlay.color = "#[H.facial_hair_color]"
						if(EYECOLOR)
							accessory_overlay.color = "#[H.eye_color]"
						if(HORNCOLOR)
							accessory_overlay.color = "#[H.horn_color]"
						if(WINGCOLOR)
							accessory_overlay.color = "#[H.wing_color]"
				else
					accessory_overlay.color = forced_colour
			else
				if(bodypart == "ears")
					accessory_overlay.icon_state = "m_ears_none_[layertext]"
				if(bodypart == "tail")
					accessory_overlay.icon_state = "m_tail_husk_[layertext]"
				if(MATRIXED)
					var/list/husklist = list()
					husklist += ReadRGB("#a3a3a3")
					husklist += ReadRGB("#a3a3a3")
					husklist += ReadRGB("#a3a3a3")
					husklist += list(0,0,0, hair_alpha)
					for(var/index=1, index<=husklist.len, index++)
						husklist[index] = husklist[index]/255
					accessory_overlay.color = husklist

			if(OFFSET_MUTPARTS in H.dna.species.offset_features)
				accessory_overlay.pixel_x += H.dna.species.offset_features[OFFSET_MUTPARTS][1]
				accessory_overlay.pixel_y += H.dna.species.offset_features[OFFSET_MUTPARTS][2]

			standing += accessory_overlay

			if(S.hasinner)
				var/mutable_appearance/inner_accessory_overlay = mutable_appearance(S.icon, layer = -layer)
				if(S.gender_specific)
					inner_accessory_overlay.icon_state = "[g]_[bodypart]inner_[S.icon_state]_[layertext]"
				else
					inner_accessory_overlay.icon_state = "m_[bodypart]inner_[S.icon_state]_[layertext]"

				if(S.center)
					inner_accessory_overlay = center_image(inner_accessory_overlay, S.dimension_x, S.dimension_y)

				if(OFFSET_MUTPARTS in H.dna.species.offset_features)
					inner_accessory_overlay.pixel_x += H.dna.species.offset_features[OFFSET_MUTPARTS][1]
					inner_accessory_overlay.pixel_y += H.dna.species.offset_features[OFFSET_MUTPARTS][2]

				standing += inner_accessory_overlay

			if(S.extra) //apply the extra overlay, if there is one
				var/mutable_appearance/extra_accessory_overlay = mutable_appearance(S.icon, layer = -layer)
				if(S.gender_specific)
					extra_accessory_overlay.icon_state = "[g]_[bodypart]_extra_[S.icon_state]_[layertext]"
				else
					extra_accessory_overlay.icon_state = "m_[bodypart]_extra_[S.icon_state]_[layertext]"
				if(S.center)
					extra_accessory_overlay = center_image(extra_accessory_overlay, S.dimension_x, S.dimension_y)


				switch(S.extra_color_src) //change the color of the extra overlay
					if(MUTCOLORS)
						if(fixed_mut_color)
							extra_accessory_overlay.color = "#[fixed_mut_color]"
						else
							extra_accessory_overlay.color = "#[H.dna.features["mcolor"]]"
					if(MUTCOLORS2)
						if(fixed_mut_color2)
							extra_accessory_overlay.color = "#[fixed_mut_color2]"
						else
							extra_accessory_overlay.color = "#[H.dna.features["mcolor2"]]"
					if(MUTCOLORS3)
						if(fixed_mut_color3)
							extra_accessory_overlay.color = "#[fixed_mut_color3]"
						else
							extra_accessory_overlay.color = "#[H.dna.features["mcolor3"]]"
					if(HAIR)
						if(hair_color == "mutcolor")
							extra_accessory_overlay.color = "#[H.dna.features["mcolor3"]]"
						else
							extra_accessory_overlay.color = "#[H.hair_color]"
					if(FACEHAIR)
						extra_accessory_overlay.color = "#[H.facial_hair_color]"
					if(EYECOLOR)
						extra_accessory_overlay.color = "#[H.eye_color]"

					if(HORNCOLOR)
						extra_accessory_overlay.color = "#[H.horn_color]"
					if(WINGCOLOR)
						extra_accessory_overlay.color = "#[H.wing_color]"

				if(OFFSET_MUTPARTS in H.dna.species.offset_features)
					extra_accessory_overlay.pixel_x += H.dna.species.offset_features[OFFSET_MUTPARTS][1]
					extra_accessory_overlay.pixel_y += H.dna.species.offset_features[OFFSET_MUTPARTS][2]

				standing += extra_accessory_overlay

			if(S.extra2) //apply the extra overlay, if there is one
				var/mutable_appearance/extra2_accessory_overlay = mutable_appearance(S.icon, layer = -layer)
				if(S.gender_specific)
					extra2_accessory_overlay.icon_state = "[g]_[bodypart]_extra2_[S.icon_state]_[layertext]"
				else
					extra2_accessory_overlay.icon_state = "m_[bodypart]_extra2_[S.icon_state]_[layertext]"
				if(S.center)
					extra2_accessory_overlay = center_image(extra2_accessory_overlay, S.dimension_x, S.dimension_y)

				switch(S.extra2_color_src) //change the color of the extra overlay
					if(MUTCOLORS)
						if(fixed_mut_color)
							extra2_accessory_overlay.color = "#[fixed_mut_color]"
						else
							extra2_accessory_overlay.color = "#[H.dna.features["mcolor"]]"
					if(MUTCOLORS2)
						if(fixed_mut_color2)
							extra2_accessory_overlay.color = "#[fixed_mut_color2]"
						else
							extra2_accessory_overlay.color = "#[H.dna.features["mcolor2"]]"
					if(MUTCOLORS3)
						if(fixed_mut_color3)
							extra2_accessory_overlay.color = "#[fixed_mut_color3]"
						else
							extra2_accessory_overlay.color = "#[H.dna.features["mcolor3"]]"
					if(HAIR)
						if(hair_color == "mutcolor3")
							extra2_accessory_overlay.color = "#[H.dna.features["mcolor"]]"
						else
							extra2_accessory_overlay.color = "#[H.hair_color]"
					if(HORNCOLOR)
						extra2_accessory_overlay.color = "#[H.horn_color]"
					if(WINGCOLOR)
						extra2_accessory_overlay.color = "#[H.wing_color]"

				if(OFFSET_MUTPARTS in H.dna.species.offset_features)
					extra2_accessory_overlay.pixel_x += H.dna.species.offset_features[OFFSET_MUTPARTS][1]
					extra2_accessory_overlay.pixel_y += H.dna.species.offset_features[OFFSET_MUTPARTS][2]

				standing += extra2_accessory_overlay


		H.overlays_standing[layer] = standing.Copy()
		standing = list()

	H.apply_overlay(BODY_BEHIND_LAYER)
	H.apply_overlay(BODY_ADJ_LAYER)
	H.apply_overlay(BODY_FRONT_LAYER)
	H.apply_overlay(BODY_TAUR_LAYER) // CITADEL EDIT


/*
 * Equip the outfit required for life. Replaces items currently worn.
 */
/datum/species/proc/give_important_for_life(mob/living/carbon/human/human_to_equip)
	if(!outfit_important_for_life)
		return
	outfit_important_for_life= new()
	outfit_important_for_life.equip(human_to_equip)

//This exists so sprite accessories can still be per-layer without having to include that layer's
//number in their sprite name, which causes issues when those numbers change.
/datum/species/proc/mutant_bodyparts_layertext(layer)
	switch(layer)
		if(BODY_BEHIND_LAYER)
			return "BEHIND"
		if(BODY_ADJ_LAYER)
			return "ADJ"
		if(BODY_FRONT_LAYER)
			return "FRONT"
	//CITADEL EDIT
		if(BODY_TAUR_LAYER)
			return "TAUR"
	//END EDIT

/* TODO: Snowflake trail marks
// Impliments different trails for species depending on if they're wearing shoes.
/datum/species/proc/get_move_trail(var/mob/living/carbon/human/H)
	if(H.lying)
		return /obj/effect/decal/cleanable/blood/footprints/tracks/body
	if(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)))
		var/obj/item/clothing/shoes/shoes = (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)) ? H.wear_suit : H.shoes // suits take priority over shoes
		return shoes.move_trail
	else
		return move_trail */

/datum/species/proc/spec_life(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		H.setOxyLoss(0)
		H.losebreath = 0

		var/takes_crit_damage = !HAS_TRAIT(H, TRAIT_NOCRITDAMAGE)
		if((H.health < H.crit_threshold) && takes_crit_damage)
			H.adjustBruteLoss(1)

/datum/species/proc/spec_death(gibbed, mob/living/carbon/human/H)
	return

/datum/species/proc/auto_equip(mob/living/carbon/human/H)
	// handles the equipping of species-specific gear
	return

/datum/species/proc/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	if(slot in no_equip)
		if(!I.species_exception || !is_type_in_list(src, I.species_exception))
			return FALSE

	var/num_arms = H.get_num_arms(FALSE)
	var/num_legs = H.get_num_legs(FALSE)

	switch(slot)
		if(SLOT_HANDS)
			if(H.get_empty_held_indexes())
				return TRUE
			return FALSE
		if(SLOT_WEAR_MASK)
			if(H.wear_mask)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_MASK))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_NECK)
			if(H.wear_neck)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_NECK) )
				return FALSE
			return TRUE
		if(SLOT_BACK)
			if(H.back)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_BACK) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_WEAR_SUIT)
			if(H.wear_suit)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_OCLOTHING) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_GLOVES)
			if(H.gloves)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_GLOVES) )
				return FALSE
			if(num_arms < 2)
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_SHOES)
			if(H.shoes)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_FEET) )
				return FALSE
			if(num_legs < 2)
				return FALSE
			if(DIGITIGRADE in species_traits)
				if(!is_species(H, /datum/species/lizard/ashwalker))
					H.update_inv_shoes()
				else
					return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_BELT)
			if(H.belt)
				return FALSE
			if(!CHECK_BITFIELD(I.item_flags, NO_UNIFORM_REQUIRED))
				var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_CHEST)
				if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
					if(!disable_warning)
						to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
					return FALSE
			if(!(I.slot_flags & ITEM_SLOT_BELT))
				return
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_GLASSES)
			if(H.glasses)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_EYES))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_HEAD)
			if(H.head)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_HEAD))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_EARS)
			if(H.ears)
				return FALSE
			if(!(I.slot_flags & ITEM_SLOT_EARS))
				return FALSE
			if(!H.get_bodypart(BODY_ZONE_HEAD))
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_W_UNIFORM)
			if(H.w_uniform)
				return FALSE
			if( !(I.slot_flags & ITEM_SLOT_ICLOTHING) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_WEAR_ID)
			if(H.wear_id)
				return FALSE
			if(!CHECK_BITFIELD(I.item_flags, NO_UNIFORM_REQUIRED))
				var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_CHEST)
				if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
					if(!disable_warning)
						to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
					return FALSE
			if( !(I.slot_flags & ITEM_SLOT_ID) )
				return FALSE
			return equip_delay_self_check(I, H, bypass_equip_delay_self)
		if(SLOT_L_STORE)
			if(HAS_TRAIT(I, TRAIT_NODROP)) //Pockets aren't visible, so you can't move TRAIT_NODROP items into them.
				return FALSE
			if(H.l_store)
				return FALSE

			var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_L_LEG)

			if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
				return FALSE
			if(I.slot_flags & ITEM_SLOT_DENYPOCKET)
				return FALSE
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & ITEM_SLOT_POCKET) )
				return TRUE
		if(SLOT_R_STORE)
			if(HAS_TRAIT(I, TRAIT_NODROP))
				return FALSE
			if(H.r_store)
				return FALSE

			var/obj/item/bodypart/O = H.get_bodypart(BODY_ZONE_R_LEG)

			if(!H.w_uniform && !nojumpsuit && (!O || O.status != BODYPART_ROBOTIC))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>")
				return FALSE
			if(I.slot_flags & ITEM_SLOT_DENYPOCKET)
				return FALSE
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & ITEM_SLOT_POCKET) )
				return TRUE
			return FALSE
		if(SLOT_S_STORE)
			if(HAS_TRAIT(I, TRAIT_NODROP))
				return FALSE
			if(H.s_store)
				return FALSE
			if(!H.wear_suit)
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a suit before you can attach this [I.name]!</span>")
				return FALSE
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					to_chat(H, "You somehow have a suit with no defined allowed items for suit storage, stop that.")
				return FALSE
			if(I.w_class > WEIGHT_CLASS_BULKY)
				if(!disable_warning)
					to_chat(H, "The [I.name] is too big to attach.") //should be src?
				return FALSE
			if( istype(I, /obj/item/pda) || istype(I, /obj/item/pen) || is_type_in_list(I, H.wear_suit.allowed) )
				return TRUE
			return FALSE
		if(SLOT_HANDCUFFED)
			if(H.handcuffed)
				return FALSE
			if(!istype(I, /obj/item/restraints/handcuffs))
				return FALSE
			if(num_arms < 2)
				return FALSE
			return TRUE
		if(SLOT_LEGCUFFED)
			if(H.legcuffed)
				return FALSE
			if(!istype(I, /obj/item/restraints/legcuffs))
				return FALSE
			if(num_legs < 2)
				return FALSE
			return TRUE
		if(SLOT_IN_BACKPACK)
			if(H.back)
				if(SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_CAN_INSERT, I, H, TRUE))
					return TRUE
			return FALSE
	return FALSE //Unsupported slot

/datum/species/proc/equip_delay_self_check(obj/item/I, mob/living/carbon/human/H, bypass_equip_delay_self)
	if(!I.equip_delay_self || bypass_equip_delay_self)
		return TRUE
	H.visible_message("<span class='notice'>[H] start putting on [I]...</span>", "<span class='notice'>You start putting on [I]...</span>")
	return do_after(H, I.equip_delay_self, target = H)

/datum/species/proc/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	return

/datum/species/proc/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.update_mutant_bodyparts()

/datum/species/proc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == exotic_blood && !istype(exotic_blood, /datum/reagent/blood))
		H.blood_volume = min(H.blood_volume + round(chem.volume, 0.1), BLOOD_VOLUME_MAXIMUM)
		H.reagents.del_reagent(chem.type)
		return TRUE
	return FALSE

/datum/species/proc/check_weakness(obj/item, mob/living/attacker)
	return FALSE

////////
	//LIFE//
	////////

/datum/species/proc/handle_digestion(mob/living/carbon/human/H)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		return //hunger is for BABIES

	//The fucking TRAIT_FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
	if(HAS_TRAIT(H, TRAIT_FAT))//I share your pain, past coder.
		if(H.overeatduration < 100)
			to_chat(H, "<span class='notice'>You feel fit again!</span>")
			REMOVE_TRAIT(H, TRAIT_FAT, OBESITY)
			H.remove_movespeed_modifier(MOVESPEED_ID_FAT)
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()
	else
		if(H.overeatduration >= 100)
			to_chat(H, "<span class='danger'>You suddenly feel blubbery!</span>")
			ADD_TRAIT(H, TRAIT_FAT, OBESITY)
			H.add_movespeed_modifier(MOVESPEED_ID_FAT, multiplicative_slowdown = 1.5)
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()

	// nutrition decrease and satiety
	if (H.nutrition > 0 && H.stat != DEAD && !HAS_TRAIT(H, TRAIT_NOHUNGER))
		// THEY HUNGER
		var/hunger_rate = HUNGER_FACTOR
		var/datum/component/mood/mood = H.GetComponent(/datum/component/mood)
		if(mood && mood.sanity > SANITY_DISTURBED)
			hunger_rate *= max(0.5, 1 - 0.002 * mood.sanity) //0.85 to 0.75

		// Whether we cap off our satiety or move it towards 0
		if(H.satiety > MAX_SATIETY)
			H.satiety = MAX_SATIETY
		else if(H.satiety > 0)
			H.satiety--
		else if(H.satiety < -MAX_SATIETY)
			H.satiety = -MAX_SATIETY
		else if(H.satiety < 0)
			H.satiety++
			if(prob(round(-H.satiety/40)))
				H.Jitter(5)
			hunger_rate = 3 * HUNGER_FACTOR
		hunger_rate *= H.physiology.hunger_mod
		H.nutrition = max(0, H.nutrition - hunger_rate)


	if (H.nutrition > NUTRITION_LEVEL_FULL)
		if(H.overeatduration < 600) //capped so people don't take forever to unfat
			H.overeatduration++
	else
		if(H.overeatduration > 1)
			H.overeatduration -= 2 //doubled the unfat rate

	//metabolism change
	if(H.nutrition > NUTRITION_LEVEL_FAT)
		H.metabolism_efficiency = 1
	else if(H.nutrition > NUTRITION_LEVEL_FED && H.satiety > 80)
		if(H.metabolism_efficiency != 1.25 && !HAS_TRAIT(H, TRAIT_NOHUNGER))
			to_chat(H, "<span class='notice'>You feel vigorous.</span>")
			H.metabolism_efficiency = 1.25
	else if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		if(H.metabolism_efficiency != 0.8)
			to_chat(H, "<span class='notice'>You feel sluggish.</span>")
		H.metabolism_efficiency = 0.8
	else
		if(H.metabolism_efficiency == 1.25)
			to_chat(H, "<span class='notice'>You no longer feel vigorous.</span>")
		H.metabolism_efficiency = 1

	//Hunger slowdown for if mood isn't enabled
	if(CONFIG_GET(flag/disable_human_mood))
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			var/hungry = (500 - H.nutrition) / 5 //So overeat would be 100 and default level would be 80
			if(hungry >= 70)
				H.add_movespeed_modifier(MOVESPEED_ID_HUNGRY, override = TRUE, multiplicative_slowdown = (hungry / 50))
			else
				H.remove_movespeed_modifier(MOVESPEED_ID_HUNGRY)

	switch(H.nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			H.throw_alert("nutrition", /obj/screen/alert/fat)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FULL)
			H.clear_alert("nutrition")
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			H.throw_alert("nutrition", /obj/screen/alert/hungry)
		if(0 to NUTRITION_LEVEL_STARVING)
			H.throw_alert("nutrition", /obj/screen/alert/starving)

/datum/species/proc/update_health_hud(mob/living/carbon/human/H)
	return 0

/datum/species/proc/handle_mutations_and_radiation(mob/living/carbon/human/H)
	. = FALSE
	var/radiation = H.radiation

	if(HAS_TRAIT(H, TRAIT_RADIMMUNE))
		radiation = 0
		return TRUE

	if(radiation > RAD_MOB_KNOCKDOWN && prob(RAD_MOB_KNOCKDOWN_PROB))
		if(CHECK_MOBILITY(H, MOBILITY_STAND))
			H.emote("collapse")
		H.DefaultCombatKnockdown(RAD_MOB_KNOCKDOWN_AMOUNT)
		to_chat(H, "<span class='danger'>You feel weak.</span>")

	if(radiation > RAD_MOB_VOMIT && prob(RAD_MOB_VOMIT_PROB))
		H.vomit(10, TRUE)

	if(radiation > RAD_MOB_MUTATE)
		if(prob(1))
			to_chat(H, "<span class='danger'>You mutate!</span>")
			H.easy_randmut(NEGATIVE+MINOR_NEGATIVE)
			H.emote("gasp")
			H.domutcheck()

	if(radiation > RAD_MOB_HAIRLOSS)
		if(prob(15) && !(H.hair_style == "Bald") && (HAIR in species_traits))
			to_chat(H, "<span class='danger'>Your hair starts to fall out in clumps...</span>")
			addtimer(CALLBACK(src, .proc/go_bald, H), 50)

/datum/species/proc/go_bald(mob/living/carbon/human/H)
	if(QDELETED(H))	//may be called from a timer
		return
	H.facial_hair_style = "Shaved"
	H.hair_style = "Bald"
	H.update_hair()

//////////////////
// ATTACK PROCS //
//////////////////

/datum/species/proc/help(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.health >= 0 && !HAS_TRAIT(target, TRAIT_FAKEDEATH))
		target.help_shake_act(user)
		if(target != user)
			log_combat(user, target, "shaked")
		return 1
	else
		var/we_breathe = !HAS_TRAIT(user, TRAIT_NOBREATH)
		var/we_lung = user.getorganslot(ORGAN_SLOT_LUNGS)

		if(we_breathe && we_lung)
			user.do_cpr(target)
		else if(we_breathe && !we_lung)
			to_chat(user, "<span class='warning'>You have no lungs to breathe with, so you cannot peform CPR.</span>")
		else
			to_chat(user, "<span class='notice'>You do not breathe, so you cannot perform CPR.</span>")

/datum/species/proc/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s grab attempt!</span>")
		return 0
	if(attacker_style && attacker_style.grab_act(user,target))
		return 1
	else
		target.grabbedby(user)
		return 1





/datum/species/proc/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(!attacker_style && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>You don't want to harm [target]!</span>")
		return FALSE
	if(user.getStaminaLoss() >= STAMINA_SOFTCRIT) //CITADEL CHANGE - makes it impossible to punch while in stamina softcrit
		to_chat(user, "<span class='warning'>You're too exhausted.</span>") //CITADEL CHANGE - ditto
		return FALSE //CITADEL CHANGE - ditto
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s attack!</span>")
		return FALSE
	if(attacker_style && attacker_style.harm_act(user,target))
		return TRUE
	else

		var/atk_verb = user.dna.species.attack_verb
		if(target.lying)
			atk_verb = "kick"

		switch(atk_verb)
			if("kick")
				user.do_attack_animation(target, ATTACK_EFFECT_KICK)
			if("slash")
				user.do_attack_animation(target, ATTACK_EFFECT_CLAW)
			if("smash")
				user.do_attack_animation(target, ATTACK_EFFECT_SMASH)
			else
				user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

		user.adjustStaminaLossBuffered(5) //CITADEL CHANGE - makes punching cause staminaloss

		var/damage = rand(user.dna.species.punchdamagelow, user.dna.species.punchdamagehigh)

		//CITADEL CHANGES - makes resting and disabled combat mode reduce punch damage, makes being out of combat mode result in you taking more damage
		if(!target.combatmode && damage < user.dna.species.punchstunthreshold)
			damage = user.dna.species.punchstunthreshold - 1
		if(!CHECK_MOBILITY(user, MOBILITY_STAND))
			damage *= 0.5
		if(!user.combatmode)
			damage *= 0.25
		//END OF CITADEL CHANGES

		var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))

		if(!damage || !affecting)
			playsound(target.loc, user.dna.species.miss_sound, 25, 1, -1)
			target.visible_message("<span class='danger'>[user] has attempted to [atk_verb] [target]!</span>",\
			"<span class='userdanger'>[user] has attempted to [atk_verb] [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			return FALSE


		var/armor_block = target.run_armor_check(affecting, "melee")

		playsound(target.loc, user.dna.species.attack_sound, 25, 1, -1)

		target.visible_message("<span class='danger'>[user] has [atk_verb]ed [target]!</span>", \
					"<span class='userdanger'>[user] has [atk_verb]ed [target]!</span>", null, COMBAT_MESSAGE_RANGE)

		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		user.dna.species.spec_unarmedattacked(user, target)

		if(user.limb_destroyer)
			target.dismembering_strike(user, affecting.body_zone)
		target.apply_damage(damage, BRUTE, affecting, armor_block)
		log_combat(user, target, "punched")
		if((target.stat != DEAD) && damage >= user.dna.species.punchstunthreshold)
			target.visible_message("<span class='danger'>[user] has knocked  [target] down!</span>", \
							"<span class='userdanger'>[user] has knocked [target] down!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(80, EFFECT_KNOCKDOWN, armor_block)
			target.forcesay(GLOB.hit_appends)
		else if(target.lying)
			target.forcesay(GLOB.hit_appends)

/datum/species/proc/spec_unarmedattacked(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return

/datum/species/proc/disarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	// CITADEL EDIT slap mouthy gits and booty
	var/aim_for_mouth = user.zone_selected == "mouth"
	var/target_on_help = target.a_intent == INTENT_HELP
	var/target_aiming_for_mouth = target.zone_selected == "mouth"
	var/target_restrained = target.restrained()
	var/same_dir = (target.dir & user.dir)
	var/aim_for_groin  = user.zone_selected == "groin"
	var/target_aiming_for_groin = target.zone_selected == "groin"

	if(target.check_block()) //END EDIT
		target.visible_message("<span class='warning'>[target] blocks [user]'s disarm attempt!</span>")
		return 0
	else if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)
		to_chat(user, "<span class='warning'>You're too exhausted!</span>")
		return FALSE

	else if(aim_for_mouth && ( target_on_help || target_restrained || target_aiming_for_mouth))
		playsound(target.loc, 'sound/weapons/slap.ogg', 50, 1, -1)

		user.visible_message(\
			"<span class='danger'>\The [user] slaps \the [target] in the face!</span>",\
			"<span class='notice'>You slap [user == target ? "yourself" : "\the [target]"] in the face! </span>",\
			"You hear a slap."
		)
		user.do_attack_animation(target, ATTACK_EFFECT_FACE_SLAP)
		user.adjustStaminaLossBuffered(3)
		if (!HAS_TRAIT(target, TRAIT_PERMABONER))
			stop_wagging_tail(target)
		return FALSE
	else if(!(user.client?.prefs.cit_toggles & NO_ASS_SLAP) && aim_for_groin && (target == user || target.lying || same_dir) && (target_on_help || target_restrained || target_aiming_for_groin))
		if(target.client?.prefs.cit_toggles & NO_ASS_SLAP)
			to_chat(user,"A force stays your hand, preventing you from slapping \the [target]'s ass!")
			return FALSE
		user.do_attack_animation(target, ATTACK_EFFECT_ASS_SLAP)
		user.adjustStaminaLossBuffered(3)
		target.adjust_arousal(20,maso = TRUE)
		if (ishuman(target) && HAS_TRAIT(target, TRAIT_MASO) && target.has_dna() && prob(10))
			target.mob_climax(forced_climax=TRUE)
		if (!HAS_TRAIT(target, TRAIT_PERMABONER))
			stop_wagging_tail(target)
		playsound(target.loc, 'sound/weapons/slap.ogg', 50, 1, -1)
		user.visible_message(\
			"<span class='danger'>\The [user] slaps \the [target]'s ass!</span>",\
			"<span class='notice'>You slap [user == target ? "your" : "\the [target]'s"] ass!</span>",\
			"You hear a slap."
		)
		return FALSE
	else if(attacker_style && attacker_style.disarm_act(user,target))
		return 1
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)

		user.adjustStaminaLossBuffered(3) //CITADEL CHANGE - makes disarmspam cause staminaloss

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		//var/randomized_zone = ran_zone(user.zone_selected) CIT CHANGE - comments out to prevent compiling errors
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)
		if(target.pulling == user)
			target.visible_message("<span class='warning'>[user] wrestles out of [target]'s grip!</span>")
			target.stop_pulling()
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			log_combat(user, target, "disarmed out of grab from")
			return
		//var/obj/item/bodypart/affecting = target.get_bodypart(randomized_zone) CIT CHANGE - comments this out to prevent compile errors due to the below commented out bit
		var/randn = rand(1, 100)
		/*if(randn <= 25) CITADEL CHANGE - moves disarm push attempts to right click
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			target.visible_message("<span class='danger'>[user] has pushed [target]!</span>",
				"<span class='userdanger'>[user] has pushed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(40, EFFECT_KNOCKDOWN, target.run_armor_check(affecting, "melee", "Your armor prevents your fall!", "Your armor softens your fall!"))
			target.forcesay(GLOB.hit_appends)
			log_combat(user, target, "pushed over")
			return*/
		if(!target.combatmode) // CITADEL CHANGE
			randn += -10 //CITADEL CHANGE - being out of combat mode makes it easier for you to get disarmed
		if(!CHECK_MOBILITY(user, MOBILITY_STAND)) //CITADEL CHANGE
			randn += 100 //CITADEL CHANGE - No kosher disarming if you're resting
		if(!user.combatmode) //CITADEL CHANGE
			randn += 25 //CITADEL CHANGE - Makes it harder to disarm outside of combat mode
		if(user.pulling == target)
			randn += -20 //If you have the time to get someone in a grab, you should have a greater chance at snatching the thing in their hand. Will be made completely obsolete by the grab rework but i've got a poor track record for releasing big projects on time so w/e i guess

		if(randn <= 35)//CIT CHANGE - changes this back to a 35% chance to accomodate for the above being commented out in favor of right-click pushing
			var/obj/item/I = null
			if(target.pulling)
				target.visible_message("<span class='warning'>[user] has broken [target]'s grip on [target.pulling]!</span>")
				target.stop_pulling()
			else
				I = target.get_active_held_item()
				if(target.dropItemToGround(I))
					target.visible_message("<span class='danger'>[user] has disarmed [target]!</span>", \
						"<span class='userdanger'>[user] has disarmed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
				else
					I = null
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			log_combat(user, target, "disarmed", "[I ? " removing \the [I]" : ""]")
			return


		playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		target.visible_message("<span class='danger'>[user] attempted to disarm [target]!</span>", \
						"<span class='userdanger'>[user] attemped to disarm [target]!</span>", null, COMBAT_MESSAGE_RANGE)
		log_combat(user, target, "attempted to disarm")


/datum/species/proc/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	return

/datum/species/proc/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	CHECK_DNA_AND_SPECIES(M)
	CHECK_DNA_AND_SPECIES(H)

	if(!istype(M)) //sanity check for drones.
		return
	if(M.mind)
		attacker_style = M.mind.martial_art
		if(attacker_style?.pacifism_check && HAS_TRAIT(M, TRAIT_PACIFISM)) // most martial arts are quite harmful, alas.
			attacker_style = null
	switch(M.a_intent)
		if("help")
			help(M, H, attacker_style)

		if("grab")
			grab(M, H, attacker_style)

		if("harm")
			harm(M, H, attacker_style)

		if("disarm")
			disarm(M, H, attacker_style)

/datum/species/proc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	// Allows you to put in item-specific reactions based on species
	if(user != H)
		if(H.check_shields(I, I.force, "the [I.name]", MELEE_ATTACK, I.armour_penetration))
			return 0
	if(H.check_block())
		H.visible_message("<span class='warning'>[H] blocks [I]!</span>")
		return 0

	var/hit_area
	if(!affecting) //Something went wrong. Maybe the limb is missing?
		affecting = H.bodyparts[1]

	hit_area = affecting.name
	var/def_zone = affecting.body_zone

	var/armor_block = H.run_armor_check(affecting, "melee", "<span class='notice'>Your armor has protected your [hit_area].</span>", "<span class='notice'>Your armor has softened a hit to your [hit_area].</span>",I.armour_penetration)
	armor_block = min(90,armor_block) //cap damage reduction at 90%
	var/Iforce = I.force //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)
	//CIT CHANGES START HERE - combatmode and resting checks
	var/totitemdamage = I.force
	if(iscarbon(user))
		var/mob/living/carbon/tempcarb = user
		if(!tempcarb.combatmode)
			totitemdamage *= 0.5
	if(!CHECK_MOBILITY(user, MOBILITY_STAND))
		totitemdamage *= 0.5
	if(istype(H))
		if(!H.combatmode)
			totitemdamage *= 1.5
	//CIT CHANGES END HERE
	var/weakness = H.check_weakness(I, user)
	apply_damage(totitemdamage * weakness, I.damtype, def_zone, armor_block, H) //CIT CHANGE - replaces I.force with totitemdamage

	H.send_item_attack_message(I, user, hit_area)

	if(!I.force)
		return 0 //item force is zero

	//dismemberment
	var/probability = I.get_dismemberment_chance(affecting)
	if(prob(probability) || (HAS_TRAIT(H, TRAIT_EASYDISMEMBER) && prob(probability))) //try twice
		if(affecting.dismember(I.damtype))
			I.add_mob_blood(H)
			playsound(get_turf(H), I.get_dismember_sound(), 80, 1)

	var/bloody = 0
	if(((I.damtype == BRUTE) && I.force && prob(25 + (I.force * 2))))
		if(affecting.status == BODYPART_ORGANIC)
			I.add_mob_blood(H)	//Make the weapon bloody, not the person.
			if(prob(I.force * 2))	//blood spatter!
				bloody = 1
				var/turf/location = H.loc
				if(istype(location))
					H.add_splatter_floor(location)
				if(get_dist(user, H) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(H)

		switch(hit_area)
			if(BODY_ZONE_HEAD)
				if(!I.get_sharpness() && armor_block < 50)
					if(prob(I.force))
						H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 20)
						if(H.stat == CONSCIOUS)
							H.visible_message("<span class='danger'>[H] has been knocked senseless!</span>", \
											"<span class='userdanger'>[H] has been knocked senseless!</span>")
							H.confused = max(H.confused, 20)
							H.adjust_blurriness(10)
						if(prob(10))
							H.gain_trauma(/datum/brain_trauma/mild/concussion)
					else
						H.adjustOrganLoss(ORGAN_SLOT_BRAIN, I.force * 0.2)

					if(H.stat == CONSCIOUS && H != user && prob(I.force + ((100 - H.health) * 0.5))) // rev deconversion through blunt trauma.
						var/datum/antagonist/rev/rev = H.mind.has_antag_datum(/datum/antagonist/rev)
						var/datum/antagonist/gang/gang = H.mind.has_antag_datum(/datum/antagonist/gang && !/datum/antagonist/gang/boss)
						if(rev)
							rev.remove_revolutionary(FALSE, user)
						if(gang)
							H.mind.remove_antag_datum(/datum/antagonist/gang)

				if(bloody)	//Apply blood
					if(H.wear_mask)
						H.wear_mask.add_mob_blood(H)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_mob_blood(H)
						H.update_inv_head()
					if(H.glasses && prob(33))
						H.glasses.add_mob_blood(H)
						H.update_inv_glasses()

			if(BODY_ZONE_CHEST)
				if(H.stat == CONSCIOUS && !I.get_sharpness() && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='danger'>[H] has been knocked down!</span>", \
									"<span class='userdanger'>[H] has been knocked down!</span>")
						H.apply_effect(60, EFFECT_KNOCKDOWN, armor_block)

				if(bloody)
					if(H.wear_suit)
						H.wear_suit.add_mob_blood(H)
						H.update_inv_wear_suit()
					if(H.w_uniform)
						H.w_uniform.add_mob_blood(H)
						H.update_inv_w_uniform()

		if(Iforce > 10 || Iforce >= 5 && prob(33))
			H.forcesay(GLOB.hit_appends)	//forcesay checks stat already.
	return TRUE

/datum/species/proc/alt_spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return TRUE
	CHECK_DNA_AND_SPECIES(M)
	CHECK_DNA_AND_SPECIES(H)

	if(!istype(M)) //sanity check for drones.
		return TRUE
	if(M.mind)
		attacker_style = M.mind.martial_art
	if((M != H) && M.a_intent != INTENT_HELP && H.check_shields(M, 0, M.name, attack_type = UNARMED_ATTACK))
		log_combat(M, H, "attempted to touch")
		H.visible_message("<span class='warning'>[M] attempted to touch [H]!</span>")
		return TRUE
	switch(M.a_intent)
		if(INTENT_HELP)
			if(M == H)
				althelp(M, H, attacker_style)
				return TRUE
			return FALSE
		if(INTENT_DISARM)
			altdisarm(M, H, attacker_style)
			return TRUE
	return FALSE

/datum/species/proc/althelp(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user == target && istype(user))
		if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)
			to_chat(user, "<span class='warning'>You're too exhausted for that.</span>")
			return
		if(user.IsKnockdown() || user.IsParalyzed() || user.IsStun())
			to_chat(user, "<span class='warning'>You can't seem to force yourself up right now!</span>")
			return
		if(CHECK_MOBILITY(user, MOBILITY_STAND))
			to_chat(user, "<span class='notice'>You can only force yourself up if you're on the ground.</span>")
			return
		user.visible_message("<span class='notice'>[user] forces [p_them()]self up to [p_their()] feet!</span>", "<span class='notice'>You force yourself up to your feet!</span>")
		user.set_resting(FALSE, TRUE)
		user.adjustStaminaLossBuffered(user.stambuffer) //Rewards good stamina management by making it easier to instantly get up from resting
		playsound(user, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/datum/species/proc/altdisarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)
		to_chat(user, "<span class='warning'>You're too exhausted.</span>")
		return FALSE
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s shoving attempt!</span>")
		return FALSE
	if(attacker_style && attacker_style.disarm_act(user,target))
		return TRUE
	if(!CHECK_MOBILITY(user, MOBILITY_STAND))
		return FALSE
	else
		if(user == target)
			return
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
		user.adjustStaminaLossBuffered(4)
		playsound(target, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)

		if(CHECK_MOBILITY(target, MOBILITY_STAND))
			target.adjustStaminaLoss(5)

		if(target.is_shove_knockdown_blocked())
			return

		var/turf/target_oldturf = target.loc
		var/shove_dir = get_dir(user.loc, target_oldturf)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)
		var/mob/living/carbon/human/target_collateral_human
		var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied

		//Thank you based whoneedsspace
		target_collateral_human = locate(/mob/living/carbon/human) in target_shove_turf.contents
		if(target_collateral_human && CHECK_MOBILITY(target_collateral_human, MOBILITY_STAND))
			shove_blocked = TRUE
		else
			target_collateral_human = null
			target.Move(target_shove_turf, shove_dir)
			if(get_turf(target) == target_oldturf)
				shove_blocked = TRUE

		var/append_message = ""
		if(shove_blocked && !target.buckled)
			var/directional_blocked = !target.Adjacent(target_shove_turf)
			var/targetatrest = !CHECK_MOBILITY(target, MOBILITY_STAND)
			if((directional_blocked || !(target_collateral_human || target_shove_turf.shove_act(target, user))) && !targetatrest)
				target.DefaultCombatKnockdown(SHOVE_KNOCKDOWN_SOLID)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name], knocking them down!</span>",
					"<span class='danger'>You shove [target.name], knocking them down!</span>", null, COMBAT_MESSAGE_RANGE)
				log_combat(user, target, "shoved", "knocking them down")
			else if(target_collateral_human && !targetatrest)
				target.DefaultCombatKnockdown(SHOVE_KNOCKDOWN_HUMAN)
				target_collateral_human.DefaultCombatKnockdown(SHOVE_KNOCKDOWN_COLLATERAL)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name] into [target_collateral_human.name]!</span>",
					"<span class='danger'>You shove [target.name] into [target_collateral_human.name]!</span>", null, COMBAT_MESSAGE_RANGE)
				append_message += ", into [target_collateral_human.name]"

		else
			user.visible_message("<span class='danger'>[user.name] shoves [target.name]!</span>",
				"<span class='danger'>You shove [target.name]!</span>", null, COMBAT_MESSAGE_RANGE)
		var/obj/item/target_held_item = target.get_active_held_item()
		if(!is_type_in_typecache(target_held_item, GLOB.shove_disarming_types))
			target_held_item = null
		if(!target.has_movespeed_modifier(MOVESPEED_ID_SHOVE))
			target.add_movespeed_modifier(MOVESPEED_ID_SHOVE, multiplicative_slowdown = SHOVE_SLOWDOWN_STRENGTH)
			if(target_held_item)
				if(!HAS_TRAIT(target_held_item, TRAIT_NODROP))
					target.visible_message("<span class='danger'>[target.name]'s grip on \the [target_held_item] loosens!</span>",
						"<span class='danger'>Your grip on \the [target_held_item] loosens!</span>", null, COMBAT_MESSAGE_RANGE)
					append_message += ", loosening their grip on [target_held_item]"
				else
					append_message += ", but couldn't loose their grip on [target_held_item]"
			addtimer(CALLBACK(target, /mob/living/carbon/human/proc/clear_shove_slowdown), SHOVE_SLOWDOWN_LENGTH)
		else if(target_held_item)
			if(target.dropItemToGround(target_held_item))
				target.visible_message("<span class='danger'>[target.name] drops \the [target_held_item]!!</span>",
					"<span class='danger'>You drop \the [target_held_item]!!</span>", null, COMBAT_MESSAGE_RANGE)
				append_message += ", causing them to drop [target_held_item]"
		log_combat(user, target, "shoved", append_message)

/datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_APPLY_DAMGE, damage, damagetype, def_zone)
	var/hit_percent = (100-(blocked+armor))/100
	hit_percent = (hit_percent * (100-H.physiology.damage_resistance))/100
	if(!forced && hit_percent <= 0)
		return 0

	var/obj/item/bodypart/BP = null
	if(isbodypart(def_zone))
		if(damagetype == STAMINA && istype(def_zone, /obj/item/bodypart/head))
			BP = H.get_bodypart(check_zone(BODY_ZONE_CHEST))
		else
			BP = def_zone
	else
		if(!def_zone)
			def_zone = ran_zone(def_zone)
		if(damagetype == STAMINA && def_zone == BODY_ZONE_HEAD)
			def_zone = BODY_ZONE_CHEST
		BP = H.get_bodypart(check_zone(def_zone))

	if(!BP)
		BP = H.bodyparts[1]

	switch(damagetype)
		if(BRUTE)
			H.damageoverlaytemp = 20
			var/damage_amount = forced ? damage : damage * hit_percent * brutemod * H.physiology.brute_mod
			if(BP)
				if(damage > 0 ? BP.receive_damage(damage_amount, 0) : BP.heal_damage(abs(damage_amount), 0))
					H.update_damage_overlays()
					if(HAS_TRAIT(H, TRAIT_MASO) && prob(damage_amount))
						H.mob_climax(forced_climax=TRUE)

			else//no bodypart, we deal damage with a more general method.
				H.adjustBruteLoss(damage_amount)
		if(BURN)
			H.damageoverlaytemp = 20
			var/damage_amount = forced ? damage : damage * hit_percent * burnmod * H.physiology.burn_mod
			if(BP)
				if(damage > 0 ? BP.receive_damage(0, damage_amount) : BP.heal_damage(0, abs(damage_amount)))
					H.update_damage_overlays()
			else
				H.adjustFireLoss(damage_amount)
		if(TOX)
			var/damage_amount = forced ? damage : damage * hit_percent * H.physiology.tox_mod
			H.adjustToxLoss(damage_amount)
		if(OXY)
			var/damage_amount = forced ? damage : damage * hit_percent * H.physiology.oxy_mod
			H.adjustOxyLoss(damage_amount)
		if(CLONE)
			var/damage_amount = forced ? damage : damage * hit_percent * H.physiology.clone_mod
			H.adjustCloneLoss(damage_amount)
		if(STAMINA)
			var/damage_amount = forced ? damage : damage * hit_percent * H.physiology.stamina_mod
			if(BP)
				if(damage > 0 ? BP.receive_damage(0, 0, damage_amount) : BP.heal_damage(0, 0, abs(damage * hit_percent * H.physiology.stamina_mod), only_robotic = FALSE, only_organic = FALSE))
					H.update_stamina()
			else
				H.adjustStaminaLoss(damage_amount)
		if(BRAIN)
			var/damage_amount = forced ? damage : damage * hit_percent * H.physiology.brain_mod
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, damage_amount)
	return 1

/datum/species/proc/on_hit(obj/item/projectile/P, mob/living/carbon/human/H)
	// called when hit by a projectile
	switch(P.type)
		if(/obj/item/projectile/energy/floramut) // overwritten by plants/pods
			H.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		if(/obj/item/projectile/energy/florayield)
			H.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")

/datum/species/proc/bullet_act(obj/item/projectile/P, mob/living/carbon/human/H)
	// called before a projectile hit
	return

/////////////
//BREATHING//
/////////////

/datum/species/proc/breathe(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		return TRUE


/datum/species/proc/handle_environment(datum/gas_mixture/environment, mob/living/carbon/human/H)
	if(!environment)
		return
	if(istype(H.loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	var/loc_temp = H.get_temperature(environment)

	//Body temperature is adjusted in two parts: first there your body tries to naturally preserve homeostasis (shivering/sweating), then it reacts to the surrounding environment
	//Thermal protection (insulation) has mixed benefits in two situations (hot in hot places, cold in hot places)
	if(!H.on_fire) //If you're on fire, you do not heat up or cool down based on surrounding gases
		var/natural = 0
		if(H.stat != DEAD)
			natural = H.natural_bodytemperature_stabilization()
		var/thermal_protection = 1
		if(loc_temp < H.bodytemperature) //Place is colder than we are
			thermal_protection -= H.get_thermal_protection(loc_temp, TRUE) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(H.bodytemperature < BODYTEMP_NORMAL) //we're cold, insulation helps us retain body heat and will reduce the heat we lose to the environment
				H.adjust_bodytemperature((thermal_protection+1)*natural + max(thermal_protection * (loc_temp - H.bodytemperature) / BODYTEMP_COLD_DIVISOR, BODYTEMP_COOLING_MAX))
			else //we're sweating, insulation hinders our ability to reduce heat - and it will reduce the amount of cooling you get from the environment
				H.adjust_bodytemperature(natural*(1/(thermal_protection+1)) + max((thermal_protection * (loc_temp - H.bodytemperature) + BODYTEMP_NORMAL - H.bodytemperature) / BODYTEMP_COLD_DIVISOR , BODYTEMP_COOLING_MAX)) //Extra calculation for hardsuits to bleed off heat
		else //Place is hotter than we are
			thermal_protection -= H.get_thermal_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(H.bodytemperature < BODYTEMP_NORMAL) //and we're cold, insulation enhances our ability to retain body heat but reduces the heat we get from the environment
				H.adjust_bodytemperature((thermal_protection+1)*natural + min(thermal_protection * (loc_temp - H.bodytemperature) / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX))
			else //we're sweating, insulation hinders out ability to reduce heat - but will reduce the amount of heat we get from the environment
				H.adjust_bodytemperature(natural*(1/(thermal_protection+1)) + min(thermal_protection * (loc_temp - H.bodytemperature) / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX))
		switch((loc_temp - H.bodytemperature)*thermal_protection)
			if(-INFINITY to -50)
				H.throw_alert("temp", /obj/screen/alert/cold, 3)
			if(-50 to -35)
				H.throw_alert("temp", /obj/screen/alert/cold, 2)
			if(-35 to -20)
				H.throw_alert("temp", /obj/screen/alert/cold, 1)
			if(-20 to 0) //This is the sweet spot where air is considered normal
				H.clear_alert("temp")
			if(0 to 15) //When the air around you matches your body's temperature, you'll start to feel warm.
				H.throw_alert("temp", /obj/screen/alert/hot, 1)
			if(15 to 30)
				H.throw_alert("temp", /obj/screen/alert/hot, 2)
			if(30 to INFINITY)
				H.throw_alert("temp", /obj/screen/alert/hot, 3)

	// +/- 50 degrees from 310K is the 'safe' zone, where no damage is dealt.
	if(H.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTHEAT))
		//Body temperature is too hot.

		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "cold")
		SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "hot", /datum/mood_event/hot)

		H.remove_movespeed_modifier(MOVESPEED_ID_COLD)

		var/burn_damage
		var/firemodifier = H.fire_stacks / 50
		if (H.on_fire)
			burn_damage = max(log(2-firemodifier,(H.bodytemperature-BODYTEMP_NORMAL))-5,0)
		else
			firemodifier = min(firemodifier, 0)
			burn_damage = max(log(2-firemodifier,(H.bodytemperature-BODYTEMP_NORMAL))-5,0) // this can go below 5 at log 2.5
		burn_damage = burn_damage * heatmod * H.physiology.heat_mod
		if (H.stat < UNCONSCIOUS && (prob(burn_damage) * 10) / 4) //40% for level 3 damage on humans
			H.emote("scream")
		H.apply_damage(burn_damage, BURN)

	else if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !HAS_TRAIT(H, TRAIT_RESISTCOLD))
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "hot")
		SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "cold", /datum/mood_event/cold)
		//Sorry for the nasty oneline but I don't want to assign a variable on something run pretty frequently
		H.add_movespeed_modifier(MOVESPEED_ID_COLD, override = TRUE, multiplicative_slowdown = ((BODYTEMP_COLD_DAMAGE_LIMIT - H.bodytemperature) / COLD_SLOWDOWN_FACTOR))
		switch(H.bodytemperature)
			if(200 to BODYTEMP_COLD_DAMAGE_LIMIT)
				H.apply_damage(COLD_DAMAGE_LEVEL_1*coldmod*H.physiology.cold_mod, BURN)
			if(120 to 200)
				H.apply_damage(COLD_DAMAGE_LEVEL_2*coldmod*H.physiology.cold_mod, BURN)
			else
				H.apply_damage(COLD_DAMAGE_LEVEL_3*coldmod*H.physiology.cold_mod, BURN)

	else
		H.remove_movespeed_modifier(MOVESPEED_ID_COLD)
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "cold")
		SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "hot")

	var/pressure = environment.return_pressure()
	var/adjusted_pressure = H.calculate_affecting_pressure(pressure) //Returns how much pressure actually affects the mob.
	switch(adjusted_pressure)
		if(HAZARD_HIGH_PRESSURE to INFINITY)
			if(!HAS_TRAIT(H, TRAIT_RESISTHIGHPRESSURE))
				H.adjustBruteLoss(min(((adjusted_pressure / HAZARD_HIGH_PRESSURE) -1 ) * PRESSURE_DAMAGE_COEFFICIENT, MAX_HIGH_PRESSURE_DAMAGE) * H.physiology.pressure_mod)
				H.throw_alert("pressure", /obj/screen/alert/highpressure, 2)
			else
				H.clear_alert("pressure")
		if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
			H.throw_alert("pressure", /obj/screen/alert/highpressure, 1)
		if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
			H.clear_alert("pressure")
		if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
			H.throw_alert("pressure", /obj/screen/alert/lowpressure, 1)
		else
			if(HAS_TRAIT(H, TRAIT_RESISTLOWPRESSURE))
				H.clear_alert("pressure")
			else
				H.adjustBruteLoss(LOW_PRESSURE_DAMAGE * H.physiology.pressure_mod)
				H.throw_alert("pressure", /obj/screen/alert/lowpressure, 2)

//////////
// FIRE //
//////////

/datum/species/proc/handle_fire(mob/living/carbon/human/H, no_protection = FALSE)
	if(HAS_TRAIT(H, TRAIT_NOFIRE))
		return
	if(H.on_fire)
		//the fire tries to damage the exposed clothes and items
		var/list/burning_items = list()
		//HEAD//
		var/obj/item/clothing/head_clothes = null
		if(H.glasses)
			head_clothes = H.glasses
		if(H.wear_mask)
			head_clothes = H.wear_mask
		if(H.wear_neck)
			head_clothes = H.wear_neck
		if(H.head)
			head_clothes = H.head
		if(head_clothes)
			burning_items += head_clothes
		else if(H.ears)
			burning_items += H.ears

		//CHEST//
		var/obj/item/clothing/chest_clothes = null
		if(H.w_uniform)
			chest_clothes = H.w_uniform
		if(H.wear_suit)
			chest_clothes = H.wear_suit

		if(chest_clothes)
			burning_items += chest_clothes

		//ARMS & HANDS//
		var/obj/item/clothing/arm_clothes = null
		if(H.gloves)
			arm_clothes = H.gloves
		if(H.w_uniform && ((H.w_uniform.body_parts_covered & HANDS) || (H.w_uniform.body_parts_covered & ARMS)))
			arm_clothes = H.w_uniform
		if(H.wear_suit && ((H.wear_suit.body_parts_covered & HANDS) || (H.wear_suit.body_parts_covered & ARMS)))
			arm_clothes = H.wear_suit
		if(arm_clothes)
			burning_items |= arm_clothes

		//LEGS & FEET//
		var/obj/item/clothing/leg_clothes = null
		if(H.shoes)
			leg_clothes = H.shoes
		if(H.w_uniform && ((H.w_uniform.body_parts_covered & FEET) || (H.w_uniform.body_parts_covered & LEGS)))
			leg_clothes = H.w_uniform
		if(H.wear_suit && ((H.wear_suit.body_parts_covered & FEET) || (H.wear_suit.body_parts_covered & LEGS)))
			leg_clothes = H.wear_suit
		if(leg_clothes)
			burning_items |= leg_clothes

		for(var/X in burning_items)
			var/obj/item/I = X
			if(!(I.resistance_flags & FIRE_PROOF))
				I.take_damage(H.fire_stacks, BURN, "fire", 0)

		var/thermal_protection = H.easy_thermal_protection()

		if(thermal_protection >= FIRE_IMMUNITY_MAX_TEMP_PROTECT && !no_protection)
			return
		if(thermal_protection >= FIRE_SUIT_MAX_TEMP_PROTECT && !no_protection)
			H.adjust_bodytemperature(11)
		else
			H.adjust_bodytemperature(BODYTEMP_HEATING_MAX + (H.fire_stacks * 12))
			SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "on_fire", /datum/mood_event/on_fire)

/datum/species/proc/CanIgniteMob(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_NOFIRE))
		return FALSE
	return TRUE

/datum/species/proc/ExtinguishMob(mob/living/carbon/human/H)
	return


////////////
//Stun//
////////////

/datum/species/proc/spec_stun(mob/living/carbon/human/H,amount)
	. = stunmod * H.physiology.stun_mod * amount

//////////////
//Space Move//
//////////////

/datum/species/proc/space_move(mob/living/carbon/human/H)
	return 0

/datum/species/proc/negates_gravity(mob/living/carbon/human/H)
	return 0

////////////////
//Tail Wagging//
////////////////

/datum/species/proc/can_wag_tail(mob/living/carbon/human/H)
	return FALSE

/datum/species/proc/is_wagging_tail(mob/living/carbon/human/H)
	return FALSE

/datum/species/proc/start_wagging_tail(mob/living/carbon/human/H)

/datum/species/proc/stop_wagging_tail(mob/living/carbon/human/H)
