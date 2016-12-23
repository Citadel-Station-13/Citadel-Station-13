/*
Ideas for the subtle effects of hallucination:

Light up oxygen/plasma indicators (done)
Cause health to look critical/dead, even when standing (done)
Characters silently watching you
Brief flashes of fire/space/bombs/c4/dangerous shit (done)
Items that are rare/traitorous/don't exist appearing in your inventory slots (done)
Strange audio (should be rare) (done)
Gunshots/explosions/opening doors/less rare audio (done)

*/

/mob/living/carbon
	var/image/halimage
	var/image/halbody
	var/obj/halitem
	var/hal_screwyhud = 0 //1 - critical, 2 - dead, 3 - oxygen indicator, 4 - toxin indicator, 5 - perfect health
	var/handling_hal = 0

/mob/living/carbon/proc/handle_hallucinations()
	if(handling_hal)
		return

	//Least obvious
	var/list/minor = list("sounds"=20,"bolts_minor"=10,"whispers"=15,"message"=5)
	//Something's wrong here
	var/list/medium = list("hudscrew"=15,"items"=15,"dangerflash"=15,"bolts"=10,"flood"=10,"husks"=10,"battle"=10)
	//AAAAH
	var/list/major = list("fake"=10,"death"=5,"xeno"=10,"singulo"=10,"delusion"=10)

	var/grade = 0
	var/current = list()
	var/trip_length = 0

	handling_hal = 1
	while(hallucination > 20)
		sleep(rand(200,500)/(hallucination/25))
		trip_length += 1
		if(prob(min(20,trip_length*2)))
			grade = min(3,grade+1)
		if(prob(20))
			continue
		current = list()
		for(var/a in minor)
			current[a] = minor[a] * (grade==0?2:1)
		for(var/b in medium)
			current[b] = medium[b] * (grade==1?2:1)
		for(var/c in major)
			current[c] = major[c] * (grade==2?2:1)

		var/halpick = pickweight(current)

		hallucinate(halpick)
	handling_hal = 0

/obj/effect/hallucination
	invisibility = INVISIBILITY_OBSERVER
	var/mob/living/carbon/target = null

/obj/effect/hallucination/proc/wake_and_restore()
	target.hal_screwyhud = 0
	target.SetSleeping(0)

/obj/effect/hallucination/simple
	var/image_icon = 'icons/mob/alien.dmi'
	var/image_state = "alienh_pounce"
	var/px = 0
	var/py = 0
	var/col_mod = null
	var/image/current_image = null
	var/image_layer = MOB_LAYER
	var/active = 1 //qdelery

/obj/effect/hallucination/simple/New(loc,var/mob/living/carbon/T)
	target = T
	current_image = GetImage()
	if(target.client) target.client.images |= current_image

/obj/effect/hallucination/simple/proc/GetImage()
	var/image/I = image(image_icon,loc,image_state,image_layer,dir=src.dir)
	I.pixel_x = px
	I.pixel_y = py
	if(col_mod)
		I.color = col_mod
	return I

/obj/effect/hallucination/simple/proc/Show(update=1)
	if(active)
		if(target.client) target.client.images.Remove(current_image)
		if(update)
			current_image = GetImage()
		if(target.client) target.client.images |= current_image

/obj/effect/hallucination/simple/update_icon(new_state,new_icon,new_px=0,new_py=0)
	image_state = new_state
	if(new_icon)
		image_icon = new_icon
	else
		image_icon = initial(image_icon)
	px = new_px
	py = new_py
	Show()

/obj/effect/hallucination/simple/Moved(atom/OldLoc, Dir)
	Show()

/obj/effect/hallucination/simple/Destroy()
	if(target.client) target.client.images.Remove(current_image)
	active = 0
	return ..()

#define FAKE_FLOOD_EXPAND_TIME 30
#define FAKE_FLOOD_MAX_RADIUS 7

