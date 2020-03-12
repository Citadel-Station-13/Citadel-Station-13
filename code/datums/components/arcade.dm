#define ARCADE_WEIGHT_TRICK 4
#define ARCADE_WEIGHT_USELESS 2
#define ARCADE_WEIGHT_RARE 1
#define ARCADE_RATIO_PLUSH 0.20 // average 1 out of 6 wins is a plush.

#define ARCADE_PLAY_ATTACK_HAND	(1<<0) //warning: causes the item to be unpickable through normal clicks.
#define ARCADE_PLAY_ATTACK_SELF	(1<<1)
#define ARCADE_PLAY_ALT_CLICK	(1<<2)
#define ARCADE_PLAY_MUST_HOLD	(1<<3)
#define ARCADE_EXAMINE_HINT		(1<<4)
#define ARCADE_TOGGLE_EMAG		(1<<5)
#define ARCADE_EMAGGED			(1<<6)

/datum/component/arcade
	var/arcade_name = "some arcade game"
	//Callbacks invoked with added user, emagged and prize rarity class arguments.
	var/datum/callback/on_new_game
	var/datum/callback/on_victory
	var/datum/callback/on_loss
	var/datum/callback/can_use
	var/use_ui = TRUE //will it use a browser/tgui menu or the standard html one?
	var/arcade_flags

/datum/component/arcade/Initialize(_new_game, _victory, _loss, _can_use, _flags = ARCADE_TOGGLE_EMAG|ARCADE_PLAY_ATTACK_HAND, _name)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	on_new_game = _new_game
	on_victory = _victory
	on_loss = _loss
	can_use = _can_use

	if(!isitem(parent))
		_flags &= ~ARCADE_PLAY_MUST_HOLD //it's useless here.
	arcade_flags = _flags
	if(_name)
		arcade_name = _name

	RegisterSignal(parent, COMSIG_ATOM_INTERACT, .proc/interact) //by itself it only works for updates and silicons.
	if(arcade_flags & ARCADE_TOGGLE_EMAG)
		RegisterSignal(parent, COMSIG_ATOM_EMAG_ACT, .proc/on_emag)
	if(arcade_flags & ARCADE_PLAY_ALT_CLICK)
		RegisterSignal(parent, COMSIG_CLICK_ALT, .proc/interact_altclick)
	if(arcade_flags & ARCADE_PLAY_ATTACK_SELF)
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/interact_self)
	if(arcade_flags & ARCADE_PLAY_ATTACK_HAND)
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, .proc/interact_hand)
	if(arcade_flags & ARCADE_EXAMINE_HINT)
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)

/datum/component/arcade/Destroy()
	if(on_new_game)
		qdel(on_new_game)
	if(on_victory)
		qdel(on_victory)
	if(on_loss)
		qdel(on_loss)
	if(can_use)
		qdel(can_use)
	return ..()

/datum/component/arcade/proc/on_emag(datum/source, mob/user)
	if(arcade_flags & ARCADE_EMAGGED)
		return FALSE
	return TRUE

//The update arg is TRUE by default as we want the altclick/attack_hand/attack_self hooks to actually work.
/datum/component/arcade/proc/interact(atom/source, mob/user, update = TRUE)
	if(!user || (!update && !source.hasSiliconAccessInArea(user)) || !can_use?.Invoke(user))
		return
	if(user.machine != source)
		user.set_machine(source)
	if(use_ui)
		ui_interact(user)
	return COMPONENT_STOP_INTERACT|COMPONENT_INTERACT_TRUE_ANYWAY

/datum/component/arcade/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!parent || href_list["close"] || !can_use.Invoke(usr))
		usr.unset_machine()
		usr << browse(null, "window=arcade")
		return TRUE

//These 3 procs all operate more or less the same, .

/datum/component/arcade/proc/interact_hand(atom/source, mob/user)
	if(ismob(source) && user.a_intent != INTENT_HELP) //so we can punch em to death anyway.
		return
	if((IsAdminGhost(user) || source.can_interact(user)) && interact(source, user))
		return COMPONENT_NO_ATTACK_HAND

