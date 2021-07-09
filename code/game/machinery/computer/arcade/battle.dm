// ** BATTLE ** //
/obj/machinery/computer/arcade/battle
	name = "arcade machine"
	desc = "Does not support Pinball."
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade/battle

	var/enemy_name = "Space Villain"
	///Enemy health/attack points
	var/enemy_hp = 100
	var/enemy_mp = 40
	///Temporary message, for attack messages, etc
	var/temp = "<br><center><h3>Winners don't use space drugs<center><h3>"
	///the list of passive skill the enemy currently has. the actual passives are added in the enemy_setup() proc
	var/list/enemy_passive
	///if all the enemy's weakpoints have been triggered becomes TRUE
	var/finishing_move = FALSE
	///linked to passives, when it's equal or above the max_passive finishing move will become TRUE
	var/pissed_off = 0
	///the number of passives the enemy will start with
	var/max_passive = 3
	///weapon wielded by the enemy, the shotgun doesn't count.
	var/chosen_weapon

	///Player health
	var/player_hp = 85
	///player magic points
	var/player_mp = 20
	///used to remember the last three move of the player before this turn.
	var/list/last_three_move
	///if the enemy or player died. restart the game when TRUE
	var/gameover = FALSE
	///the player cannot make any move while this is set to TRUE. should only TRUE during enemy turns.
	var/blocked = FALSE
	///used to clear the enemy_action proc timer when the game is restarted
	var/timer_id
	///weapon used by the enemy, pure fluff.for certain actions
	var/list/weapons
	///unique to the emag mode, acts as a time limit where the player dies when it reaches 0.
	var/bomb_cooldown = 19

///creates the enemy base stats for a new round along with the enemy passives
/obj/machinery/computer/arcade/battle/proc/enemy_setup(player_skill)
	player_hp = 85
	player_mp = 20
	enemy_hp = 100
	enemy_mp = 40
	gameover = FALSE
	blocked = FALSE
	finishing_move = FALSE
	pissed_off = 0
	last_three_move = null

	enemy_passive = list("short_temper" = TRUE, "poisonous" = TRUE, "smart" = TRUE, "shotgun" = TRUE, "magical" = TRUE, "chonker" = TRUE)
	for(var/i = LAZYLEN(enemy_passive); i > max_passive; i--) //we'll remove passives from the list until we have the number of passive we want
		var/picked_passive = pick(enemy_passive)
		LAZYREMOVE(enemy_passive, picked_passive)

	if(LAZYACCESS(enemy_passive, "chonker"))
		enemy_hp += 20

	if(LAZYACCESS(enemy_passive, "shotgun"))
		chosen_weapon = "shotgun"
	else if(weapons)
		chosen_weapon = pick(weapons)
	else
		chosen_weapon = "null gun" //if the weapons list is somehow empty, shouldn't happen but runtimes are sneaky bastards.

	if(player_skill)
		player_hp += player_skill * 2

/obj/machinery/computer/arcade/battle/Reset()
	max_passive = 3
	var/name_action
	var/name_part1
	var/name_part2

	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		name_action = pick_list(ARCADE_FILE, "rpg_action_halloween")
		name_part1 = pick_list(ARCADE_FILE, "rpg_adjective_halloween")
		name_part2 = pick_list(ARCADE_FILE, "rpg_enemy_halloween")
		weapons = strings(ARCADE_FILE, "rpg_weapon_halloween")
	else if(SSevents.holidays && SSevents.holidays[CHRISTMAS])
		name_action = pick_list(ARCADE_FILE, "rpg_action_xmas")
		name_part1 = pick_list(ARCADE_FILE, "rpg_adjective_xmas")
		name_part2 = pick_list(ARCADE_FILE, "rpg_enemy_xmas")
		weapons = strings(ARCADE_FILE, "rpg_weapon_xmas")
	else if(SSevents.holidays && SSevents.holidays[VALENTINES])
		name_action = pick_list(ARCADE_FILE, "rpg_action_valentines")
		name_part1 = pick_list(ARCADE_FILE, "rpg_adjective_valentines")
		name_part2 = pick_list(ARCADE_FILE, "rpg_enemy_valentines")
		weapons = strings(ARCADE_FILE, "rpg_weapon_valentines")
	else
		name_action = pick_list(ARCADE_FILE, "rpg_action")
		name_part1 = pick_list(ARCADE_FILE, "rpg_adjective")
		name_part2 = pick_list(ARCADE_FILE, "rpg_enemy")
		weapons = strings(ARCADE_FILE, "rpg_weapon")

	enemy_name = ("The " + name_part1 + " " + name_part2)
	name = (name_action + " " + enemy_name)

	enemy_setup(0) //in the case it's reset we assume the player skill is 0 because the VOID isn't a gamer

