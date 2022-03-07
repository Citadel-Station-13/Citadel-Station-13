/datum/ghostrole/lavaland_prisoner
	name = "Lavaland Prisoner"
	desc = "You're a prisoner, sentenced to hard work in one of Nanotrasen's labor camps, but it seems as though fate has other plans for you."
	instantiator = /datum/ghostrole_instantiator/human/random/lavaland_prisoner
	assigned_role = "Escaped Prisoner"

/datum/ghostrole/lavaland_prisoner/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint)
	. = ..()
	var/list/crimes = list("murder", "larceny", "embezzlement", "unionization", "dereliction of duty", "kidnapping", "gross incompetence", "grand theft", "collaboration with the Syndicate", \
	"worship of a forbidden deity", "interspecies relations", "mutiny")
	to_chat(created, span_danger("Good. It seems as though your ship crashed. You remember that you were convicted of [pick(crimes)]. but regardless of that, it seems like your crime doesn't matter now. You don't know where you are, but you know that it's out to kill you, and you're not going \
	to lose this opportunity. Find a way to get out of this mess and back to where you rightfully belong - your [pick("house", "apartment", "spaceship", "station")]."))

/datum/ghostrole_instantiator/human/random/lavaland_prisoner
	equip_outfit = /datum/outfit/lavalandprisoner

/datum/ghostrole_instantiator/human/random/lavaland_prisoner/Randomize(mob/living/carbon/human/H, list/params)
	. = ..()
	H.real_name = "NTP #LL-0[rand(111,999)]" //Nanotrasen Prisoner #Lavaland-(numbers)
	H.name = H.real_name

//Prisoner containment sleeper: Spawns in crashed prison ships in lavaland. Ghosts become escaped prisoners and are advised to find a way out of the mess they've gotten themselves into.
/obj/structure/ghost_role_spawner/prisoner_transport
	name = "prisoner containment sleeper"
	desc = "A sleeper designed to put its occupant into a deep coma, unbreakable until the sleeper turns off. This one's glass is cracked and you can see a pale, sleeping face staring out."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	role_type = /datum/ghostrole/lavaland_prisoner

/datum/outfit/lavalandprisoner
	name = "Lavaland Prisoner"
	uniform = /obj/item/clothing/under/rank/prisoner
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/sneakers/orange
	r_pocket = /obj/item/tank/internals/emergency_oxygen

/obj/structure/ghost_role_spawner/prisoner_transport/Destroy()
	new/obj/structure/fluff/empty_sleeper/syndicate(get_turf(src))
	return ..()
