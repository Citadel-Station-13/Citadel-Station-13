#define TAPPED_ANGLE 90
#define UNTAPPED_ANGLE 0

#define COMMON_SERIES list(/datum/tcg_card/pack_1, /datum/tcg_card/exodia) //So star cards don't drop

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
	var/illegal = FALSE

/obj/item/tcg_card/special
	special = TRUE

/obj/item/tcg_card/examine(mob/user)
	. = ..()
	sleep(2) //So it prints this shit after the examine
	if(flipped)
		return
	to_chat(user, "<span class='notice'>This card has following stats:</span>")
	to_chat(user, "<span class='notice'>Mana cost: [card_datum.mana_cost]</span>")
	to_chat(user, "<span class='notice'>Health: [card_datum.health]</span>")
	to_chat(user, "<span class='notice'>Attack: [card_datum.attack]</span>")
	to_chat(user, "<span class='notice'>Faction: [card_datum.faction]</span>")
	to_chat(user, "<span class='notice'>Rarity: [card_datum.rarity]</span>")
	to_chat(user, "<span class='notice'>Card Type: [card_datum.card_type]</span>")
	to_chat(user, "<span class='notice'>It's effect is: [card_datum.rules]</span>")
	if(illegal)
		to_chat(user, "<span class='warning'>It's a low-quality copy of a real card. TCG Gaming Community won't probably accept it.</span>") //Doesn't do crap, just for lulz

/obj/item/tcg_card/openTip(location, control, params, user) //Overriding for nice UI
	if(flipped)
		return ..()
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

/obj/item/tcg_card/New(loc, new_datum, illegal_card = FALSE)
	. = ..()
	if(!special)
		datum_type = new_datum
	if(datum_type)
		card_datum = new datum_type
	illegal = illegal_card
	if(!card_datum)
		return
	icon = card_datum.pack
	icon_state = card_datum.icon_state
	name = card_datum.name
	desc = card_datum.desc

	switch(card_datum.rarity)
		if("Common")
			grind_results = list(/datum/reagent/card_powder/green = 1)
		if("Rare")
			grind_results = list(/datum/reagent/card_powder/blue = 1)
		if("Epic")
			grind_results = list(/datum/reagent/card_powder/purple = 1)
		if("Legendary")
			grind_results = list(/datum/reagent/card_powder/yellow = 1)
		if("Exodia")
			grind_results = list(/datum/reagent/card_powder/black = 1)

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
			user.put_in_hands(hand)
			hand.update_icon()
			return ..()
		var/obj/item/tcgcard_deck/new_deck = new /obj/item/tcgcard_deck(drop_location())
		new_deck.flipped = flipped
		user.transferItemToLoc(second_card, new_deck)//Start a new pile with both cards, in the order of card placement.
		user.transferItemToLoc(src, new_deck)
		new_deck.update_icon_state()
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
	var/list/series = list(/datum/tcg_card/pack_1, /datum/tcg_card/exodia)
	///Chance of the pack having a coin in it out of 10
	var/contains_coin = -1
	///The amount of cards to draw from the rarity table
	var/card_count = 5
	///The rarity table, the set must contain at least one of each
	var/list/rarity_table = list(
		"Common" = 900,
		"Rare" = 300,
		"Epic" = 50,
		"Legendary" = 3,
		"Exodia" = 1) //Basically 0.1%, it doesn't have guar. rarity
	///The amount of cards to draw from the guarenteed rarity table
	var/guaranteed_count = 1
	///The guaranteed rarity table, acts about the same as the rarity table. it can have as many or as few raritys as you'd like
	var/list/guar_rarity = list(
		"Legendary" = 1,
		"Epic" = 9,
		"Rare" = 30)

	var/illegal = FALSE //Can cargo get it?

	custom_price = PRICE_EXPENSIVE

/obj/item/cardpack/series_one
	name = "Trading Card Pack: 2560 Core Set"
	desc = "Contains six cards of varying rarity from the 2560 Core Set. Collect them all!"
	icon_state = "cardpack"
	series = list(/datum/tcg_card/pack_1, /datum/tcg_card/exodia)
	contains_coin = 10

