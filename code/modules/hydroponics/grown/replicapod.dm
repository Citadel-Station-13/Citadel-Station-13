// A very special plant, deserving it's own file.

/obj/item/seeds/replicapod
	name = "pack of replica pod seeds"
	desc = "These seeds grow into replica pods. They say these are used to harvest humans."
	icon_state = "seed-replicapod"
	species = "replicapod"
	plantname = "Replica Pod"
	product = /mob/living/carbon/human //verrry special -- Urist
	lifespan = 50
	endurance = 8
	maturation = 20 // it takes a very long time to grow
	production = 1
	yield = 1 //seeds if there isn't a dna inside
	potency = 30
	var/volume = 5
	var/ckey = null
	var/realName = null
	var/datum/mind/mind = null
	var/blood_gender = null
	var/blood_type = null
	var/list/features = null
	var/factions = null
	var/list/quirks = null
	var/ui = null
	var/datum/species/old_species = null
	var/contains_sample = 0

/obj/item/seeds/replicapod/Initialize()
	. = ..()

	create_reagents(volume, INJECTABLE | DRAWABLE)

/obj/item/seeds/replicapod/on_reagent_change(changetype)
	var/list/blood_types = typesof(/datum/reagent/blood)
	if(changetype == ADD_REAGENT)
		var/accepted = FALSE
		for(var/blood_type in blood_types)
			var/datum/reagent/blood/B = reagents.has_reagent(blood_type, 5) //make sure seed pack is full, to stop some funky exploity stuff
			if(B)
				if(B.data["mind"] && B.data["cloneable"])
					mind = B.data["mind"]
					ckey = B.data["ckey"]
					realName = B.data["real_name"]
					blood_gender = B.data["gender"]
					blood_type = B.data["blood_type"]
					features = B.data["features"]
					factions = B.data["factions"]
					quirks = B.data["quirks"]
					ui = B.data["ui"]
					old_species = B.data["species"]
					contains_sample = TRUE
					accepted = TRUE
					visible_message("<span class='notice'>[src] is injected with a fresh blood sample.</span>") // 'the' is automatically added
					break
		if(!accepted)
			visible_message("<span class='warning'>[src] rejects the sample!</span>")

/obj/item/seeds/replicapod/get_analyzer_text()
	var/text = ..()
	if(contains_sample)
		text += "\n It contains a blood sample!"
	return text


/obj/item/seeds/replicapod/harvest(mob/user) //now that one is fun -- Urist
	var/obj/machinery/hydroponics/parent = loc
	var/make_podman = FALSE
	var/can_revive = FALSE
	var/ckey_holder = null
	var/list/result = list()
	if(CONFIG_GET(flag/revival_pod_plants))
		if(ckey)
			for(var/mob/M in GLOB.player_list)
				if(isobserver(M))
					var/mob/dead/observer/O = M
					if(O.ckey == ckey && O.can_reenter_corpse)
						can_revive = TRUE
						break
				else
					if(M.ckey == ckey && M.stat == DEAD && !M.suiciding && AmBloodsucker(M))
						can_revive = TRUE
						if(isliving(M))
							var/mob/living/L = M
							can_revive = !L.hellbound
						break
		else //If the player has ghosted from his corpse before blood was drawn, his ckey is no longer attached to the mob, so we need to match up the cloned player through the mind key
			for(var/mob/M in GLOB.player_list)
				if(mind && M.mind && ckey(M.mind.key) == ckey(mind.key) && M.ckey && M.client && M.stat == DEAD && !M.suiciding)
					if(isobserver(M))
						var/mob/dead/observer/O = M
						if(!O.can_reenter_corpse)
							break
					can_revive = TRUE
					if(isliving(M))
						var/mob/living/L = M
						make_podman = !L.hellbound
					ckey_holder = M.ckey
					break

	if(can_revive)	//all conditions met!
		if(potency >= 90)
			make_podman = TRUE
		var/mob/living/carbon/human/podman = new /mob/living/carbon/human(parent.loc)
		if(realName)
			podman.real_name = realName
		else
			podman.real_name = "Pod Person ([rand(1,999)])"
		mind.transfer_to(podman)
		if(ckey)
			podman.ckey = ckey
		else
			podman.ckey = ckey_holder
		podman.gender = blood_gender
		podman.faction |= factions
		for(var/V in quirks)
			new V(podman)
		if(make_podman) // make them a podperson
			if(!features["mcolor"])
				features["mcolor"] = "#59CE00"
			podman.hardset_dna(null,null,podman.real_name,blood_type, new /datum/species/pod,features)//Discard SE's and UI's, podman cloning is inaccurate, and always make them a podman
      podman.set_cloned_appearance()
		else
			// make them themselves, and not a pod
			podman.hardset_dna(ui, null, podman.real_name, blood_type, old_species, features)

		//deal clone damage because this shouldn't be better than cloning
		podman.adjustCloneLoss(25 + (50/max(potency,1))) // deal between 25 and 75 clone damage depending on potency

	else //else, one packet of seeds. maybe two
		var/seed_count = 1
		if(prob(getYield() * 20))
			seed_count++
		var/output_loc = parent.Adjacent(user) ? user.loc : parent.loc //needed for TK
		for(var/i=0,i<seed_count,i++)
			var/obj/item/seeds/replicapod/harvestseeds = src.Copy()
			result.Add(harvestseeds)
			harvestseeds.forceMove(output_loc)

	parent.update_tray()
	return result
