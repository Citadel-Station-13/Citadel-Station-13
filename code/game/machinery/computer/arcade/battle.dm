// ** BATTLE ** //

/obj/machinery/computer/arcade/battle
	name = "arcade machine"
	desc = "Does not support Pinball."
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade/battle
	arcade_comptype = /datum/component/arcade/battle

/obj/machinery/computer/arcade/battle/Initialize()
	. = ..()
	Reset()

/obj/machinery/computer/arcade/battle/proc/Reset()
	var/name_action
	var/name_part1
	var/name_part2

	name_action = pick("Defeat ", "Annihilate ", "Save ", "Strike ", "Stop ", "Destroy ", "Robust ", "Romance ", "Pwn ", "Own ", "Ban ")

	name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread King ", "the Space ", "Lord ", "the Great ", "Duke ", "General ")
	name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "slime", "Griefer", "ERPer", "Lizard Man", "Unicorn", "Bloopers")

	. = replacetext((name_part1 + name_part2), "the ", "") //return value for the comp enemy name
	name = (name_action + name_part1 + name_part2)

/obj/machinery/computer/arcade/battle/new_game(mob/user, emagged = FALSE)
	if(emagged)
		name = "Outbomb Cuban Pete"
		. = "Cuban Pete"
	else if(name == "Outbomb Cuban Pete") //mmmh
		. = Reset()

/obj/machinery/computer/arcade/battle/victory(mob/user, emagged = FALSE, list/rarity_classes)
	if(emagged)
		new /obj/effect/spawner/newbomb/timer/syndicate(loc)
		new /obj/item/clothing/head/collectable/petehat(loc)
		message_admins("[ADMIN_LOOKUPFLW(user)] has outbombed Cuban Pete and been awarded a bomb.")
		log_game("[key_name(user)] has outbombed Cuban Pete and been awarded a bomb.")
		. = Reset()
	else
		return ..()

/obj/machinery/computer/arcade/battle/loss(mob/user, emagged = FALSE)
	playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
	if(emagged)
		usr.gib()
		. = Reset()