/// Mail is tamper-evident and unresealable, postmarked by CentCom for an individual recepient.
/obj/item/mail
	name = "mail"
	gender = NEUTER
	desc = "An officially postmarked, tamper-evident parcel regulated by CentCom and made of high-quality materials."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail_small"
	item_state = "paper"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	// drop_sound = 'sound/items/handling/paper_drop.ogg'
	// pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	/// Destination tagging for the mail sorter.
	var/sort_tag = 0
	/// Weak reference to who this mail is for and who can open it.
	var/datum/weakref/recipient_ref
	/// How many goodies this mail contains.
	var/goodie_count = 1
	/// Goodies which can be given to anyone. The base weight for cash is 56. For there to be a 50/50 chance of getting a department item, they need 56 weight as well.
	var/list/generic_goodies = list(
		/obj/item/stack/spacecash/c50 = 10,
		/obj/item/stack/spacecash/c100 = 25,
		/obj/item/stack/spacecash/c200 = 15,
		/obj/item/stack/spacecash/c500 = 5,
		/obj/item/stack/spacecash/c1000 = 1,
	)
	// Overlays (pure fluff)
	/// Does the letter have the postmark overlay?
	var/postmarked = TRUE
	/// Does the letter have a stamp overlay?
	var/stamped = TRUE
	/// List of all stamp overlays on the letter.
	var/list/stamps = list()
	/// Maximum number of stamps on the letter.
	var/stamp_max = 1
	/// Physical offset of stamps on the object. X direction.
	var/stamp_offset_x = 0
	/// Physical offset of stamps on the object. Y direction.
	var/stamp_offset_y = 2

	///mail will have the color of the department the recipient is in.
	var/static/list/department_colors

/obj/item/mail/envelope
	name = "envelope"
	icon_state = "mail_large"
	goodie_count = 2
	stamp_max = 2
	stamp_offset_y = 5

/obj/item/mail/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))
	AddElement(/datum/element/item_scaling, 0.5, 1)
	if(isnull(department_colors))
		department_colors = list(
			ACCOUNT_CIV = COLOR_WHITE,
			ACCOUNT_ENG = COLOR_PALE_ORANGE,
			ACCOUNT_SCI = COLOR_PALE_PURPLE_GRAY,
			ACCOUNT_MED = COLOR_PALE_BLUE_GRAY,
			ACCOUNT_SRV = COLOR_PALE_GREEN_GRAY,
			ACCOUNT_CAR = COLOR_BEIGE,
			ACCOUNT_SEC = COLOR_PALE_RED_GRAY,
		)

	// Icons
	// Add some random stamps.
	if(stamped == TRUE)
		var/stamp_count = rand(1, stamp_max)
		for(var/i = 1, i <= stamp_count, i++)
			stamps += list("stamp_[rand(2, 6)]")
	update_icon()

/obj/item/mail/update_overlays()
	. = ..()
	var/bonus_stamp_offset = 0
	for(var/stamp in stamps)
		var/image/stamp_image = image(
			icon = icon,
			icon_state = stamp,
			pixel_x = stamp_offset_x,
			pixel_y = stamp_offset_y + bonus_stamp_offset
		)
		stamp_image.appearance_flags |= RESET_COLOR
		bonus_stamp_offset -= 5
		. += stamp_image

	if(postmarked == TRUE)
		var/image/postmark_image = image(
			icon = icon,
			icon_state = "postmark",
			pixel_x = stamp_offset_x + rand(-3, 1),
			pixel_y = stamp_offset_y + rand(bonus_stamp_offset + 3, 1)
		)
		postmark_image.appearance_flags |= RESET_COLOR
		. += postmark_image