/obj/item/cardpack/syndicate //More cards. Perfect stuff for gaming gang
	name = "Trading Card Pack: Nuclear Danger"
	desc = "Contains twelve cards of varying rarity from 2560 Core Set and 2560 Nuclear Danger. This pack was stamped by Waffle Co."
	icon_state = "cardpack_syndicate"
	series = list(/datum/tcg_card/pack_1, /datum/tcg_card/pack_nuclear)
	contains_coin = 100

	card_count = 9
	guaranteed_count = 3

	illegal = TRUE

	guar_rarity = list( //Better chances
		"Legendary" = 5,
		"Epic" = 10,
		"Rare" = 30)

/obj/item/cardpack/equipped(mob/user, slot, initial)
	. = ..()
	transform = matrix()

/obj/item/cardpack/dropped(mob/user, silent)
	. = ..()
	transform = matrix(0.5,0,0,0,0.5,0)

/obj/item/cardpack/attack_self(mob/user)
	. = ..()
	var/list/cards = buildCardListWithRarity(card_count, guaranteed_count)
	var/obj/item/tcgcard_hand/hand = new(get_turf(user))
	for(var/template in cards)
		var/obj/item/tcg_card/card = new(hand, template, illegal)
		hand.cards.Add(card)
	user.put_in_hands(hand)
	hand.update_icon()
	to_chat(user, "<span_class='notice'>Wow! Check out these cards!</span>")
	playsound(loc, 'sound/items/poster_ripped.ogg', 20, TRUE)
	if(prob(contains_coin))
		to_chat(user, "<span_class='notice'>...and it came with a flipper, too!</span>")
		new /obj/item/coin/thunderdome(get_turf(user))
	new /obj/item/paper/tcg_rules(get_turf(user))
	qdel(src)

/obj/item/cardpack/proc/buildCardListWithRarity(card_cnt, rarity_cnt)
	var/list/return_cards = list()

	var/list/cards = list()
	for(var/card_type in series)
		for(var/card in subtypesof(card_type))
			var/datum/tcg_card/new_card = new card()
			if(new_card.name == "Stupid Coder")
				continue
			cards.Add(card)
			qdel(new_card)
	var/list/possible_cards = list()
	var/list/rarity_cards = list("Exodia" = list(), "Legendary" = list(), "Epic" = list(), "Rare" = list(), "Common" = list())
	for(var/card in cards)
		var/datum/tcg_card/new_card = new card()
		if(new_card.name == "Stupid Coder")
			continue
		possible_cards[card] = rarity_table[new_card.rarity]
		var/list/rarity_card_type = rarity_cards[new_card.rarity]
		if(!rarity_card_type)
			rarity_card_type = list()
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

/obj/item/coin/thunderdome/Initialize(mapload)
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

/obj/item/tcgcard_deck/Initialize(mapload)
	LoadComponent(/datum/component/storage/concrete/tcg)
	. = ..()

/obj/item/tcgcard_deck/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage/concrete/tcg)
	STR.storage_flags = STORAGE_FLAGS_LEGACY_DEFAULT
	STR.max_volume = DEFAULT_VOLUME_TINY * 30
	STR.max_w_class = DEFAULT_VOLUME_TINY
	STR.max_items = 30

/obj/item/tcgcard_deck/update_icon_state()
	. = ..()
	if(flipped)
		switch(contents.len)
			if(1 to 10)
				icon_state = "deck_low"
			if(11 to 20)
				icon_state = "deck_half"
			if(21 to INFINITY)
				icon_state = "deck_full"
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
	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
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

	if(istype(I, /obj/item/tcgcard_hand))
		var/obj/item/tcgcard_hand/hand = I
		for(var/obj/item/tcg_card/card in hand.cards)
			if(contents.len > 30)
				return FALSE
			card.flipped = flipped
			card.forceMove(src)
			hand.cards.Remove(card)

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
	w_class = WEIGHT_CLASS_TINY
	var/list/cards = list()

