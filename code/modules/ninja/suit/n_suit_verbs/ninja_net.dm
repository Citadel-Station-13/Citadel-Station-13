
//Allows the ninja to kidnap people
/obj/item/clothing/suit/space/space_ninja/proc/ninjanet()
	var/mob/living/carbon/human/H = affecting
	var/mob/living/carbon/C

	//If there's only one valid target, let's actually try to capture it, rather than forcing
	//the user to fiddle with the dialog displaying a list of one
	//Also, let's make this smarter and not list mobs you can't currently net.
	var/Candidates[]
	for(var/mob/mob in oview(H))
		if(!mob.client)//Monkeys without a client can still step_to() and bypass the net. Also, netting inactive people is lame.
			//to_chat(H, "<span class='warning'>[C.p_they(TRUE)] will bring no honor to your Clan!</span>")
			continue
		if(locate(/obj/structure/energy_net) in get_turf(mob))//Check if they are already being affected by an energy net.
			//to_chat(H, "<span class='warning'>[C.p_they(TRUE)] are already trapped inside an energy net!</span>")
			continue
		for(var/turf/T in getline(get_turf(H), get_turf(mob)))
			if(T.density)//Don't want them shooting nets through walls. It's kind of cheesy.
				//to_chat(H, "<span class='warning'>You may not use an energy net through solid obstacles!</span>")
				continue
		Candidates+=mob

	if(Candidates.len == 1)
		C = Candidates[1]
	else
		C = input("Select who to capture:","Capture who?",null) as null|mob in Candidates


	if(QDELETED(C)||!(C in oview(H)))
		return 0

	if(!ninjacost(200,N_STEALTH_CANCEL))
		H.Beam(C,"n_beam",time=15)
		H.say("Get over here!", forced = "ninja net")
		var/obj/structure/energy_net/E = new /obj/structure/energy_net(C.drop_location())
		E.affecting = C
		E.master = H
		H.visible_message("<span class='danger'>[H] caught [C] with an energy net!</span>","<span class='notice'>You caught [C] with an energy net!</span>")

		if(C.buckled)
			C.buckled.unbuckle_mob(affecting,TRUE)
		E.buckle_mob(C, TRUE) //No moving for you!
		//The person can still try and attack the net when inside.

		START_PROCESSING(SSobj, E)
