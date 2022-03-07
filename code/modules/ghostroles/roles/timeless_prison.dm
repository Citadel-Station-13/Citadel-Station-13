/datum/ghostrole/timeless_prison
	name = "Timeless Prisoner"
	desc = "Years ago, you sacrificed the lives of your trusted friends and the humanity of yourself to reach the Wish Granter. Though you \
	did so, it has come at a cost: your very body rejects the light, dooming you to wander endlessly in this horrible wasteland."
	instantiator = /datum/ghostrole_instantiator/human/random/species/shadow
	assigned_role = "Exile"

/datum/ghostrole/timeless_prison/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/wish = rand(1,4)
	switch(wish)
		if(1)
			to_chat(created, "<b>You wished to kill, and kill you did. You've lost track of how many, but the spark of excitement that murder once held has winked out. You feel only regret.</b>")
		if(2)
			to_chat(created, "<b>You wished for unending wealth, but no amount of money was worth this existence. Maybe charity might redeem your soul?</b>")
		if(3)
			to_chat(created, "<b>You wished for power. Little good it did you, cast out of the light. You are the [created.gender == MALE ? "king" : "queen"] of a hell that holds no subjects. You feel only remorse.</b>")
		if(4)
			to_chat(created, "<b>You wished for immortality, even as your friends lay dying behind you. No matter how many times you cast yourself into the lava, you awaken in this room again within a few days. There is no escape.</b>")

/datum/ghostrole_instantiator/human/random/species/shadow
	possible_species = list(
		/datum/species/shadow
	)

/datum/ghostrole_instantiator/human/random/species/shadow/timeless_prison/Randomize(mob/living/carbon/human/H, list/params)
	. = ..()
	H.real_name = "Wish Granter's Victim ([rand(1,999)])"

//Timeless prisons: Spawns in Wish Granter prisons in lavaland. Ghosts become age-old users of the Wish Granter and are advised to seek repentance for their past.
/obj/structure/ghost_role_spawner/exile
	name = "timeless prison"
	desc = "Although this stasis pod looks medicinal, it seems as though it's meant to preserve something for a very long time."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	role_type = /datum/ghostrole/timeless_prison

/obj/structure/ghost_role_spawner/exile/Destroy()
	new/obj/structure/fluff/empty_sleeper(get_turf(src))
	return ..()
