//Ratvar himself. Impossible to damage by most standard means, He will dominate the station and all upon it.
/obj/structure/destructible/clockwork/massive/ratvar
	name = "Ratvar, the Clockwork Justiciar"
	desc = "<span class='userdanger'>What is what is what are what real what is all a lie all a lie it's all a lie why how can what is</span>"
	clockwork_desc = "<span class='large_brass'><b><i>Ratvar, the Clockwork Justiciar, your master eternal.</i></b></span>"
	icon = 'icons/effects/512x512.dmi'
	icon_state = "ratvar"
	pixel_x = -235
	pixel_y = -248
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	appearance_flags = 0
	var/atom/prey //Whatever Ratvar is chasing
	var/clashing = FALSE //If Ratvar is FUCKING FIGHTING WITH NAR-SIE
	var/proselytize_range = 10

/obj/structure/destructible/clockwork/massive/ratvar/New()
	..()
	ratvar_awakens++
	for(var/obj/O in all_clockwork_objects)
		O.ratvar_act()
	START_PROCESSING(SSobj, src)
	send_to_playing_players("<span class='ratvar'>\"[text2ratvar("ONCE AGAIN MY LIGHT SHALL SHINE ACROSS THIS PATHETIC REALM")]!!\"</span>")
	send_to_playing_players('sound/effects/ratvar_reveal.ogg')
	var/image/alert_overlay = image('icons/effects/clockwork_effects.dmi', "ratvar_alert")
	var/area/A = get_area(src)
	notify_ghosts("The Justiciar's light calls to you! Reach out to Ratvar in [A.name] to be granted a shell to spread his glory!", null, source = src, alert_overlay = alert_overlay)
	addtimer(SSshuttle.emergency, "request", 50, TIMER_NORMAL, null, 0.1)

/obj/structure/destructible/clockwork/massive/ratvar/Destroy()
	ratvar_awakens--
	for(var/obj/O in all_clockwork_objects)
		O.ratvar_act()
	STOP_PROCESSING(SSobj, src)
	send_to_playing_players("<span class='heavy_brass'><font size=6>\"NO! I will not... be...</font> <font size=5>banished...</font> <font size=4>again...\"</font></span>")
	return ..()

/obj/structure/destructible/clockwork/massive/ratvar/attack_ghost(mob/dead/observer/O)
	var/alertresult = alert(O, "Embrace the Justiciar's light? You can no longer be cloned!",,"Yes", "No")
	if(alertresult == "No" || !O)
		return 0
	var/mob/living/simple_animal/drone/cogscarab/ratvar/R = new/mob/living/simple_animal/drone/cogscarab/ratvar(get_turf(src))
	R.visible_message("<span class='heavy_brass'>[R] forms, and its eyes blink open, glowing bright red!</span>")
	R.key = O.key

/obj/structure/destructible/clockwork/massive/ratvar/Bump(atom/A)
	var/turf/T = get_turf(A)
	forceMove(T)
	T.ratvar_act()

/obj/structure/destructible/clockwork/massive/ratvar/Process_Spacemove()
	return clashing

/obj/structure/destructible/clockwork/massive/ratvar/process()
	if(clashing) //I'm a bit occupied right now, thanks
		return
	for(var/I in circlerangeturfs(src, proselytize_range))
		var/turf/T = I
		T.ratvar_act()
	for(var/I in circleviewturfs(src, round(proselytize_range * 0.5)))
		var/turf/T = I
		T.ratvar_act(1)
	var/dir_to_step_in = pick(cardinal)
	if(!prey)
		for(var/obj/singularity/narsie/N in poi_list)
			if(N.z == z)
				prey = N
				break
		if(!prey) //In case there's a Nar-Sie
			var/list/meals = list()
			for(var/mob/living/L in living_mob_list)
				if(L.z == z && !is_servant_of_ratvar(L) && L.mind)
					meals += L
			if(meals.len)
				prey = pick(meals)
				prey << "<span class='heavy_brass'><font size=5>\"You will do.\"</font></span>\n\
				<span class='userdanger'>Something very large and very malevolent begins lumbering its way towards you...</span>"
				prey << 'sound/effects/ratvar_reveal.ogg'
	else
		if(prob(10) || is_servant_of_ratvar(prey) || prey.z != z)
			prey << "<span class='heavy_brass'><font size=5>\"How dull. Leave me.\"</font></span>\n\
			<span class='userdanger'>You feel tremendous relief as a set of horrible eyes loses sight of you...</span>"
			prey = null
		else
			dir_to_step_in = get_dir(src, prey) //Unlike Nar-Sie, Ratvar ruthlessly chases down his target
	step(src, dir_to_step_in)