/obj/machinery/computer/arcade/battle/ui_interact(mob/user)
	. = ..()
	screen_setup(user)

///sets up the main screen for the user
/obj/machinery/computer/arcade/battle/proc/screen_setup(mob/user)
	var/dat = "<a href='byond://?src=[REF(src)];close=1'>Close</a>"
	dat += "<center><h4>[enemy_name]</h4></center>"

	dat += "[temp]"
	dat += "<br><center>Health: [player_hp] | Magic: [player_mp] | Enemy Health: [enemy_hp]</center>"

	if (gameover)
		dat += "<center><b><a href='byond://?src=[REF(src)];newgame=1'>New Game</a>"
	else
		dat += "<center><b><a href='byond://?src=[REF(src)];attack=1'>Light attack</a>"
		dat += "<center><b><a href='byond://?src=[REF(src)];defend=1'>Defend</a>"
		dat += "<center><b><a href='byond://?src=[REF(src)];counter_attack=1'>Counter attack</a>"
		dat += "<center><b><a href='byond://?src=[REF(src)];power_attack=1'>Power attack</a>"

	dat += "</b></center>"
	if(user.client) //mainly here to avoid a runtime when the player gets gibbed when losing the emag mode.
		var/datum/browser/popup = new(user, "arcade", "Space Villain 2000")
		popup.set_content(dat)
		popup.open()

