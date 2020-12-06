//A speedy, annoying and scaredy demon
/mob/living/simple_animal/hostile/asteroid/imp
	name = "lava imp"
	desc = "Lowest on the hierarchy of slaughter demons, this one is still nothing to sneer at."
	icon = 'sandcode/icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "imp"
	icon_living = "imp"
	icon_aggro = "imp"
	icon_dead = "imp_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	move_to_delay = 4
	projectiletype = /obj/item/projectile/magic/impfireball
	projectilesound = 'sandcode/sound/misc/impranged.wav'
	ranged = 1
	ranged_message = "shoots a fireball"
	ranged_cooldown_time = 70
	throw_message = "does nothing against the hardened skin of"
	vision_range = 5
	speed = 1
	maxHealth = 150
	health = 150
	harm_intent_damage = 15
	obj_damage = 60
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	a_intent = INTENT_HARM
	speak_emote = list("groans")
	attack_sound = 'sandcode/sound/misc/impattacks.wav'
	aggro_vision_range = 15
	retreat_distance = 5
	gold_core_spawnable = HOSTILE_SPAWN
	crusher_loot = /obj/item/crusher_trophy/blaster_tubes/impskull
	loot = list()
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 2, /obj/item/stack/sheet/bone = 4, /obj/item/stack/sheet/leather = 2, /obj/item/stack/ore/plasma = 2)
	robust_searching = FALSE
	death_sound = 'sandcode/sound/misc/impdies.wav'
	glorymessageshand = list("grabs the imp's eyes and rips them out, shoving the bloody imp aside!", "grabs and crushes the imp's skull apart with their bare hands!", "rips the imp's head clean off with their bare hands!")
	glorymessagespka = list("sticks their PKA into the imp's mouth and shoots it, showering everything in gore!", "bashes the imp's head into their chest with their PKA!", "shoots off both legs of the imp with their PKA!")
	glorymessagespkabayonet = list("slices the imp's head off by the neck with the PKA's bayonet!", "repeatedly stabs the imp in their gut with the PKA's bayonet!")
	glorymessagescrusher = list("chops the imp horizontally in half with their crusher in one swift move!", "chops off the imp's legs with their crusher and kicks their face hard, exploding it while they're in the air!", "slashes each of the imp's arms off by the shoulder with their crusher!")

/mob/living/simple_animal/hostile/asteroid/imp/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	playsound(src, 'sandcode/sound/misc/impinjured.wav', rand(25,100), -1) //HURT ME PLENTY

/mob/living/simple_animal/hostile/asteroid/imp/bullet_act(obj/item/projectile/P)
	. = ..()
	playsound(src, 'sandcode/sound/misc/impinjured.wav', rand(25,100), -1)

/mob/living/simple_animal/hostile/asteroid/imp/Aggro()
	. = ..()
	playsound(src, pick('sandcode/sound/misc/impsight.wav', 'sandcode/sound/misc/impsight2.wav'), rand(50,75), -1)

/mob/living/simple_animal/hostile/asteroid/imp/LoseAggro()
	. = ..()
	playsound(src, pick('sandcode/sound/misc/impnearby.wav', 'sandcode/sound/misc/impnearby.wav'), rand(25, 60), -1)

/obj/item/projectile/magic/impfireball //bobyot y u no use child of fireball
	name = "demonic fireball" //because it fucking explodes and deals brute damage even when values are set to -1
	icon_state = "fireball"
	damage = 10
	damage_type = BURN
	nodamage = 0
	armour_penetration = 20
	var/firestacks = 5

/obj/item/projectile/magic/impfireball/on_hit(target)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.adjust_fire_stacks(firestacks)
		C.IgniteMob()
		if(C.stat != DEAD && C.stat != UNCONSCIOUS)
			playsound(C, 'sandcode/sound/misc/doominjured.wav', 100, -1)
		else if(C.stat == DEAD)
			playsound(C, 'sandcode/sound/misc/doomdies.wav', 100, -1)
		else
			playsound(C, pick('sandcode/sound/misc/doomscream.wav', 'sandcode/sound/misc/doomscream2.wav'), 100, -1)
