
/mob/living/simple_animal/hostile/megafauna/dragon
	vore_active = TRUE
	vore_organs = list(new/datum/belly/megafauna/dragon/maw,
					new/datum/belly/megafauna/dragon/gullet,
					new/datum/belly/megafauna/dragon/gut)

/datum/belly/megafauna/dragon
	human_prey_swallow_time = 5 SECONDS // maybe enough to switch targets if distracted
	nonhuman_prey_swallow_time = 5 SECONDS

/datum/belly/megafauna/dragon/maw
	name = "maw"
	inside_flavor = "The maw of the dreaded Ash drake closes around you, engulfing you into a swelteringly hot, disgusting enviroment. The acidic saliva tingles over your form while that tongue pushes you further back...towards the dark gullet beyond."
	vore_verb = "scoop"
	datum/belly/transferlocation = /datum/belly/megafauna/dragon/gullet
	transferchance = 100
	vore_sound = 'sound/vore/pred/taurswallow.ogg'
	swallow_time = 10 SECONDS

/datum/belly/megafauna/dragon/gullet
	name = "gullet"
	inside_flavor = "A ripple of muscle and arching of the tongue pushes you down like any other food. Food you've become the moment you were consumed. The dark ambience of the outside world is replaced with working, wet flesh. Your only light being what you brought with you."
	swallow_time = 15 SECONDS
	datum/belly/transferlocation = /datum/belly/megafauna/dragon/gut
	transferchance = 100
	swallow_time = 5 SECONDS

/datum/belly/megafauna/dragon/gut
	name = "stomach"
	vore_capacity = 5 //I doubt this many people will actually last in the gut, but...
	inside_flavor = "With a rush of burning ichor greeting you, you're introduced to the Drake's stomach. Wrinkled walls greedily grind against you, acidic slimes working into your body as you become fuel and nutriton for a superior predator. All that's left is your body's willingness to resist your destiny."
	digest_mode = DM_DIGEST
	digest_burn = 5