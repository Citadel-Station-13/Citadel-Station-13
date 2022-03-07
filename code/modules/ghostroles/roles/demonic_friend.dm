/datum/ghostrole/demonic_friend
	name = "Demonic Friend"
	desc = "You are someone's demonic friend from hell."
	instantiator = /datum/ghostrole_instantiator/human/random/demonic_friend
	assigned_role = "SuperFriend"

/datum/ghostrole/demonic_friend/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	if(params["spell"])
		var/obj/effect/proc_holder/spell/targeted/summon_friend/S = spawnpoint?.params["spell"]
		S.friend = created
		S.charge_counter = S.charge_max
	if(!created.mind)
		CRASH("No mind")
	created.mind.hasSoul = FALSE
	if(params["owner"])
		var/datum/mind/owner = spawnpoint.params["owner"]
		soullink(/datum/soullink/oneway, owner.current, created)
		created.name = created.real_name
		created.real_name = "[owner.name]'s best friend"
		if(QDELETED(owner.current) || owner.current.stat == DEAD)
			addtimer(CALLBACK(created, /mob/proc/dust), 15 SECONDS)
	else
		addtimer(CALLBACK(created, /mob/proc/dust), 15 SECONDS)

/datum/ghostrole/demonic_friend/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	if(params["owner"])
		var/datum/mind/owner = spawnpoint?.params["owner"]
		to_chat(created, "You have been given a reprieve from your eternity of torment, to be [owner.name]'s friend for their short mortal coil.")
		to_chat(created, "Be aware that if you do not live up to their expectations, they can send you back to hell with a single thought. [owner.name]'s death will also return you to hell.")
		if(QDELETED(owner.current) || owner.current.stat == DEAD)
			to_chat(created, span_danger("Your owner is already dead! You will soon perish."))
		else
			GiveCustomObjective(created, "Be [owner.name]'s friend, and keep them alive, so you don't get sent back to hell.")
	else
		to_chat(created, span_danger("Your owner is already dead! You will soon perish."))

/datum/ghostrole_instantiator/human/random/demonic_friend
	equip_outfit = /datum/outfit/demonic_friend

/datum/ghostrole_instantiator/human/random/demonic_friend/Equip(client/C, mob/M, list/params)
	. = ..()
	var/mob/living/carbon/human/H = .
	if(!istype(H))
		return
	var/obj/item/card/id/ID = H.wear_id?.GetID()
	if(ID && params["owner"])
		var/datum/mind/_M = params["owner"]
		ID.registered_name = "[_M.name]'s best friend"
		ID.update_label()

/obj/structure/ghost_role_spawner/demonic_friend
	name = "Essence of friendship"
	desc = "Oh boy! Oh boy! A friend!"
	icon = 'icons/obj/cardboard_cutout.dmi'
	icon_state = "cutout_basic"
	role_type = /datum/ghostrole/demonic_friend

/datum/outfit/demonic_friend
	name = "Demonic Friend"
	uniform = /obj/item/clothing/under/misc/assistantformal
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/radio/off
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/mindshield) //No revolutionaries, he's MY friend.
	id = /obj/item/card/id
	access_clone = /datum/job/assistant
