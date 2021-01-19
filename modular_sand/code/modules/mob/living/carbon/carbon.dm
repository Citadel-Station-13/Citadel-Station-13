//It's here so it doesn't make a big mess on randomverbs.dm, 
//also because of this you can proccall it, why would you if you have smite?
/mob/living/proc/pregoodbye(C)
	if(isanimal(C))
		var/mob/living/simple_animal/D = C
		D.AIStatus = AI_OFF
	Immobilize(1000, TRUE, TRUE)// 			currently the only ways of
	next_action_immediate = 10000000000 // 	completely freezing someone as i know
	playsound(C, "modular_sand/sound/effects/admin_punish/changetheworld.ogg", 100, FALSE)
	say("Change the world")
	sleep(20)
	playsound(C, "modular_sand/sound/effects/admin_punish/myfinalmessage.ogg", 100, FALSE)
	say("My final message")
	sleep(20)
	playsound(C, "modular_sand/sound/effects/admin_punish/goodbye.ogg", 100, FALSE)
	say("Goodbye.")
	sleep(20)
	playsound(C, "modular_sand/sound/effects/admin_punish/endjingle.ogg", 100, FALSE)
	goodbye()

/mob/living/proc/goodbye() //this must be separate because it's a loop!
	if(alpha <= 10)
		sleep(2)
		ghostize()
		Destroy()
	else
		alpha = alpha - 7
		sleep(1)
		goodbye()
