/datum/reagent/water/fish
	name = "Dirty water"
	id = "fishwater"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen. This seems to have been taken from a dirty fishtank."
	taste_description = "Shit filled water"
	glass_icon_state = "glass_clear"
	glass_name = "glass of fishwater"
	glass_desc = "I've got no idea why you would ever want to drink this."
	shot_glass_icon_state = "shotglassclear"
	var/toxpwr = 0.25

/datum/reagent/water/fish/on_mob_life(mob/living/M)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM, 0)
		. = 1
	..()