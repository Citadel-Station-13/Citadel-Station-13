
/obj/effect/gibspawner
	var/sparks = FALSE //whether sparks spread
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/gib_mob_type  //generate a fake mob to transfer DNA from if we weren't passed a mob.
	var/gib_mob_species //We'll want to nip-pick their species for blood type stuff
	var/sound_to_play = 'sound/effects/blobattack.ogg'
	var/sound_vol = 60
	var/list/gibtypes = list() //typepaths of the gib decals to spawn
	var/list/gibamounts = list() //amount to spawn for each gib decal type we'll spawn.
	var/list/gibdirections = list() //of lists of possible directions to spread each gib decal type towards.

/obj/effect/gibspawner/Initialize(mapload, mob/living/source_mob, list/datum/disease/diseases, list/blood_dna)
	. = ..()
	if(gibtypes.len != gibamounts.len)
		stack_trace("Gib list amount length mismatch!")
		return
	if(gibamounts.len != gibdirections.len)
		stack_trace("Gib list dir length mismatch!")
		return

	var/obj/effect/decal/cleanable/blood/gibs/gib = null

	if(sound_to_play && isnum(sound_vol))
		playsound(src, sound_to_play, sound_vol, TRUE)

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, loc)
		s.start()

	var/list/dna_to_add //find the dna to pass to the spawned gibs. do note this can be null if the mob doesn't have blood. add_blood_DNA() has built in null handling.
	var/body_coloring = ""
	if(source_mob)
		if(!issilicon(source_mob))
			dna_to_add = blood_dna || source_mob.get_blood_dna_list() //ez pz
		if(ishuman(source_mob))
			var/mob/living/carbon/human/H = source_mob
			if(H.dna.species.use_skintones)
				body_coloring = "#[skintone2hex(H.skin_tone)]"
			else
				body_coloring = "#[H.dna.features["mcolor"]]"

	else if(gib_mob_type)
		var/mob/living/temp_mob = new gib_mob_type(src) //generate a fake mob so that we pull the right type of DNA for the gibs.
		if(gib_mob_species)
			if(ishuman(temp_mob))
				var/mob/living/carbon/human/H = temp_mob
				H.set_species(gib_mob_species)
				dna_to_add = temp_mob.get_blood_dna_list()
				if(H.dna.species.use_skintones)
					body_coloring = "#[skintone2hex(H.skin_tone)]"
				else
					body_coloring = "#[H.dna.features["mcolor"]]"
			else
				dna_to_add = temp_mob.get_blood_dna_list()
		else if(!issilicon(temp_mob))
			dna_to_add = temp_mob.get_blood_dna_list()
		qdel(temp_mob)
	else
		dna_to_add = list("Non-human DNA" = random_blood_type()) //else, generate a random bloodtype for it.


	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(loc, diseases)
				if(iscarbon(loc))
					var/mob/living/carbon/digester = loc
					digester.stomach_contents += gib

				if(dna_to_add && dna_to_add.len)
					gib.add_blood_DNA(dna_to_add)
					gib.body_colors = body_coloring
					gib.update_icon()

				var/list/directions = gibdirections[i]
				if(isturf(loc))
					if(directions.len)
						gib.streak(directions)

	return INITIALIZE_HINT_QDEL


/obj/effect/gibspawner/generic
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(2, 2, 1)
	sound_vol = 40

/obj/effect/gibspawner/generic/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH),list(EAST, NORTHEAST, SOUTHEAST, SOUTH), list())
	return ..()

/obj/effect/gibspawner/generic/animal
	gib_mob_type = /mob/living/simple_animal/pet

/obj/effect/gibspawner/human
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/human/up, /obj/effect/decal/cleanable/blood/gibs/human/down, /obj/effect/decal/cleanable/blood/gibs/human, /obj/effect/decal/cleanable/blood/gibs/human, /obj/effect/decal/cleanable/blood/gibs/human/body, /obj/effect/decal/cleanable/blood/gibs/human/limb, /obj/effect/decal/cleanable/blood/gibs/human/core)
	gibamounts = list(1, 1, 1, 1, 1, 1, 1)
	gib_mob_type = /mob/living/carbon/human
	gib_mob_species = /datum/species/human
	sound_vol = 50

/obj/effect/gibspawner/human/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/human/bodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/human, /obj/effect/decal/cleanable/blood/gibs/human/core, /obj/effect/decal/cleanable/blood/gibs/human, /obj/effect/decal/cleanable/blood/gibs/human/core, /obj/effect/decal/cleanable/blood/gibs/human, /obj/effect/decal/cleanable/blood/gibs/human/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/human/bodypartless/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/lizard
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/human/lizard/up, /obj/effect/decal/cleanable/blood/gibs/human/lizard/down, /obj/effect/decal/cleanable/blood/gibs/human/lizard, /obj/effect/decal/cleanable/blood/gibs/human/lizard, /obj/effect/decal/cleanable/blood/gibs/human/lizard/body, /obj/effect/decal/cleanable/blood/gibs/human/lizard/limb, /obj/effect/decal/cleanable/blood/gibs/human/lizard/core)
	gibamounts = list(1, 1, 1, 1, 1, 1, 1)
	gib_mob_type = /mob/living/carbon/human/species/lizard
	gib_mob_species = /datum/species/lizard
	sound_vol = 50

