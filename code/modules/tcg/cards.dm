#define TAPPED_ANGLE 90
#define UNTAPPED_ANGLE 0

//The game itself is supposed to be played on 3x2 table. This is important since it's the search range of the cards for automation.

/datum/tcg_card
	var/name = "Stupid Coder"
	var/desc = "A coder that fucked up this card. Report if you see this."
	var/rules = "Tap this card. It will ahelp itself"
	var/icon_state = "cardback"
	var/pack = 'icons/obj/tcg/pack_1.dmi'

	var/mana_cost = 0
	var/attack = 0
	var/health = 0

	var/faction = "Coderbus"
	var/rarity = "Stoopid"
	var/card_type = "Unit"

	var/obj/item/tcg_card/card

/*Uncomment if you want to make the game automatic

/datum/tcg_card/proc/Use(datum/tcg_card/affected_card, mob/living/user)
	if(card_type == "Equipment")
		affected_card.health += health
		affected_card.attack += attack
		to_chat(user, "<span class ='notice'>You use [card] on [affected_card.card], upgrading it's stats.</span>")
		user.emote("uses [card] on [affected_card.card], upgrading it's stats.") //To get that visible emote. Useful if you want nice gameplay
	else if (card_type == "Unit")
		affected_card.health -= attack
		health -= affected_card.attack
		var/flavortext = "."
		if(affected_card.health <= 0)
			flavortext = ", killing [affected_card.card]!"
			if(health <= 0)
				flavortext = ", killing both [affected_card.card] and [card]!"
		else
			flavortext = ", killing [card] in the process!"
		to_chat(user, "<span class ='notice'>You attack [affected_card.card] with [card][flavortext]</span>")
		user.emote("attacks [affected_card.card] with [card][flavortext]")

*/

/datum/tcg_card/proc/UseSelf(mob/living/user)
	return

/datum/tcg_card/proc/Tap(mob/living/user) //Actually runtimes on tap! Tapping is basically disabling a card for a turn in exchange for special effects
	if(type == /datum/tcg_card)
		log_runtime("[user] managed to get a blank TCG card.")

/datum/tcg_card/proc/Untap(mob/living/user)
	return

/datum/tcg_card/proc/Reset(mob/living/user)
	to_chat(user, "<span class ='notice'>You reset [card]'s stats to original.</span>")
	mana_cost = initial(mana_cost)
	rules = initial(rules)
	health = initial(health)
	attack = initial(attack)
	faction = initial(faction)

/obj/item/tcg_card
	name = "TCG card"
	desc = "A flipped TCG-branded card."
	icon_state = "cardback"
	icon = 'icons/obj/tcg/pack_1.dmi'

	var/datum_type = /datum/tcg_card
	var/datum/tcg_card/card_datum

	w_class = WEIGHT_CLASS_TINY

	var/flipped = FALSE
	var/tapped = FALSE
	var/special = FALSE

/obj/item/tcg_card/special
	special = TRUE

/obj/item/tcg_card/examine(mob/user)
	. = ..()
	sleep(2) //So it prints this shit after the examine
	to_chat(user, "<span class='notice'>This card has following stats:</span>")
	to_chat(user, "<span class='notice'>Mana cost: [card_datum.mana_cost]</span>")
	to_chat(user, "<span class='notice'>Health: [card_datum.health]</span>")
	to_chat(user, "<span class='notice'>Attack: [card_datum.attack]</span>")
	to_chat(user, "<span class='notice'>Faction: [card_datum.faction]</span>")
	to_chat(user, "<span class='notice'>Rarity: [card_datum.rarity]</span>")
	to_chat(user, "<span class='notice'>Card Type: [card_datum.card_type]</span>")
	to_chat(user, "<span class='notice'>It's effect is: [card_datum.rules]</span>")