/obj/item/tcgcard_hand/update_icon()
	. = ..()
	cut_overlays()
	var/angular = length(cards) / 2 * -30 + 15
	for(var/obj/item/tcg_card/card in cards)
		var/image/I = image(icon = card.icon, icon_state = card.icon_state)
		var/matrix/ntransform = matrix(I.transform)
		ntransform.TurnTo(angular, 0)
		ntransform.Translate(sin(angular) * -15, cos(angular) * 15)
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

/obj/item/tcgcard_hand/equipped(mob/user, slot, initial)
	. = ..()
	transform = matrix()

/obj/item/tcgcard_hand/dropped(mob/user, silent)
	. = ..()
	transform = matrix(0.5,0,0,0,0.5,0)

/obj/item/tcgcard_binder
	name = "Trading Card Binder"
	desc = "A TCG-branded card binder, specifically for your infinite collection of TCG cards!"
	icon = 'icons/obj/tcg/misc.dmi'
	icon_state = "binder"
	w_class = WEIGHT_CLASS_SMALL

	var/list/cards = list()
	var/list/decks = list()
	var/mode = 0 //If 1, will show all the cards even if you don't have em. If 2, will show your decks

/obj/item/tcgcard_binder/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tcg_card))
		var/obj/item/tcg_card/card = I
		card.forceMove(src)
		cards.Add(card)
	if(istype(I, /obj/item/tcgcard_hand))
		var/obj/item/tcgcard_hand/hand = I
		for(var/obj/item/tcg_card/card in hand.cards)
			card.forceMove(src)
			cards.Add(card)
		qdel(I)
	if(istype(I, /obj/item/tcgcard_deck))
		var/obj/item/tcgcard_deck/deck = I
		var/named = input(user, "How will this deck be named? Leave this field empty if you don't want to save this deck.")
		if(named)
			decks[named] = list()
		for(var/obj/item/tcg_card/card in deck.contents)
			card.forceMove(src)
			cards.Add(card)
			if(named)
				decks[named] += card.name
		qdel(I)
	. = ..()

/obj/item/tcgcard_binder/attack_self(mob/living/carbon/user)
	mode = (mode + 1) % 3
	switch(mode)
		if(0)
			to_chat(user, "<span class='notice'>[src] now shows you the cards you already have.")
		if(1)
			to_chat(user, "<span class='notice'>[src] now shows you all the different cards.")
		if(2)
			to_chat(user, "<span class='notice'>[src] now shows you your deck menu.")

/obj/item/tcgcard_binder/attack_hand(mob/living/carbon/user)
	if(loc == user)
		var/list/choices = list()
		switch(mode)
			if(1)
				var/card_types = list()

				for(var/obj/item/tcg_card/card in cards)
					card_types[card.datum_type] = card

				for(var/card_type in subtypesof(/datum/tcg_card))
					if(card_type in card_types)
						var/obj/item/tcg_card/card = card_types[card_type]
						choices[card] = image(icon = card.icon, icon_state = card.icon_state)
						continue

					var/datum/tcg_card/card_dat = new card_type
					if(card_dat.name == "Stupid Coder")
						continue
					var/image/I = image(icon = card_dat.pack, icon_state = card_dat.icon_state)
					I.color = "#999999"
					choices[card_dat.name] = I
					qdel(card_dat)
			if(0)
				for(var/obj/item/tcg_card/card in cards)
					choices[card] = image(icon = card.icon, icon_state = card.icon_state)

			if(2)
				for(var/deck in decks)
					choices[deck] = image(icon = 'icons/obj/tcg/misc.dmi', icon_state = "deck_up")

		var/obj/item/tcg_card/choice = show_radial_menu(user, src, choices, require_near = TRUE, tooltips = TRUE)
		if(choice && (choice in cards))
			choice.forceMove(get_turf(src))
			user.put_in_hands(choice)
			cards.Remove(choice)

		if(choice && (choice in decks))
			var/obj/item/tcgcard_deck/new_deck = new(get_turf(user))
			var/list/required_cards = decks[choice]
			for(var/obj/item/tcg_card/card in cards)
				if(card.name in required_cards)
					required_cards.Remove(card.name)
					cards.Remove(card)
					card.forceMove(new_deck)
			user.put_in_hands(new_deck)

		if(choice)
			return
	. = ..()

