/obj/machinery/computer/arcade/datingsim
	name = "DatingSim"
	desc = "Pretend you can actually get laid"
	icon_state = "arcade"
	icon_keyboard = null
	icon_screen = "invaders"
	clockwork = TRUE
	var/list/prizes = list(
		/obj/item/clothing/under/maid = 5,
		/obj/item/clothing/under/stripper_pink = 5,
		/obj/item/clothing/under/stripper_green = 5,
		/obj/item/dildo/custom = 5,
		/obj/item/restraints/handcuffs/fake/kinky = 5,
		/obj/item/clothing/neck/petcollar = 5,
		/obj/item/clothing/under/mankini = 1,
		/obj/item/dildo/flared/huge = 1,
		/obj/item/electropack/shockcollar = 3,
		/obj/item/clothing/neck/petcollar/locked = 1,
		)
	circuit = /obj/item/circuitboard/computer/arcade/datingsim
	var/date_name = "Space Waifu"
	var/temp = "Pretend to Get Laid!" //Temporary message, for attack messages, etc
	var/day = 1
	var/day_time = 12 //Player health/attack points
	var/player_money = 100
	var/player_strength = 3
	var/player_charm = 3
	var/player_intel = 3
	var/enemy_love = 10 //Enemy health/attack points
	var/enemy_lust = 20
	var/gameover = FALSE
	var/blocked = FALSE //Player cannot attack/heal while set
	var/turtle = 0

/obj/machinery/computer/arcade/datingsim/Reset()
	var/name_action
	var/name_part1
	var/name_part2

	name_action = pick("Yiff ", "Fuck ", "Screw ", "Cuddle ", "Glomp ", "Dominate ", "Romance ")

	name_part1 = pick("Crystal the ","Syntheia the ","Robin the ","Cheryl the","Sekke the ")
	name_part2 = pick("Fox","Human","Plasmaman","Podperson","Angel","Princess","Hedgehog","Bat","Echidna","Wolf","Cat","Lizard","Snake")

	date_name = (name_part1 + name_part2)
	name = (name_action + name_part1 + name_part2)