/obj/item/tcg_card/openTip(location, control, params, user) //Overriding for nice UI
	var/desc_content = "[desc] <br> \
					    <span class='notice'>This card has following stats:</span> <br> \
					    <span class='notice'>Mana cost: [card_datum.mana_cost]</span> <br> \
					    <span class='notice'>Health: [card_datum.health]</span> <br> \
					    <span class='notice'>Attack: [card_datum.attack]</span> <br> \
					    <span class='notice'>Faction: [card_datum.faction]</span> <br> \
					    <span class='notice'>Rarity: [card_datum.rarity]</span> <br> \
					    <span class='notice'>Card Type: [card_datum.card_type]</span> <br> \
					    <span class='notice'>It's effect is: [card_datum.rules]</span>"
	openToolTip(user,src,params,title = name,content = desc_content,theme = "")

/obj/item/tcg_card/New(loc, new_datum)
	. = ..()
	if(!special)
		datum_type = new_datum
	card_datum = new datum_type
	icon = card_datum.pack
	icon_state = card_datum.icon_state

/obj/item/tcg_card/attack_hand(mob/user)
	var/list/possible_actions = list(
		"Pick Up" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_pickup"),
		"Tap" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_tap"),
		"Flip" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_flip")
		)
	var/result = show_radial_menu(user, src, possible_actions, require_near = TRUE, tooltips = TRUE)
	switch(result)
		if("Pick Up")
			. = ..()
		if("Flip")
			flipped = !flipped
			if(flipped)
				icon_state = "cardback"
				name = "TCG card"
				desc = "A flipped TCG-branded card."
			else
				name = card_datum.name
				desc = card_datum.desc
				icon_state = card_datum.icon_state
		if("Tap")
			var/matrix/ntransform = matrix(transform)
			if(tapped)
				ntransform.TurnTo(TAPPED_ANGLE , UNTAPPED_ANGLE)
			else
				ntransform.TurnTo(UNTAPPED_ANGLE , TAPPED_ANGLE)
			tapped = !tapped
			animate(src, transform = ntransform, time = 2, easing = (EASE_IN|EASE_OUT))
			if(tapped)
				card_datum.Tap(user)
			else
				card_datum.Untap(user)

/obj/item/tcg_card/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tcg_card))
		var/obj/item/tcg_card/second_card = I
		if(loc == user && second_card.loc == user)
			var/obj/item/tcgcard_hand/hand = new(get_turf(user))
			src.forceMove(hand)
			second_card.forceMove(hand)
			hand.cards.Add(src)
			hand.cards.Add(second_card)
			hand.update_icon()
			return ..()
		var/obj/item/tcgcard_deck/new_deck = new /obj/item/tcgcard_deck(drop_location())
		new_deck.flipped = flipped
		user.transferItemToLoc(second_card, new_deck)//Start a new pile with both cards, in the order of card placement.
		user.transferItemToLoc(src, new_deck)
		new_deck.update_icon_state()
		user.put_in_hands(new_deck)
		new_deck.update_icon()
	if(istype(I, /obj/item/tcgcard_deck))
		var/obj/item/tcgcard_deck/old_deck = I
		if(length(old_deck.contents) >= 30)
			to_chat(user, "<span class='notice'>This pile has too many cards for a regular deck!</span>")
			return
		user.transferItemToLoc(src, old_deck)
		flipped = old_deck.flipped
		old_deck.update_icon()
		update_icon()
	return ..()

/obj/item/tcg_card/attack_self(mob/user)
	var/list/possible_actions = list(
		"Reset to Default" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_reset"),
		"Change stats" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_change_stats")
		)
	var/result = show_radial_menu(user, src, possible_actions, require_near = TRUE, tooltips = TRUE)
	switch(result)
		if("Reset to Default")
			card_datum.Reset(user)
			user.visible_message("<span class='notice'>[user] resets [src]'s stats.</span>")
		if("Change stats")
			possible_actions = list(
			"Health" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_health"),
			"Attack" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_attack"),
			"Mana" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_mana")
			)
			result = show_radial_menu(user, src, possible_actions, require_near = TRUE, tooltips = TRUE)
			switch(result)
				if("Health")
					card_datum.health = input(user, "What do you want health to be?", "Changing [src]'s health") as num|null
				if("Attack")
					card_datum.attack = input(user, "What do you want attack to be?", "Changing [src]'s attack") as num|null
				if("Mana")
					card_datum.mana_cost = input(user, "What do you want mana cost to be?", "Changing [src]'s mana cost") as num|null
			user.visible_message("<span class='notice'>[user] changes [src]'s [result].</span>")