/obj/item/tcgcard_binder/proc/check_for_exodia()
	var/list/card_types = list()
	for(var/obj/item/tcg_card/card in cards)
		card_types.Add(card.datum_type)

	for(var/card_type in subtypesof(/datum/tcg_card))
		var/datum/tcg_card/card_dat = new card_type

		if(card_dat.name == "Eldritch Horror" && (card_type in card_types)) //We already have Exodia saved
			qdel(card_dat)
			return

		if(card_dat.name == "Stupid Coder" || card_dat.name == "Eldritch Horror") //It would be stupid if we require exodia or system cards to get exodia
			continue
		qdel(card_dat)
		if(!(card_type in card_types))
			return

	var/obj/item/tcg_card/card = new(get_turf(src), /datum/tcg_card/exodia/exodia)
	card.forceMove(src)
	cards.Add(card)

/obj/item/tcgcard_binder/full/Initialize(mapload) //For admemes.
	. = ..()
	for(var/cardtype in subtypesof(/datum/tcg_card))
		var/obj/item/tcg_card/card = new(get_turf(src), cardtype)
		if(card.card_datum.name == "Stupid Coder")
			qdel(card)
			continue
		card.forceMove(src)
		cards.Add(card)

/obj/item/paper/tcg_rules
	name = "TCG Rulebook"
	desc = "A small rulebook containing a starter guide for TCG."
	icon = 'icons/obj/tcg/misc.dmi'
	icon_state = "deck_low"
	w_class = WEIGHT_CLASS_TINY

	info = "<span class='notice'>*---------* \n\
	      <span class='boldnotice'>Welcome to the Exciting world of Tactical Card Game!</span> <span clas='smallnotice'>Sponsored by Nanotrasen Edu-tainment Devision.</span> \n \
		  <span class='boldnotice'>Core Rules:</span> \n \
		  <br> \n \
		  Tactical Card Game (Also known as TCG) is a traditional trading card game. It's played between two players, each with a deck or collection of cards. \n \

		  <br> \n \
		  Each player's deck contains up to 30 cards. Each player's hand can hold a maximum of 7 cards. At the end of your turn, if you have more than 7 cards, you must choose cards to discard to your discard pile until you have 7 cards.  \n \
		  To begin a match, both players must flip a coin to decide who goes first. The winner of the coin toss then decides if they go first or second. Before the match begins each player draws 5 cards each with the ability to mulligan cards from their hand facedown once (Basically, you get a first pass where you can replace cards in your hands back into your deck, shuffle your deck, then draw until you're back to 5).  \n \
		  Each player begins with 1 Max Mana to start with, which serves as the cost to playing cards. \n \

		  <br> \n \
		  In order to play the TCG, a deck is required. As stated above, decks must contain up to 30 cards.  \n \
		  Additionally, to save cards you need to have a card binder on yourself to store the cards. When the shift ends, your cards will be automatically saved by integrated scanners in your card binder.  \n \
		  Finally, a stock of Thunderdome Flippers to use for coin tosses and counter effects is recommended- these can be obtained occasionally from cardpacks, but any coin will do.  \n \

		  <br> \n \
		  Win condition is simple - kill your opponent's hero by depleting all of their 20 lifeshards.  \n \

		  <br> \n \
		  <span class='boldnotice'>Gameplay Phases:</span>  \n \

		  <br> \n \
		  A single turn of the game goes as follows, and the order of card effects is very similar to other card games. Within a single turn, the following phases are gone through, in order, unless otherwise altered by a card effect. Turn Phases are the Draw Phase, Effect Phase 1, Play Phase, Combat Phase, Effect Phase 2, and the End Phase.  \n \

		  <br> \n \
		  During the draw phase, the player whose turn it is untaps all their cards, then draws a single card. They gain 1 Max Mana, and their Mana is refilled. Cards with missing health due to defending, attacking, or damage effects return to max health at the end of the draw phase.  \n \
		  During the First Effect Phase, this is when effects that take place at the start of your turn would occur. If an opponent's effect takes place at the start of your turn, their effects will always take place first, then yours, unless otherwise stated by a card effect. If an opponent's effect would cause you to lose the game, and your effects would prevent that condition from happening afterwards, you would lose the game. As a general roll, when it's your turn, your opponent's effects take place FIRST, then yours.  \n \

		  <br> \n \
		  During the Play Phase, this is when you can play, summon, or activate your own cards. Card Effects that don't state when they're activated MUST be activated during the Play Phase. Your opponent can also activate their own card effects in response to one of your actions during your play phase, if able. Any card played during the play phase can activate its effect as soon as it's played. More details within the Card Breakdown section.  \n \

		  <br> \n \
		  During the Battle Phase, a Unit Card is able to battle other Unit Cards, or attack their opponent once per turn. Neither player can attack on their first turn, and all cards that enter the field can attack as soon as they can, unless it is that player's first turn, or they are prevented by a card effect. More details within the Card Combat section.  \n \

		  <br> \n \
		  During the End Phase, end of turn effects will occur. If the active player has more than 7 cards in their hand by this point, this is when they must discard cards. All of the player's cards who used an effect at any point in the turn are refreshed, and able to use their effect again going into the opponent's turn. By the end of their turn, if the player has more than 7 cards, they must discard cards from their hand until 7 remain.  \n \
		  After all 5 phases have passed, the players turn officially ends, and the opponent begins their turn, starting anew from the draw phase.  \n \

		  <br> \n \
		  Card effects are typically limited to the turn that that card is played. For example, a card effect that provides a card +1/+1 attack/health would only last until the end of the turn, unless otherwise stated, OR if the card is an Equipment Card. More on those below.  \n \

		  <br> \n \
		  <span class='boldnotice'>Card Breakdown:</span>  \n \

		  <br> \n \
		  Within the game, there are 3 kinds of cards (So far), Unit, Equipment and Spell cards.  \n \

		  <br> \n \
		  Unit Cards. All Unit Cards have 4 core values to keep in mind, Attack, Health, Faction, and Summoning Cost. Attack serves as a card's offensive value in combat. Health serves as a card's defensive value in combat, and doubles as a card's health. Factions are groupings of cards that can often share effects and traits together. Summoning Cost is how much mana a card needs in order to be summoned.  \n \

		  <br> \n \
		  Equipment Cards. All Equipment Cards similarly to Unit Cards have Attack, Health, and Summon Cost values, but for equipment, these values are added to the attached card's values. Equipment can only be attached (Equip) to units, and they last until the unit dies, or otherwise leaves the field, following it's equipt card. If returned to the hand, send to the discard pile, or otherwise leaves the field, it is detatched from the equipt card. When a Equipment Card increases a card's attack or health, those effects stay on the equip card until the equipment is unequip or removed from the parent card.  \n \
		  If a card would have it's health decreased by having it's equip card removed, it's handled by having it's maximum health decreased, not it's current health. For example, lets say you had a card with 1/1 attack/health, and give it an equipment giving it +1/+2, then that card enters combat, dropping it down to 2/1. If by an opponent's card effect it lost that +1/+2 equipment now, it's stats would be 1/1 once again. If an equip card explicitly lowers a card's stats, it is possible for a card to be killed as a result, but drops in attack will always bottom out at 0 attack at any given time.  \n \

		  <br> \n \
		  Spell Cards. Spell Cards don't have attack or health values, instead, they activate their effects as soon as they are summoned and leave the field afterwards(if not stated otherwise).  \n \
		  <br> \n \
		  <span class='boldnotice'>Card Subtypes:</span>  \n \
		  <br> \n \
		  Card effects:  \n \
		  Asimov - Unit cannot attack units with Human subtype  \n \
		  Changeling - Unit posesses all the subtypes at the same time  \n \
		  Greytide - On summon, unit gains amount of power equal to amount of other units with Greytide for 1 turn  \n \
		  Holy - Unit can't be targeted by spells  \n \
		  Taunt - All opposing unit attacks must be directed towards the unit with Taunt.  \n \
		  First Strike - This unit attacks first. If attacked unit is dead, unit doesn't recieve damage from it.  \n \
		  Deadeye - This unit can always hit opponents, regardless of effects or immunities.  \n \
		  Squad Tactics - When this unit attacks an opponent's unit and defeats it in combat, the owner of the defeated card takes 1 lifeshard of damage from combat.  \n \
		  Immunity - The unit cannot be affected by card effects or combat of its immunity type. This includes both friendly and opposing effects.  \n \
		  Fury - The unit must attack at every possibility.  \n \
		  Blocker - The unit cannot declare attacks, but can defend.  \n \
		  Hivemind - The unit enters combat with a hivemind token on it. The first time this card would take damage, remove that token instead. This does not apply to instant removal effects, only points of damage.  \n \
		  Clockwork - The unit can copy a single keyword on another unit on the field, until they lose the clockwork keyword or leave the field.  \n \
		  <br> \n \
		  <span class='boldnotice'>Card Combat:</span>  \n \
		  <br> \n \
		  Card combat is determined as follows. On your turn, any non-tapped unit card with a positive attack power is capable of declaring an attack. Upon declaring an attack, you must state if you're attacking your opponent directly, or if you're going to attack a specific opponent's unit. Unless otherwise stated, cards can only attack or defend one time per turn.  \n \
		  <br> \n \
		  An attack against a unit healths as follows: Both units will do their power as damage to the opponent's unit's health. Damage is typically dealt at the same time, and if both units would kill each other through combat, both are destroyed at the same time. If One or both units would not be destroyed by combat, they would have their health reduced by the difference of their health minus their opponent's power, until the start of your next turn. If the attacker or defender has a keyword or effect that prevents them from attacking their opponent (Like silicon, immunity), then they are not able to attack, but may still defend against the opponent's attack. Once combat has healthd, all remaining participants become tapped.  \n \
		  <br> \n \
		  A direct attack healths as follows: The attacking unit declares an attack against the opponent's lifeshards. Your opponent may then declare a defender if one is available, who will then turn the combat into an attack against a unit for the purposes of combat that turn. If the attack is not blocked, and the direct attack connects, then your opponent loses a number of lifeshards equal to the attacking units power. </span>"

/obj/item/cardboard_card
	name = "cardboard card cutout"
	desc = "A small piece of cardboard shaped as a TCG card."
	icon = 'icons/obj/tcg/misc.dmi'
	icon_state = "template"

/datum/reagent/card_powder/reaction_obj(obj/O, reac_volume)
	if(istype(O, /obj/item/cardboard_card))
		var/list/possible_cards = list()
		for(var/card_series in COMMON_SERIES)
			for(var/card_type in subtypesof(card_series))
				var/datum/tcg_card/card = new card_type
				if(card.rarity == rarity)
					possible_cards.Add(card_type)
				qdel(card)
		if(length(possible_cards))
			new /obj/item/tcg_card(get_turf(O), pick(possible_cards), TRUE)
			qdel(O)

	. = ..()

/mob/living/carbon/human/proc/SaveTCGCards()
	if(!client)
		return

	var/obj/item/tcgcard_binder/binder = locate() in src
	if(!binder)
		var/obj/item/storage/backpack/back = locate() in src
		binder = locate() in back

	if(!binder)
		return

	var/list/card_types = list()
	for(var/obj/item/tcg_card/card in binder.cards)
		//if(!card.illegal) //Uncomment if you want to block syndie cards from saving
		if(!(card.datum_type in card_types))
			card_types[card.datum_type] = card.illegal
		else
			if(islist(card_types[card.datum_type]))
				card_types[card.datum_type] += card.illegal
			else
				card_types[card.datum_type] = list(card_types[card.datum_type], card.illegal)

	client.prefs.tcg_decks = binder.decks
	client.prefs.tcg_cards = card_types
	client.prefs.save_character(TRUE)

#undef COMMON_SERIES
#undef TAPPED_ANGLE
#undef UNTAPPED_ANGLE
