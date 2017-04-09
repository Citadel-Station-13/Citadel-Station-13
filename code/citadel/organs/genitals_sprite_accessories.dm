/datum/sprite_accessory
	var/alt_aroused = FALSE //CIT CODE if this is TRUE, then the genitals will use an alternate icon_state when aroused.


//DICKS,COCKS,PENISES,WHATEVER YOU WANT TO CALL THEM
/datum/sprite_accessory/penis
	icon = 'code/citadel/icons/penis_onmob.dmi'
	icon_state = null
	name = "penis"			//the preview name of the accessory
	gender_specific = 0	//Might be needed somewhere down the list.
	color_src = "cock_color"
	locked = 0

/datum/sprite_accessory/penis/human
	icon_state = "human"
	name = "Human"

/datum/sprite_accessory/penis/knotted
	icon_state = "knotted"
	name = "Knotted"

/datum/sprite_accessory/penis/flared
	icon_state = "flared"
	name = "Flared"

/datum/sprite_accessory/penis/barbknot
	icon_state = "barbknot"
	name = "Barbed, Knotted"

/datum/sprite_accessory/penis/tapered
	icon_state = "tapered"
	name = "Tapered"

//Vaginas
/datum/sprite_accessory/vagina
	icon = 'code/citadel/icons/vagina_onmob.dmi'
	icon_state = null
	name = "vagina"
	gender_specific = 0
	color_src = "vag_color"
	locked = 0
	alt_aroused = FALSE //if this is TRUE, then the genitals will use an alternate sprite for aroused states

/datum/sprite_accessory/vagina/human
	icon_state = "human"
	name = "Human"
	alt_aroused = TRUE

/datum/sprite_accessory/vagina/tentacles
	icon_state = "tentacle"
	name = "Tentacle"
	alt_aroused = TRUE

/datum/sprite_accessory/vagina/dentata
	icon_state = "dentata"
	name = "Dentata"
	alt_aroused = TRUE

/datum/sprite_accessory/vagina/hairy
	icon_state = "hairy"
	name = "Hairy"


//BREASTS BE HERE
/datum/sprite_accessory/breasts
	icon = 'code/citadel/icons/breasts_onmob.dmi'
	icon_state = null
	name = "breasts"
	gender_specific = 0
	color_src = "breasts_color"
	locked = 0

/datum/sprite_accessory/breasts/pair
	icon_state = "pair"
	name = "Pair"

/*!!ULTRACOMPRESSEDEDITION!!
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
*/// Sorry for ruining your things


//OVIPOSITORS BE HERE
/datum/sprite_accessory/ovipositor
	icon = 'code/citadel/icons/penis_onmob.dmi'
	icon_state = null
	name = "Ovipositor"			//the preview name of the accessory
	gender_specific = 0			//Might be needed somewhere down the list.
	color_src = "cock_color"
	locked = 0

/datum/sprite_accessory/ovipositor/knotted
	icon_state = "knotted"
	name = "Knotted"
