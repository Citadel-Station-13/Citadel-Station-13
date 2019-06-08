/mob/living/simple_animal/hostile/killertomato
	name = "Killer Tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"
	gender = NEUTER
	speak_chance = 0
	turns_per_move = 5
	maxHealth = 30
	health = 30
	see_in_dark = 3
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/killertomato = 2)
	response_help  = "prods"
	response_disarm = "pushes aside"
	response_harm   = "smacks"
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "slams"
	attack_sound = 'sound/weapons/punch1.ogg'
	ventcrawler = VENTCRAWLER_ALWAYS
	faction = list("plants")
	robust_searching = 1
	mob_biotypes = list(MOB_ORGANIC, MOB_WEAK_AGAINST_EPIC)

	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 150
	maxbodytemp = 500
	gold_core_spawnable = HOSTILE_SPAWN


/mob/living/simple_animal/hostile/killertomato/hunter
	name = "Hunter Tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef! This one seems to be a special breed, especially for hunting fauna of all sizes."
	turns_per_move = 4 //slightly faster
	maxHealth = 45 //slightly sturdier
	health = 45
	butcher_results = list()
	friend_types = list(/mob/living/carbon/human)
