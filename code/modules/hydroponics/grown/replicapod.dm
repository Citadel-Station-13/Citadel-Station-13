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
	maturation = 10
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
	var/contains_sample = 0

/obj/item/seeds/replicapod/Initialize(mapload)
	. = ..()

	create_reagents(volume, INJECTABLE | DRAWABLE)

/obj/item/seeds/replicapod/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

/obj/item/seeds/replicapod/proc/check_mind_orbiting(atom/A)
	for(var/mob/M in A.orbiters?.orbiters)
		if(mind && M.mind && ckey(M.mind.key) == ckey(mind.key) && M.ckey && M.client && M.stat == DEAD && !M.suiciding && isobserver(M))
			return TRUE
	return FALSE

/obj/item/seeds/replicapod/process()
	var/obj/machinery/hydroponics/parent = loc
	if(parent.harvest != 1)
		return
	if (check_mind_orbiting(parent))
		icon_harvest = "replicapod-orbit"
	else
		icon_harvest = "replicapod-harvest"
	parent.update_icon_plant()

/obj/item/seeds/replicapod/on_reagent_change(changetype)
	if(changetype == ADD_REAGENT)
		for(var/datum/reagent/R as anything in reagents.reagent_list)
			if(R.data["mind"])
				if(R.data["cloneable"])
					mind = R.data["mind"]
					ckey = R.data["ckey"]
					realName = R.data["real_name"]
					blood_gender = R.data["gender"]
					blood_type = R.data["blood_type"]
					features = R.data["features"]
					factions = R.data["factions"]
					quirks = R.data["quirks"]
					contains_sample = TRUE
					visible_message("<span class='notice'>The [src] is injected with a fresh blood sample.</span>")
				else
					visible_message("<span class='warning'>The [src] rejects the sample!</span>")

/obj/item/seeds/replicapod/get_analyzer_text()
	var/text = ..()
	var/obj/machinery/hydroponics/parent = loc
	if(contains_sample)
		text += "\n It contains a blood sample!"
	if (parent && istype(parent) && check_mind_orbiting(parent))
		text += "\n The soul is ready to enter the body."
	return text


/obj/item/seeds/replicapod/harvest(mob/user) //now that one is fun -- Urist
	var/obj/machinery/hydroponics/parent = loc
	var/make_podman = 0
	var/ckey_holder = null
	var/list/result = list()
	if(CONFIG_GET(flag/revival_pod_plants))
		if(ckey)
			for(var/mob/M in GLOB.player_list)
				if(isobserver(M))
					var/mob/dead/observer/O = M
					if(O.ckey == ckey && O.can_reenter_corpse)
						make_podman = 1
						break
				else
					if(M.ckey == ckey && M.stat == DEAD && !M.suiciding && AmBloodsucker(M))
						make_podman = 1
						if(isliving(M))
							var/mob/living/L = M
							make_podman = !L.hellbound
						break
		else //If the player has ghosted from his corpse before blood was drawn, his ckey is no longer attached to the mob, so we need to match up the cloned player through the mind key
			for(var/mob/M in GLOB.player_list)
				if(mind && M.mind && ckey(M.mind.key) == ckey(mind.key) && M.ckey && M.client && M.stat == DEAD && !M.suiciding)
					if(isobserver(M))
						var/mob/dead/observer/O = M
						if(!O.can_reenter_corpse)
							break
					make_podman = 1
					if(isliving(M))
						var/mob/living/L = M
						make_podman = !L.hellbound
					ckey_holder = M.ckey
					break

	if(make_podman)	//all conditions met!
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
		if(!features["mcolor"])
			features["mcolor"] = "#59CE00"
		for(var/V in quirks)
			new V(podman)
		podman.hardset_dna(null,null,podman.real_name,blood_type, new /datum/species/pod,features)//Discard SE's and UI's, podman cloning is inaccurate, and always make them a podman
		podman.set_cloned_appearance()

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
