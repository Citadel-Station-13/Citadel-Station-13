/datum/experiment/scanning/points/slime
	name = "Base Slime Experiment"
	required_points = 1

/datum/experiment/scanning/points/slime/calibration
	name = "Slime Sample Test"
	description = "Let's see if our scanners can pick up the genetic data from a simple slime extract."
	required_atoms = list(/obj/item/slime_extract/grey = 1)

/datum/experiment/scanning/points/slime/easy
	name = "Easy Slime Survey"
	description = "A wealthy client has requested that we provide samples of data from several basic slime cores."
	required_points = 3
	required_atoms =  list(/obj/item/slime_extract/orange = 1,
							/obj/item/slime_extract/purple = 1,
							/obj/item/slime_extract/blue = 1,
							/obj/item/slime_extract/metal = 1)

/datum/experiment/scanning/points/slime/moderate
	name = "Moderate Slime Survey"
	description = "Central Command has asked that you collect data from several common slime cores."
	required_points = 5
	required_atoms = list(/obj/item/slime_extract/yellow = 1,
							/obj/item/slime_extract/darkpurple = 1,
							/obj/item/slime_extract/darkblue = 1,
							/obj/item/slime_extract/silver = 1)

/datum/experiment/scanning/points/slime/hard
	name = "Challenging Slime Survey"
	description = "Another station has challenged your research team to collect several challenging slime cores, \
					are you up to the task?"
	required_points = 10
	required_atoms = list(/obj/item/slime_extract/bluespace = 1,
							/obj/item/slime_extract/sepia = 1,
							/obj/item/slime_extract/cerulean = 1,
							/obj/item/slime_extract/pyrite = 1,
							/obj/item/slime_extract/red = 2,
							/obj/item/slime_extract/green = 2,
							/obj/item/slime_extract/pink = 2,
							/obj/item/slime_extract/gold = 2)

/datum/experiment/scanning/points/slime/expert
	name = "Expert Slime Survey"
	description = "The intergalactic society of xenobiologists are currently looking for samples of the most complex \
					slime cores, we are tasking your station with providing them with everything they need."
	required_points = 10
	required_atoms = list(/obj/item/slime_extract/adamantine = 1,
							/obj/item/slime_extract/oil = 1,
							/obj/item/slime_extract/black = 1,
							/obj/item/slime_extract/lightpink = 1,
							/obj/item/slime_extract/rainbow = 10)

/datum/experiment/scanning/random/cytology/easy
	name = "Basic Cytology Scanning Experiment"
	description = "A scientist needs vermin to test on, get us some simple critters!"
	total_requirement = 3
	max_requirement_per_type = 2
	possible_types = list(/mob/living/simple_animal/cockroach, /mob/living/simple_animal/mouse)

/datum/experiment/scanning/random/cytology/medium
	name = "Advanced Cytology Scanning Experiment"
	description = "We need to see how the body functions from the earliest moments. Some cytology experiments will help us gain this understanding."
	total_requirement = 3
	max_requirement_per_type = 2
	possible_types = list(/mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/retaliate/poison/snake, /mob/living/simple_animal/pet/cat, /mob/living/simple_animal/pet/dog/corgi, /mob/living/simple_animal/cow, /mob/living/simple_animal/chicken)

/datum/experiment/scanning/random/cytology/medium/one
	name = "Advanced Cytology Scanning Experiment One"

/datum/experiment/scanning/random/cytology/medium/two
	name = "Advanced Cytology Scanning Experiment Two"

/datum/experiment/scanning/random/janitor_trash
	name = "Station Hygiene Inspection"
	description = "To learn how to clean, we must first learn what it is to have filth. We need you to scan some filth around the station."
	possible_types = list(/obj/effect/decal/cleanable/vomit,
	/obj/effect/decal/cleanable/blood)
	total_requirement = 3

/datum/experiment/explosion/calibration
	name = "Is This Thing On?"
	description = "The engineers from last shift left a notice for us that the doppler array seemed to be malfunctioning. \
					Could you check that it is still working? Any explosion will do!"
	required_light = 1

/datum/experiment/explosion/maxcap
	name = "Mother of God"
	description = "A recent outbreak of a blood-cult in a nearby sector necessitates the development of a large explosive. \
					Create a large enough explosion to prove your bomb, we'll be watching."

/datum/experiment/explosion/medium
	name = "Explosive Ordinance Experiment"
	description = "Alright, can we really call ourselves professionals if we can't make shit blow up?"
	required_heavy = 2
	required_light = 6

/datum/experiment/explosion/maxcap/New()
	required_devastation = GLOB.MAX_EX_DEVESTATION_RANGE
	required_heavy = GLOB.MAX_EX_HEAVY_RANGE
	required_light = GLOB.MAX_EX_LIGHT_RANGE

