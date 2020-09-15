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
	health = 120
	maxHealth = 120
	force_threshold = 8
	speed = 0
	obj_damage = 40
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
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

/mob/living/simple_animal/hostile/clockwork/marauder/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
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
		attack_verb_continuous = "devastates"
		attack_verb_simple = "devastate"
		speed = -1
		obj_damage = 100
		max_shield_health = INFINITY
	else if(GLOB.ratvar_approaches) //Hefty health bonus and slight attack damage increase
		melee_damage_upper = 15
		melee_damage_lower = 15
		attack_verb_continuous = "carves"
		attack_verb_simple = "carve"
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

//Clockwork guardian: Slow but with high damage, resides inside of a servant. Created via the Memory Allocation scripture.
/mob/living/simple_animal/hostile/clockwork/marauder/guardian
	name = "clockwork guardian"
	desc = "A stalwart apparition of a soldier, blazing with crimson flames. It's armed with a gladius and shield and stands ready by its master."
	icon_state = "clockwork_marauder"
	health = 300
	maxHealth = 300
	speed = 1
	obj_damage = 40
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	weather_immunities = list("lava")
	movement_type = FLYING
	AIStatus = AI_OFF //this has to be manually set so that the guardian doesn't start bashing the host, how annoying -_-
	loot = list(/obj/item/clockwork/component/geis_capacitor/fallen_armor)
	max_shield_health = 0
	shield_health = 0
	var/true_name = "Meme Master 69" //Required to call forth the guardian
	var/global/list/possible_true_names = list("Servant", "Warden", "Serf", "Page", "Usher", "Knave", "Vassal", "Escort")
	var/mob/living/host //The mob that the guardian is living inside of
	var/recovering = FALSE //If the guardian is recovering from recalling
	var/blockchance = 17 //chance to block attacks entirely
	var/counterchance = 30 //chance to counterattack after blocking
	var/static/list/damage_heal_order = list(OXY, BURN, BRUTE, TOX) //we heal our host's damage in this order
	light_range = 2
	light_power = 1.1
	playstyle_string = "<span class='sevtug'>You are a clockwork guardian</span><b>, a living extension of Sevtug's will. As a guardian, you are somewhat slow, but may block attacks, \
	and have a chance to also counter blocked melee attacks for extra damage, in addition to being immune to extreme temperatures and pressures. \
	Your primary goal is to serve the creature that you are now a part of, as well as The Clockwork Justiciar, Ratvar. You can use <span class='sevtug_small'><i>The Hierophant Network</i></span> to communicate silently with your master and their allies, \
	but can only exit if your master calls your true name or if they are exceptionally damaged. \
	\n\n\
	Stay near your host to protect and heal them; being too far from your host will rapidly cause you massive damage. Recall to your host if you are too weak and believe you cannot continue \
	fighting safely. As a final note, you should probably avoid harming any fellow servants of Ratvar.</span>"

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/Initialize()
	. = ..()
	true_name = pick(possible_true_names)

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/BiologicalLife(seconds, times_fired)
	..()
	if(is_in_host())
		if(!is_servant_of_ratvar(host))
			emerge_from_host(FALSE, TRUE)
			unbind_from_host()
			return
		if(!GLOB.ratvar_awakens && host.stat == DEAD)
			death()
			return
		if(GLOB.ratvar_awakens)
			adjustHealth(-50)
		else
			adjustHealth(-10)
		if(!recovering)
			heal_host() //also heal our host if inside of them and we aren't recovering
		else if(health == maxHealth)
			to_chat(src, "<span class='userdanger'>Your strength has returned. You can once again come forward!</span>")
			to_chat(host, "<span class='userdanger'>Your guardian is now strong enough to come forward again!</span>")
			recovering = FALSE
	else
		if(GLOB.ratvar_awakens) //If Ratvar is alive, guardians don't need a host and are downright impossible to kill
			adjustHealth(-5)
			heal_host()
		else if(host)
			if(!is_servant_of_ratvar(host))
				unbind_from_host()
				return
			if(host.stat == DEAD)
				adjustHealth(50)
				to_chat(src, "<span class='userdanger'>Your host is dead!</span>")
				return
			if(z && host.z && z == host.z)
				switch(get_dist(get_turf(src), get_turf(host)))
					if(2)
						adjustHealth(-1)
					if(3)
						//EQUILIBRIUM
					if(4)
						adjustHealth(1)
					if(5)
						adjustHealth(3)
					if(6)
						adjustHealth(6)
					if(7)
						adjustHealth(9)
					if(8 to INFINITY)
						adjustHealth(15)
						to_chat(src, "<span class='userdanger'>You're too far from your host and rapidly taking damage!</span>")
					else //right next to or on top of host
						adjustHealth(-2)
						heal_host() //gradually heal host if nearby and host is very weak
			else //well then, you're not even in the same zlevel
				adjustHealth(15)
				to_chat(src, "<span class='userdanger'>You're too far from your host and rapidly taking damage!</span>")

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/death(gibbed)
	emerge_from_host(FALSE, TRUE)
	unbind_from_host()
	visible_message("<span class='warning'>[src]'s equipment clatters lifelessly to the ground as the red flames within dissipate.</span>", \
	"<span class='userdanger'>Your equipment falls away. You feel a moment of confusion before your fragile form is annihilated.</span>")
	. = ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Current True Name: [true_name]")
		stat(null, "Host: [host ? host : "NONE"]")
		if(host)
			var/resulthealth = round((host.health / host.maxHealth) * 100, 0.5)
			if(iscarbon(host))
				resulthealth = round((abs(HEALTH_THRESHOLD_DEAD - host.health) / abs(HEALTH_THRESHOLD_DEAD - host.maxHealth)) * 100)
			stat(null, "Host Health: [resulthealth]%")
			if(GLOB.ratvar_awakens)
				stat(null, "You are [recovering ? "un" : ""]able to deploy!")
			else
				if(resulthealth > GUARDIAN_EMERGE_THRESHOLD)
					stat(null, "You are [recovering ? "unable to deploy" : "able to deploy on hearing your True Name"]!")
				else
					stat(null, "You are [recovering ? "unable to deploy" : "able to deploy to protect your host"]!")
		stat(null, "You do [melee_damage_upper] damage on melee attacks.")

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/Process_Spacemove(movement_dir = 0)
	return 1

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/bind_to_host(mob/living/new_host)
	if(!new_host)
		return FALSE
	host = new_host
	var/datum/action/innate/summon_guardian/SG = new()
	SG.linked_guardian = src
	SG.Grant(host)
	var/datum/action/innate/linked_minds/LM = new()
	LM.linked_guardian = src
	LM.Grant(host)
	return TRUE

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/unbind_from_host()
	if(host)
		for(var/datum/action/innate/summon_guardian/SG in host.actions)
			qdel(SG)
		for(var/datum/action/innate/linked_minds/LM in host.actions)
			qdel(LM)
		host = null
		return TRUE
	return FALSE