/obj/machinery/computer/arcade/datingsim/ui_interact(mob/user)
	. = ..()
	var/dat = "<a href='byond://?src=[REF(src)];close=1'>Close</a>"
	dat += "<center><h4>[date_name]</h4></center>"

	dat += "<br><center><h3>[temp]</h3></center>"
	dat += "<br><center>Hours Left: [day_time] Day: [day] | Money: $[player_money] | S: [player_strength] C: [player_charm] I: [player_intel] | Date Love: [enemy_love] Date Lust: [enemy_lust]</center>"

	if (gameover)
		dat += "<center><b><a href='byond://?src=[REF(src)];newgame=1'>New Game</a>"
	else
		dat += "<center><b><a href='byond://?src=[REF(src)];talk=1'>Talk</a> | "
		dat += "<a href='byond://?src=[REF(src)];date=1'>Date</a> | "
		dat += "<a href='byond://?src=[REF(src)];flirt=1'>Flirt</a> "

		dat += "<br><a href='byond://?src=[REF(src)];work=1'>Work</a> | "
		dat += "<a href='byond://?src=[REF(src)];gym=1'>Gym</a> | "
		dat += "<a href='byond://?src=[REF(src)];study=1'>Study</a> | "
		dat += "<a href='byond://?src=[REF(src)];gym=1'>Gym</a> | "

		dat += "<br><a href='byond://?src=[REF(src)];sleep=1'>Sleep</a> | "

	dat += "</b></center>"
	var/datum/browser/popup = new(user, "arcade", "Space Villain 2000")
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/computer/arcade/datingsim/Topic(href, href_list)
	if(..())
		return

	if (!blocked && !gameover)
		if (href_list["talk"])
			blocked = TRUE
			temp = "You try to talk to [date_name]!"
			var/datecost = 0
			var/datelove = pick(5,5,5,10,10,-10,-10,20,20)
			var/datelust = pick(3,3,3,10,5,5)
			var/dating = 1
			//playsound(loc, 'sound/arcade/hit.ogg', 50, 1, extrarange = -3, falloff = 10)
			updateUsrDialog()
			if(turtle > 0)
				turtle--

			sleep(10)
			day_time -= 1
			arcade_action(usr)

		else if (href_list["date"])
			var/datecost = pick(5,5,5,5,10,10,10,10,10,10,10,10,50,50,100)
			var/datelove = pick(5,5,5,10,10,-10,-10,20,20)
			var/datelust = pick(3,3,3,10,5,5)
			var/dating = 1
			blocked = TRUE
			updateUsrDialog()
			player_money -= datecost
			sleep(10)
			arcade_action(usr)

		else if (href_list["flirt"])
			blocked = TRUE
			var/flirting = 1

			updateUsrDialog()
			sleep(10)
			arcade_action(usr)

		else if (href_list["gym"])
			blocked = TRUE
			var/chargeamt = rand(4,7)
			temp = "You get [chargeamt] points stronger!"
			playsound(loc, 'sound/arcade/mana.ogg', 50, 1, extrarange = -3, falloff = 10)
			player_strength += chargeamt
			if(turtle > 0)
				turtle--

			updateUsrDialog()
			sleep(10)
			arcade_action(usr)

		else if (href_list["work"])
			blocked = TRUE
			var/pay = rand(10,50)
			temp = "You make $[pay]"
			playsound(loc, 'sound/arcade/mana.ogg', 50, 1, extrarange = -3, falloff = 10)
			player_money += pay
			if(turtle > 0)
				turtle--

			updateUsrDialog()
			sleep(10)
			arcade_action(usr)

		else if (href_list["study"])
			blocked = TRUE
			var/chargeamt = rand(4,7)
			temp = "You get [chargeamt] smarter!"
			playsound(loc, 'sound/arcade/mana.ogg', 50, 1, extrarange = -3, falloff = 10)
			player_intel += chargeamt
			if(turtle > 0)
				turtle--

			updateUsrDialog()
			sleep(10)
			arcade_action(usr)

		else if (href_list["sleep"])
			blocked = TRUE
			var/chargeamt = rand(4,7)
			temp = "You pay $10 in rent!"
			playsound(loc, 'sound/arcade/mana.ogg', 50, 1, extrarange = -3, falloff = 10)
			player_intel += chargeamt
			if(turtle > 0)
				turtle--

			updateUsrDialog()
			sleep(10)
			arcade_action(usr)

	if (href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=arcade")

	else if (href_list["newgame"]) //Reset everything
	temp = "New Round"
	var/day = 1
	var/day_time = 0 //Player health/attack points
	var/player_money = 100
	var/player_strength = 3
	var/player_charm = 3
	var/player_intel = 3
	var/enemy_love = 10 //Enemy health/attack points
	var/enemy_lust = 20
	var/gameover = FALSE
	var/turtle = 0

		if(obj_flags & EMAGGED)
			Reset()
			obj_flags &= ~EMAGGED

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/arcade/datingsim/proc/arcade_action(mob/user)
	var/defense = player_strength * player_charm * player_intel
	var/str_mod = player_strength - 10
	var/charm_mod = player_charm - 10
	var/intel_mod = player_intel - 10
	if ((enemy_love >= 100) & (enemy_lust >= 100))
		if(!gameover)
			gameover = TRUE
			temp = "You screwed [date_name]! Rejoice!"
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

	else if (dating)
		if (datecost == 0)
			enemy_love += rand(1,5) + (date_love + str_mod + charm_mod + intel_mod)
		else
			enemy_love += rand(1,5) + (date_love + str_mod + charm_mod + intel_mod)
			enemy_lust += rand(1,5) + (date_love + str_mod + charm_mod + intel_mod)

	else if (flirting)
		var/flirtval = rand(1,99)
		enemy_lust += flirtval
		enemy_love -= (flirtval - defense)

	else if ((enemy_love <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		temp = "[enemy_name] kicks you in the balls!"
		playsound(loc, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 10)
		player_strength -= stealamt
		updateUsrDialog()

		if (enemy_love <= 0)
			gameover = TRUE
			sleep(10)
			temp = "[date_name] hates you! GAME OVER"
			playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
			if(obj_flags & EMAGGED)
				usr.gib()
			SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "mana", (obj_flags & EMAGGED ? "emagged":"normal")))


	else if(player_money <= 0)
		sleep (10)
		temp = "You went broke, asshole! You beg [date_name] for money!"
		playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
		var/loselove = rand(10,50)

	if (day_time <= 0)
		gameover = TRUE
		sleep (10)
		temp = "You overexert yourself and die. GAME OVER"
		if(obj_flags & EMAGGED)
			usr.gib()
		playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)

	if (player_strength <= 0)
		gameover = TRUE
		temp = "You have a heart attack and die! GAME OVER"
		playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
		if(obj_flags & EMAGGED)
			usr.gib()
		SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "strength", (obj_flags & EMAGGED ? "emagged":"normal")))

	if (player_charm <= 0)
		gameover = TRUE
		temp = "You are \"mistaken\" for a disgusting monster and shot! GAME OVER"
		playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
		if(obj_flags & EMAGGED)
			usr.gib()
		SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "charm", (obj_flags & EMAGGED ? "emagged":"normal")))

	if (player_intelligence <= 0)
		gameover = TRUE
		temp = "You forget to breathe and die! GAME OVER"
		playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
		if(obj_flags & EMAGGED)
			usr.gib()
		SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "intelligence", (obj_flags & EMAGGED ? "emagged":"normal")))

	if (enemy_love <= 0)
		gameover = TRUE
		temp = "[date_name] hates you! GAME OVER"
		playsound(loc, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
		if(obj_flags & EMAGGED)
			usr.gib()
		SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "love", (obj_flags & EMAGGED ? "emagged":"normal")))

	blocked = FALSE
	return
