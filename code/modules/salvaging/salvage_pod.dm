//Salvaging pod. Large pod used to navigate debris fields. Capable of basic collection and sorting of materials.

/obj/mecha/pod
/obj/mecha/pod/salvage
	desc = "Autonomous Power Loader Unit. This newer model is refitted with powerful armour against the dangers of the EVA mining process."
	name = "\improper APLU \"Ripley\""
	icon_state = "salpod"
	icon = 'icons/salvaging/salpod.dmi'
	step_in = 5
	max_temperature = 20000
	health = 200
	lights_power = 7
	deflect_chance = 15
	damage_absorption = list("brute"=0.6,"fire"=1,"bullet"=0.8,"laser"=0.9,"energy"=1,"bomb"=0.6)
	max_equip = 6
	wreckage = /obj/structure/mecha_wreckage/ripley