/obj/machinery/computer/arcade/battle/Topic(href, href_list)
	if(..())
		return
	var/gamerSkill = 0
	// if(usr?.mind)
	// 	gamerSkill = usr.mind.get_skill_level(/datum/skill/gaming)

	if (!blocked && !gameover)
		var/attackamt = usr.rand_good(5,7) + usr.rand_good(0, gamerSkill)

		if(finishing_move) //time to bonk that fucker,cuban pete will sometime survive a finishing move.
			attackamt *= 100

		//light attack suck absolute ass but it doesn't cost any MP so it's pretty good to finish an enemy off
		if (href_list["attack"])
			temp = "<br><center><h3>you do quick jab for [attackamt] of damage!</h3></center>"
			enemy_hp -= attackamt
			arcade_action(usr,"attack",attackamt)

		//defend lets you gain back MP and take less damage from non magical attack.
		else if(href_list["defend"])
			temp = "<br><center><h3>you take a defensive stance and gain back 10 mp!</h3></center>"
			player_mp += 10
			arcade_action(usr,"defend",attackamt)
			playsound(src, 'sound/arcade/mana.ogg', 50, TRUE, extrarange = -3)

		//mainly used to counter short temper and their absurd damage, will deal twice the damage the player took of a non magical attack.
		else if(href_list["counter_attack"] && player_mp >= 10)
			temp = "<br><center><h3>you prepare yourself to counter the next attack!</h3></center>"
			player_mp -= 10
			arcade_action(usr,"counter_attack",attackamt)
			playsound(src, 'sound/arcade/mana.ogg', 50, TRUE, extrarange = -3)

		else if(href_list["counter_attack"] && player_mp < 10)
			temp = "<br><center><h3>you don't have the mp necessary to counter attack and defend yourself instead</h3></center>"
			player_mp += 10
			arcade_action(usr,"defend",attackamt)
			playsound(src, 'sound/arcade/mana.ogg', 50, TRUE, extrarange = -3)

		//power attack deals twice the amount of damage but is really expensive MP wise, mainly used with combos to get weakpoints.
		else if (href_list["power_attack"] && player_mp >= 20)
			temp = "<br><center><h3>You attack [enemy_name] with all your might for [attackamt * 2] damage!</h3></center>"
			enemy_hp -= attackamt * 2
			player_mp -= 20
			arcade_action(usr,"power_attack",attackamt)

		else if(href_list["power_attack"] && player_mp < 20)
			temp = "<br><center><h3>You don't have the mp necessary for a power attack and settle for a light attack!</h3></center>"
			enemy_hp -= attackamt
			arcade_action(usr,"attack",attackamt)

	if (href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=arcade")

	else if (href_list["newgame"]) //Reset everything
		temp = "<br><center><h3>New Round<center><h3>"

		if(obj_flags & EMAGGED)
			Reset()
			obj_flags &= ~EMAGGED

		enemy_setup(gamerSkill)
		screen_setup(usr)


	add_fingerprint(usr)
	updateUsrDialog()
	return

///happens after a player action and before the enemy turn. the enemy turn will be cancelled if there's a gameover.
/obj/machinery/computer/arcade/battle/proc/arcade_action(mob/user,player_stance,attackamt)
	screen_setup(user)
	blocked = TRUE
	if(player_stance == "attack" || player_stance == "power_attack")
		if(attackamt > 40)
			playsound(src, 'sound/arcade/boom.ogg', 50, TRUE, extrarange = -3)
		else
			playsound(src, 'sound/arcade/hit.ogg', 50, TRUE, extrarange = -3)

	timer_id = addtimer(CALLBACK(src, .proc/enemy_action,player_stance,user),1 SECONDS,TIMER_STOPPABLE)
	gameover_check(user)

///the enemy turn, the enemy's action entirely depend on their current passive and a teensy tiny bit of randomness
/obj/machinery/computer/arcade/battle/proc/enemy_action(player_stance,mob/user)
	var/list/list_temp = list()

	switch(LAZYLEN(last_three_move)) //we keep the last three action of the player in a list here
		if(0 to 2)
			LAZYADD(last_three_move, player_stance)
		if(3)
			for(var/i in 1 to 2)
				last_three_move[i] = last_three_move[i + 1]
			last_three_move[3] = player_stance

		if(4 to INFINITY)
			last_three_move = null //this shouldn't even happen but we empty the list if it somehow goes above 3

	var/enemy_stance
	var/attack_amount = user.rand_bad(8,10) //making the attack amount not vary too much so that it's easier to see if the enemy has a shotgun

	if(player_stance == "defend")
		attack_amount -= 5

	//if emagged, cuban pete will set up a bomb acting up as a timer. when it reaches 0 the player fucking dies
	if(obj_flags & EMAGGED)
		switch(bomb_cooldown--)
			if(18)
				list_temp += "<br><center><h3>[enemy_name] takes two valve tank and links them together, what's he planning?<center><h3>"
			if(15)
				list_temp += "<br><center><h3>[enemy_name] adds a remote control to the tan- ho god is that a bomb?<center><h3>"
			if(12)
				list_temp += "<br><center><h3>[enemy_name] throws the bomb next to you, you'r too scared to pick it up. <center><h3>"
			if(6)
				list_temp += "<br><center><h3>[enemy_name]'s hand brushes the remote linked to the bomb, your heart skipped a beat. <center><h3>"
			if(2)
				list_temp += "<br><center><h3>[enemy_name] is going to press the button! It's now or never! <center><h3>"
			if(0)
				player_hp -= attack_amount * 1000 //hey it's a maxcap we might as well go all in

	//yeah I used the shotgun as a passive, you know why? because the shotgun gives +5 attack which is pretty good
	if(LAZYACCESS(enemy_passive, "shotgun"))
		if(weakpoint_check("shotgun","defend","defend","power_attack"))
			list_temp += "<br><center><h3>You manage to disarm [enemy_name] with a surprise power attack and shoot him with his shotgun until it runs out of ammo! <center><h3> "
			enemy_hp -= 10
			chosen_weapon = "empty shotgun"
		else
			attack_amount += 5

	//heccing chonker passive, only gives more HP at the start of a new game but has one of the hardest weakpoint to trigger.
	if(LAZYACCESS(enemy_passive, "chonker"))
		if(weakpoint_check("chonker","power_attack","power_attack","power_attack"))
			list_temp += "<br><center><h3>After a lot of power attacks you manage to tip over [enemy_name] as they fall over their enormous weight<center><h3> "
			enemy_hp -= 30

	//smart passive trait, mainly works in tandem with other traits, makes the enemy unable to be counter_attacked
	if(LAZYACCESS(enemy_passive, "smart"))
		if(weakpoint_check("smart","defend","defend","attack"))
			list_temp += "<br><center><h3>[enemy_name] is confused by your illogical strategy!<center><h3> "
			attack_amount -= 5

		else if(attack_amount >= player_hp)
			player_hp -= attack_amount
			list_temp += "<br><center><h3>[enemy_name] figures out you are really close to death and finishes you off with their [chosen_weapon]!<center><h3>"
			enemy_stance = "attack"

		else if(player_stance == "counter_attack")
			list_temp += "<br><center><h3>[enemy_name] is not taking your bait. <center><h3> "
			if(LAZYACCESS(enemy_passive, "short_temper"))
				list_temp += "However controlling their hatred of you still takes a toll on their mental and physical health!"
				enemy_hp -= 5
				enemy_mp -= 5
			enemy_stance = "defensive"

	//short temper passive trait, gets easily baited into being counter attacked but will bypass your counter when low on HP
	if(LAZYACCESS(enemy_passive, "short_temper"))
		if(weakpoint_check("short_temper","counter_attack","counter_attack","counter_attack"))
			list_temp += "<br><center><h3>[enemy_name] is getting frustrated at all your counter attacks and throws a tantrum!<center><h3>"
			enemy_hp -= attack_amount

		else if(player_stance == "counter_attack")
			if(!(LAZYACCESS(enemy_passive, "smart")) && enemy_hp > 30)
				list_temp += "<br><center><h3>[enemy_name] took the bait and allowed you to counter attack for [attack_amount * 2] damage!<center><h3>"
				player_hp -= attack_amount
				enemy_hp -= attack_amount * 2
				enemy_stance = "attack"

			else if(enemy_hp <= 30) //will break through the counter when low enough on HP even when smart.
				list_temp += "<br><center><h3>[enemy_name] is getting tired of your tricks and breaks through your counter with their [chosen_weapon]!<center><h3>"
				player_hp -= attack_amount
				enemy_stance = "attack"

		else if(!enemy_stance)
			var/added_temp

			if(rand())
				added_temp = "you for [attack_amount + 5] damage!"
				player_hp -= attack_amount + 5
				enemy_stance = "attack"
			else
				added_temp = "the wall, breaking their skull in the process and losing [attack_amount] hp!" //[enemy_name] you have a literal dent in your skull
				enemy_hp -= attack_amount
				enemy_stance = "attack"

			list_temp += "<br><center><h3>[enemy_name] grits their teeth and charge right into [added_temp]<center><h3>"

	//in the case none of the previous passive triggered, Mainly here to set an enemy stance for passives that needs it like the magical passive.
	if(!enemy_stance)
		enemy_stance = pick("attack","defensive")
		if(enemy_stance == "attack")
			player_hp -= attack_amount
			list_temp += "<br><center><h3>[enemy_name] attacks you for [attack_amount] points of damage with their [chosen_weapon]<center><h3>"
			if(player_stance == "counter_attack")
				enemy_hp -= attack_amount * 2
				list_temp += "<br><center><h3>You counter [enemy_name]'s attack and deal [attack_amount * 2] points of damage!<center><h3>"

		if(enemy_stance == "defensive" && enemy_mp < 15)
			list_temp += "<br><center><h3>[enemy_name] take some time to get some mp back!<center><h3> "
			enemy_mp += attack_amount

		else if (enemy_stance == "defensive" && enemy_mp >= 15 && !(LAZYACCESS(enemy_passive, "magical")))
			list_temp += "<br><center><h3>[enemy_name] quickly heal themselves for 5 hp!<center><h3> "
			enemy_mp -= 15
			enemy_hp += 5

	//magical passive trait, recharges MP nearly every turn it's not blasting you with magic.
	if(LAZYACCESS(enemy_passive, "magical"))
		if(player_mp >= 50)
			list_temp += "<br><center><h3>the huge amount of magical energy you have acumulated throws [enemy_name] off balance!<center><h3>"
			enemy_mp = 0
			LAZYREMOVE(enemy_passive, "magical")
			pissed_off++

		else if(LAZYACCESS(enemy_passive, "smart") && player_stance == "counter_attack" && enemy_mp >= 20)
			list_temp += "<br><center><h3>[enemy_name] blasts you with magic from afar for 10 points of damage before you can counter!<center><h3>"
			player_hp -= 10
			enemy_mp -= 20

		else if(enemy_hp >= 20 && enemy_mp >= 40 && enemy_stance == "defensive")
			list_temp += "<br><center><h3>[enemy_name] Blasts you with magic from afar!<center><h3>"
			enemy_mp -= 40
			player_hp -= 30
			enemy_stance = "attack"

		else if(enemy_hp < 20 && enemy_mp >= 20 && enemy_stance == "defensive") //it's a pretty expensive spell so they can't spam it that much
			list_temp += "<br><center><h3>[enemy_name] heal themselves with magic and gain back 20 hp!<center><h3>"
			enemy_hp += 20
			enemy_mp -= 30
		else
			list_temp += "<br><center><h3>[enemy_name]'s magical nature lets them get some mp back!<center><h3>"
			enemy_mp += attack_amount

	//poisonous passive trait, while it's less damage added than the shotgun it acts up even when the enemy doesn't attack at all.
	if(LAZYACCESS(enemy_passive, "poisonous"))
		if(weakpoint_check("poisonous","attack","attack","attack"))
			list_temp += "<br><center><h3>your flurry of attack throws back the poisonnous gas at [enemy_name] and makes them choke on it!<center><h3> "
			enemy_hp -= 5
		else
			list_temp += "<br><center><h3>the stinky breath of [enemy_name] hurts you for 3 hp!<center><h3> "
			player_hp -= 3

	//if all passive's weakpoint have been triggered, set finishing_move to TRUE
	if(pissed_off >= max_passive && !finishing_move)
		list_temp += "<br><center><h3>You have weakened [enemy_name] enough for them to show their weak point, you will do 10 times as much damage with your next attack!<center><h3> "
		finishing_move = TRUE

	playsound(src, 'sound/arcade/heal.ogg', 50, TRUE, extrarange = -3)

	temp = list_temp.Join()
	gameover_check(user)
	screen_setup(user)
	blocked = FALSE


/obj/machinery/computer/arcade/battle/proc/gameover_check(mob/user)
	var/xp_gained = 0
	if(enemy_hp <= 0)
		if(!gameover)
			if(timer_id)
				deltimer(timer_id)
				timer_id = null
			if(player_hp <= 0)
				player_hp = 1 //let's just pretend the enemy didn't kill you so not both the player and enemy look dead.
			gameover = TRUE
			blocked = FALSE
			temp = "<br><center><h3>[enemy_name] has fallen! Rejoice!<center><h3>"
			playsound(loc, 'sound/arcade/win.ogg', 50, TRUE)

			if(obj_flags & EMAGGED)
				new /obj/effect/spawner/newbomb/timer/syndicate(loc)
				new /obj/item/clothing/head/collectable/petehat(loc)
				message_admins("[ADMIN_LOOKUPFLW(usr)] has outbombed Cuban Pete and been awarded a bomb.")
				log_game("[key_name(usr)] has outbombed Cuban Pete and been awarded a bomb.")
				Reset()
				obj_flags &= ~EMAGGED
				xp_gained += 100
			else
				prizevend(user)
				xp_gained += 50
			SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("win", (obj_flags & EMAGGED ? "emagged":"normal")))

	else if(player_hp <= 0)
		if(timer_id)
			deltimer(timer_id)
			timer_id = null
		gameover = TRUE
		temp = "<br><center><h3>You have been crushed! GAME OVER<center><h3>"
		playsound(loc, 'sound/arcade/lose.ogg', 50, TRUE)
		xp_gained += 10//pity points
		if(obj_flags & EMAGGED)
			var/mob/living/living_user = user
			if (istype(living_user))
				living_user.gib()
		SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "hp", (obj_flags & EMAGGED ? "emagged":"normal")))

	// if(gameover)
	// 	user?.mind?.adjust_experience(/datum/skill/gaming, xp_gained+1)//always gain at least 1 point of XP


