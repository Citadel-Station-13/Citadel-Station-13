/*This is the datum to copy when making new overlays.
/datum/sprite_accessory/[replaceme]
	icon			//the icon file the accessory is located in
	icon_state		//the icon_state of the accessory
	name			//the preview name of the accessory
	gender = NEUTER	//Determines if the accessory will be skipped or included in random hair generations
	gender_specific //Something that can be worn by either gender, but looks different on each
	color_src = MUTCOLOR
	hasinner		//Decides if this sprite has an "inner" part, such as the fleshy parts on ears.
	locked = 0		//Is this part locked from roundstart selection? Used for parts that apply effects, typically.
	dimension_x = 32
	dimension_y = 32
	center = FALSE	//Should we center the sprite?
	extra = 0 											//Used for extra overlays on top of the bodypart that may be colored seperately. Uses the secondary mutant color as default. See species.dm for the actual overlay code.
	extra_icon = 'icons/mob/mam_bodyparts.dmi'
	extra_color_src = MUTCOLORS2 						//The color source for the extra overlay.
*/

//DICKS,COCKS,PENISES,WHATEVER YOU WANT TO CALL THEM
/datum/sprite_accessory/penis
	icon = 'icons/mob/penises.dmi'
	icon_state = null
	name = "penis"			//the preview name of the accessory
	gender_specific = 0	//Might be needed somewhere down the list.
	color_src = "cock_color"
	locked = 0

/datum/sprite_accessory/penis/human
	icon_state = "human"
	name = "Human"
	color_src = "cock_color"

/datum/sprite_accessory/penis/knotted
	icon_state = "knotted"
	name = "Knotted"

/datum/sprite_accessory/penis/flared
	icon_state = "flared"
	name = "Flared"

/datum/sprite_accessory/penis/barbed
	icon_state = "barbed"
	name = "Barbed"

/datum/sprite_accessory/penis/barbknot
	icon_state = "barbknot"
	name = "Barbed, Knotted"


//BREASTS BE HERE
/datum/sprite_accessory/breasts
	icon = 'icons/mob/breasts.dmi'
	icon_state = null
	name = "breasts"
	gender_specific = 0
	color_src = MUTCOLORS2	//I'll have skin_tone override this if the mob requires it	(humans)
	locked = 0
/*!!ULTRACOMPRESSEDEDITION!!*/
/datum/sprite_accessory/breasts/a
	icon_state = "a"
	name = "A"
/datum/sprite_accessory/breasts/aa
	icon_state = "a"
	name = "AA"
/datum/sprite_accessory/breasts/b
	icon_state = "b"
	name = "B"
/datum/sprite_accessory/breasts/bb
	icon_state = "b"
	name = "BB"
/datum/sprite_accessory/breasts/c
	icon_state = "c"
	name = "C"
/datum/sprite_accessory/breasts/cc
	icon_state = "c"
	name = "CC"
/datum/sprite_accessory/breasts/d
	icon_state = "d"
	name = "D"
/datum/sprite_accessory/breasts/dd
	icon_state = "d"
	name = "DD"
/datum/sprite_accessory/breasts/e
	icon_state = "e"
	name = "E"
/datum/sprite_accessory/breasts/ee
	icon_state = "e"
	name = "EE"
/datum/sprite_accessory/breasts/f
	icon_state = "f"
	name = "F"
	locked = 1
/datum/sprite_accessory/breasts/ff
	icon_state = "f"
	name = "FF"
	locked = 1
/datum/sprite_accessory/breasts/g
	icon_state = "g"
	name = "G"
	locked = 1
/datum/sprite_accessory/breasts/gg
	icon_state = "g"
	name = "GG"
	locked = 1
/datum/sprite_accessory/breasts/h
	icon_state = "h"
	name = "H"
	locked = 1
/datum/sprite_accessory/breasts/hh
	icon_state = "h"
	name = "HH"
	locked = 1

//OVIPOSITORS BE HERE
/datum/sprite_accessory/ovipositor
	icon = 'icons/mob/ovipositors.dmi'
	icon_state = null
	name = "Ovipositor"			//the preview name of the accessory
	gender_specific = 0			//Might be needed somewhere down the list.
	color_src = "cock_color"
	locked = 0

/datum/sprite_accessory/ovipositor/knotted
	icon_state = "knotted"
	name = "Knotted"
