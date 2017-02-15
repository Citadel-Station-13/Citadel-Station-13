//Mob vars
/mob/living
	var/arousalloss = 0			//How aroused the mob is.
	var/min_arousal = 0			//The lowest this mobs arousal will get. default = 0
	var/max_arousal = 100		//The highest this mobs arousal will get. default = 100
	var/arousal_rate = 1		//The base rate that arousal will increase in this mob.
	var/arousal_loss_rate = 1	//How easily arousal can be relieved for this mob.
	var/canbearoused = FALSE	//Mob-level disabler for arousal. Starts off and can be enabled as features are added for different mob types.
	var/mb_cd_length = 100		//10 second cooldown for masturbating because fuck spam
	var/mb_cd_timer = 0			//The timer itself

/mob/living/carbon/human
	canbearoused = TRUE

//Species vars
/datum/species
	var/arousal_gain_rate = 1 //Rate at which this species becomes aroused
	var/arousal_lose_rate = 1 //Multiplier for how easily arousal can be relieved

//Mob procs
/mob/living/Life()
	if(stat != DEAD)
		handle_arousal()
	..()

/mob/living/proc/handle_arousal()
	return

/mob/living/carbon/handle_arousal()
	..()
	var/datum/species/S
	if(has_dna())
		S = dna.species
	if(S && SSmob.times_fired%36==2 && getArousalLoss() < 100)//Totally stolen from breathing code. Do this every 36 ticks.
		adjustArousalLoss(arousal_rate * S.arousal_gain_rate)

/mob/living/proc/getArousalLoss()
	return arousalloss

/mob/living/proc/adjustArousalLoss(amount, updating_arousal=1)
	if(status_flags & GODMODE || !canbearoused)
		return 0
	arousalloss = Clamp(arousalloss + amount, min_arousal, max_arousal)
	if(updating_arousal)
		updatearousal()

/mob/living/proc/setArousalLoss(amount, updating_arousal=1)
	if(status_flags & GODMODE || !canbearoused)
		return 0
	arousalloss = Clamp(amount, min_arousal, max_arousal)
	if(updating_arousal)
		updatearousal()

/mob/living/proc/getPercentAroused()
	return ((100 / max_arousal) * arousalloss)

/mob/living/proc/isPercentAroused(percentage)//returns true if the mob's arousal (measured in a percent of 100) is greater than the arg percentage.
	if(!isnum(percentage))
		return FALSE
	if(getPercentAroused() >= percentage)
		return TRUE

/mob/living/proc/mob_masturbate()//This is just so I can test this shit without being forced to add actual content to get rid of arousal. Will be a very basic proc for a while.
	set name = "Masturbate"
	set category = "IC"
	if(canbearoused && !restrained() && !stat)
		if(mb_cd_timer <= world.time)
			//start the cooldown even if it fails
			mb_cd_timer = world.time + mb_cd_length
			if(getArousalLoss() >= ((max_arousal / 100) * 33))//33% arousal or greater required
				src.visible_message("<span class='danger'>[src] starts masturbating!</span>", \
								"<span class='userdanger'>You start masturbating.</span>")
				if(do_after(src, 100, target = src))
					src.visible_message("<span class='danger'>[src] relieves themself!</span>", \
								"<span class='userdanger'>You have relieved yourself.</span>")
					setArousalLoss(min_arousal)
					/*
					switch(gender)
						if(MALE)
							PoolOrNew(/obj/effect/decal/cleanable/semen, loc)
						if(FEMALE)
							PoolOrNew(/obj/effect/decal/cleanable/femcum, loc)
					*/
			else
				src << "<span class='notice'>You aren't aroused enough for that.</span>"

//H U D//
/mob/living/proc/updatearousal()
	update_arousal_hud()

/mob/living/proc/update_arousal_hud()
	return 0

/datum/species/proc/update_arousal_hud(mob/living/carbon/human/H)
	return 0

/mob/living/carbon/human/update_arousal_hud()
	if(!client || !hud_used)
		return 0
	if(dna.species.update_arousal_hud())
		return 0
	if(!canbearoused)
		hud_used.arousal.icon_state = "arousal0"
		return 0
	else
		if(hud_used.arousal)
			if(stat == DEAD)
				hud_used.arousal.icon_state = "arousal0"
				return 1
			if(getArousalLoss() == max_arousal)
				hud_used.arousal.icon_state = "arousal100"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 90)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal90"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 80)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal80"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 70)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal70"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 60)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal60"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 50)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal50"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 40)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal40"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 30)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal30"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 20)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal10"
				return 1
			if(getArousalLoss() >= (max_arousal / 100) * 10)//M O D U L A R ,   W O W
				hud_used.arousal.icon_state = "arousal10"
				return 1
			else
				hud_used.arousal.icon_state = "arousal0"

/obj/screen/arousal
	name = "arousal"
	icon_state = "arousal0"
	screen_loc = ui_arousal

/obj/screen/arousal/Click()
	if(!isliving(usr))
		return 0
	var/mob/living/M = usr
	if(M.canbearoused)
		M.mob_masturbate()
		return 1
	else
		M << "<span class='warning'>Arousal is disabled. Feature is unavailable.</span>"

/mob/living/carbon/human/mob_masturbate()
	var/list/genitals_list = list()
	var/obj/item/organ/genital/SG//originally selected_genital
	var/obj/item/weapon/reagent_containers/RC
	if(canbearoused && mb_cd_timer <= world.time && has_dna())
		if(restrained())
			src << "<span class='warning'>You can't do that while restrained!</span>"
			return
		if(stat)
			src << "<span class='warning'>You must be conscious to do that!</span>"
			return
		if(if(getArousalLoss() < ((max_arousal / 100) * 33)))
			src << "<span class='warning'>You aren't aroused enough for that.</span>"
			return
		if(w_suit)
			if(GROIN in w_suit.body_parts_covered)
			src << "<span class='warning'>You need to undress, first.</span>"
			return
		if(w_uniform)
			if(GROIN in w_uniform.body_parts_covered)
			src << "<span class='warning'>You need to undress, first.</span>"
			return
		for(var/obj/item/organ/genital/G in internal_organs)
			genitals_list += G
		if(genitals_list.len)
			SG = input(user, "Masturbate with what?", "Masturbate")  as null|anything in genitals_list
			if(SG)
				switch(SG.type)
					if(/obj/item/organ/genital/penis)
						var/obj/item/organ/genital/penis/P = SG


					else
		else
			return