/obj/effect/hallucination/fake_flood
	//Plasma/N2O starts flooding from the nearby vent
	var/list/flood_images = list()
	var/list/turf/flood_turfs = list()
	var/image_icon = 'icons/effects/tile_effects.dmi'
	var/image_state = "plasma"
	var/radius = 0
	var/next_expand = 0

/obj/effect/hallucination/fake_flood/New(loc,var/mob/living/carbon/T)
	..()
	target = T
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in orange(7,target))
		if(!U.welded)
			src.loc = U.loc
			break
	image_state = pick("plasma","nitrous_oxide")
	flood_images += image(image_icon,src,image_state,MOB_LAYER)
	flood_turfs += get_turf(src.loc)
	if(target.client) target.client.images |= flood_images
	next_expand = world.time + FAKE_FLOOD_EXPAND_TIME
	START_PROCESSING(SSobj, src)

/obj/effect/hallucination/fake_flood/process()
	if(next_expand <= world.time)
		radius++
		if(radius > FAKE_FLOOD_MAX_RADIUS)
			qdel(src)
			return
		Expand()
		next_expand = world.time + FAKE_FLOOD_EXPAND_TIME

/obj/effect/hallucination/fake_flood/proc/Expand()
	for(var/turf/T in circlerangeturfs(loc,radius))
		if((T in flood_turfs)|| T.blocks_air)
			continue
		flood_images += image(image_icon,T,image_state,MOB_LAYER)
		flood_turfs += T
	if(target.client)
		target.client.images |= flood_images

/obj/effect/hallucination/fake_flood/Destroy()
	STOP_PROCESSING(SSobj, src)
	qdel(flood_turfs)
	flood_turfs = list()
	if(target.client)
		target.client.images.Remove(flood_images)
	target = null
	qdel(flood_images)
	flood_images = list()
	return ..()

/obj/effect/hallucination/simple/xeno
	image_icon = 'icons/mob/alien.dmi'
	image_state = "alienh_pounce"

/obj/effect/hallucination/simple/xeno/New(loc,var/mob/living/carbon/T)
	..()
	name = "alien hunter ([rand(1, 1000)])"

/obj/effect/hallucination/simple/xeno/throw_impact(A)
	update_icon("alienh_pounce")
	if(A == target)
		target.Weaken(5)
		target.visible_message("<span class='danger'>[target] flails around wildly.</span>","<span class ='userdanger'>[name] pounces on you!</span>")

/obj/effect/hallucination/xeno_attack
	//Xeno crawls from nearby vent,jumps at you, and goes back in
	var/obj/machinery/atmospherics/components/unary/vent_pump/pump = null
	var/obj/effect/hallucination/simple/xeno/xeno = null

/obj/effect/hallucination/xeno_attack/New(loc,var/mob/living/carbon/T)
	target = T
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in orange(7,target))
		if(!U.welded)
			pump = U
			break
	if(pump)
		xeno = new(pump.loc,target)
		sleep(10)
		xeno.update_icon("alienh_leap",'icons/mob/alienleap.dmi',-32,-32)
		xeno.throw_at(target,7,1, spin = 0, diagonals_first = 1)
		sleep(10)
		xeno.update_icon("alienh_leap",'icons/mob/alienleap.dmi',-32,-32)
		xeno.throw_at(pump,7,1, spin = 0, diagonals_first = 1)
		sleep(10)
		var/xeno_name = xeno.name
		target << "<span class='notice'>[xeno_name] begins climbing into the ventilation system...</span>"
		sleep(10)
		qdel(xeno)
		target << "<span class='notice'>[xeno_name] scrambles into the ventilation ducts!</span>"
	qdel(src)

/obj/effect/hallucination/simple/clown
	image_icon = 'icons/mob/animal.dmi'
	image_state = "clown"

/obj/effect/hallucination/simple/clown/New(loc,var/mob/living/carbon/T,duration)
	..(loc, T)
	name = pick(clown_names)
	QDEL_IN(src,duration)

/obj/effect/hallucination/simple/clown/scary
	image_state = "scary_clown"

