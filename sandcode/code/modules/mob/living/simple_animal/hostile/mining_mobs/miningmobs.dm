/mob/living/simple_animal/hostile/asteroid
	var/glorykill = FALSE //CAN THIS MOTHERFUCKER BE SNAPPED IN HALF FOR HEALTH?
	var/list/glorymessageshand = list() //WHAT THE FUCK ARE THE MESSAGES SAID BY THIS FUCK WHEN HE'S GLORY KILLED WITH AN EMPTY HAND?
	var/list/glorymessagescrusher = list() //SAME AS ABOVE BUT CRUSHER
	var/list/glorymessagespka = list() //SAME AS ABOVE THE ABOVE BUT PKA
	var/list/glorymessagespkabayonet = list() //SAME AS ABOVE BUT WITH A HONKING KNIFE ON THE FUCKING THING
	var/gloryhealth = 7.5
	var/glorymodifier = 1.5

/mob/living/simple_animal/hostile/asteroid/Life()
	..()
	if(health <= (maxHealth/10 * glorymodifier) && !glorykill && stat != DEAD)
		glorykill = TRUE
		glory()
	else if(health > (maxHealth/10 * glorymodifier) && glorykill && stat != DEAD)
		glorykill = FALSE
		unglory()

/mob/living/simple_animal/hostile/asteroid/proc/glory()
	desc += "<br><b>[src] is staggered and can be glory killed!</b>"
	animate(src, color = "#00FFFF", time = 5)

/mob/living/simple_animal/hostile/asteroid/proc/unglory()
	desc = initial(desc)
	animate(src, color = initial(color), time = 5)

/mob/living/simple_animal/hostile/asteroid/death(gibbed)
	animate(src, color = initial(color), time = 3)
	desc = initial(desc)
	SSblackbox.record_feedback("tally", "mobs_killed_mining", 1, type)
	var/datum/status_effect/crusher_damage/C = has_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
	if(C && crusher_loot && prob((C.total_damage/maxHealth) * crusher_drop_mod)) //on average, you'll need to kill 4 creatures before getting the item
		spawn_crusher_loot()
	..(gibbed)

/mob/living/simple_animal/hostile/asteroid/AltClick(mob/living/carbon/slayer)
	if(!slayer.canUseTopic(src, TRUE))
		return
	if(glorykill)
		if(do_mob(slayer, src, 10) && (stat != DEAD))
			var/message
			if(!slayer.get_active_held_item() || (!istype(slayer.get_active_held_item(), /obj/item/kinetic_crusher) && !istype(slayer.get_active_held_item(), /obj/item/gun/energy/kinetic_accelerator)))
				message = pick(glorymessageshand)
			else if(istype(slayer.get_active_held_item(), /obj/item/kinetic_crusher))
				message = pick(glorymessagescrusher)
			else if(istype(slayer.get_active_held_item(), /obj/item/gun/energy/kinetic_accelerator))
				message = pick(glorymessagespka)
				var/obj/item/gun/energy/kinetic_accelerator/KA = get_active_held_item()
				if(KA && KA.bayonet)
					message = pick(glorymessagespka | glorymessagespkabayonet)
			if(message)
				visible_message("<span class='danger'><b>[slayer] [message]</b></span>")
			else
				visible_message("<span class='danger'><b>[slayer] does something generally considered brutal to [src]... Whatever that may be!</b></span>")
			slayer.heal_overall_damage(gloryhealth,gloryhealth)
			playsound(src.loc, death_sound, 150, TRUE, -1)
			crusher_drop_mod *= 2
			adjustHealth(maxHealth, TRUE, TRUE)
			if(mob_biotypes & MOB_ORGANIC)
				new /obj/effect/gibspawner/generic(src.loc)
			else if(mob_biotypes & MOB_ROBOTIC)
				new /obj/effect/gibspawner/robot(src.loc)
		else
			to_chat(slayer, "<span class='danger'>You fail to glory kill [src]!</span>")