//DAMAGE and FATIGUE
/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/heal_host()
	if(!host)
		return
	var/resulthealth = round((host.health / host.maxHealth) * 100, 0.5)
	if(iscarbon(host))
		resulthealth = round((abs(HEALTH_THRESHOLD_DEAD - host.health) / abs(HEALTH_THRESHOLD_DEAD - host.maxHealth)) * 100)
	if(GLOB.ratvar_awakens || resulthealth <= GUARDIAN_EMERGE_THRESHOLD)
		new /obj/effect/temp_visual/heal(host.loc, "#AF0AAF")
		host.heal_ordered_damage(4, damage_heal_order)

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(amount > 0)
		for(var/mob/living/L in view(2, src))
			if(L.is_holding_item_of_type(/obj/item/nullrod))
				to_chat(src, "<span class='userdanger'>The presence of a brandished holy artifact weakens your armor!</span>")
				amount *= 4 //if a wielded null rod is nearby, it takes four times the health damage
				break
	. = ..()
	if(src && updating_health)
		update_health_hud()
		update_stats()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/update_health_hud()
	if(hud_used && hud_used.healths)
		if(istype(hud_used, /datum/hud/marauder))
			var/datum/hud/marauder/G = hud_used
			var/resulthealth
			if(host)
				if(iscarbon(host))
					resulthealth = "[round((abs(HEALTH_THRESHOLD_DEAD - host.health) / abs(HEALTH_THRESHOLD_DEAD - host.maxHealth)) * 100)]%"
				else
					resulthealth = "[round((host.health / host.maxHealth) * 100, 0.5)]%"
			else
				resulthealth = "NONE"
			G.hosthealth.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#AF0AAF'>HOST<br>[resulthealth]</font></div>"
		hud_used.healths.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#AF0AAF'>[round((health / maxHealth) * 100, 0.5)]%</font>"

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/update_stats()
	if(GLOB.ratvar_awakens)
		speed = 0
		melee_damage_lower = 20
		melee_damage_upper = 20
		attack_verb_continuous = "devastates"
	else
		var/healthpercent = (health/maxHealth) * 100
		switch(healthpercent)
			if(100 to 70) //Bonuses to speed and damage at high health
				speed = 0
				melee_damage_lower = 16
				melee_damage_upper = 16
				attack_verb_continuous = "viciously slashes"
			if(70 to 40)
				speed = initial(speed)
				melee_damage_lower = initial(melee_damage_lower)
				melee_damage_upper = initial(melee_damage_upper)
				attack_verb_continuous = initial(attack_verb_continuous)
			if(40 to 30) //Damage decrease, but not speed
				speed = initial(speed)
				melee_damage_lower = 10
				melee_damage_upper = 10
				attack_verb_continuous = "lightly slashes"
			if(30 to 20) //Speed decrease
				speed = 2
				melee_damage_lower = 8
				melee_damage_upper = 8
				attack_verb_continuous = "lightly slashes"
			if(20 to 10) //Massive speed decrease and weak melee attacks
				speed = 3
				melee_damage_lower = 6
				melee_damage_upper = 6
				attack_verb_continuous = "weakly slashes"
			if(10 to 0) //We are super weak and going to die
				speed = 4
				melee_damage_lower = 4
				melee_damage_upper = 4
				attack_verb_continuous = "taps"