/datum/component/arcade/proc/interact_self(atom/source, mob/user)
	if((IsAdminGhost(user) || (source.can_interact(user) && (!(arcade_flags & ARCADE_PLAY_MUST_HOLD) || user.is_holding(source)))) && interact(source, user))
		return COMPONENT_NO_INTERACT

/datum/component/arcade/proc/interact_altclick(atom/source, mob/user)
	if((source.hasSiliconAccessInArea(user) || (source.can_interact(user) && (!(arcade_flags & ARCADE_PLAY_MUST_HOLD) || user.is_holding(source)))) && interact(source, user))
		return TRUE

//Some examine feedback if the ARCADE_EXAMINE_HINT bitflag was present on the init flags.
/datum/component/arcade/proc/on_examine(atom/source, mob/user, list/examine_list)
	var/list/L
	if(arcade_flags & ARCADE_PLAY_ALT_CLICK)
		LAZYADD(L, "<b>Alt-Click</b>")
	if(arcade_flags & ARCADE_PLAY_ATTACK_HAND)
		LAZYADD(L, ismob(source) ? "[L ? "c" : "C"]almly interact with" : "[L ? "i" : "I"]nteract with")
	if(arcade_flags & ARCADE_PLAY_ATTACK_SELF)
		LAZYADD(L, "[L ? "a" : "A"]ctivate")
	if(L)
		var/it = source.p_they()
		L[L.len] = "[L[L.len]] [it] [(arcade_flags & ARCADE_PLAY_MUST_HOLD && !source.hasSiliconAccessInArea(user)) ? "in your hands" : ""]"

		examine_list = "<span class='notice'>[english_list(L, and_text = " or ")] to play \'[arcade_name]\'.</span>"

//Callback hooks and possible extras for subtypes

/datum/component/arcade/proc/new_game(mob/user, emag_run = FALSE, ...)
	if(arcade_flags & ARCADE_TOGGLE_EMAG)
		if(emag_run)
			arcade_flags |= ARCADE_EMAGGED
		else
			arcade_flags &= ~ARCADE_EMAGGED
	. = on_new_game?.InvokeAsync(arglist(args))

/datum/component/arcade/proc/victory(mob/user, was_emag_run = FALSE, ...)
	. = on_victory?.InvokeAsync(arglist(args))
	if(arcade_flags & ARCADE_TOGGLE_EMAG)
		arcade_flags &= ~ARCADE_EMAGGED

/datum/component/arcade/proc/loss(mob/user, was_emag_run = FALSE, ...)
	. = on_loss?.InvokeAsync(arglist(args))
	if(arcade_flags & ARCADE_TOGGLE_EMAG)
		arcade_flags &= ~ARCADE_EMAGGED


/datum/component/arcade/battle
	arcade_name = "Arcade Battles"
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

/datum/component/arcade/battle/on_emag(datum/source, mob/user)
	. = ..()
	if(!.)
		return

	temp = "If you die in the game, you die for real!"
	enemy_name = "Cuban Pete"

	to_chat(user, "<span class='warning'>A mesmerizing Rhumba beat starts playing from the arcade machine's speakers!</span>")
	new_game(user, TRUE)
	var/atom/A = parent
	A.updateDialog()

/datum/component/arcade/battle/ui_interact(mob/user)
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
	var/atom/A = parent
	popup.set_title_image(user.browse_rsc_icon(A.icon, A.icon_state))
	popup.open()

