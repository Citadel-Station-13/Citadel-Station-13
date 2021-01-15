// welcome to the jungle, we got fun and games

//areas

/area/awaymission/jungleresort
	name = "Jungle Resort"
	icon_state = "awaycontent30"

//objects

/obj/item/paper/crumpled/awaymissions/jungleresort/notice
	name = "Resort Notice"
	info = "Due to unforeseen circumstances and the disappearance of several resort employees and visitors, the resort shall be closed to the public until further notice. - <i>Resort Manager Joe Lawrence</i.>"

/obj/item/melee/chainofcommand/jungle
	name = "treasure hunter's whip"
	desc = "The tool of a fallen treasure hunter, old and outdated, it still stings like hell to be hit by."
	hitsound = 'sound/weapons/whip.ogg'
	icon_state = "whip"

//turfs

/turf/open/water/jungle
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/open/floor/plating/dirt/jungle
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/open/floor/plating/dirt/dark/jungle
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/closed/mineral/random/labormineral/jungle
	baseturfs = /turf/open/floor/plating/asteroid
	turf_type = /turf/open/floor/plating/asteroid

//mobs

/mob/living/carbon/monkey/punpun/curiousgorge
	name = "Curious Gorge"
	pet_monkey_names = list("Curious Gorge", "Jungle Gorge", "Jungah Joe", "Mr. Monke")
	rare_pet_monkey_names = list("Sun Mukong", "Monkey Kong")

/mob/living/simple_animal/hostile/jungle/leaper/boss
	health = 450