//ATTACKING, BLOCKING, and COUNTERING

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/AttackingTarget()
	if(is_in_host())
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/bullet_act(obj/item/projectile/Proj)
	if(blockOrCounter(null, Proj))
		return
	return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/hitby(atom/movable/AM, skipcatch, hitpush, blocked, atom/movable/AM, datum/thrownthing/throwingdatum)
	if(blockOrCounter(null, AM))
		return
	return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/attack_animal(mob/living/simple_animal/M)
	if(istype(M, /mob/living/simple_animal/hostile/clockwork/marauder/guardian) || !blockOrCounter(M, M)) //we don't want infinite blockcounter loops if fighting another guardian
		return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/attack_paw(mob/living/carbon/monkey/M)
	if(!blockOrCounter(M, M))
		return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/attack_alien(mob/living/carbon/alien/humanoid/M)
	if(!blockOrCounter(M, M))
		return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/attack_slime(mob/living/simple_animal/slime/M)
	if(!blockOrCounter(M, M))
		return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/attack_hand(mob/living/carbon/human/M)
	if(!blockOrCounter(M, M))
		return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/nullrod) || !blockOrCounter(user, I))
		return ..()

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/blockOrCounter(mob/target, atom/textobject)
	if(GLOB.ratvar_awakens) //if ratvar has woken, we block nearly everything at a very high chance
		blockchance = 90
		counterchance = 90
	if(prob(blockchance))
		. = TRUE
		if(target)
			target.do_attack_animation(src)
			target.DelayNextAction(CLICK_CD_MELEE)
		blockchance = initial(blockchance)
		playsound(src, 'sound/magic/clockwork/fellowship_armory.ogg', 30, 1, 0, 1) //clang
		visible_message("<span class='boldannounce'>[src] blocks [target && isitem(textobject) ? "[target]'s [textobject.name]":"\the [textobject]"]!</span>", \
		"<span class='userdanger'>You block [target && isitem(textobject) ? "[target]'s [textobject.name]":"\the [textobject]"]!</span>")
		if(target && Adjacent(target))
			if(prob(counterchance))
				counterchance = initial(counterchance)
				var/previousattack_verb_continuous = attack_verb_continuous
				attack_verb_continuous = "counters"
				UnarmedAttack(target)
				attack_verb_continuous = previousattack_verb_continuous
			else
				counterchance = min(counterchance + initial(counterchance), 100)
	else
		blockchance = min(blockchance + initial(blockchance), 100)
	if(GLOB.ratvar_awakens)
		blockchance = 90
		counterchance = 90

