//Mob vars
/mob/living
	var/arousalloss = 0			//How aroused the mob is.
	var/min_arousal = 0			//The lowest this mobs arousal will get. default = 0
	var/max_arousal = 100		//The highest this mobs arousal will get. default = 100
	var/arousal_rate = 1		//The base rate that arousal will increase in this mob.
	var/arousal_loss_rate = 1	//How easily arousal can be relieved for this mob.
	var/canbearoused = FALSE	//Mob-level disabler for arousal. Starts off and can be enabled as features are added for different mob types.
	var/mb_cd_length = 100		//5 second cooldown for masturbating because fuck spam.
	var/mb_cd_timer = 0			//The timer itself

/mob/living/carbon/human
	canbearoused = TRUE

	var/saved_underwear = ""//saves their underwear so it can be toggled later
	var/saved_undershirt = ""

/mob/living/carbon/human/New()
	..()
	saved_underwear = underwear
	saved_undershirt = undershirt

//Species vars
/datum/species
	var/arousal_gain_rate = 1 //Rate at which this species becomes aroused
	var/arousal_lose_rate = 1 //Multiplier for how easily arousal can be relieved
	var/list/cum_fluids = list("semen")
	var/list/milk_fluids = list("milk")
	var/list/femcum_fluids = list("femcum")

//Mob procs
/mob/living/proc/handle_arousal()


/mob/living/carbon/handle_arousal()
	if(canbearoused && dna)
		var/datum/species/S
		S = dna.species
		if(S && SSmobs.times_fired%36==2 && getArousalLoss() < max_arousal)//Totally stolen from breathing code. Do this every 36 ticks.
			adjustArousalLoss(arousal_rate * S.arousal_gain_rate)
			if(dna.features["exhibitionist"])
				var/amt_nude = 0
				if(is_chest_exposed() && (gender == FEMALE || getorganslot("breasts")))
					amt_nude++
				if(is_groin_exposed())
					if(getorganslot("penis"))
						amt_nude++
					if(getorganslot("vagina"))
						amt_nude++
				var/mob/living/M
				var/watchers = 0
				for(M in view(world.view, src))
					if(M.client && !M.stat && !M.eye_blind && (locate(src) in viewers(world.view,M)))
						watchers++
				if(watchers && amt_nude)
					adjustArousalLoss((amt_nude * watchers) + S.arousal_gain_rate)


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
	if(!isnum(percentage) || percentage > 100 || percentage < 0)
		CRASH("Provided percentage is invalid")
	if(getPercentAroused() >= percentage)
		return TRUE
	return FALSE

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
		hud_used.arousal.icon_state = ""
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
	icon = 'code/citadel/icons/hud.dmi'
	screen_loc = ui_arousal

/obj/screen/arousal/Click()
	if(!isliving(usr))
		return 0
	var/mob/living/M = usr
	if(M.canbearoused)
		M.mob_climax()
		return 1
	else
		to_chat(M, "<span class='warning'>Arousal is disabled. Feature is unavailable.</span>")



/mob/living/proc/mob_climax()//This is just so I can test this shit without being forced to add actual content to get rid of arousal. Will be a very basic proc for a while.
	set name = "Masturbate"
	set category = "IC"
	if(canbearoused && !restrained() && !stat)
		if(mb_cd_timer <= world.time)
			//start the cooldown even if it fails
			mb_cd_timer = world.time + mb_cd_length
			if(getArousalLoss() >= ((max_arousal / 100) * 33))//33% arousal or greater required
				src.visible_message("<span class='danger'>[src] starts masturbating!</span>", \
								"<span class='userdanger'>You start masturbating.</span>")
				if(do_after(src, 30, target = src))
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
				to_chat(src, "<span class='notice'>You aren't aroused enough for that.</span>")

