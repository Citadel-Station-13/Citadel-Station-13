//Fire
/mob/living/simple_animal/hostile/guardian/fire
	a_intent = INTENT_HELP
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_sound = 'sound/items/welder.ogg'
	attack_verb_continuous = "ignites"
	attack_verb_simple = "ignite"
	melee_damage_type = BURN
	damage_coeff = list(BRUTE = 0.7, BURN = 0.1, TOX = 0.7, CLONE = 0.7, STAMINA = 0, OXY = 0.7)
	playstyle_string = "<span class='holoparasite'>As a <b>chaos</b> type, you take 30% damage reduction to all but burn, which you are almost immune to. You will ignite any enemy you bump into. in addition, your melee attacks will cause human targets to see everyone as you.</span>"
	magic_fluff_string = "<span class='holoparasite'>..And draw the Wizard, bringer of endless chaos!</span>"
	tech_fluff_string = "<span class='holoparasite'>Boot sequence complete. Crowd control modules activated. Holoparasite swarm online.</span>"
	carp_fluff_string = "<span class='holoparasite'>CARP CARP CARP! You caught one! OH GOD, EVERYTHING'S ON FIRE. Except you and the fish.</span>"

/mob/living/simple_animal/hostile/guardian/fire/BiologicalLife(delta_time, times_fired)
	if(!(. = ..()))
		return
	if(summoner)
		summoner.ExtinguishMob()
		summoner.adjust_fire_stacks(-20)

/mob/living/simple_animal/hostile/guardian/fire/AttackingTarget()
	. = ..()
	if(. && ishuman(target) && target != summoner)
		new /datum/hallucination/delusion(target,TRUE,"custom",200,0, icon_state,icon)

/mob/living/simple_animal/hostile/guardian/fire/Crossed(AM as mob|obj)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/Bumped(atom/movable/AM)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/Bump(AM as mob|obj)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/proc/collision_ignite(AM as mob|obj)
	if(isliving(AM))
		var/mob/living/M = AM
		if(!hasmatchingsummoner(M) && M != summoner && M.fire_stacks < 10)
			M.fire_stacks = 10
			M.IgniteMob()