/obj/effect/hallucination/singularity_scare
	//Singularity moving towards you.
	//todo Hide where it moved with fake space images
	var/obj/effect/hallucination/simple/singularity/s = null

/obj/effect/hallucination/singularity_scare/New(loc,var/mob/living/carbon/T)
	target = T
	var/turf/start = T.loc
	var/screen_border = pick(SOUTH,EAST,WEST,NORTH)
	for(var/i = 0,i<11,i++)
		start = get_step(start,screen_border)
	s = new(start,target)
	for(var/i = 0,i<11,i++)
		sleep(5)
		s.loc = get_step(get_turf(s),get_dir(s,target))
		s.Show()
		s.Eat()
	qdel(s)

/obj/effect/hallucination/simple/singularity
	image_icon = 'icons/effects/224x224.dmi'
	image_state = "singularity_s7"
	image_layer = MASSIVE_OBJ_LAYER
	px = -96
	py = -96

/obj/effect/hallucination/simple/singularity/proc/Eat(atom/OldLoc, Dir)
	var/target_dist = get_dist(src,target)
	if(target_dist<=3) //"Eaten"
		target.hal_screwyhud = 1
		target.SetSleeping(20)
		addtimer(src, "wake_and_restore", rand(50, 100))

/obj/effect/hallucination/battle

/obj/effect/hallucination/battle/New(loc,var/mob/living/carbon/T)
	target = T
	var/hits = rand(3,6)
	switch(rand(1,5))
		if(1) //Laser fight
			for(var/i=0,i<hits,i++)
				target << sound('sound/weapons/Laser.ogg',0,1,0,25)
				sleep(rand(1,5))
			target << sound(get_sfx("bodyfall"),0,1,0,25)
		if(2) //Esword fight
			target << sound('sound/weapons/saberon.ogg',0,1,0,15)
			for(var/i=0,i<hits,i++)
				target << sound('sound/weapons/blade1.ogg',,0,1,0,25)
				sleep(rand(1,5))
			target << sound(get_sfx("bodyfall"),0,1,0,25)
			target << sound('sound/weapons/saberoff.ogg',0,1,0,15)
		if(3) //Gun fight
			for(var/i=0,i<hits,i++)
				target << sound(get_sfx("gunshot"),0,1,0,25)
				sleep(rand(1,5))
			target << sound(get_sfx("bodyfall"),0,1,0,25)
		if(4) //Stunprod + cablecuff
			target << sound('sound/weapons/Egloves.ogg',0,1,40)
			target << sound(get_sfx("bodyfall"),0,1,0,25)
			sleep(30)
			target << sound('sound/weapons/cablecuff.ogg',0,1,0,15)
		if(5) // Tick Tock
			for(var/i=0,i<hits,i++)
				target << sound('sound/items/timer.ogg',0,1,0,25)
				sleep(15)
	qdel(src)


/obj/effect/hallucination/delusion
	var/list/image/delusions = list()

/obj/effect/hallucination/delusion/New(loc,mob/living/carbon/T,force_kind = null , duration = 300,skip_nearby = 1, custom_icon = null, custom_icon_file = null)
	target = T
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("clown","corgi","carp","skeleton","demon")
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H == target)
			continue
		if(skip_nearby && (H in view(target)))
			continue
		switch(kind)
			if("clown")//Clown
				A = image('icons/mob/animal.dmi',H,"clown")
			if("carp")//Carp
				A = image('icons/mob/animal.dmi',H,"carp")
			if("corgi")//Corgi
				A = image('icons/mob/pets.dmi',H,"corgi")
			if("skeleton")//Skeletons
				A = image('icons/mob/human.dmi',H,"skeleton_s")
			if("demon")//Demon
				A = image('icons/mob/mob.dmi',H,"daemon")
			if("custom")
				A = image(custom_icon_file, H, custom_icon)
		A.override = 1
		if(target.client)
			delusions |= A
			target.client.images |= A
	QDEL_IN(src, duration)

