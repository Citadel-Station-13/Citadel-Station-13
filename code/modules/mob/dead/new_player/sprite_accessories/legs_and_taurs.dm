/datum/sprite_accessory/legs 	//legs are a special case, they aren't actually sprite_accessories but are updated with them. -- OR SO THEY USED TO BE
	icon = null					//These datums exist for selecting legs on preference, and little else

/******************************************
***************** Leggy *******************
*******************************************/

/datum/sprite_accessory/legs/none
	name = "Plantigrade"

/datum/sprite_accessory/legs/digitigrade_lizard
	name = "Digitigrade"

/datum/sprite_accessory/legs/digitigrade_bird
	name = "Avian"


/******************************************
************** Taur Bodies ****************
*******************************************/

/datum/sprite_accessory/taur
	icon = 'modular_citadel/icons/mob/mam_taur.dmi'
	center = TRUE
	dimension_x = 64
	color_src = "dual_color" //we apply some snowflake colouring because it's (sometimes) two parts, don't worry about it
	recommended_species = list("human", "lizard", "insect", "mammal", "xeno", "jelly", "slimeperson", "podweak")
	relevant_layers = list(BODY_ADJ_UPPER_LAYER, BODY_FRONT_LAYER)
	var/taur_mode = NONE //Must be a single specific tauric suit variation bitflag. Don't do FLAG_1|FLAG_2
	var/alt_taur_mode = NONE //Same as above.
	var/hide_legs = USE_QUADRUPED_CLIP_MASK
	var/taur_marking_state = NONE //does your taur have separately colorable markings, if so what's the state, leave as NONE if it doesnt have any

/datum/sprite_accessory/taur/is_not_visible(var/mob/living/carbon/human/H, var/tauric)
	return (!tauric || (H.wear_suit && (H.wear_suit.flags_inv & HIDETAUR)))

/datum/sprite_accessory/taur/New()
	switch(hide_legs)
		if(USE_QUADRUPED_CLIP_MASK)
			alpha_mask_state = "taur_mask_def"
		if(USE_SNEK_CLIP_MASK)
			alpha_mask_state = "taur_mask_naga"

/datum/sprite_accessory/taur/none
	name = "None"
	icon_state = "None"
	dimension_x = 32
	center = FALSE
	recommended_species = null
	relevant_layers = null
	hide_legs = FALSE

/datum/sprite_accessory/taur/wolf
	name = "Wolf"
	icon_state = "wolf"
	taur_marking_state = "wolf_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/wolf/synth
	name = "Wolf (synth)"
	icon_state = "synthwolf"
	taur_marking_state = "synthwolf_markings"

/datum/sprite_accessory/taur/wolf/fat
	name = "Wolf (fat)"
	icon_state = "fatwolf"
	taur_marking_state = "fatwolf_markings"

/datum/sprite_accessory/taur/cow
	name = "Cow"
	icon_state = "cow"
	taur_mode = STYLE_HOOF_TAURIC
	alt_taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/deer
	name = "Deer"
	icon_state = "deer"
	taur_marking_state = "deer_markings"
	taur_mode = STYLE_HOOF_TAURIC
	alt_taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/lizard
	name = "Lizard"
	icon_state = "lizard"
	taur_marking_state = "lizard_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/lizard/synth
	name = "Lizard (synth)"
	icon_state = "synthlizard"
	taur_marking_state = "synthlizard_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/drake
	name = "Drake"
	icon_state = "drake"
	taur_marking_state = "drake_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/spider
	name = "Spider"
	icon_state = "spider_s"

/datum/sprite_accessory/taur/feline
	name = "Feline"
	icon_state = "feline"
	taur_marking_state = "feline_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/feline/synth
	name = "Feline (synth)"
	icon_state = "synthfeline"
	taur_marking_state = "synthfeline_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/feline/fat
	name = "Feline (fat)"
	icon_state = "fatfeline"
	taur_marking_state = "fatfeline_markings"

/datum/sprite_accessory/taur/horse
	name = "Horse"
	icon_state = "horse"
	taur_mode = STYLE_HOOF_TAURIC
	alt_taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/horse/synth
	name = "Horse (synth)"
	icon_state = "synthhorse"
	taur_marking_state = "synthhorse_markings"
	taur_mode = STYLE_HOOF_TAURIC
	alt_taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/naga
	name = "Naga"
	icon_state = "naga"
	icon_state = "naga_markings"
	taur_mode = STYLE_SNEK_TAURIC
	hide_legs = USE_SNEK_CLIP_MASK

/datum/sprite_accessory/taur/otie
	name = "Otie"
	icon_state = "otie"
	icon_state = "otie_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/tempest
	name = "Tempest"
	icon_state = "tempest"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/skunk
	name = "Skunk"
	icon_state = "skunk"
	icon_state = "skunk_markings"
	taur_mode = STYLE_PAW_TAURIC

/datum/sprite_accessory/taur/mermaid
	name = "Mermaid"
	icon_state = "mermaid"
	taur_mode = STYLE_SNEK_TAURIC
	hide_legs = USE_SNEK_CLIP_MASK

/datum/sprite_accessory/taur/tentacle
	name = "Tentacle"
	icon_state = "tentacle"
	taur_mode = STYLE_SNEK_TAURIC
	hide_legs = USE_SNEK_CLIP_MASK

/datum/sprite_accessory/taur/slug
	name = "Slug"
	icon_state = "slug"
	taur_mode = STYLE_SNEK_TAURIC
	hide_legs = USE_SNEK_CLIP_MASK

/datum/sprite_accessory/taur/frog //frogs are closer to snakes than wolves, probably, listen i'm no biology major
	name = "Frog"
	icon_state = "frog"
	taur_mode = STYLE_SNEK_TAURIC
	hide_legs = USE_SNEK_CLIP_MASK
