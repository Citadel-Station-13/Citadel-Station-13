// ** BATTLE ** //


/obj/machinery/computer/arcade/battle
	name = "arcade machine"
	desc = "Does not support Pinball."
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade/battle
	var/enemy_name = "Space Villain"
	var/temp = "Winners don't use space drugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = FALSE
	var/blocked = FALSE //Player cannot attack/heal while set
	var/turtle = 0

	var/turn_speed = 5 //Measured in deciseconds.

/obj/machinery/computer/arcade/battle/Reset()
	var/name_action
	var/name_part1
	var/name_part2

	name_action = pick("Defeat ", "Annihilate ", "Save ", "Strike ", "Stop ", "Destroy ", "Robust ", "Romance ", "Pwn ", "Own ", "Ban ")

	name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread King ", "the Space ", "Lord ", "the Great ", "Duke ", "General ")
	name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "slime", "Griefer", "ERPer", "Lizard Man", "Unicorn", "Bloopers")

	enemy_name = replacetext((name_part1 + name_part2), "the ", "")
	name = (name_action + name_part1 + name_part2)

/obj/machinery/computer/arcade/battle/ui_interact(mob/user)
	. = ..()
	var/dat = "<a href='byond://?src=[REF(src)];close=1'>Close</a>"
	dat += "<center><h4>[enemy_name]</h4></center>"

	dat += "<br><center><h3>[temp]</h3></center>"
	dat += "<br><center>Health: [player_hp] | Magic: [player_mp] | Enemy Health: [enemy_hp]</center>"

	if (gameover)
		dat += "<center><b><a href='byond://?src=[REF(src)];newgame=1'>New Game</a>"
	else
		dat += "<center><b><a href='byond://?src=[REF(src)];attack=1'>Attack</a> | "
		dat += "<a href='byond://?src=[REF(src)];heal=1'>Heal</a> | "
		dat += "<a href='byond://?src=[REF(src)];charge=1'>Recharge Power</a>"

	dat += "</b></center>"
	var/datum/browser/popup = new(user, "arcade", "Space Villain 2000")
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/arcade/battle/Topic(href, href_list)
	if(..())
		return

	if (!blocked && !gameover)
		if (href_list["attack"])
			blocked = TRUE
			var/attackamt = rand(2,6)
			temp = "You attack for [attackamt] damage!"
			playsound(loc, 'sound/arcade/hit.ogg', 50, 1, extrarange = -3, falloff = 10)
			updateUsrDialog()
			if(turtle > 0)
				turtle--

			sleep(turn_speed)
			enemy_hp -= attackamt
			arcade_action(usr)

		else if (href_list["heal"])
			blocked = TRUE
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			temp = "You use [pointamt] magic to heal for [healamt] damage!"
			playsound(loc, 'sound/arcade/heal.ogg', 50, 1, extrarange = -3, falloff = 10)
			updateUsrDialog()
			turtle++

			sleep(turn_speed)
			player_mp -= pointamt
			player_hp += healamt
			blocked = TRUE
			updateUsrDialog()
			arcade_action(usr)

		else if (href_list["charge"])
			blocked = TRUE
			var/chargeamt = rand(4,7)
			temp = "You regain [chargeamt] points"
			playsound(loc, 'sound/arcade/mana.ogg', 50, 1, extrarange = -3, falloff = 10)
			player_mp += chargeamt
			if(turtle > 0)
				turtle--

			updateUsrDialog()
			sleep(turn_speed)
			arcade_action(usr)

	if (href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=arcade")

	else if (href_list["newgame"]) //Reset everything
		temp = "New Round"
		player_hp = initial(player_hp)
		player_mp = initial(player_mp)
		enemy_hp = initial(enemy_hp)
		enemy_mp = initial(enemy_mp)
		gameover = FALSE
		turtle = 0

		if(obj_flags & EMAGGED)
			Reset()
			obj_flags &= ~EMAGGED

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/arcade/battle/proc/arcade_action(mob/user)
	if ((enemy_mp <= 0) || (enemy_hp <= 0))
		if(!gameover)
			gameover = TRUE
			temp = "[enemy_name] has fallen! Rejoice!"
			playsound(loc, 'sound/arcade/win.ogg', 50, 1, extrarange = -3, falloff = 10)

			if(obj_flags & EMAGGED)
				new /obj/effect/spawner/newbomb/timer/syndicate(loc)
				new /obj/item/clothing/head/collectable/petehat(loc)
				message_admins("[ADMIN_LOOKUPFLW(usr)] has outbombed Cuban Pete and been awarded a bomb.")
				log_game("[key_name(usr)] has outbombed Cuban Pete and been awarded a bomb.")
				Reset()
				obj_flags &= ~EMAGGED
			else
				prizevend(user)
			SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("win", (obj_flags & EMAGGED ? "emagged":"normal")))


	else if ((obj_flags & EMAGGED) && (turtle >= 4))
		var/boomamt = rand(5,10)
		temp = "[enemy_name] throws a bomb, exploding you for [boomamt] damage!"
		playsound(loc, 'sound/arcade/boom.ogg', 50, 1, extrarange = -3, falloff = 10)
		player_hp -= boomamt

	else if ((enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		temp = "[enemy_name] steals [stealamt] of your power!"
		playsound(loc, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 10)
		player_mp -= stealamt
		updateUsrDialog()

		if (player_mp <= 0)
			gameover = TRUE
			sleep(turn_speed)
			temp = "You have been drained! GAME OVER"
			playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
			if(obj_flags & EMAGGED)
				usr.gib()
			SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "mana", (obj_flags & EMAGGED ? "emagged":"normal")))

	else if ((enemy_hp <= 10) && (enemy_mp > 4))
		temp = "[enemy_name] heals for 4 health!"
		playsound(loc, 'sound/arcade/heal.ogg', 50, 1, extrarange = -3, falloff = 10)
		enemy_hp += 4
		enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		temp = "[enemy_name] attacks for [attackamt] damage!"
		playsound(loc, 'sound/arcade/hit.ogg', 50, 1, extrarange = -3, falloff = 10)
		player_hp -= attackamt

	if ((player_mp <= 0) || (player_hp <= 0))
		gameover = TRUE
		temp = "You have been crushed! GAME OVER"
		playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
		if(obj_flags & EMAGGED)
			usr.gib()
		SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "hp", (obj_flags & EMAGGED ? "emagged":"normal")))

	blocked = FALSE
	return

/obj/machinery/computer/arcade/battle/examine_more(mob/user)
	to_chat(user, "<span class='notice'>Scribbled on the side of the Arcade Machine you notice some writing...\
	\nmagical -> >=50 power\
	\nsmart -> defend, defend, light attack\
	\nshotgun -> defend, defend, power attack\
	\nshort temper -> counter, counter, counter\
	\npoisonous -> light attack, light attack, light attack\
	\nchonker -> power attack, power attack, power attack</span>")
	return ..()

/obj/machinery/computer/arcade/battle/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	to_chat(user, "<span class='warning'>A mesmerizing Rhumba beat starts playing from the arcade machine's speakers!</span>")
	temp = "If you die in the game, you die for real!"
	player_hp = 30
	player_mp = 10
	enemy_hp = 45
	enemy_mp = 20
	gameover = FALSE
	blocked = FALSE

	obj_flags |= EMAGGED

	enemy_name = "Cuban Pete"
	name = "Outbomb Cuban Pete"

	updateUsrDialog()
	return TRUE