//COMMUNICATION and EMERGENCE
/*
/mob/living/simple_animal/hostile/clockwork/marauder/guardian/handle_inherent_channels(message, message_mode)
	if(host && (is_in_host() || message_mode == MODE_BINARY))
		guardian_comms(message)
		return TRUE
	return ..()
*/
/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/guardian_comms(message)
	var/name_part = "<span class='sevtug'>[src] ([true_name])</span>"
	message = "<span class='sevtug_small'>\"[message]\"</span>" //Processed output
	to_chat(src, "[name_part]<span class='sevtug_small'>:</span> [message]")
	to_chat(host, "[name_part]<span class='sevtug_small'>:</span> [message]")
	for(var/M in GLOB.mob_list)
		if(isobserver(M))
			var/link = FOLLOW_LINK(M, src)
			to_chat(M, "[link] [name_part] <span class='sevtug_small'>(to</span> <span class='sevtug'>[findtextEx(host.name, host.real_name) ? "[host.name]" : "[host.real_name] (as [host.name])"]</span><span class='sevtug_small'>):</span> [message] ")
	return TRUE

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/return_to_host()
	if(is_in_host())
		return FALSE
	if(!host)
		to_chat(src, "<span class='warning'>You don't have a host!</span>")
		return FALSE
	var/resulthealth = round((host.health / host.maxHealth) * 100, 0.5)
	if(iscarbon(host))
		resulthealth = round((abs(HEALTH_THRESHOLD_DEAD - host.health) / abs(HEALTH_THRESHOLD_DEAD - host.maxHealth)) * 100)
	host.visible_message("<span class='warning'>[host]'s skin flashes crimson!</span>", "<span class='sevtug'>You feel [true_name]'s consciousness settle in your mind.</span>")
	visible_message("<span class='warning'>[src] suddenly disappears!</span>", "<span class='sevtug'>You return to [host].</span>")
	forceMove(host)
	if(resulthealth > GUARDIAN_EMERGE_THRESHOLD && health != maxHealth)
		recovering = TRUE
		to_chat(src, "<span class='userdanger'>You have weakened and will need to recover before manifesting again!</span>")
		to_chat(host, "<span class='sevtug'>[true_name] has weakened and will need to recover before manifesting again!</span>")
	return TRUE

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/try_emerge()
	if(!host)
		to_chat(src, "<span class='warning'>You don't have a host!</span>")
		return FALSE
	if(!GLOB.ratvar_awakens)
		var/resulthealth = round((host.health / host.maxHealth) * 100, 0.5)
		if(iscarbon(host))
			resulthealth = round((abs(HEALTH_THRESHOLD_DEAD - host.health) / abs(HEALTH_THRESHOLD_DEAD - host.maxHealth)) * 100)
		if(host.stat != DEAD && resulthealth > GUARDIAN_EMERGE_THRESHOLD) //if above 20 health, fails
			to_chat(src, "<span class='warning'>Your host must be at [GUARDIAN_EMERGE_THRESHOLD]% or less health to emerge like this!</span>")
			return FALSE
	return emerge_from_host(FALSE)

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/emerge_from_host(hostchosen, force) //Notice that this is a proc rather than a verb - guardians can NOT exit at will, but they CAN return
	if(!is_in_host())
		return FALSE
	if(!force && recovering)
		if(hostchosen)
			to_chat(host, "<span class='sevtug'>[true_name] is too weak to come forth!</span>")
		else
			to_chat(host, "<span class='sevtug'>[true_name] tries to emerge to protect you, but it's too weak!</span>")
		to_chat(src, "<span class='userdanger'>You try to come forth, but you're too weak!</span>")
		return FALSE
	if(!force)
		if(hostchosen) //guardian approved
			to_chat(host, "<span class='sevtug'>Your words echo with power as [true_name] emerges from your body!</span>")
		else
			to_chat(host, "<span class='sevtug'>[true_name] emerges from your body to protect you!</span>")
	forceMove(host.loc)
	visible_message("<span class='warning'>[host]'s skin glows red as [name] emerges from their body!</span>", "<span class='sevtug_small'>You exit the safety of [host]'s body!</span>")
	return TRUE

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/get_alt_name()
	return " ([text2ratvar(true_name)])"