/obj/effect/hallucination/delusion/Destroy()
	for(var/image/I in delusions)
		if(target.client)
			target.client.images.Remove(I)

/obj/effect/hallucination/fakeattacker/New(loc,var/mob/living/carbon/T)
	target = T
	var/mob/living/carbon/human/clone = null
	var/clone_weapon = null

	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.stat || H.lying)
			continue
		clone = H
		break

	if(!clone)
		return

	var/obj/effect/fake_attacker/F = new/obj/effect/fake_attacker(get_turf(target),target)
	for(var/obj/item/I in clone.held_items)
		if(!(locate(I) in non_fakeattack_weapons))
			clone_weapon = I.name
			F.weap = I

	F.name = clone.name
	F.my_target = target
	F.weapon_name = clone_weapon

	F.left = image(clone,dir = WEST)
	F.right = image(clone,dir = EAST)
	F.up = image(clone,dir = NORTH)
	F.down = image(clone,dir = SOUTH)

	F.updateimage()
	qdel(src)

/obj/effect/fake_attacker
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = 0
	anchored = 1
	opacity = 0
	var/mob/living/carbon/human/my_target = null
	var/weapon_name = null
	var/obj/item/weap = null
	var/image/stand_icon = null
	var/image/currentimage = null
	var/icon/base = null
	var/skin_tone
	var/mob/living/clone = null
	var/image/left
	var/image/right
	var/image/up
	var/collapse
	var/image/down

	obj_integrity = 100

/obj/effect/fake_attacker/attackby(obj/item/weapon/P, mob/living/user, params)
	step_away(src,my_target,2)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	my_target << sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
	my_target.visible_message("<span class='danger'>[my_target] flails around wildly.</span>", \
							"<span class='danger'>[my_target] has attacked [src]!</span>")

	obj_integrity -= P.force

/obj/effect/fake_attacker/Crossed(mob/M, somenumber)
	if(M == my_target)
		step_away(src,my_target,2)
		if(prob(30))
			for(var/mob/O in oviewers(world.view , my_target))
				O << "<span class='danger'>[my_target] stumbles around.</span>"

/obj/effect/fake_attacker/New(loc,var/mob/living/carbon/T)
	..()
	my_target = T
	QDEL_IN(src, 300)
	step_away(src,my_target,2)
	addtimer(src, "attack_loop", 0)


/obj/effect/fake_attacker/proc/updateimage()
//	del src.currentimage
	if(src.dir == NORTH)
		del src.currentimage
		src.currentimage = new /image(up,src)
	else if(src.dir == SOUTH)
		del src.currentimage
		src.currentimage = new /image(down,src)
	else if(src.dir == EAST)
		del src.currentimage
		src.currentimage = new /image(right,src)
	else if(src.dir == WEST)
		del src.currentimage
		src.currentimage = new /image(left,src)
	my_target << currentimage


