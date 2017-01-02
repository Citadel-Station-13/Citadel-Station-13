/mob/living/carbon/alien/humanoid
	name = "alien"
	icon_state = "alien_s"
	pass_flags = PASSTABLE
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno = 5, /obj/item/stack/sheet/animalhide/xeno = 1)
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/caste = ""
	var/alt_icon = 'icons/mob/alienleap.dmi' //used to switch between the two alien icon files.
	var/leap_on_click = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 30
	var/custom_pixel_x_offset = 0 //for admin fuckery.
	var/custom_pixel_y_offset = 0
	var/sneaking = 0 //For sneaky-sneaky mode and appropriate slowdown

//This is fine right now, if we're adding organ specific damage this needs to be updated
/mob/living/carbon/alien/humanoid/New()
	AddAbility(new/obj/effect/proc_holder/alien/regurgitate(null))
	..()


/mob/living/carbon/alien/humanoid/movement_delay()
	. = ..()
	. += move_delay_add + config.alien_delay + sneaking	//move_delay_add is used to slow aliens with stuns

/mob/living/carbon/alien/humanoid/emp_act(severity)
	if(r_store) r_store.emp_act(severity)
	if(l_store) l_store.emp_act(severity)
	..()

/mob/living/carbon/alien/humanoid/attack_hulk(mob/living/carbon/human/user)
	if(user.a_intent == "harm")
		..(user, 1)
		adjustBruteLoss(15)
		var/hitverb = "punched"
		if(mob_size < MOB_SIZE_LARGE)
			Paralyse(1)
			step_away(src,user,15)
			sleep(1)
			step_away(src,user,15)
			hitverb = "slammed"
		playsound(loc, "punch", 25, 1, -1)
		visible_message("<span class='danger'>[user] has [hitverb] [src]!</span>", \
		"<span class='userdanger'>[user] has [hitverb] [src]!</span>")
		return 1

/mob/living/carbon/alien/humanoid/attack_hand(mob/living/carbon/human/M)
	if(..())
		switch(M.a_intent)
			if ("harm")
				var/damage = rand(1, 9)
				if (prob(90))
					playsound(loc, "punch", 25, 1, -1)
					visible_message("<span class='danger'>[M] has punched [src]!</span>", \
							"<span class='userdanger'>[M] has punched [src]!</span>")
					if ((stat != DEAD) && (damage > 9 || prob(5)))//Regular humans have a very small chance of weakening an alien.
						Paralyse(2)
						visible_message("<span class='danger'>[M] has weakened [src]!</span>", \
								"<span class='userdanger'>[M] has weakened [src]!</span>")
					adjustBruteLoss(damage)
					add_logs(M, src, "attacked")
					updatehealth()
				else
					playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
					visible_message("<span class='danger'>[M] has attempted to punch [src]!</span>")

			if ("disarm")
				if (!lying)
					if (prob(5))
						Paralyse(2)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						add_logs(M, src, "pushed")
						visible_message("<span class='danger'>[M] has pushed down [src]!</span>", \
							"<span class='userdanger'>[M] has pushed down [src]!</span>")
					else
						if (prob(50))
							drop_item()
							playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
							visible_message("<span class='danger'>[M] has disarmed [src]!</span>", \
							"<span class='userdanger'>[M] has disarmed [src]!</span>")
						else
							playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
							visible_message("<span class='danger'>[M] has attempted to disarm [src]!</span>")

/mob/living/carbon/alien/humanoid/restrained(ignore_grab)
	. = handcuffed


/mob/living/carbon/alien/humanoid/show_inv(mob/user)
	user.set_machine(src)
	var/dat = {"
	<HR>
	<B><FONT size=3>[name]</FONT></B>
	<HR>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=[slot_l_hand]'>		[l_hand		? l_hand	: "Nothing"]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=[slot_r_hand]'>		[r_hand		? r_hand	: "Nothing"]</A>
	<BR><A href='?src=\ref[src];pouches=1'>Empty Pouches</A>"}

	if(handcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_handcuffed]'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_legcuffed]'>Legcuffed</A>"

	dat += {"
	<BR>
	<BR><A href='?src=\ref[user];mach_close=mob\ref[src]'>Close</A>
	"}
	user << browse(dat, "window=mob\ref[src];size=325x500")
	onclose(user, "mob\ref[src]")


/mob/living/carbon/alien/humanoid/Topic(href, href_list)
	..()
	//strip panel
	if(usr.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		if(href_list["pouches"])
			visible_message("<span class='danger'>[usr] tries to empty [src]'s pouches.</span>", \
							"<span class='userdanger'>[usr] tries to empty [src]'s pouches.</span>")
			if(do_mob(usr, src, POCKET_STRIP_DELAY * 0.5))
				unEquip(r_store)
				unEquip(l_store)

/mob/living/carbon/alien/humanoid/cuff_resist(obj/item/I)
	playsound(src, 'sound/voice/hiss5.ogg', 40, 1, 1)  //Alien roars when starting to break free
	..(I, cuff_break = INSTANT_CUFFBREAK)

/mob/living/carbon/alien/humanoid/resist_grab(moving_resist)
	if(pulledby.grab_state)
		visible_message("<span class='danger'>[src] has broken free of [pulledby]'s grip!</span>")
	pulledby.stop_pulling()
	. = 0

/mob/living/carbon/alien/humanoid/get_standard_pixel_y_offset(lying = 0)
	if(leaping)
		return -32
	else if(custom_pixel_y_offset)
		return custom_pixel_y_offset
	else
		return initial(pixel_y)

/mob/living/carbon/alien/humanoid/get_standard_pixel_x_offset(lying = 0)
	if(leaping)
		return -32
	else if(custom_pixel_x_offset)
		return custom_pixel_x_offset
	else
		return initial(pixel_x)

/mob/living/carbon/alien/humanoid/check_ear_prot()
	return 1

/mob/living/carbon/alien/humanoid/get_permeability_protection()
	return 0.8

/mob/living/carbon/alien/humanoid/alien_evolve(mob/living/carbon/alien/humanoid/new_xeno)
	drop_l_hand()
	drop_r_hand()
	for(var/atom/movable/A in stomach_contents)
		stomach_contents.Remove(A)
		new_xeno.stomach_contents.Add(A)
		A.loc = new_xeno
	..()

//For alien evolution/promotion procs. Checks for
proc/alien_type_present(var/alienpath)
	for(var/mob/living/carbon/alien/humanoid/A in living_mob_list)
		if(!istype(A, alienpath))
			continue
		if(!A.key || A.stat == DEAD) //Only living aliens with a ckey are valid.
			continue
		return 1
	return 0


/mob/living/carbon/alien/humanoid/check_breath(datum/gas_mixture/breath)
	if(breath && breath.total_moles() > 0 && !sneaking)
		playsound(get_turf(src), pick('sound/voice/lowHiss2.ogg', 'sound/voice/lowHiss3.ogg', 'sound/voice/lowHiss4.ogg'), 50, 0, -5)
	..()

/mob/living/carbon/alien/humanoid/grabbedby(mob/living/carbon/user, supress_message = 0)
	if(user == src && pulling && grab_state >= GRAB_AGGRESSIVE && !pulling.anchored && iscarbon(pulling))
		devour_mob(pulling, devour_time = 60)
	else
		..()