/obj/item/tcg_card/equipped(mob/user, slot, initial)
	. = ..()
	transform = matrix()

/obj/item/tcg_card/dropped(mob/user, silent)
	. = ..()
	transform = matrix(0.5,0,0,0,0.5,0)

/obj/item/cardpack
	name = "Trading Card Pack: Coder"
	desc = "Contains six complete fuckups by the coders. Report this on github please!"
	icon = 'icons/obj/tcg/misc.dmi'
	icon_state = "cardpack"
	w_class = WEIGHT_CLASS_TINY
	///The card series to look in
	var/series = /datum/tcg_card/pack_1
	///Chance of the pack having a coin in it out of 10
	var/contains_coin = -1
	///The amount of cards to draw from the rarity table
	var/card_count = 5
	///The rarity table, the set must contain at least one of each
	var/list/rarity_table = list(
		"Common" = 900,
		"Rare" = 300,
		"Epic" = 50,
		"Legendary" = 3)
	///The amount of cards to draw from the guarenteed rarity table
	var/guaranteed_count = 1
	///The guaranteed rarity table, acts about the same as the rarity table. it can have as many or as few raritys as you'd like
	var/list/guar_rarity = list(
		"Legendary" = 1,
		"Epic" = 9,
		"Rare" = 30)

	custom_price = PRICE_EXPENSIVE

/obj/item/cardpack/series_one
	name = "Trading Card Pack: 2560 Core Set"
	desc = "Contains six cards of varying rarity from the 2560 Core Set. Collect them all!"
	icon_state = "cardpack"
	series = /datum/tcg_card/pack_1
	contains_coin = 10

/obj/item/cardpack/equipped(mob/user, slot, initial)
	. = ..()
	transform = matrix()

/obj/item/cardpack/dropped(mob/user, silent)
	. = ..()
	transform = matrix(0.5,0,0,0,0.5,0)

/obj/item/cardpack/attack_self(mob/user)
	. = ..()
	var/list/cards = buildCardListWithRarity(card_count, guaranteed_count)
	for(var/template in cards)
		new /obj/item/tcg_card(get_turf(user), template)
	to_chat(user, "<span_class='notice'>Wow! Check out these cards!</span>")
	playsound(loc, 'sound/items/poster_ripped.ogg', 20, TRUE)
	if(prob(contains_coin))
		to_chat(user, "<span_class='notice'>...and it came with a flipper, too!</span>")
		new /obj/item/coin/thunderdome(get_turf(user))
	qdel(src)

/obj/item/cardpack/proc/buildCardListWithRarity(card_cnt, rarity_cnt)
	var/list/return_cards = list()

	var/list/cards = subtypesof(series)
	var/list/possible_cards = list()
	var/list/rarity_cards = list("Legendary" = list(), "Epic" = list(), "Rare" = list(), "Common" = list())
	for(var/card in cards)
		var/datum/tcg_card/new_card = new card()
		possible_cards[card] = rarity_table[new_card.rarity]
		var/list/rarity_card_type = rarity_cards[new_card.rarity]
		rarity_card_type.Add(card)
		rarity_cards[new_card.rarity] = rarity_card_type //FUCK CI
		qdel(new_card)

	for(var/card_counter = 1 to card_count)
		var/cardtype = pickweight(possible_cards)
		return_cards.Add(cardtype)

	for(var/card_counter = 1 to guaranteed_count)
		var/card_list = pickweight(guar_rarity)
		return_cards.Add(pick(rarity_cards[card_list]))

	return return_cards

/obj/item/coin/thunderdome
	name = "Thunderdome Flipper"
	desc = "A Thunderdome TCG flipper, for deciding who gets to go first. Also conveniently acts as a counter, for various purposes."
	icon = 'icons/obj/tcg/misc.dmi'
	icon_state = "coin_nanotrasen"
	custom_materials = list(/datum/material/plastic = 400)
	material_flags = NONE
	sideslist = list("nanotrasen", "syndicate")

/obj/item/coin/thunderdome/Initialize()
	. = ..()
	transform = matrix(0.5,0,0,0,0.5,0)