/obj/effect/gibspawner/lizard/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/lizard/bodypartless
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/human/lizard, /obj/effect/decal/cleanable/blood/gibs/human/lizard/core, /obj/effect/decal/cleanable/blood/gibs/human/lizard, /obj/effect/decal/cleanable/blood/gibs/human/lizard/core, /obj/effect/decal/cleanable/blood/gibs/human/lizard, /obj/effect/decal/cleanable/blood/gibs/human/lizard/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/lizard/bodypartless/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/slime
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/slime/up, /obj/effect/decal/cleanable/blood/gibs/slime/down, /obj/effect/decal/cleanable/blood/gibs/slime, /obj/effect/decal/cleanable/blood/gibs/slime, /obj/effect/decal/cleanable/blood/gibs/slime/body, /obj/effect/decal/cleanable/blood/gibs/slime/limb, /obj/effect/decal/cleanable/blood/gibs/slime/core)
	gibamounts = list(1, 1, 1, 1, 1, 1, 1)
	gib_mob_type = /mob/living/carbon/human/species/roundstartslime
	gib_mob_species = /datum/species/jelly/roundstartslime
	sound_vol = 50

/obj/effect/gibspawner/slime/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/slime/bodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/slime, /obj/effect/decal/cleanable/blood/gibs/slime/core, /obj/effect/decal/cleanable/blood/gibs/slime, /obj/effect/decal/cleanable/blood/gibs/slime/core, /obj/effect/decal/cleanable/blood/gibs/slime, /obj/effect/decal/cleanable/blood/gibs/slime/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/slime/bodypartless/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/ipc
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/ipc/up, /obj/effect/decal/cleanable/blood/gibs/ipc/down, /obj/effect/decal/cleanable/blood/gibs/ipc, /obj/effect/decal/cleanable/blood/gibs/ipc, /obj/effect/decal/cleanable/blood/gibs/ipc/body, /obj/effect/decal/cleanable/blood/gibs/ipc/limb, /obj/effect/decal/cleanable/blood/gibs/ipc/core)
	gibamounts = list(1, 1, 1, 1, 1, 1, 1)
	gib_mob_type = /mob/living/carbon/human/species/ipc
	gib_mob_species = /datum/species/ipc
	sound_vol = 50
	sparks = TRUE
	sound_to_play = 'sound/effects/bang.ogg'

/obj/effect/gibspawner/ipc/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/ipc/bodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/ipc, /obj/effect/decal/cleanable/blood/gibs/ipc/core, /obj/effect/decal/cleanable/blood/gibs/ipc, /obj/effect/decal/cleanable/blood/gibs/ipc/core, /obj/effect/decal/cleanable/blood/gibs/ipc, /obj/effect/decal/cleanable/blood/gibs/ipc/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/ipc/bodypartless/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/xeno
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/xeno/up, /obj/effect/decal/cleanable/blood/gibs/xeno/down, /obj/effect/decal/cleanable/blood/gibs/xeno, /obj/effect/decal/cleanable/blood/gibs/xeno, /obj/effect/decal/cleanable/blood/gibs/xeno/body, /obj/effect/decal/cleanable/blood/gibs/xeno/limb, /obj/effect/decal/cleanable/blood/gibs/xeno/core)
	gibamounts = list(1, 1, 1, 1, 1, 1, 1)
	gib_mob_type = /mob/living/carbon/alien

/obj/effect/gibspawner/xeno/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/xeno/bodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/xeno, /obj/effect/decal/cleanable/blood/gibs/xeno/core, /obj/effect/decal/cleanable/blood/gibs/xeno, /obj/effect/decal/cleanable/blood/gibs/xeno/core, /obj/effect/decal/cleanable/blood/gibs/xeno, /obj/effect/decal/cleanable/blood/gibs/xeno/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/xeno/bodypartless/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	return ..()

/obj/effect/gibspawner/xeno/xenoperson
	gib_mob_type = /mob/living/carbon/human/species/xeno
	gib_mob_species = /datum/species/xeno

/obj/effect/gibspawner/xeno/xenoperson/bodypartless

/obj/effect/gibspawner/larva
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/xeno/larva, /obj/effect/decal/cleanable/blood/gibs/xeno/larva, /obj/effect/decal/cleanable/blood/gibs/xeno/larva/body, /obj/effect/decal/cleanable/blood/gibs/xeno/larva/body)
	gibamounts = list(1, 1, 1, 1)
	gib_mob_type = /mob/living/carbon/alien/larva

/obj/effect/gibspawner/larva/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST), list(), GLOB.alldirs)
	return ..()

/obj/effect/gibspawner/larva/bodypartless
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/xeno/larva, /obj/effect/decal/cleanable/blood/gibs/xeno/larva, /obj/effect/decal/cleanable/blood/gibs/xeno/larva)
	gibamounts = list(1, 1, 1)

/obj/effect/gibspawner/larva/bodypartless/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST), list())
	return ..()

/obj/effect/gibspawner/robot
	sparks = TRUE
	gibtypes = list(/obj/effect/decal/cleanable/robot_debris/up, /obj/effect/decal/cleanable/robot_debris/down, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris/limb)
	gibamounts = list(1, 1, 1, 1, 1, 1)
	gib_mob_type = /mob/living/silicon/robot

/obj/effect/gibspawner/robot/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs)
	gibamounts[6] = pick(0, 1, 2)
	return ..()