/datum/component/arcade/battle/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if (!blocked && !gameover)
		if (href_list["attack"])
			blocked = TRUE
			var/attackamt = rand(2,6)
			temp = "You attack for [attackamt] damage!"
			playsound(parent, 'sound/arcade/hit.ogg', 50, 1, extrarange = -3, falloff = 10)
			if(turtle > 0)
				turtle--
			enemy_hp -= attackamt

			addtimer(CALLBACK(src, .proc/arcade_action, usr), turn_speed)

		else if (href_list["heal"])
			blocked = TRUE
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			temp = "You use [pointamt] magic to heal for [healamt] damage!"
			playsound(parent, 'sound/arcade/heal.ogg', 50, 1, extrarange = -3, falloff = 10)
			turtle++
			player_mp -= pointamt
			player_hp += healamt

			addtimer(CALLBACK(src, .proc/arcade_action, usr), turn_speed)

		else if (href_list["charge"])
			blocked = TRUE
			var/chargeamt = rand(4,7)
			temp = "You regain [chargeamt] points"
			playsound(parent, 'sound/arcade/mana.ogg', 50, 1, extrarange = -3, falloff = 10)
			player_mp += chargeamt
			if(turtle > 0)
				turtle--

			addtimer(CALLBACK(src, .proc/arcade_action, usr), turn_speed)

	else if (href_list["newgame"]) //Reset everything
		new_game(usr, FALSE)

	var/atom/A = parent
	A.updateDialog()

/datum/component/arcade/battle/new_game(mob/user, emag_run = FALSE, ...)
	. = ..()
	enemy_name = .
	temp = "New Round"
	player_hp = initial(player_hp)
	player_mp = initial(player_mp)
	enemy_hp = initial(enemy_hp)
	enemy_mp = initial(enemy_mp)
	gameover = FALSE
	turtle = 0

/datum/component/arcade/battle/victory(mob/user, emag_run = FALSE, ...)
	. = ..()
	if(.)
		enemy_name = .

/datum/component/arcade/battle/loss(mob/user, emag_run = FALSE, ...)
	. = ..()
	if(.)
		enemy_name = .

/datum/component/arcade/battle/proc/arcade_action(mob/user)
	if ((enemy_mp <= 0) || (enemy_hp <= 0))
		if(!gameover)
			gameover = TRUE
			temp = "[enemy_name] has fallen! Rejoice!"
			playsound(parent, 'sound/arcade/win.ogg', 50, 1, extrarange = -3, falloff = 10)
			SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("win", (arcade_flags & ARCADE_EMAGGED) ? "emagged" : "normal"))
			victory(user, arcade_flags & ARCADE_EMAGGED)

	else if ((arcade_flags & ARCADE_EMAGGED) && (turtle >= 4))
		var/boomamt = rand(5,10)
		temp = "[enemy_name] throws a bomb, exploding you for [boomamt] damage!"
		playsound(parent, 'sound/arcade/boom.ogg', 50, 1, extrarange = -3, falloff = 10)
		player_hp -= boomamt

	else if ((enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		temp = "[enemy_name] steals [stealamt] of your power!"
		playsound(parent, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 10)
		player_mp -= stealamt

		if (player_mp <= 0)
			gameover = TRUE
			sleep(turn_speed)
			temp = "You have been drained! GAME OVER"
			playsound(parent, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
			SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "mana", ((arcade_flags & ARCADE_EMAGGED) ? "emagged":"normal")))
			loss(user, arcade_flags & ARCADE_EMAGGED)

	else if ((enemy_hp <= 10) && (enemy_mp > 4))
		temp = "[enemy_name] heals for 4 health!"
		playsound(parent, 'sound/arcade/heal.ogg', 50, 1, extrarange = -3, falloff = 10)
		enemy_hp += 4
		enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		temp = "[enemy_name] attacks for [attackamt] damage!"
		playsound(parent, 'sound/arcade/hit.ogg', 50, 1, extrarange = -3, falloff = 10)
		player_hp -= attackamt

	if ((player_mp <= 0) || (player_hp <= 0))
		gameover = TRUE
		temp = "You have been crushed! GAME OVER"
		playsound(parent, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 10)
		SSblackbox.record_feedback("nested tally", "arcade_results", 1, list("loss", "hp", ((arcade_flags & ARCADE_EMAGGED) ? "emagged":"normal")))
		loss(user, arcade_flags & ARCADE_EMAGGED)

	blocked = FALSE
	var/atom/A = parent
	A.updateDialog()