/obj/structure/destructible/clockwork/massive/ratvar/narsie_act()
	if(clashing)
		return FALSE
	clashing = TRUE
	world << "<span class='heavy_brass'><font size=5>\"[pick("BLOOD GOD!!!", "NAR-SIE!!!", "AT LAST, YOUR TIME HAS COME!")]\"</font></span>"
	world << "<span class='cult'><font size=5>\"<b>Ratvar?! How?!</b>\"</font></span>"
	for(var/obj/singularity/narsie/N in range(15, src))
		if(N.clashing)
			continue
		N.clashing = TRUE
		clash_of_the_titans(N) //IT'S TIME FOR THE BATTLE OF THE AGES
		break
	return TRUE

//Put me in Reebe, will you? Ratvar has found and is going to fucking murder Nar-Sie
/obj/structure/destructible/clockwork/massive/ratvar/proc/clash_of_the_titans(obj/singularity/narsie/narsie)
	var/winner = "Undeclared"
	var/base_victory_chance = 1
	while(src && narsie)
		send_to_playing_players('sound/magic/clockwork/ratvar_attack.ogg')
		sleep(5.2)
		for(var/mob/M in mob_list)
			if(!isnewplayer(M))
				flash_color(M, flash_color="#966400", flash_time=1)
				shake_camera(M, 4, 3)
		var/ratvar_chance = min(ticker.mode.servants_of_ratvar.len, 50)
		var/narsie_chance = ticker.mode.cult.len
		for(var/mob/living/simple_animal/hostile/construct/harvester/C in player_list)
			narsie_chance++
		ratvar_chance = rand(base_victory_chance, ratvar_chance)
		narsie_chance = rand(base_victory_chance, min(narsie_chance, 50))
		if(ratvar_chance > narsie_chance)
			winner = "Ratvar"
			break
		sleep(rand(2,5))
		send_to_playing_players('sound/magic/clockwork/narsie_attack.ogg')
		sleep(7.4)
		for(var/mob/M in mob_list)
			if(!isnewplayer(M))
				flash_color(M, flash_color="#C80000", flash_time=1)
				shake_camera(M, 4, 3)
		if(narsie_chance > ratvar_chance)
			winner = "Nar-Sie"
			break
		base_victory_chance *= 2 //The clash has a higher chance of resolving each time both gods attack one another
	switch(winner)
		if("Ratvar")
			send_to_playing_players("<span class='heavy_brass'><font size=5>\"[pick("DIE! DIE! DIE!", "FILTH!!!", "SUFFER!!!", text2ratvar("ROT FOR CENTURIES AS I HAVE!!"))]\"</font></span>\n\
			<span class='cult'><font size=5>\"<b>[pick("Nooooo...", "Not die. To y-", "Die. Ratv-", "Sas tyen re-")]\"</b></font></span>") //nar-sie get out
			send_to_playing_players('sound/magic/clockwork/anima_fragment_attack.ogg')
			send_to_playing_players('sound/magic/demon_dies.ogg')
			clashing = FALSE
			qdel(narsie)
		if("Nar-Sie")
			send_to_playing_players("<span class='cult'><font size=5>\"<b>[pick("Ha.", "Ra'sha fonn dest.", "You fool. To come here.")]</b>\"</font></span>") //Broken English
			send_to_playing_players('sound/magic/demon_attack1.ogg')
			send_to_playing_players('sound/magic/clockwork/anima_fragment_death.ogg')
			narsie.clashing = FALSE
			qdel(src)
