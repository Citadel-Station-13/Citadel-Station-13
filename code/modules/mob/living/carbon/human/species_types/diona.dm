/datum/species/dionae
	name = "Dionae"
	id = "diona"
	blacklisted = FALSE
	sexes = FALSE
	say_mod = "rustles"
	default_color = "00FF00"

	species_traits = list(MUTCOLORS,NOEYES)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("diona_body_markings")
	default_features = list("diona_body_markings" = "Default")

	mutanttongue = /obj/item/organ/tongue/diona
	coldmod = 1.25
	heatmod = 1.25

	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/lizard
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	exotic_bloodtype = "D"
	disliked_food = TOXIC | JUNKFOOD
	liked_food = SUGAR | RAW | MEAT