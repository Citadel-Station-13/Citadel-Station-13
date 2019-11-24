/obj/item/organ/genital/eggsack
	name = "Egg sack"
	desc = "An egg producing reproductive organ."
	icon_state = "egg_sack"
	icon = 'modular_citadel/icons/obj/genitals/ovipositor.dmi'
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TESTICLES
	genital_flags = GENITAL_INTERNAL|GENITAL_BLACKLISTED //unimplemented
	linked_organ_slot = ORGAN_SLOT_PENIS
	color = null //don't use the /genital color since it already is colored
	var/egg_girth = EGG_GIRTH_DEF
	var/cum_mult = CUM_RATE_MULT
	var/cum_rate = CUM_RATE
	var/cum_efficiency	= CUM_EFFICIENCY
