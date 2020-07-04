/mob/dead/observer/proc/on_click_ctrl_shift(mob/user)
	if(isobserver(user) && check_rights(R_SPAWN))
		change_mob_type( /mob/living/carbon/human , null, null, TRUE) //always delmob, ghosts shouldn't be left lingering

/mob/dead/observer/proc/on_click_ctrl(mob/user)
	quickicspawn(user)

/mob/dead/observer/proc/quickicspawn(mob/user)
	if(isobserver(user) && check_rights(R_SPAWN))
		var/teleport_option = alert(src, "How would you like to be spawned in?","IC Quick Spawn","Bluespace","Droppod", "Cancel")
		if (teleport_option == "Cancel")
			return
		var/dresscode = client.robust_dress_shop()
		if (!dresscode)
			return
		var/grant_spell = alert(src, "Do you want to get the 'Return' spell?","IC Quick Spawn","Yes","No")

		var/turf/current_turf = get_turf(src)
		var/mob/living/carbon/human/spawned_player = new(src)

		if (teleport_option == "Bluespace")
			playsound(spawned_player, 'sound/magic/Disable_Tech.ogg', 100, 1)

		if(mind && isliving(spawned_player))
			mind.transfer_to(spawned_player, 1) // second argument to force key move to new mob
		else
			transfer_ckey(spawned_player)

		if(grant_spell != "No")
			spawned_player.mind.AddSpell(new /obj/effect/proc_holder/spell/self/return_back)

		if(dresscode != "Naked")
			spawned_player.equipOutfit(dresscode)

		switch(teleport_option)
			if("Bluespace")
				spawned_player.forceMove(current_turf)

				var/datum/effect_system/spark_spread/quantum/sparks = new
				sparks.set_up(10, 1, spawned_player)
				sparks.attach(get_turf(spawned_player))
				sparks.start()
			if("Droppod")
				var/obj/structure/closet/supplypod/empty_pod = new()

				empty_pod.style = STYLE_BLUESPACE
				empty_pod.bluespace = TRUE
				empty_pod.explosionSize = list(0,0,0,0)
				empty_pod.desc = "A sleek, and slightly worn bluespace pod - its probably seen many deliveries..."

				spawned_player.forceMove(empty_pod)

				new /obj/effect/abstract/DPtarget(current_turf, empty_pod)