/mob/living/carbon/human/mob_climax(forced_climax=FALSE) //Forced is instead of the other proc, makes you cum if you have the tools for it, ignoring restraints
	if(mb_cd_timer > world.time)
		if(!forced_climax) //Don't spam the message to the victim if forced to come too fast
			to_chat(src, "<span class='warning'>You need to wait [round((mb_cd_timer - world.time)/(20))] seconds before you can do that again!</span>")
		return
	mb_cd_timer = (world.time + mb_cd_length)
	var/list/genitals_list = list()
	var/obj/item/organ/genital/SG = null//originally selected_genital
	var/list/containers_list = list()
	var/obj/item/weapon/reagent_containers/SC = null
	var/datum/reagents/fluid_source = null
	var/into_container = 0
	var/free_hands = get_num_arms() //arms was only used to know if we had ANY at all
	var/total_cum = 0
	var/finished = 0
	var/mb_time = 30
	if(canbearoused && has_dna())
		if(stat==2)
			to_chat(src, "<span class='warning'>You can't do that while dead!</span>")
			return
		if(forced_climax) //Something forced us to cum, this is not a masturbation thing and does not progress to the other checks
			for(var/obj/item/organ/genital/G in internal_organs)
				if(G.can_masturbate_with) //All capable genitals will orgasm with this
					var/unable_to_come = FALSE
					switch(G.type)
						if(/obj/item/organ/genital/penis)
							var/obj/item/organ/genital/penis/P = G
							if(!P.linked_balls)
								unable_to_come = TRUE
							else
								fluid_source = P.linked_balls.reagents


						if(/obj/item/organ/genital/vagina)
							var/obj/item/organ/genital/vagina/V = G
							if(!V.linked_womb)
								unable_to_come = TRUE
							else
								fluid_source = V.linked_womb.reagents
						else //Weird, undefined genitalia behaviour
							unable_to_come = TRUE

					if(unable_to_come)
						src.visible_message("<span class='danger'>[src] shudders, their [G.name] unable to cum.</span>", \
						"<span class='userdanger'>Your [G.name] cannot cum, giving no relief.</span>", \
						"<span class='userdanger'>Your [G.name] cannot cum, giving no relief.</span>")
					else
						if(fluid_source)
							total_cum = fluid_source.total_volume
							src.visible_message("<span class='danger'>[src] looks like they're about to cum.</span>", \
							"<span class='green'>You feel yourself about to orgasm.</span>", \
							"<span class='green'>You feel yourself about to orgasm.</span>")
							if(do_after(src, mb_time, target = src))
								if(total_cum > 5)
									fluid_source.reaction(src.loc, TOUCH, 1, 0)
								fluid_source.clear_reagents()
								fluid_source = null //cleanup so this can be used for the next genitalia

								src.visible_message("<span class='danger'>[src] orgasms, cumming[istype(src.loc, /turf/open/floor) ? " onto [src.loc]" : ""]!</span>", \
								"<span class='green'>You're forced to cum[istype(src.loc, /turf/open/floor) ? " onto [src.loc]" : ""] with your [G].</span>", \
								"<span class='green'>Your [G] have been forced to climax.</span>")
								finished = 1
			if(finished)
				setArousalLoss(min_arousal)
			return //Do not proceed to masturbating if all genitals have been forced to orgasm.
		if(stat==1) //Sleeping people can be forced chemically or with electrical stimulants, for example.
			to_chat(src, "<span class='warning'>You must be conscious to do that!</span>")
			return
		if(restrained())
			to_chat(src, "<span class='warning'>You can't do that while restrained!</span>")
			return
		if(getArousalLoss() < 33)//flat number instead of percentage
			to_chat(src, "<span class='warning'>You aren't aroused enough for that!</span>")
			return
		if(!is_groin_exposed())
			to_chat(src, "<span class='warning'>You need to undress, first!</span>")
			return
		if(!free_hands)
			to_chat(src, "<span class='warning'>You need at least one free arm.</span>")
			return
		for(var/helditem in held_items)//how many hands are free
			if(isobj(helditem))
				free_hands--
		if(free_hands <= 0)
			to_chat(src, "<span class='warning'>You need at least one free hand.</span>")
			return
		for(var/obj/item/organ/genital/G in internal_organs)
			if(G.can_masturbate_with)//filter out what you can't masturbate with
				genitals_list += G
		if(genitals_list.len)
			SG = input(src, "with what?", "Masturbate")  as null|obj in genitals_list
			if(SG)
				for(var/obj/item/weapon/reagent_containers/container in held_items)
					if(container.is_open_container() || istype(container, /obj/item/weapon/reagent_containers/food/snacks/pie))
						containers_list += container
				if(containers_list.len)
					SC = input(src, "Into or onto what?(Cancel for nowhere)", "Masturbate")  as null|obj in containers_list
					if(SC)
						if(in_range(src, SC))
							into_container = 1
				SG.update()
				switch(SG.type)

					//Penis
					if(/obj/item/organ/genital/penis)
						var/obj/item/organ/genital/penis/P = SG
						if(!P.linked_balls)
							to_chat(src, "<span class='warning'>You need a pair of testicles to do this.</span>")
							return
						fluid_source = P.linked_balls.reagents
						total_cum = fluid_source.total_volume
						if(into_container)//into a glass or beaker or whatever
							src.visible_message("<span class='danger'>[src] starts [pick("jerking off","stroking")] their [SG.name] over [SC].</span>", \
								"<span class='userdanger'>You start jerking off over [SC.name].</span>", \
								"<span class='userdanger'>You start masturbating.</span>")
							if(do_after(src, mb_time, target = src) && in_range(src, SC))
								fluid_source.trans_to(SC, total_cum)
								src.visible_message("<span class='danger'>[src] orgasms, [pick("cumming into", "emptying themself into")] [SC]!</span>", \
									"<span class='green'>You cum into [SC].</span>", \
									"<span class='green'>You have relieved yourself.</span>")
								finished = 1
						else //Not in a container
							if(src.pulling)
								if(iscarbon(src.pulling))
									var/mob/living/carbon/C = src.pulling
									if(!C.is_groin_exposed())
										to_chat(src, "<span class='warning'>You must undress someone to climax inside them.</span>")
										return
								if(isliving(src.pulling)) //Gotta be alive to fuck it, don't wanna have to code fucking objects that ain't containers...
									var/mob/living/partner = src.pulling
									src.visible_message("[src] is about to climax inside [partner]!", \
									"You're about to climax inside [partner]!", \
									"<span class='danger'>You're preparing to climax inside someone!</span>")
									switch(grab_state)
										if(GRAB_PASSIVE)
											if(do_after(src, mb_time, target = src) && in_range(src, partner))
												var/spillage = 0.5 //Leaks a bit on passive grab
												var/did_spill = FALSE
												fluid_source.trans_to(partner, total_cum*(1-spillage))
												total_cum = total_cum*spillage
												if(total_cum > 5)
													fluid_source.reaction(partner.loc, TOUCH, 1, 0)
													did_spill = TRUE
												fluid_source.clear_reagents()

												src.visible_message("<span class='danger'>[src] ejaculates inside [partner][did_spill ? ", overflowing and spilling":""]!</span>", \
												"<span class='green'>You ejaculate inside [partner][did_spill ? ", spilling out of them":""].</span>", \
												"<span class='green'>You have climaxed inside someone[did_spill ? ", spilling out of them":""].</span>")
												finished = 1
										else //Aggressive or higher
											if(do_after(src, mb_time, target = src) && in_range(src, partner))
												var/spillage = 0.0 //Leakproofing seals
												fluid_source.trans_to(partner, total_cum*(1-spillage))
												total_cum = total_cum*spillage
												if(total_cum > 5)
													fluid_source.reaction(partner.loc, TOUCH, 1, 0)
												fluid_source.clear_reagents()

												src.visible_message("<span class='danger'>[src] ejaculates inside [partner], spilling nothing!</span>", \
												"<span class='green'>You ejaculate inside [partner], spilling nothing.</span>", \
												"<span class='green'>You have climaxed inside someone, spilling nothing.</span>")
												finished = 1
								//Don't care, not coding you fucking a unanchored girder
							else //No pulling, or pulling non-living things
								src.visible_message("<span class='danger'>[src] starts [pick("jerking off","stroking")] their [SG].</span>", \
								"<span class='green'>You start masturbating.</span>", \
								"<span class='green'>You start masturbating.</span>")
								if(do_after(src, mb_time, target = src))
									if(total_cum > 5)
										fluid_source.reaction(src.loc, TOUCH, 1, 0)
									fluid_source.clear_reagents()

									src.visible_message("<span class='danger'>[src] orgasms, cumming[istype(src.loc, /turf/open/floor) ? " onto [src.loc]" : ""]!</span>", \
									"<span class='green'>You cum[istype(src.loc, /turf/open/floor) ? " onto [src.loc]" : ""].</span>", \
									"<span class='green'>You have relieved yourself.</span>")
									finished = 1

					if(/obj/item/organ/genital/vagina)
						var/obj/item/organ/genital/vagina/V = SG
						if(!V.linked_womb)
							to_chat(src, "<span class='warning'>You need a womb to do this.</span>")
							return
						fluid_source = V.linked_womb.reagents
						total_cum = fluid_source.total_volume
						if(into_container)//into a glass or beaker or whatever
							src.visible_message("<span class='danger'>[src] starts fingering their [SG.name] over [SC].</span>", \
								"<span class='userdanger'>You start fingering over [SC.name].</span>", \
								"<span class='userdanger'>You start masturbating.</span>")
							if(do_after(src, mb_time, target = src) && in_range(src, SC))
								fluid_source.trans_to(SC, total_cum)
								src.visible_message("<span class='danger'>[src] orgasms, [pick("cumming into", "emptying themself into")] [SC]!</span>", \
									"<span class='green'>You cum into [SC].</span>", \
									"<span class='green'>You have relieved yourself.</span>")
								finished = 1

						else//not into a container
							src.visible_message("<span class='danger'>[src] starts fingering their vagina.</span>", \
								"<span class='userdanger'>You start fingering your vagina.</span>", \
										"<span class='userdanger'>You start masturbating.</span>")
							if(do_after(src, mb_time, target = src))
								if(total_cum > 5)
									fluid_source.reaction(src.loc, TOUCH, 1, 0)
								fluid_source.clear_reagents()
								src.visible_message("<span class='danger'>[src] orgasms, cumming[istype(src.loc, /turf/open/floor) ? " onto [src.loc]" : ""]!</span>", \
									"<span class='green'>You cum[istype(src.loc, /turf/open/floor) ? " onto [src.loc]" : ""].</span>", \
									"<span class='green'>You have relieved yourself.</span>")
								finished = 1

					else//backup message, just in case
						src.visible_message("<span class='danger'>[src] starts masturbating!</span>", \
								"<span class='userdanger'>You start masturbating.</span>")
						if(do_after(src, mb_time, target = src))
							src.visible_message("<span class='danger'>[src] [pick("relieves themself!", "shudders and moans in orgasm!")]</span>", \
								"<span class='userdanger'>You have relieved yourself.</span>")
							finished = 1
				if(finished)
					setArousalLoss(min_arousal)

		else
			to_chat(src, "<span class='warning'>You have no genitals!</span>")
			return