/mob/living/simple_animal/hostile/clockwork/marauder/guardian/proc/is_in_host() //Checks if the guardian is inside of their host
	return host && loc == host

//HOST ACTIONS

//Summon guardian action: Calls forth or recalls your guardian
/datum/action/innate/summon_guardian
	name = "Force Guardian to Emerge/Recall"
	desc = "Allows you to force your clockwork guardian to emerge or recall as required."
	button_icon_state = "clockwork_marauder"
	background_icon_state = "bg_clock"
	check_flags = AB_CHECK_CONSCIOUS
	buttontooltipstyle = "clockcult"
	var/mob/living/simple_animal/hostile/clockwork/marauder/guardian/linked_guardian
	var/list/defend_phrases = list("Defend me", "Come forth", "Assist me", "Protect me", "Give aid", "Help me")
	var/list/return_phrases = list("Return", "Return to me", "Your job is done", "You have served", "Come back", "Retreat")

/datum/action/innate/summon_guardian/IsAvailable()
	if(!linked_guardian)
		return FALSE
	if(isliving(owner))
		var/mob/living/L = owner
		if(!L.can_speak_vocal() || L.stat)
			return FALSE
	return ..()

/datum/action/innate/summon_guardian/Activate()
	if(linked_guardian.is_in_host())
		clockwork_say(owner, text2ratvar("[pick(defend_phrases)], [linked_guardian.true_name]!"))
		linked_guardian.emerge_from_host(TRUE)
	else
		clockwork_say(owner, text2ratvar("[pick(return_phrases)], [linked_guardian.true_name]!"))
		linked_guardian.return_to_host()
	return TRUE

//Linked Minds action: talks to your guardian
/datum/action/innate/linked_minds
	name = "Linked Minds"
	desc = "Allows you to silently communicate with your guardian."
	button_icon_state = "linked_minds"
	background_icon_state = "bg_clock"
	check_flags = AB_CHECK_CONSCIOUS
	buttontooltipstyle = "clockcult"
	var/mob/living/simple_animal/hostile/clockwork/marauder/guardian/linked_guardian

/datum/action/innate/linked_minds/IsAvailable()
	if(!linked_guardian)
		return FALSE
	return ..()

/datum/action/innate/linked_minds/Activate()
	var/message = stripped_input(owner, "Enter a message to tell your guardian.", "Telepathy")
	if(!owner || !message)
		return FALSE
	if(!linked_guardian)
		to_chat(owner, "<span class='warning'>Your guardian seems to have been destroyed!</span>")
		return FALSE
	var/name_part = "<span class='sevtug'>Servant [findtextEx(owner.name, owner.real_name) ? "[owner.name]" : "[owner.real_name] (as [owner.name])"]</span>"
	message = "<span class='sevtug_small'>\"[message]\"</span>" //Processed output
	to_chat(owner, "[name_part]<span class='sevtug_small'>:</span> [message]")
	to_chat(linked_guardian, "[name_part]<span class='sevtug_small'>:</span> [message]")
	for(var/M in GLOB.mob_list)
		if(isobserver(M))
			var/link = FOLLOW_LINK(M, src)
			to_chat(M, "[link] [name_part] <span class='sevtug_small'>(to</span> <span class='sevtug'>[linked_guardian] ([linked_guardian.true_name])</span><span class='sevtug_small'>):</span> [message]")
	return TRUE
