/datum/ghostrole/seed_vault
	name = "Lifebringer"
	desc = "You are a sentient ecosystem, an example of the mastery over life that your creators possessed."
	spawntext = "Your masters, benevolent as they were, created uncounted seed vaults and spread them across \
	the universe to every planet they could chart. You are in one such seed vault. \
	Your goal is to cultivate and spread life wherever it will go while waiting for contact from your creators. \
	Estimated time of last contact: Deployment, 5000 millennia ago."
	assigned_role = "Lifebringer"
	instantiator = /datum/ghostrole_instantiator/human/random/seed_vault

/datum/ghostrole_instantiator/human/random/seed_vault
	mob_traits = list(
		TRAIT_EXEMPT_HEALTH_EVENTS
	)

/datum/ghostrole_instantiator/human/random/seed_vault/Randomize(mob/living/carbon/human/H, list/params)
	. = ..()
	H.set_species(new /datum/species/pod)
	var/plant_name = pick("Tomato", "Potato", "Broccoli", "Carrot", "Ambrosia", "Pumpkin", "Ivy", "Kudzu", "Banana", "Moss", "Flower", "Bloom", "Root", "Bark", "Glowshroom", "Petal", "Leaf", \
	"Venus", "Sprout","Cocoa", "Strawberry", "Citrus", "Oak", "Cactus", "Pepper", "Juniper")
	H.real_name = plant_name //why this works when moving it from one function to another is beyond me
	H.underwear = "Nude" //You're a plant, partner
	H.undershirt = "Nude" //changing underwear/shirt/socks doesn't seem to function correctly right now because of some bug elsewhere?
	H.socks = "Nude"
	H.update_body(TRUE)
	H.language_holder.selected_language = /datum/language/sylvan

//Preserved terrarium/seed vault: Spawns in seed vault structures in lavaland. Ghosts become plantpeople and are advised to begin growing plants in the room near them.
/obj/structure/ghost_role_spawner/seed_vault
	name = "preserved terrarium"
	desc = "An ancient machine that seems to be used for storing plant matter. The glass is obstructed by a mat of vines."
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "terrarium"
	role_type = /datum/ghostrole/seed_vault

/obj/structure/ghost_role_spawner/seed_vault/Destroy()
	new/obj/structure/fluff/empty_terrarium(get_turf(src))
	return ..()
