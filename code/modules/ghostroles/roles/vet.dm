/datum/ghostrole/lavaland_vet
	name = "Lavaland Vet"
	desc = "You are a animal doctor who just woke up in lavaland"
	assigned_role = "Translocated Vet"
	spawntext = "What...? Where are you? Where are the others? This is still the animal hospital - you should know, you've been an intern here for weeks - but \
	you see them right now. So where is \
	everyone? Where did they go? What happened to the hospital? And is that <i>smoke</i> you smell? You need to find someone else. Maybe they c	everyone's gone. One of the cats scratched you just a few minutes ago. That's why you were in the pod - to heal the scratch. The scabs are still fresh; an tell you what happened."

//Broken rejuvenation pod: Spawns in animal hospitals in lavaland. Ghosts become disoriented interns and are advised to search for help.
/obj/structure/ghost_role_spawner/lavaland_vet
	name = "broken rejuvenation pod"
	desc = "A small sleeper typically used to instantly restore minor wounds. This one seems broken, and its occupant is comatose."
	role_type = /datum/ghostrole/lavaland_vet

/obj/structure/ghost_role_spawner/lavaland_vet/Destroy()
	var/obj/structure/fluff/empty_sleeper/S = new(drop_location())
	S.setDir(dir)
	return ..()
