/mob/living/proc/run_armor_check(def_zone = null, attack_flag = "melee", absorb_text = null, soften_text = null, armour_penetration, penetrated_text)
	var/armor = getarmor(def_zone, attack_flag)

	//the if "armor" check is because this is used for everything on /living, including humans
	if(armor && armour_penetration)
		armor = max(0, armor - armour_penetration)
		if(penetrated_text)
			src << "<span class='userdanger'>[penetrated_text]</span>"
		else
			src << "<span class='userdanger'>Your armor was penetrated!</span>"
	else if(armor >= 100)
		if(absorb_text)
			src << "<span class='userdanger'>[absorb_text]</span>"
		else
			src << "<span class='userdanger'>Your armor absorbs the blow!</span>"
	else if(armor > 0)
		if(soften_text)
			src << "<span class='userdanger'>[soften_text]</span>"
		else
			src << "<span class='userdanger'>Your armor softens the blow!</span>"
	return armor


/mob/living/proc/getarmor(def_zone, type)
	return 0

/mob/living/proc/on_hit(obj/item/projectile/proj_type)
	return

/mob/living/bullet_act(obj/item/projectile/P, def_zone)
	var/armor = run_armor_check(def_zone, P.flag, "","",P.armour_penetration)
	if(!P.nodamage)
		apply_damage(P.damage, P.damage_type, def_zone, armor)
	return P.on_hit(src, armor, def_zone)

