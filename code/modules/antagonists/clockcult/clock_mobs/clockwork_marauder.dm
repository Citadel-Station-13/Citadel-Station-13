#define MARAUDER_SLOWDOWN_PERCENTAGE 0.40 //Below this percentage of health, marauders will become slower
#define MARAUDER_SHIELD_REGEN_TIME 200 //In deciseconds, how long it takes for shields to regenerate after breaking
#define MARAUDER_SPACE_FULL_DAMAGE 6		//amount of damage per life tick while inside space
#define MARAUDER_SPACE_NEAR_DAMAGE 4			//amount of damage taking per Life() tick from being next to space.

//Clockwork marauder: A well-rounded frontline construct. Only one can exist for every two human servants.
/mob/living/simple_animal/hostile/clockwork/marauder
	name = "clockwork marauder"
	desc = "The stalwart apparition of a soldier, blazing with crimson flames. It's armed with a gladius and shield."
	icon_state = "clockwork_marauder"
	mob_biotypes = MOB_HUMANOID
	threat = 3
	health = 120
	maxHealth = 120
	force_threshold = 8
	speed = 0
	obj_damage = 40
	melee_damage_lower = 12
	melee_damage_upper = 12
	attacktext = "slashes"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	weather_immunities = list("lava")
	movement_type = FLYING
	a_intent = INTENT_HARM
	loot = list(/obj/item/clockwork/component/geis_capacitor/fallen_armor)
	light_range = 3
	light_power = 1.7
	playstyle_string = "<span class='big bold'><span class='neovgre'>You are a clockwork marauder,</span></span><b> a well-rounded frontline construct of Ratvar. Although you have no \
	unique abilities, you're a fearsome fighter in one-on-one combat, and your shield protects from projectiles!<br><br>Obey the Servants and do as they \
	tell you. Your primary goal is to defend the Ark from destruction; they are your allies in this, and should be protected from harm.</b> \
	<span class='danger big'>Be warned, however, that you will rapidly decay near the void of space.</span>"
	empower_string = "<span class='neovgre'>The Anima Bulwark's power flows through you! Your weapon will strike harder, your armor is sturdier, and your shield is more durable.</span>"
	var/default_speed = 0
	var/max_shield_health = 3
	var/shield_health = 3 //Amount of projectiles that can be deflected within
	var/shield_health_regen = 0 //When world.time equals this, shield health will regenerate

/mob/living/simple_animal/hostile/clockwork/marauder/examine_info()
	if(!shield_health)
		return "<span class='warning'>Its shield has been destroyed!</span>"

/mob/living/simple_animal/hostile/clockwork/marauder/Life()
	..()
	var/turf/T = get_turf(src)
	var/turf/open/space/S = isspaceturf(T)? T : null
	var/less_space_damage
	if(!istype(S))
		var/turf/open/space/nearS = locate() in oview(1)
		if(nearS)
			S = nearS
			less_space_damage = TRUE
	if(S)
		to_chat(src, "<span class='userdanger'>The void of space drains Ratvar's Light from you! You feel yourself rapidly decaying. It would be wise to get back inside!</span>")
		adjustBruteLoss(less_space_damage? MARAUDER_SPACE_NEAR_DAMAGE : MARAUDER_SPACE_FULL_DAMAGE)
	if(!GLOB.ratvar_awakens && health / maxHealth <= MARAUDER_SLOWDOWN_PERCENTAGE)
		speed = default_speed + 1 //Yes, this slows them down
	else
		speed = default_speed
	if(shield_health < max_shield_health && world.time >= shield_health_regen)
		shield_health_regen = world.time + MARAUDER_SHIELD_REGEN_TIME
		to_chat(src, "<span class='neovgre'>Your shield has recovered, <b>[shield_health]</b> blocks remaining!</span>")
		playsound_local(src, "shatter", 75, TRUE, frequency = -1)
		shield_health++

/mob/living/simple_animal/hostile/clockwork/marauder/update_values()
	if(GLOB.ratvar_awakens) //Massive attack damage bonuses and health increase, because Ratvar
		health = 300
		maxHealth = 300
		melee_damage_upper = 25
		melee_damage_lower = 25
		attacktext = "devastates"
		speed = -1
		obj_damage = 100
		max_shield_health = INFINITY
	else if(GLOB.ratvar_approaches) //Hefty health bonus and slight attack damage increase
		melee_damage_upper = 15
		melee_damage_lower = 15
		attacktext = "carves"
		obj_damage = 50
		max_shield_health = 4

/mob/living/simple_animal/hostile/clockwork/marauder/death(gibbed)
	visible_message("<span class='danger'>[src]'s equipment clatters lifelessly to the ground as the red flames within dissipate.</span>", \
	"<span class='userdanger'>Dented and scratched, your armor falls away, and your fragile form breaks apart without its protection.</span>")
	. = ..()

/mob/living/simple_animal/hostile/clockwork/marauder/Process_Spacemove(movement_dir = 0)
	return TRUE

/mob/living/simple_animal/hostile/clockwork/marauder/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(amount > 0)
		for(var/mob/living/L in view(2, src))
			if(L.is_holding_item_of_type(/obj/item/nullrod))
				to_chat(src, "<span class='userdanger'>The presence of a brandished holy artifact weakens your armor!</span>")
				amount *= 4 //if a wielded null rod is nearby, it takes four times the health damage
				break
	. = ..()

/mob/living/simple_animal/hostile/clockwork/marauder/bullet_act(obj/item/projectile/P)
	if(deflect_projectile(P))
		return BULLET_ACT_BLOCK
	return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/proc/deflect_projectile(obj/item/projectile/P)
	if(!shield_health)
		return
	var/energy_projectile = istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)
	visible_message("<span class='danger'>[src] deflects [P] with [p_their()] shield!</span>", \
	"<span class='danger'>You block [P] with your shield! <i>Blocks left:</i> <b>[shield_health - 1]</b></span>")
	if(energy_projectile)
		playsound(src, 'sound/weapons/effects/searwall.ogg', 50, TRUE)
	else
		playsound(src, "ricochet", 50, TRUE)
	shield_health--
	if(!shield_health)
		visible_message("<span class='warning'>[src]'s shield breaks from deflecting the attack!</span>", "<span class='boldwarning'>Your shield breaks! Give it some time to recover...</span>")
		playsound(src, "shatter", 100, TRUE)
	shield_health_regen = world.time + MARAUDER_SHIELD_REGEN_TIME
	return TRUE

#undef MARAUDER_SLOWDOWN_PERCENTAGE
#undef MARAUDER_SHIELD_REGEN_TIME
