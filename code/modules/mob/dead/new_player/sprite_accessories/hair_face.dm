/////////////////////////////
// Facial Hair Definitions //
/////////////////////////////
/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix w/ beards :P)

// please make sure they're sorted alphabetically and categorized

/datum/sprite_accessory/facial_hair/abe
	name = "Beard (Abraham Lincoln)"
	icon_state = "facial_abe"

/datum/sprite_accessory/facial_hair/brokenman
	name = "Beard (Broken Man)"
	icon_state = "facial_brokenman"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Beard (Chinstrap)"
	icon_state = "facial_chin"

/datum/sprite_accessory/facial_hair/dwarf
	name = "Beard (Dwarf)"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hair/fiveoclock
	name = "Beard (Five o Clock Shadow)"
	icon_state = "facial_fiveoclock"

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Beard (Full)"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/gt
	name = "Beard (Goatee)"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/hip
	name = "Beard (Hipster)"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/jensen
	name = "Beard (Jensen)"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Beard (Neckbeard)"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hair/vlongbeard
	name = "Beard (Very Long)"
	icon_state = "facial_wise"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Beard (Long)"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/fu
	name = "Moustache (Fu Manchu)"
	icon_state = "facial_fumanchu"

/datum/sprite_accessory/facial_hair/hogan
	name = "Moustache (Hulk Hogan)"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/selleck
	name = "Moustache (Selleck)"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Moustache (Square)"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hair/vandyke
	name = "Moustache (Van Dyke)"
	icon_state = "facial_vandyke"

/datum/sprite_accessory/facial_hair/watson
	name = "Moustache (Watson)"
	icon_state = "facial_watson"

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = null
	gender = NEUTER

/datum/sprite_accessory/facial_hair/elvis
	name = "Sideburns (Elvis)"
	icon_state = "facial_elvis"

#define VFACE(_name, new_state) /datum/sprite_accessory/facial_hair/##new_state/icon_state=#new_state;;/datum/sprite_accessory/facial_hair/##new_state/name= #_name + " (Virgo)"
VFACE("Watson", facial_watson_s)
VFACE("Chaplin", facial_chaplin_s)
VFACE("Fullbeard", facial_fullbeard_s)
VFACE("Vandyke", facial_vandyke_s)
VFACE("Elvis", facial_elvis_s)
VFACE("Abe", facial_abe_s)
VFACE("Chin", facial_chin_s)
VFACE("GT", facial_gt_s)
VFACE("Hip", facial_hip_s)
VFACE("Hogan", facial_hogan_s)
VFACE("Selleck", facial_selleck_s)
VFACE("Neckbeard", facial_neckbeard_s)
VFACE("Longbeard", facial_longbeard_s)
VFACE("Dwarf", facial_dwarf_s)
VFACE("Sideburn", facial_sideburn_s)
VFACE("Mutton", facial_mutton_s)
VFACE("Moustache", facial_moustache_s)
VFACE("Pencilstache", facial_pencilstache_s)
VFACE("Goatee", facial_goatee_s)
VFACE("Smallstache", facial_smallstache_s)
VFACE("Volaju", facial_volaju_s)
VFACE("3 O\'clock", facial_3oclock_s)
VFACE("5 O\'clock", facial_5oclock_s)
VFACE("7 O\'clock", facial_7oclock_s)
VFACE("5 O\'clock Moustache", facial_5oclockmoustache_s)
VFACE("7 O\'clock", facial_7oclockmoustache_s)
VFACE("Walrus", facial_walrus_s)
VFACE("Muttonmus", facial_muttonmus_s)
VFACE("Wise", facial_wise_s)
VFACE("Martial Artist", facial_martialartist_s)
VFACE("Dorsalfnil", facial_dorsalfnil_s)
VFACE("Hornadorns", facial_hornadorns_s)
VFACE("Spike", facial_spike_s)
VFACE("Chinhorns", facial_chinhorns_s)
VFACE("Cropped Fullbeard", facial_croppedfullbeard_s)
VFACE("Chinless Beard", facial_chinlessbeard_s)
VFACE("Moonshiner", facial_moonshiner_s)
VFACE("Tribearder", facial_tribearder_s)
#undef VFACE