/proc/vol_by_throwforce_and_or_w_class(obj/item/I)
		if(!I)
				return 0
		if(I.throwforce && I.w_class)
				return Clamp((I.throwforce + I.w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
		else if(I.w_class)
				return Clamp(I.w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
		else
				return 0

/mob/living/hitby(atom/movable/AM, skipcatch, hitpush = 1, blocked = 0)
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		var/zone = ran_zone("chest", 65)//Hits a random part of the body, geared towards the chest
		var/dtype = BRUTE
		var/volume = vol_by_throwforce_and_or_w_class(I)
		if(istype(I,/obj/item/weapon)) //If the item is a weapon...
			var/obj/item/weapon/W = I
			dtype = W.damtype

			if (W.throwforce > 0) //If the weapon's throwforce is greater than zero...
				if (W.throwhitsound) //...and throwhitsound is defined...
					playsound(loc, W.throwhitsound, volume, 1, -1) //...play the weapon's throwhitsound.
				else if(W.hitsound) //Otherwise, if the weapon's hitsound is defined...
					playsound(loc, W.hitsound, volume, 1, -1) //...play the weapon's hitsound.
				else if(!W.throwhitsound) //Otherwise, if throwhitsound isn't defined...
					playsound(loc, 'sound/weapons/genhit.ogg',volume, 1, -1) //...play genhit.ogg.

		else if(!I.throwhitsound && I.throwforce > 0) //Otherwise, if the item doesn't have a throwhitsound and has a throwforce greater than zero...
			playsound(loc, 'sound/weapons/genhit.ogg', volume, 1, -1)//...play genhit.ogg
		if(!I.throwforce)// Otherwise, if the item's throwforce is 0...
			playsound(loc, 'sound/weapons/throwtap.ogg', 1, volume, -1)//...play throwtap.ogg.
		if(!blocked)
			visible_message("<span class='danger'>[src] has been hit by [I].</span>", \
							"<span class='userdanger'>[src] has been hit by [I].</span>")
			var/armor = run_armor_check(zone, "melee", "Your armor has protected your [parse_zone(zone)].", "Your armor has softened hit to your [parse_zone(zone)].",I.armour_penetration)
			apply_damage(I.throwforce, dtype, zone, armor, I)
			if(I.thrownby)
				add_logs(I.thrownby, src, "hit", I)
	else
		playsound(loc, 'sound/weapons/genhit.ogg', 50, 1, -1)
	..()

/mob/living/mech_melee_attack(obj/mecha/M)
	if(M.occupant.a_intent == "harm")
		M.do_attack_animation(src)
		if(M.damtype == "brute")
			step_away(src,M,15)
		switch(M.damtype)
			if("brute")
				Paralyse(1)
				take_overall_damage(rand(M.force/2, M.force))
				playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			if("fire")
				take_overall_damage(0, rand(M.force/2, M.force))
				playsound(src, 'sound/items/Welder.ogg', 50, 1)
			if("tox")
				M.mech_toxin_damage(src)
			else
				return
		updatehealth()
		visible_message("<span class='danger'>[M.name] has hit [src]!</span>", \
						"<span class='userdanger'>[M.name] has hit [src]!</span>")
		add_logs(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")
	else
		step_away(src,M)
		add_logs(M.occupant, src, "pushed", M)
		visible_message("<span class='warning'>[M] pushes [src] out of the way.</span>")


//Mobs on Fire
/mob/living/proc/IgniteMob()
	if(fire_stacks > 0 && !on_fire)
		on_fire = 1
		src.visible_message("<span class='warning'>[src] catches fire!</span>", \
						"<span class='userdanger'>You're set on fire!</span>")
		src.AddLuminosity(3)
		throw_alert("fire", /obj/screen/alert/fire)
		update_fire()
		return TRUE
	return FALSE

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		src.AddLuminosity(-3)
		clear_alert("fire")
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
	fire_stacks = Clamp(fire_stacks + add_fire_stacks, -20, 20)
	if(on_fire && fire_stacks <= 0)
		ExtinguishMob()

/mob/living/proc/handle_fire()
	if(fire_stacks < 0) //If we've doused ourselves in water to avoid fire, dry off slowly
		fire_stacks = min(0, fire_stacks + 1)//So we dry ourselves back to default, nonflammable.
	if(!on_fire)
		return 1
	if(fire_stacks > 0)
		adjust_fire_stacks(-0.1) //the fire is slowly consumed
	else
		ExtinguishMob()
		return
	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(!G.gases["o2"] || G.gases["o2"][MOLES] < 1)
		ExtinguishMob() //If there's no oxygen in the tile we're on, put out the fire
		return
	var/turf/location = get_turf(src)
	location.hotspot_expose(700, 50, 1)

/mob/living/fire_act()
	adjust_fire_stacks(3)
	IgniteMob()


//Share fire evenly between the two mobs
//Called in MobBump() and Crossed()
/mob/living/proc/spreadFire(mob/living/L)
	if(!istype(L))
		return
	var/L_old_on_fire = L.on_fire

	if(on_fire) //Only spread fire stacks if we're on fire
		fire_stacks /= 2
		L.fire_stacks += fire_stacks
		if(L.IgniteMob())
			log_game("[key_name(src)] bumped into [key_name(L)] and set them on fire")

	if(L_old_on_fire) //Only ignite us and gain their stacks if they were onfire before we bumped them
		L.fire_stacks /= 2
		fire_stacks += L.fire_stacks
		IgniteMob()

//Mobs on Fire end

/mob/living/proc/dominate_mind(mob/living/target, duration = 100, silent) //Allows one mob to assume control of another while imprisoning the old consciousness for a time
	if(!target)
		return 0
	if(target.mental_dominator)
		src << "<span class='warning'>[target] is already being controlled by someone else!</span>"
		return 0
	if(!target.mind)
		src << "<span class='warning'>[target] is mindless and would make you permanently catatonic!</span>"
		return 0
	if(!silent)
		src << "<span class='userdanger'>You pounce upon [target]'s mind and seize control of their body!</span>"
		target << "<span class='userdanger'>Your control over your body is wrenched away from you!</span>"
	target.mind_control_holder = new/mob/living/mind_control_holder(target)
	target.mind_control_holder.real_name = "imprisoned mind of [target.real_name]"
	target.mind.transfer_to(target.mind_control_holder)
	mind.transfer_to(target)
	target.mental_dominator = src
	spawn(duration)
		if(!src)
			if(!silent)
				target << "<span class='userdanger'>You try to return to your own body, but sense nothing! You're being forced out!</span>"
			target.ghostize(1)
			target.mind_control_holder.mind.transfer_to(target)
			if(!silent)
				target << "<span class='userdanger'>You take control of your own body again!</span>"
			return 0
		if(!silent)
			target << "<span class='userdanger'>You're forced out! You return to your own body.</span>"
		target.mind.transfer_to(src)
		target.mind_control_holder.mind.transfer_to(target)
		qdel(mind_control_holder)
		if(!silent)
			target << "<span class='userdanger'>You take control of your own body again!</span>"
		return 1

/mob/living/acid_act(acidpwr, toxpwr, acid_volume)
	take_organ_damage(min(10*toxpwr, acid_volume * toxpwr))

/mob/living/proc/grabbedby(mob/living/carbon/user, mob/living/target, supress_message = 0)

//	if(grab_state >= GRAB_AGGRESSIVE && !pulling.anchored && iscarbon(pulling) && user.zone_selected == "mouth")
//		src.vore_attack(src, devour_time = 100) //It would be better to define it on this level instead of human_defense.dm, but you'd probably need to do more work down the line. ex: xeno devour code
//		return

	if(anchored)
		return 0
	if(!user.pulling || user.pulling != src)
		user.start_pulling(src, supress_message)
		return

	if(!(status_flags & CANPUSH))
		user << "<span class='warning'>[src] can't be grabbed more aggressively!</span>"
		return 0
	grippedby(user)

//proc to upgrade a simple pull into a more aggressive grab.
/mob/living/proc/grippedby(mob/living/carbon/user)
	if(user.grab_state < GRAB_KILL)
		user.changeNext_move(CLICK_CD_GRABBING)
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

		if(user.grab_state) //only the first upgrade is instantaneous
			var/old_grab_state = user.grab_state
			var/grab_upgrade_time = 30
			visible_message("<span class='danger'>[user] starts to tighten \his grip on [src]!</span>", \
				"<span class='userdanger'>[user] starts to tighten \his grip on you!</span>")
			if(!do_mob(user, src, grab_upgrade_time))
				return 0
			if(!user.pulling || user.pulling != src || user.grab_state != old_grab_state || user.a_intent != "grab")
				return 0
		user.grab_state++
		switch(user.grab_state)
			if(GRAB_AGGRESSIVE)
				add_logs(user, src, "grabbed", addition="aggressively")
				visible_message("<span class='danger'>[user] has grabbed [src] aggressively!</span>", \
								"<span class='userdanger'>[user] has grabbed [src] aggressively!</span>")
				drop_r_hand()
				drop_l_hand()
				stop_pulling()
			if(GRAB_NECK)
				visible_message("<span class='danger'>[user] has grabbed [src] by the neck!</span>",\
								"<span class='userdanger'>[user] has grabbed you by the neck!</span>")
				update_canmove() //we fall down
				if(!buckled && !density)
					Move(user.loc)
			if(GRAB_KILL)
				visible_message("<span class='danger'>[user] is strangling [src]!</span>", \
								"<span class='userdanger'>[user] is strangling you!</span>")
				update_canmove() //we fall down
				if(!buckled && !density)
					Move(user.loc)
		return 1


/mob/living/attack_slime(mob/living/simple_animal/slime/M)
	if(!ticker || !ticker.mode)
		M << "You cannot attack people before the game has started."
		return

	if(M.buckled)
		if(M in buckled_mobs)
			M.Feedstop()
		return // can't attack while eating!

	if (stat != DEAD)
		add_logs(M, src, "attacked")
		M.do_attack_animation(src)
		visible_message("<span class='danger'>The [M.name] glomps [src]!</span>", \
				"<span class='userdanger'>The [M.name] glomps [src]!</span>")
		return 1

/mob/living/attack_animal(mob/living/simple_animal/M)
	M.face_atom(src)
	if(M.melee_damage_upper == 0)
		M.visible_message("<span class='notice'>\The [M] [M.friendly] [src]!</span>")
		return 0
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		M.do_attack_animation(src)
		visible_message("<span class='danger'>\The [M] [M.attacktext] [src]!</span>", \
						"<span class='userdanger'>\The [M] [M.attacktext] [src]!</span>")
		add_logs(M, src, "attacked")
		return 1


/mob/living/attack_paw(mob/living/carbon/monkey/M)
	if(!ticker || !ticker.mode)
		M << "You cannot attack people before the game has started."
		return 0

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return 0

	if (M.a_intent == "harm")
		if(M.is_muzzled() || (M.wear_mask && M.wear_mask.flags_cover & MASKCOVERSMOUTH))
			M << "<span class='warning'>You can't bite with your mouth covered!</span>"
			return 0
		M.do_attack_animation(src)
		if (prob(75))
			add_logs(M, src, "attacked")
			playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
			visible_message("<span class='danger'>[M.name] bites [src]!</span>", \
					"<span class='userdanger'>[M.name] bites [src]!</span>")
			return 1
		else
			visible_message("<span class='danger'>[M.name] has attempted to bite [src]!</span>", \
				"<span class='userdanger'>[M.name] has attempted to bite [src]!</span>")
	return 0

/mob/living/attack_larva(mob/living/carbon/alien/larva/L)

	switch(L.a_intent)
		if("help")
			visible_message("<span class='notice'>[L.name] rubs its head against [src].</span>")
			return 0

		else
			L.do_attack_animation(src)
			if(prob(90))
				add_logs(L, src, "attacked")
				visible_message("<span class='danger'>[L.name] bites [src]!</span>", \
						"<span class='userdanger'>[L.name] bites [src]!</span>")
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				return 1
			else
				visible_message("<span class='danger'>[L.name] has attempted to bite [src]!</span>", \
					"<span class='userdanger'>[L.name] has attempted to bite [src]!</span>")
	return 0

/mob/living/attack_alien(mob/living/carbon/alien/humanoid/M)
	if(!ticker || !ticker.mode)
		M << "You cannot attack people before the game has started."
		return 0

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return 0

	switch(M.a_intent)
		if ("help")
			visible_message("<span class='notice'>[M] caresses [src] with its scythe like arm.</span>")
			return 0

		if ("grab")
			grabbedby(M)
			return 0
		else
			M.do_attack_animation(src)
			return 1

/mob/living/incapacitated(ignore_restraints, ignore_grab)
	if(stat || paralysis || stunned || weakened || (!ignore_restraints && restrained(ignore_grab)))
		return 1

//Looking for irradiate()? It's been moved to radiation.dm under the rad_act() for mobs.

/mob/living/Stun(amount, updating = 1, ignore_canstun = 0)
	if(stun_absorption && !stat)
		visible_message("<span class='warning'>[src]'s yellow aura momentarily intensifies!</span>", "<span class='userdanger'>Your ward absorbs the stun!</span>")
		stun_absorption_count += amount
		return 0
	..()

/mob/living/Weaken(amount, updating = 1, ignore_canweaken = 0)
	if(stun_absorption && !stat)
		visible_message("<span class='warning'>[src]'s yellow aura momentarily intensifies!</span>", "<span class='userdanger'>Your ward absorbs the stun!</span>")
		stun_absorption_count += amount
		return 0
	..()