/obj/item/coin/thunderdome/equipped(mob/user, slot, initial)
	. = ..()
	transform = matrix()

/obj/item/coin/thunderdome/dropped(mob/user, silent)
	. = ..()
	transform = matrix(0.5,0,0,0,0.5,0)

/obj/item/tcgcard_deck
	name = "Trading Card Pile"
	desc = "A stack of TCG cards."
	icon = 'icons/obj/tcg/misc.dmi'
	icon_state = "deck_up"

	var/flipped = FALSE

	var/static/radial_draw = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_draw")
	var/static/radial_shuffle = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_shuffle")
	var/static/radial_pickup = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_pickup")

/obj/item/tcgcard_deck/Initialize()
	. = ..()
	LoadComponent(/datum/component/storage/concrete/tcg)

/obj/item/tcgcard_deck/update_icon_state()
	. = ..()
	if(flipped)
		switch(contents.len)
			if(1 to 10)
				icon_state = "deck_tcg_low"
			if(11 to 20)
				icon_state = "deck_tcg_half"
			if(21 to INFINITY)
				icon_state = "deck_tcg_full"
	else
		icon_state = "deck_up"

/obj/item/tcgcard_deck/examine(mob/user)
	. = ..()
	. += "<span class='notice'>\The [src] has [contents.len] cards inside.</span>"

/obj/item/tcgcard_deck/attack_hand(mob/user)
	var/list/choices = list(
		"Draw" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_draw"),
		"Shuffle" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_shuffle"),
		"Pickup" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_pickup"),
		"Flip" = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_flip"),
		)
	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Draw")
			draw_card(user)
		if("Shuffle")
			shuffle_deck(user)
		if("Pickup")
			user.put_in_hands(src)
		if("Flip")
			flip_deck()

/obj/item/tcgcard_deck/Destroy()
	for(var/card in 1 to contents.len)
		var/obj/item/tcg_card/stored_card = contents[card]
		stored_card.forceMove(drop_location())
	. = ..()

/obj/item/tcgcard_deck/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/tcgcard_deck/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/tcg_card))
		if(contents.len > 30)
			to_chat(user, "<span class='notice'>This pile has too many cards for a regular deck!</span>")
			return FALSE
		var/obj/item/tcg_card/new_card = I
		new_card.flipped = flipped
		new_card.forceMove(src)

/obj/item/tcgcard_deck/attack_self(mob/living/carbon/user)
	shuffle_deck(user)
	return ..()

/obj/item/tcgcard_deck/proc/draw_card(mob/user)
	if(!contents.len)
		CRASH("A TCG deck was created with no cards inside of it.")
	var/obj/item/tcg_card/drawn_card = contents[contents.len]
	user.put_in_hands(drawn_card)
	drawn_card.flipped = flipped //If it's a face down deck, it'll be drawn face down, if it's a face up pile you'll draw it face up.
	drawn_card.update_icon_state()
	user.visible_message("<span class='notice'>[user] draws a card from \the [src]!</span>", \
					"<span class='notice'>You draw a card from \the [src]!</span>")
	if(contents.len <= 1)
		var/obj/item/tcg_card/final_card = contents[1]
		user.transferItemToLoc(final_card, drop_location())
		qdel(src)

/obj/item/tcgcard_deck/proc/shuffle_deck(mob/user, visable = TRUE)
	if(!contents)
		return
	contents = shuffle(contents)
	if(user.active_storage)
		user.active_storage.close(user)
	if(visable)
		user.visible_message("<span class='notice'>[user] shuffles \the [src]!</span>", \
						"<span class='notice'>You shuffle \the [src]!</span>")

/obj/item/tcgcard_deck/proc/flip_deck()
	flipped = !flipped
	var/list/temp_deck = contents.Copy()
	contents = reverseRange(temp_deck)
	//Now flip the cards to their opposite positions.
	for(var/a in 1 to contents.len)
		var/obj/item/tcg_card/nu_card = contents[a]
		nu_card.flipped = flipped
		nu_card.update_icon_state()
	update_icon_state()