/datum/experiment/scanning/random/material/meat
	name = "Biological Material Scanning Experiment"
	description = "They told us we couldn't make chairs out of every material in the world. You're here to prove those nay-sayers wrong."
	possible_material_types = list(/datum/material/meat)

/datum/experiment/scanning/random/material/easy
	name = "Low Grade Material Scanning Experiment"
	description = "Material science is all about a basic understanding of the universe, and how it's built. To explain this, build something basic and we'll show you how to break it."
	total_requirement = 6
	possible_types = list(/obj/structure/chair, /obj/structure/toilet, /obj/structure/table)
	possible_material_types = list(/datum/material/iron, /datum/material/glass)

/datum/experiment/scanning/random/material/medium
	name = "Medium Grade Material Scanning Experiment"
	description = "Not all materials are strong enough to hold together a space station. Look at these materials for example, and see what makes them useful for our electronics and equipment."
	possible_material_types = list(/datum/material/silver, /datum/material/gold, /datum/material/plastic, /datum/material/titanium)

/datum/experiment/scanning/random/material/medium/one
	name = "Medium Grade Material Scanning Experiment One"

/datum/experiment/scanning/random/material/medium/two
	name = "Medium Grade Material Scanning Experiment Two"

/datum/experiment/scanning/random/material/medium/three
	name = "Medium Grade Material Scanning Experiment Three"

/datum/experiment/scanning/random/material/hard
	name = "High Grade Material Scanning Experiment"
	description = "NT spares no expense to test even the most valuable of materials for their qualities as construction materials. Go build us some of these exotic creations and collect the data."
	possible_material_types = list(/datum/material/diamond, /datum/material/plasma, /datum/material/uranium)

/datum/experiment/scanning/random/material/hard/one
	name = "High Grade Material Scanning Experiment One"

/datum/experiment/scanning/random/material/hard/two
	name = "High Grade Material Scanning Experiment Two"

/datum/experiment/scanning/random/material/hard/three
	name = "High Grade Material Scanning Experiment Three"

/datum/experiment/scanning/points/teleport_bread
	name = "Biological Teleportation Scanning Experiment"
	description = "In order to prove that experimental teleportation technology is completely safe, we need you to teleport some bread. It surely will be fine!"
	required_points = 1
	required_atoms = list(/mob/living/simple_animal/hostile/bread = 1,
						  /obj/item/reagent_containers/food/snacks/store/bread/tumor_bread = 1,
						  /obj/item/reagent_containers/food/snacks/breadslice/tumor_bread = 1) //This is going to be hard

/datum/experiment/scanning/random/darkness
	name = "Photon Sensetivity Calibration Experiment"
	description = "To aquire night-vision technology, you'll need something to compare everything with. Make sure that it's something dark."
	total_requirement = 4
	max_requirement_per_type = 2

/datum/experiment/scanning/random/darkness/final_contributing_index_checks(atom/target, typepath)
	var/turf/T = get_turf(target)
	return T.get_lumcount() <= 0.05

/datum/experiment/scanning/points/anomalies
	name = "Anomaly Research Experiment"
	description = "To understand how anomalies work, you need to find some. Good luck with scanning them."
	required_points = 2
	required_atoms = list(/obj/effect/anomaly/flux = 1,
						  /obj/effect/anomaly/grav = 1,
						  /obj/effect/anomaly/pyro = 1,
						  /obj/effect/anomaly/bluespace = 2,
						  /obj/effect/anomaly/bhole = 2)

/datum/experiment/scanning/points/botany
	name = "Anomaly Research Experiment"
	description = "If life gives you lemons, make lemonade! Although it's not really clear what to do if life gives you hot peppers."
	required_points = 6
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown = 1)

/datum/experiment/scanning/points/botany/serialize_progress_stage(atom/target, list/seen_instances)
	var/scanned_total = traits & EXP_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len
	return EXP_PROG_INT("Scan samples of grown plants", scanned_total, required_atoms[target])

/datum/experiment/scanning/cybernetics
	name = "Cybernetics Research Experiment"
	description = "To make cybernetic eyes we need to research cybernetic eyes. Just scan some augmented humans for us and we will write the results down."
	required_atoms = list(/mob/living/carbon/human = 1)

/datum/experiment/scanning/cybernetics/serialize_progress_stage(atom/target, list/seen_instances)
	var/scanned_total = traits & EXP_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len
	return EXP_PROG_INT("Scan fully augmented humans", scanned_total, required_atoms[target])

/datum/experiment/scanning/cybernetics/final_contributing_index_checks(atom/target, typepath)
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/H = target
	for(var/obj/item/bodypart/L in H.bodyparts)
		if(!L.is_robotic_limb())
			return FALSE
	return TRUE
