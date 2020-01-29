/obj/item/organ/heart/gland/transform
	true_name = "anthropmorphic transmorphosizer"
	cooldown_low = 900
	cooldown_high = 1800
	uses = -1
	human_only = TRUE
	icon_state = "species"
	mind_control_uses = 7
	mind_control_duration = 300

/obj/item/organ/heart/gland/transform/activate()
	to_chat(owner, "<span class='notice'>You feel unlike yourself.</span>")
	var/datum/species/S = pick(list(/datum/species/human, /datum/species/lizard, /datum/species/insect, /datum/species/fly))
	randomize_human(owner, initial(S.randomized_features), FALSE)
	owner.set_species(S)