///used to check if the last three move of the player are the one we want in the right order and if the passive's weakpoint has been triggered yet
/obj/machinery/computer/arcade/battle/proc/weakpoint_check(passive,first_move,second_move,third_move)
	if(LAZYLEN(last_three_move) < 3)
		return FALSE

	if(last_three_move[1] == first_move && last_three_move[2] == second_move && last_three_move[3] == third_move && LAZYACCESS(enemy_passive, passive))
		LAZYREMOVE(enemy_passive, passive)
		pissed_off++
		return TRUE
	else
		return FALSE


/obj/machinery/computer/arcade/battle/Destroy()
	enemy_passive = null
	weapons = null
	last_three_move = null
	return ..() //well boys we did it, lists are no more

/obj/machinery/computer/arcade/battle/examine_more(mob/user)
	var/list/msg = list("<span class='notice'><i>You notice some writing scribbled on the side of [src]...</i></span>")
	msg += "\t<span class='info'>smart -> defend, defend, light attack</span>"
	msg += "\t<span class='info'>shotgun -> defend, defend, power attack</span>"
	msg += "\t<span class='info'>short temper -> counter, counter, counter</span>"
	msg += "\t<span class='info'>poisonous -> light attack, light attack, light attack</span>"
	msg += "\t<span class='info'>chonker -> power attack, power attack, power attack</span>"
	return msg

/obj/machinery/computer/arcade/battle/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return

	to_chat(user, "<span class='warning'>A mesmerizing Rhumba beat starts playing from the arcade machine's speakers!</span>")
	temp = "<br><center><h2>If you die in the game, you die for real!<center><h2>"
	max_passive = 6
	bomb_cooldown = 18
	var/gamerSkill = 0
	// if(usr?.mind)
	// 	gamerSkill = usr.mind.get_skill_level(/datum/skill/gaming)
	enemy_setup(gamerSkill)
	enemy_hp += 100 //extra HP just to make cuban pete even more bullshit
	player_hp += 30 //the player will also get a few extra HP in order to have a fucking chance

	screen_setup(user)
	gameover = FALSE

	obj_flags |= EMAGGED

	enemy_name = "Cuban Pete"
	name = "Outbomb Cuban Pete"

	updateUsrDialog()
	return TRUE