/obj/item/tcgcard_hand
	name = "Trading Card Hand"
	desc = "A hand full of TCG cards."
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	var/list/cards = list()

/obj/item/tcgcard_hand/update_icon()
	. = ..()
	cut_overlays()
	var/angular = length(cards) / 2 * -30
	for(var/obj/item/tcg_card/card in cards)
		var/image/I = image(icon = card.icon, icon_state = card.icon_state)
		var/matrix/ntransform = matrix(I.transform)
		ntransform.TurnTo(angular, 0)
		ntransform.Translate(sin(angular) * -15, cos(angular) * -15)
		I.transform = ntransform
		angular += 30
		overlays += I

/obj/item/tcgcard_hand/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tcg_card))
		var/obj/item/tcg_card/card = I
		if(loc == user && card.loc == user)
			card.forceMove(src)
			cards.Add(card)
			update_icon()
	. = ..()

/obj/item/tcgcard_hand/attack_hand(mob/living/carbon/user)
	if(loc == user)
		var/list/choices = list()
		for(var/obj/item/tcg_card/card in cards)
			choices[card] = image(icon = card.icon, icon_state = card.icon_state)
		var/obj/item/tcg_card/choice = show_radial_menu(user, src, choices, require_near = TRUE, tooltips = TRUE)
		if(choice)
			choice.forceMove(get_turf(src))
			user.put_in_hands(choice)
			cards.Remove(choice)
			update_icon()
			if(length(cards) == 0)
				qdel(src)
			return
	. = ..()

/obj/item/tcgcard_binder
	name = "Trading Card Binder"
	desc = "A TCG-branded card binder, specifically for your infinite collection of TCG cards!"
	icon = 'icons/obj/tcg/misc.dmi'
	icon_state = "binder"

	var/list/cards = list()
	var/mode = 0 //If 1, will show all the cards even if you don't have em

/obj/item/tcgcard_binder/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tcg_card))
		var/obj/item/tcg_card/card = I
		card.forceMove(src)
		cards.Add(card)
	. = ..()

/obj/item/tcgcard_binder/attack_self(mob/living/carbon/user)
	mode = !mode
	to_chat(user, "<span class='notice'>[src] now shows you [mode ? "all the different cards" : "the cards you already have"].")

/obj/item/tcgcard_binder/attack_hand(mob/living/carbon/user)
	if(loc == user)
		var/list/choices = list()
		if(mode)
			var/card_types = list()

			for(var/obj/item/tcg_card/card in cards)
				card_types[card.datum_type] = card

			for(var/card_type in subtypesof(/datum/tcg_card))
				if(card_type in card_types)
					choices[card_types[card_type]] = image(icon = card_types[card_type].icon, icon_state = card_types[card_type].icon_state)
					continue

				var/datum/tcg_card/card_dat = new card_type
				if(card_dat.name == "Stupid Coder")
					continue
				var/image/I = image(icon = card_dat.pack, icon_state = card_dat.icon_state)
				I.color = "#999999"
				choices[card_dat.name] = I
				qdel(card_dat)
		else
			for(var/obj/item/tcg_card/card in cards)
				choices[card] = image(icon = card.icon, icon_state = card.icon_state)
		var/obj/item/tcg_card/choice = show_radial_menu(user, src, choices, require_near = TRUE, tooltips = TRUE)
		if(choice && choice in cards)
			choice.forceMove(get_turf(src))
			user.put_in_hands(choice)
			cards.Remove(choice)

		if(choice)
			return
	. = ..()

/obj/item/tcgcard_binder/proc/check_for_exodia()
	var/list/card_types = list()
	for(var/obj/item/tcg_card/card in cards)
		card_types.Add(card.datum_type)

	for(var/card_type in subtypesof(/datum/tcg_card))
		var/datum/tcg_card/card_dat = new card_type
		if(card_dat.name == "Stupid Coder" || card_dat.name == "Eldritch Horror") //It would be stupid if we require exodia or system cards to get exodia
			continue
		qdel(card_dat)
		if(!(card_type in card_types))
			return

	var/obj/item/tcg_card/card = new(get_turf(src), /datum/tcg_card/pack_star/exodia)
	card.forceMove(src)
	cards.Add(card)