/obj/effect/fake_attacker/proc/attack_loop()
	while(1)
		sleep(rand(5,10))
		if(obj_integrity < 0)
			collapse()
			continue
		if(get_dist(src,my_target) > 1)
			src.setDir(get_dir(src,my_target))
			step_towards(src,my_target)
			updateimage()
		else
			if(prob(15))
				do_attack_animation(my_target, ATTACK_EFFECT_PUNCH)
				if(weapon_name)
					my_target << sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
					my_target.show_message("<span class='danger'>[src.name] has attacked [my_target] with [weapon_name]!</span>", 1)
					my_target.staminaloss += 30
					if(prob(20))
						my_target.blur_eyes(3)
					if(prob(33))
						if(!locate(/obj/effect/overlay) in my_target.loc)
							fake_blood(my_target)
				else
					my_target << sound(pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
					my_target.show_message("<span class='userdanger'>[src.name] has punched [my_target]!</span>", 1)
					my_target.staminaloss += 30
					if(prob(33))
						if(!locate(/obj/effect/overlay) in my_target.loc)
							fake_blood(my_target)

		if(prob(15))
			step_away(src,my_target,2)

/obj/effect/fake_attacker/proc/collapse()
	collapse = 1
	updateimage()

/obj/effect/fake_attacker/proc/fake_blood(mob/target)
	var/obj/effect/overlay/O = new/obj/effect/overlay(target.loc)
	O.name = "blood"
	var/image/I = image('icons/effects/blood.dmi',O,"floor[rand(1,7)]",O.dir,1)
	target << I
	QDEL_IN(O, 300)

var/list/non_fakeattack_weapons = list(/obj/item/weapon/gun/ballistic, /obj/item/ammo_box/a357,\
	/obj/item/weapon/gun/energy/kinetic_accelerator/crossbow, /obj/item/weapon/melee/energy/sword/saber,\
	/obj/item/weapon/storage/box/syndicate, /obj/item/weapon/storage/box/emps,\
	/obj/item/weapon/cartridge/syndicate, /obj/item/clothing/under/chameleon,\
	/obj/item/clothing/shoes/chameleon, /obj/item/weapon/card/id/syndicate,\
	/obj/item/clothing/mask/chameleon, /obj/item/clothing/glasses/thermal,\
	/obj/item/device/chameleon, /obj/item/weapon/card/emag,	/obj/item/weapon/grenade/plastic/x4,\
	/obj/item/weapon/storage/toolbox/syndicate, /obj/item/weapon/aiModule,\
	/obj/item/device/radio/headset/syndicate,	/obj/item/weapon/grenade/plastic/c4,\
	/obj/item/device/powersink, /obj/item/weapon/storage/box/syndie_kit,\
	/obj/item/toy/syndicateballoon, /obj/item/weapon/gun/energy/laser/captain,\
	/obj/item/weapon/hand_tele, /obj/item/weapon/rcd, /obj/item/weapon/tank/jetpack,\
	/obj/item/clothing/under/rank/captain, /obj/item/device/aicard,\
	/obj/item/clothing/shoes/magboots, /obj/item/areaeditor/blueprints, /obj/item/weapon/disk/nuclear,\
	/obj/item/clothing/suit/space/nasavoid, /obj/item/weapon/tank)

/obj/effect/hallucination/bolts
	var/list/doors = list()

/obj/effect/hallucination/bolts/New(loc,var/mob/living/carbon/T,var/door_number=-1) //-1 for sever 1-2 for subtle
	target = T
	var/image/I = null
	var/count = 0
	for(var/obj/machinery/door/airlock/A in range(7, target))
		if(count>door_number && door_number>0)
			break
		count++
		I = image(A.icon,A,"door_locked",layer=A.layer+0.1)
		doors += I
		if(target.client)
			target.client.images |= I
		sleep(2)
	sleep(100)
	for(var/image/B in doors)
		if(target.client)
			target.client.images.Remove(B)
	qdel(src)

/obj/effect/hallucination/whispers

/obj/effect/hallucination/whispers/New(loc,var/mob/living/carbon/T)
	target = T
	var/speak_messages = list("I'm watching you...","[target.name]!","Go away!","Kchck-Chkck? Kchchck!","Did you hear that?","What did you do ?","Why?","Give me that!","Honk!","HELP!!")
	var/radio_messages = list("Xenos!","Singularity loose!","They are arming the nuke!","They butchered Ian!","H-help!","[pick(teleportlocs)]!!","Where's [target.name]?","Call the shuttle!")

	var/list/mob/living/carbon/people = list()
	var/list/mob/living/carbon/person = null
	for(var/mob/living/carbon/H in view(target))
		if(H == target)
			continue
		if(!person)
			person = H
		else
			if(get_dist(target,H)<get_dist(target,person))
				person = H
		people += H
	if(person) //Basic talk
		target << target.compose_message(person,person.languages_understood,pick(speak_messages),null,person.get_spans())
	else // Radio talk
		var/list/humans = list()
		for(var/mob/living/carbon/human/H in living_mob_list)
			humans += H
		person = pick(humans)
		target << target.compose_message(person,person.languages_understood,pick(radio_messages),"1459",person.get_spans())
	qdel(src)

/obj/effect/hallucination/message

/obj/effect/hallucination/message/New(loc,var/mob/living/carbon/T)
	target = T
	var/chosen = pick("<span class='userdanger'>The light burns you!</span>", \
		"<span class='danger'>You don't feel like yourself.</span>", \
		"<span class='userdanger'>Unknown has punched [target]!</span>", \
		"<span class='notice'>You hear something squeezing through the ducts...</span>", \
		"<span class='notice'>You hear a distant scream.</span>", \
		"<span class='notice'>You feel invincible, nothing can hurt you!</span>", \
		"<B>[target]</B> sneezes.", \
		"<span class='warning'>You feel faint.</span>", \
		"<span class='noticealien'>You hear a strange, alien voice in your head...</span>[pick("Hiss","Ssss")]", \
		"<span class='notice'>You can see...everything!</span>")
	target << chosen
	qdel(src)

/mob/living/carbon/proc/hallucinate(hal_type) // Todo -> proc / defines
	switch(hal_type)
		if("xeno")
			new /obj/effect/hallucination/xeno_attack(src.loc,src)
		if("singulo")
			new /obj/effect/hallucination/singularity_scare(src.loc,src)
		if("battle")
			new /obj/effect/hallucination/battle(src.loc,src)
		if("flood")
			new /obj/effect/hallucination/fake_flood(src.loc,src)
		if("delusion")
			new /obj/effect/hallucination/delusion(src.loc,src)
		if("fake")
			new /obj/effect/hallucination/fakeattacker(src.loc,src)
		if("bolts")
			new /obj/effect/hallucination/bolts(src.loc,src)
		if("bolts_minor")
			new /obj/effect/hallucination/bolts(src.loc,src,rand(1,2))
		if("whispers")
			new /obj/effect/hallucination/whispers(src.loc,src)
		if("message")
			new /obj/effect/hallucination/message(src.loc,src)
		if("sounds")
			//Strange audio
			//src << "Strange Audio"
			switch(rand(1,18))
				if(1) src << 'sound/machines/airlock.ogg'
				if(2)
					if(prob(50))src << 'sound/effects/Explosion1.ogg'
					else src << 'sound/effects/Explosion2.ogg'
				if(3) src << 'sound/effects/explosionfar.ogg'
				if(4) src << 'sound/effects/Glassbr1.ogg'
				if(5) src << 'sound/effects/Glassbr2.ogg'
				if(6) src << 'sound/effects/Glassbr3.ogg'
				if(7) src << 'sound/machines/twobeep.ogg'
				if(8) src << 'sound/machines/windowdoor.ogg'
				if(9)
					//To make it more realistic, I added two gunshots (enough to kill)
					src << 'sound/weapons/Gunshot.ogg'
					spawn(rand(10,30))
						src << 'sound/weapons/Gunshot.ogg'
				if(10) src << 'sound/weapons/smash.ogg'
				if(11)
					//Same as above, but with tasers.
					src << 'sound/weapons/Taser.ogg'
					spawn(rand(10,30))
						src << 'sound/weapons/Taser.ogg'
			//Rare audio
				if(12)
			//These sounds are (mostly) taken from Hidden: Source
					var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
						'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
						'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
						'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
						'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
					src << pick(creepyasssounds)
				if(13)
					src << "<span class='warning'>You feel a tiny prick!</span>"
				if(14)
					src << "<h1 class='alert'>Priority Announcement</h1>"
					src << "<br><br><span class='alert'>The Emergency Shuttle has docked with the station. You have 3 minutes to board the Emergency Shuttle.</span><br><br>"
					src << sound('sound/AI/shuttledock.ogg')
				if(15)
					src << 'sound/items/Welder.ogg'
				if(16)
					src << 'sound/items/Screwdriver.ogg'
				if(17)
					src << 'sound/weapons/saberon.ogg'
				if(18)
					src << 'sound/weapons/saberoff.ogg'
		if("hudscrew")
			//Screwy HUD
			//src << "Screwy HUD"
			hal_screwyhud = pick(1,2,3,3,4,4)
			spawn(rand(100,250))
				hal_screwyhud = 0
		if("items")
			//Strange items
			//src << "Traitor Items"
			if(!halitem)
				halitem = new
				var/obj/item/l_hand = get_item_for_held_index(1)
				var/obj/item/r_hand = get_item_for_held_index(2)
				var/l = ui_hand_position(get_held_index_of_item(l_hand))
				var/r = ui_hand_position(get_held_index_of_item(r_hand))
				var/list/slots_free = list(l,r)
				if(l_hand) slots_free -= l
				if(r_hand) slots_free -= r
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					if(!H.belt) slots_free += ui_belt
					if(!H.l_store) slots_free += ui_storage1
					if(!H.r_store) slots_free += ui_storage2
				if(slots_free.len)
					halitem.screen_loc = pick(slots_free)
					halitem.layer = ABOVE_HUD_LAYER
					halitem.plane = ABOVE_HUD_PLANE
					switch(rand(1,6))
						if(1) //revolver
							halitem.icon = 'icons/obj/guns/projectile.dmi'
							halitem.icon_state = "revolver"
							halitem.name = "Revolver"
						if(2) //c4
							halitem.icon = 'icons/obj/grenade.dmi'
							halitem.icon_state = "plastic-explosive0"
							halitem.name = "Mysterious Package"
							if(prob(25))
								halitem.icon_state = "c4small_1"
						if(3) //sword
							halitem.icon = 'icons/obj/weapons.dmi'
							halitem.icon_state = "sword1"
							halitem.name = "Sword"
						if(4) //stun baton
							halitem.icon = 'icons/obj/weapons.dmi'
							halitem.icon_state = "stunbaton"
							halitem.name = "Stun Baton"
						if(5) //emag
							halitem.icon = 'icons/obj/card.dmi'
							halitem.icon_state = "emag"
							halitem.name = "Cryptographic Sequencer"
						if(6) //flashbang
							halitem.icon = 'icons/obj/grenade.dmi'
							halitem.icon_state = "flashbang1"
							halitem.name = "Flashbang"
					if(client) client.screen += halitem
					QDEL_IN(halitem, rand(100, 250))
		if("dangerflash")
			//Flashes of danger
			//src << "Danger Flash"
			if(!halimage)
				var/list/possible_points = list()
				for(var/turf/open/floor/F in view(src,world.view))
					possible_points += F
				if(possible_points.len)
					var/turf/open/floor/target = pick(possible_points)

					switch(rand(1,3))
						if(1)
							//src << "Space"
							halimage = image('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
						if(2)
							//src << "Fire"
							halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
						if(3)
							//src << "C4"
							halimage = image('icons/obj/grenade.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)


					if(client) client.images += halimage
					spawn(rand(10,50)) //Only seen for a brief moment.
						if(client) client.images -= halimage
						halimage = null
		if("death")
			//Fake death
			hal_screwyhud = 1
			SetSleeping(20)
			spawn(rand(50,100))
				hal_screwyhud = 0
				SetSleeping(0)
		if("husks")
			if(!halbody)
				var/list/possible_points = list()
				for(var/turf/open/floor/F in view(src,world.view))
					possible_points += F
				if(possible_points.len)
					var/turf/open/floor/target = pick(possible_points)
					switch(rand(1,4))
						if(1)
							var/image/body = image('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
							var/matrix/M = matrix()
							M.Turn(90)
							body.transform = M
							halbody = body
						if(2,3)
							halbody = image('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
						if(4)
							halbody = image('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)

					if(client) client.images += halbody
					spawn(rand(50,80)) //Only seen for a brief moment.
						if(client) client.images -= halbody
						halbody = null
