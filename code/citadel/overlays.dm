/*This is the datum to copy when making new overlays.
/datum/sprite_accessory/[replaceme]
	icon			//the icon file the accessory is located in
	icon_state		//the icon_state of the accessory
	name			//the preview name of the accessory
	gender = NEUTER	//Determines if the accessory will be skipped or included in random hair generations
	gender_specific //Something that can be worn by either gender, but looks different on each
	color_src = MUTCOLORS	//Currently only used by mutantparts so don't worry about hair and stuff. This is the source that this accessory will get its color from. Default is MUTCOLOR, but can also be HAIR, FACEHAIR, EYECOLOR and 0 if none.
	hasinner		//Decides if this sprite has an "inner" part, such as the fleshy parts on ears.
	locked = 0		//Is this part locked from roundstart selection? Used for parts that apply effects
	dimension_x = 32
	dimension_y = 32
	center = FALSE	//Should we center the sprite?
	extra = 0 											//Used for extra overlays on top of the bodypart that may be colored seperately. Uses the secondary mutant color as default. See species.dm for the actual overlay code.
	extra_icon = 'icons/mob/mam_bodyparts.dmi'
	extra_color_src = MUTCOLORS2 						//The color source for the extra overlay.
*/

/datum/sprite_accessory/penis
	icon = icons/mob/dicks.dmi
	icon_state = null
	name = "penis"			//the preview name of the accessory
	gender_specific = 0	//Might be needed somewhere down the list.
	color_src = "cock_color"
	locked = 0

/datum/sprite_accessory/penis/human
	icon_state = "human"
	name = "Human"//the preview name of the accessory
	gender_specific = 0	//Might be needed somewhere down the list.
	color_src = "cock_color"
	locked = 0
