/obj/item/organ/genital/ovipositor
	name = "Ovipositor"
	desc = "An egg laying reproductive organ."
	icon_state = "ovi_knotted_2"
	icon = 'modular_citadel/icons/obj/genitals/ovipositor.dmi'
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS
	genital_flags = GENITAL_BLACKLISTED //unimplemented
	shape = "knotted"
	size = 3
	layer_index = PENIS_LAYER_INDEX
	var/length = 6								//inches
	var/girth  = 0
	var/girth_ratio = COCK_DIAMETER_RATIO_DEF 		//citadel_defines.dm for these defines
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/oviflags = list()
