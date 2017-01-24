/obj/structure/hivebot_beacon
	name = "beacon"
	desc = "Some odd beacon thing."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "def_radar-off"
	anchored = 1
	density = 1
	var/bot_type = "norm"
	var/bot_amt = 10

/obj/structure/hivebot_beacon/New()
	..()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(2, loc)
	smoke.start()
	visible_message("<span class='boldannounce'>The [src] warps in!</span>")
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
	addtimer(src, "warpbots", rand(10, 600))

/obj/structure/hivebot_beacon/proc/warpbots()
	icon_state = "def_radar"
	visible_message("<span class='danger'>The [src] turns on!</span>")
	while(bot_amt > 0)
		bot_amt--
		switch(bot_type)
			if("norm")
				new /mob/living/simple_animal/hostile/hivebot(get_turf(src))
			if("range")
				new /mob/living/simple_animal/hostile/hivebot/range(get_turf(src))
			if("rapid")
				new /mob/living/simple_animal/hostile/hivebot/rapid(get_turf(src))
	sleep(100)
	visible_message("<span class='boldannounce'>The [src] warps out!</span>")
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
	qdel(src)
	return