/obj/item/mail/attackby(obj/item/W, mob/user, params)
	// Destination tagging
	if(istype(W, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/destination_tag = W

		if(sort_tag != destination_tag.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[destination_tag.currTag])
			to_chat(user, span_notice("*[tag]*"))
			sort_tag = destination_tag.currTag
			playsound(loc, 'sound/machines/twobeep_high.ogg', vol = 100, vary = TRUE)

/obj/item/mail/multitool_act(mob/living/user, obj/item/tool)
	if(user.get_inactive_held_item() == src)
		balloon_alert(user, "nothing to disable!")
		return TRUE
	balloon_alert(user, "hold it!")
	return FALSE

/obj/item/mail/attack_self(mob/user)
	if(!unwrap(user))
		return FALSE
	return after_unwrap(user)

/// proc for unwrapping a mail. Goes just for an unwrapping procces, returns FALSE if it fails.
/obj/item/mail/proc/unwrap(mob/user)
	if(recipient_ref)
		var/datum/mind/recipient = recipient_ref.resolve()
		// If the recipient's mind has gone, then anyone can open their mail
		// whether a mind can actually be qdel'd is an exercise for the reader
		if(recipient && recipient != user?.mind)
			to_chat(user, span_notice("You can't open somebody else's mail! That's <em>illegal</em>!"))
			return FALSE

	balloon_alert(user, "unwrapping...")
	if(!do_after(user, 1.5 SECONDS, target = user))
		return FALSE
	return TRUE

// proc that goes after unwrapping a mail.
/obj/item/mail/proc/after_unwrap(mob/user)
	user.temporarilyRemoveItemFromInventory(src, force = TRUE)
	for(var/obj/stuff as anything in contents) // Mail and envelope actually can have more than 1 item.
		if(isitem(stuff))
			user.put_in_hands(stuff)
		else
			stuff.forceMove(drop_location())
	playsound(loc, 'sound/items/poster_ripped.ogg', vol = 50, vary = TRUE)
	qdel(src)
	return TRUE

/obj/item/mail/examine_more(mob/user)
	. = ..()
	if(!postmarked)
		. += span_info("This mail has no postmarking of any sort...")
	else
		. += span_notice("<i>You notice the postmarking on the front of the mail...</i>")
	var/datum/mind/recipient = recipient_ref.resolve()
	if(recipient)
		. += span_info("[postmarked ? "Certified NT" : "Uncertified"] mail for [recipient].")
	else if(postmarked)
		. += span_info("Certified mail for [GLOB.station_name].")
	else
		. += span_info("This is a dead letter mail with no recipient.")
	. += span_info("Distribute by hand or via destination tagger using the certified NT disposal system.")

/// Accepts a mind to initialize goodies for a piece of mail.
/obj/item/mail/proc/initialize_for_recipient(datum/mind/recipient)
	name = "[initial(name)] for [recipient.name] ([recipient.assigned_role])"
	recipient_ref = WEAKREF(recipient)

	var/mob/living/body = recipient.current
	var/list/goodies = generic_goodies

	var/datum/job/this_job = SSjob.name_occupations[recipient.assigned_role]
	var/is_mail_restricted = FALSE // certain roles and jobs (prisoner) do not receive generic gifts

	if(this_job)
		if(this_job.paycheck_department && department_colors[this_job.paycheck_department])
			color = department_colors[this_job.paycheck_department]

		var/list/job_goodies = this_job.get_mail_goodies()
		is_mail_restricted = this_job.exclusive_mail_goodies
		if(LAZYLEN(job_goodies))
			if(is_mail_restricted)
				goodies = job_goodies
			else
				goodies += job_goodies

	if(!is_mail_restricted)
		// the weighted list is 50 (generic items) + 50 (job items)
		// every quirk adds 5 to the final weighted list (regardless the number of items or weights in the quirk list)
		// 5% is not too high or low so that stacking multiple quirks doesn't tilt the weighted list too much
		for(var/datum/quirk/quirk as anything in body.roundstart_quirks)
			if(LAZYLEN(quirk.mail_goodies))
				var/quirk_goodie = pick(quirk.mail_goodies)
				goodies[quirk_goodie] = 5

		// A little boost for the special times!
		for(var/datum/holiday/holiday as anything in SSevents.holidays)
			if(LAZYLEN(holiday.mail_goodies))
				var/holiday_goodie = pick(holiday.mail_goodies)
				goodies[holiday_goodie] = holiday.mail_goodies[holiday_goodie]

	for(var/iterator in 1 to goodie_count)
		var/target_good = pickweight(goodies)
		var/atom/movable/target_atom = new target_good(src)
		body.log_message("received [target_atom.name] in the mail ([target_good])", LOG_GAME)

	return TRUE

/// Alternate setup, just complete garbage inside and anyone can open
/obj/item/mail/proc/junk_mail()

	var/obj/junk = /obj/item/paper/fluff/junkmail_generic
	var/special_name = FALSE

	if(prob(25))
		special_name = TRUE
		junk = pick(list(/obj/item/paper/pamphlet/gateway, /obj/item/paper/pamphlet/violent_video_games, /obj/item/paper/fluff/junkmail_redpill, /obj/effect/decal/cleanable/ash))

	var/list/junk_names = list(
		/obj/item/paper/pamphlet/gateway = "[initial(name)] for [pick(GLOB.adjectives)] adventurers",
		/obj/item/paper/pamphlet/violent_video_games = "[initial(name)] for the truth about the arcade centcom doesn't want to hear",
		/obj/item/paper/fluff/junkmail_redpill = "[initial(name)] for those feeling [pick(GLOB.adjectives)] working at Nanotrasen",
		/obj/effect/decal/cleanable/ash = "[initial(name)] with INCREDIBLY IMPORTANT ARTIFACT- DELIVER TO SCIENCE DIVISION. HANDLE WITH CARE.",
	)

	color = pick(department_colors) //eh, who gives a shit.
	name = special_name ? junk_names[junk] : "important [initial(name)]"

	junk = new junk(src)
	return TRUE

/obj/item/mail/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sort_tag

/// Subtype that's always junkmail
/obj/item/mail/junkmail/Initialize()
	..()
	junk_mail()

/// Crate for mail from CentCom.
/obj/structure/closet/crate/mail
	name = "mail crate"
	desc = "A certified post crate from CentCom."
	icon_state = "mail"
	base_icon_state = "mail"
	///if it'll show the nt mark on the crate
	var/postmarked = TRUE

/obj/structure/closet/crate/mail/update_icon_state()
	. = ..()
	if(opened)
		icon_state = "[base_icon_state]open"
		if(locate(/obj/item/mail) in src)
			icon_state = base_icon_state
	else
		icon_state = "[base_icon_state]sealed"

/obj/structure/closet/crate/mail/update_overlays()
	. = ..()
	if(postmarked)
		. += "mail_nt"

/// Fills this mail crate with N pieces of mail, where N is the lower of the amount var passed, and the maximum capacity of this crate. If N is larger than the number of alive human players, the excess will be junkmail.
/obj/structure/closet/crate/mail/proc/populate(amount)
	var/mail_count = min(amount, storage_capacity)
	// Fills the
	var/list/mail_recipients = list()

	for(var/mob/living/carbon/human/human in GLOB.player_list)
		if(human.stat == DEAD || !human.mind)
			continue
		// Skip wizards, nuke ops, cyborgs; Centcom does not send them mail
		if(!(human.mind.assigned_role in get_all_jobs()))
			continue

		mail_recipients += human.mind

	for(var/i in 1 to mail_count)
		var/obj/item/mail/new_mail
		if(prob(FULL_CRATE_LETTER_ODDS))
			new_mail = new /obj/item/mail(src)
		else
			new_mail = new /obj/item/mail/envelope(src)

		var/datum/mind/recipient = pick_n_take(mail_recipients)
		if(recipient)
			new_mail.initialize_for_recipient(recipient)
		else
			new_mail.junk_mail()

	update_icon()

/// Crate for mail that automatically depletes the economy subsystem's pending mail counter.
/obj/structure/closet/crate/mail/economy/Initialize(mapload)
	. = ..()
	populate(SSeconomy.mail_waiting)
	SSeconomy.mail_waiting = 0

/// Crate for mail that automatically generates a lot of mail. Usually only normal mail, but on lowpop it may end up just being junk.
/obj/structure/closet/crate/mail/full
	name = "brimming mail crate"
	desc = "A certified post crate from CentCom. Looks stuffed to the gills."

/obj/structure/closet/crate/mail/full/Initialize(mapload)
	. = ..()
	populate(INFINITY)

///Used in the mail strike shuttle loan event
/* /obj/structure/closet/crate/mail/full/mail_strike
	desc = "A post crate from somewhere else. It has no NT logo on it."
	postmarked = FALSE

/obj/structure/closet/crate/mail/full/mail_strike/populate(amount)
	var/strike_mail_to_spawn = rand(1, storage_capacity-1)
	for(var/i in 1 to strike_mail_to_spawn)
		if(prob(95))
			new /obj/item/mail/mail_strike(src)
		else
			new /obj/item/mail/traitor/mail_strike(src)
	return ..(storage_capacity - strike_mail_to_spawn) */

/// Opened mail crate
/obj/structure/closet/crate/mail/preopen
	opened = TRUE
	icon_state = "mailopen"

/// Mailbag.
/obj/item/storage/bag/mail
	name = "mail bag"
	desc = "A bag for letters, envelopes, and other postage."
	icon = 'icons/obj/library.dmi'
	icon_state = "bookbag"
	item_state = "bookbag"
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/mail/ComponentInitialize()
	. = ..()
	var/datum/component/storage/storage = GetComponent(/datum/component/storage)
	storage.max_w_class = WEIGHT_CLASS_NORMAL
	storage.max_combined_w_class = 42
	storage.max_items = 21
	storage.display_numerical_stacking = FALSE
	storage.can_hold = list(
		/obj/item/mail,
		/obj/item/small_delivery,
		/obj/item/paper
	)

/obj/item/paper/fluff/junkmail_redpill
	name = "smudged paper"
	icon_state = "scrap"
	var/nuclear_option_odds = 0.1

/obj/item/paper/fluff/junkmail_redpill/Initialize()
	. = ..()
	if(!prob(nuclear_option_odds)) // 1 in 1000 chance of getting 2 random nuke code characters.
		info = "<i>You need to escape the simulation. Don't forget the numbers, they help you remember:</i> '[rand(0,9)][rand(0,9)][rand(0,9)]...'"
		return
	var/code = random_nukecode()
	for(var/obj/machinery/nuclearbomb/selfdestruct/self_destruct in GLOB.nuke_list)
		self_destruct.r_code = code
	message_admins("Through junkmail, the self-destruct code was set to \"[code]\".")
	info = "<i>You need to escape the simulation. Don't forget the numbers, they help you remember:</i> '[code[rand(1,5)]][code[rand(1,5)]]...'"

/obj/item/paper/fluff/junkmail_redpill/true //admin letter enabling players to brute force their way through the nuke code if they're so inclined.
	nuclear_option_odds = 100

/obj/item/paper/fluff/junkmail_generic
	name = "important document"
	icon_state = "paper_words"

/obj/item/paper/fluff/junkmail_generic/Initialize()
	. = ..()
	info = pick(GLOB.junkmail_messages)

/* Maybe some other time
/obj/item/mail/traitor
	var/armed = FALSE
	var/datum/weakref/made_by_ref
	/// Cached information about who made it for logging purposes
	var/made_by_cached_name
	/// Cached information about who made it for logging purposes
	var/made_by_cached_ckey
	goodie_count = 0

/obj/item/mail/traitor/envelope
	name = "envelope"
	icon_state = "mail_large"
	stamp_max = 2
	stamp_offset_y = 5

/obj/item/mail/traitor/after_unwrap(mob/user)
	user.temporarilyRemoveItemFromInventory(src, force = TRUE)
	playsound(loc, 'sound/items/poster_ripped.ogg', vol = 50, vary = TRUE)
	for(var/obj/item/stuff as anything in contents) // Mail and envelope actually can have more than 1 item.
		if(user.put_in_hands(stuff) && armed)
			var/whomst = made_by_cached_name ? "[made_by_cached_name] ([made_by_cached_ckey])" : "no one in particular"
			log_bomber(user, "opened armed mail made by [whomst], activating", stuff)
			INVOKE_ASYNC(stuff, TYPE_PROC_REF(/obj/item, attack_self), user)
	qdel(src)
	return TRUE

/obj/item/mail/traitor/multitool_act(mob/living/user, obj/item/tool)
	if(armed == FALSE || user.get_inactive_held_item() != src)
		return ..()
	if(IS_WEAKREF_OF(user.mind, made_by_ref))
		balloon_alert(user, "disarming trap...")
		if(!do_after(user, 2 SECONDS, target = src))
			return FALSE
		balloon_alert(user, "disarmed")
		playsound(src, 'sound/machines/defib_ready.ogg', vol = 100, vary = TRUE)
		armed = FALSE
		return TRUE
	else
		balloon_alert(user, "tinkering with something...")

		if(!do_after(user, 2 SECONDS, target = src))
			after_unwrap(user)
			return FALSE
		if(prob(50))
			balloon_alert(user, "disarmed something...?")
			playsound(src, 'sound/machines/defib_ready.ogg', vol = 100, vary = TRUE)
			armed = FALSE
			return TRUE
		else
			after_unwrap(user)
			return TRUE

///Generic mail used in the mail strike shuttle loan event
/obj/item/mail/mail_strike
	name = "dead mail"
	desc = "An unmarked parcel of unknown origins, effectively undeliverable."
	postmarked = FALSE
	generic_goodies = list(
		/obj/effect/spawner/random/entertainment/money_medium = 2,
		/obj/effect/spawner/random/contraband = 2,
		/obj/effect/spawner/random/entertainment/money_large = 1,
		/obj/effect/spawner/random/entertainment/coin = 1,
		/obj/effect/spawner/random/food_or_drink/any_snack_or_beverage = 1,
		/obj/effect/spawner/random/entertainment/drugs = 1,
		/obj/effect/spawner/random/contraband/grenades = 1,
	)

/obj/item/mail/mail_strike/Initialize(mapload)
	if(prob(35))
		stamped = FALSE
	if(prob(35))
		name = "dead envelope"
		icon_state = "mail_large"
		goodie_count = 2
		stamp_max = 2
		stamp_offset_y = 5
	. = ..()
	color = pick(COLOR_SILVER, COLOR_DARK, COLOR_DRIED_TAN, COLOR_ORANGE_BROWN, COLOR_BROWN, COLOR_SYNDIE_RED)
	for(var/goodie in 1 to goodie_count)
		var/target_good = pick_weight(generic_goodies)
		new target_good(src)

///Also found in the mail strike shuttle loan. It contains a random grenade that'll be triggered when unwrapped
/obj/item/mail/traitor/mail_strike
	name = "dead mail"
	desc = "An unmarked parcel of unknown origins, effectively undeliverable."
	postmarked = FALSE

/obj/item/mail/traitor/mail_strike/Initialize(mapload)
	if(prob(35))
		stamped = FALSE
	if(prob(35))
		name = "dead envelope"
		icon_state = "mail_large"
		goodie_count = 2
		stamp_max = 2
		stamp_offset_y = 5
	. = ..()
	color = pick(COLOR_SILVER, COLOR_DARK, COLOR_DRIED_TAN, COLOR_ORANGE_BROWN, COLOR_BROWN, COLOR_SYNDIE_RED)
	new /obj/effect/spawner/random/contraband/grenades/dangerous(src)
*/
