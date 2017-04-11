GLOBAL_LIST_EMPTY(sacrificed) //a mixed list of minds and mobs
GLOBAL_LIST(rune_types) //Every rune that can be drawn by tomes
GLOBAL_LIST_EMPTY(teleport_runes)
GLOBAL_LIST_EMPTY(wall_runes)
/*

This file contains runes.
Runes are used by the cult to cause many different effects and are paramount to their success.
They are drawn with an arcane tome in blood, and are distinguishable to cultists and normal crew by examining.
Fake runes can be drawn in crayon to fool people.
Runes can either be invoked by one's self or with many different cultists. Each rune has a specific incantation that the cultists will say when invoking it.

To draw a rune, use an arcane tome.

*/

/obj/effect/rune
	name = "rune"
	var/cultist_name = "basic rune"
	desc = "An odd collection of symbols drawn in what seems to be blood."
	var/cultist_desc = "a basic rune with no function." //This is shown to cultists who examine the rune in order to determine its true purpose.
	anchored = 1
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = LOW_OBJ_LAYER
	color = "#FF0000"

	var/invocation = "Aiy ele-mayo!" //This is said by cultists when the rune is invoked.
	var/req_cultists = 1 //The amount of cultists required around the rune to invoke it. If only 1, any cultist can invoke it.
	var/req_cultists_text //if we have a description override for required cultists to invoke
	var/rune_in_use = 0 // Used for some runes, this is for when you want a rune to not be usable when in use.

	var/scribe_delay = 50 //how long the rune takes to create
	var/scribe_damage = 0.1 //how much damage you take doing it

	var/allow_excess_invokers = 0 //if we allow excess invokers when being invoked
	var/construct_invoke = 1 //if constructs can invoke it

	var/req_keyword = 0 //If the rune requires a keyword - go figure amirite
	var/keyword //The actual keyword for the rune

/obj/effect/rune/New(loc, set_keyword)
	..()
	if(set_keyword)
		keyword = set_keyword

/obj/effect/rune/examine(mob/user)
	..()
	if(iscultist(user) || user.stat == DEAD) //If they're a cultist or a ghost, tell them the effects
		to_chat(user, "<b>Name:</b> [cultist_name]")
		to_chat(user, "<b>Effects:</b> [capitalize(cultist_desc)]")
		to_chat(user, "<b>Required Acolytes:</b> [req_cultists_text ? "[req_cultists_text]":"[req_cultists]"]")
		if(req_keyword && keyword)
			to_chat(user, "<b>Keyword:</b> [keyword]")

/obj/effect/rune/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/weapon/tome) && iscultist(user))
		to_chat(user, "<span class='notice'>You carefully erase the [lowertext(cultist_name)] rune.</span>")
		qdel(src)
	else if(istype(I, /obj/item/weapon/nullrod))
		user.say("BEGONE FOUL MAGIKS!!")
		to_chat(user, "<span class='danger'>You disrupt the magic of [src] with [I].</span>")
		qdel(src)

/obj/effect/rune/attack_hand(mob/living/user)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>You aren't able to understand the words of [src].</span>")
		return
	var/list/invokers = can_invoke(user)
	if(invokers.len >= req_cultists)
		invoke(invokers)
	else
		fail_invoke()

/obj/effect/rune/attack_animal(mob/living/simple_animal/M)
	if(istype(M, /mob/living/simple_animal/shade) || istype(M, /mob/living/simple_animal/hostile/construct))
		if(construct_invoke || !iscultist(M)) //if you're not a cult construct we want the normal fail message
			attack_hand(M)
		else
			to_chat(M, "<span class='warning'>You are unable to invoke the rune!</span>")

/obj/effect/rune/proc/talismanhide() //for talisman of revealing/hiding
	visible_message("<span class='danger'>[src] fades away.</span>")
	invisibility = INVISIBILITY_OBSERVER
	alpha = 100 //To help ghosts distinguish hidden runes

/obj/effect/rune/proc/talismanreveal() //for talisman of revealing/hiding
	invisibility = 0
	visible_message("<span class='danger'>[src] suddenly appears!</span>")
	alpha = initial(alpha)

/*

There are a few different procs each rune runs through when a cultist activates it.
can_invoke() is called when a cultist activates the rune with an empty hand. If there are multiple cultists, this rune determines if the required amount is nearby.
invoke() is the rune's actual effects.
fail_invoke() is called when the rune fails, via not enough people around or otherwise. Typically this just has a generic 'fizzle' effect.
structure_check() searches for nearby cultist structures required for the invocation. Proper structures are pylons, forges, archives, and altars.

*/

/obj/effect/rune/proc/can_invoke(var/mob/living/user=null)
	//This proc determines if the rune can be invoked at the time. If there are multiple required cultists, it will find all nearby cultists.
	var/list/invokers = list() //people eligible to invoke the rune
	var/list/chanters = list() //people who will actually chant the rune when passed to invoke()
	if(user)
		chanters += user
		invokers += user
	if(req_cultists > 1 || allow_excess_invokers)
		for(var/mob/living/L in range(1, src))
			if(iscultist(L))
				if(L == user)
					continue
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if((H.disabilities & MUTE) || H.silent)
						continue
				if(L.stat)
					continue
				invokers += L
		if(invokers.len >= req_cultists)
			invokers -= user
			if(allow_excess_invokers)
				chanters += invokers
			else
				shuffle(invokers)
				for(var/i in 1 to req_cultists)
					var/L = pick_n_take(invokers)
					if(L)
						chanters += L
	return chanters

/obj/effect/rune/proc/invoke(var/list/invokers)
	//This proc contains the effects of the rune as well as things that happen afterwards. If you want it to spawn an object and then delete itself, have both here.
	if(invocation)
		for(var/M in invokers)
			var/mob/living/L = M
			L.say(invocation)
	do_invoke_glow()

/obj/effect/rune/proc/do_invoke_glow()
	set waitfor = FALSE
	var/oldtransform = transform
	animate(src, transform = matrix()*2, alpha = 0, time = 5) //fade out
	sleep(5)
	animate(transform = oldtransform, alpha = 255, time = 0)

/obj/effect/rune/proc/fail_invoke()
	//This proc contains the effects of a rune if it is not invoked correctly, through either invalid wording or not enough cultists. By default, it's just a basic fizzle.
	visible_message("<span class='warning'>The markings pulse with a \
		small flash of red light, then fall dark.</span>")
	var/oldcolor = color
	color = rgb(255, 0, 0)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 5)

//Malformed Rune: This forms if a rune is not drawn correctly. Invoking it does nothing but hurt the user.
/obj/effect/rune/malformed
	cultist_name = "malformed rune"
	cultist_desc = "a senseless rune written in gibberish. No good can come from invoking this."
	invocation = "Ra'sha yoka!"

/obj/effect/rune/malformed/New()
	..()
	icon_state = "[rand(1,7)]"
	color = rgb(rand(0,255), rand(0,255), rand(0,255))

/obj/effect/rune/malformed/invoke(var/list/invokers)
	..()
	for(var/M in invokers)
		var/mob/living/L = M
		to_chat(L, "<span class='cultitalic'><b>You feel your life force draining. The Geometer is displeased.</b></span>")
		L.apply_damage(30, BRUTE)
	qdel(src)

/mob/proc/null_rod_check() //The null rod, if equipped, will protect the holder from the effects of most runes
	var/obj/item/weapon/nullrod/N = locate() in src
	if(N && !GLOB.ratvar_awakens) //If Nar-Sie or Ratvar are alive, null rods won't protect you
		return N
	return 0

/mob/proc/bible_check() //The bible, if held, might protect against certain things
	var/obj/item/weapon/storage/book/bible/B = locate() in src
	if(is_holding(B))
		return B
	return 0

//Rite of Binding: A paper on top of the rune to a talisman.
/obj/effect/rune/imbue
	cultist_name = "Create Talisman"
	cultist_desc = "transforms paper into powerful magic talismans."
	invocation = "H'drak v'loso, mir'kanas verbot!"
	icon_state = "3"
	color = "#0000FF"

/obj/effect/rune/imbue/invoke(var/list/invokers)
	var/mob/living/user = invokers[1] //the first invoker is always the user
	var/list/papers_on_rune = checkpapers()
	var/entered_talisman_name
	var/obj/item/weapon/paper/talisman/talisman_type
	var/list/possible_talismans = list()
	if(!papers_on_rune.len)
		to_chat(user, "<span class='cultitalic'>There must be a blank paper on top of [src]!</span>")
		fail_invoke()
		log_game("Talisman Creation rune failed - no blank papers on rune")
		return
	if(rune_in_use)
		to_chat(user, "<span class='cultitalic'>[src] can only support one ritual at a time!</span>")
		fail_invoke()
		log_game("Talisman Creation rune failed - already in use")
		return

	for(var/I in subtypesof(/obj/item/weapon/paper/talisman) - /obj/item/weapon/paper/talisman/malformed - /obj/item/weapon/paper/talisman/supply - /obj/item/weapon/paper/talisman/supply/weak)
		var/obj/item/weapon/paper/talisman/J = I
		var/talisman_cult_name = initial(J.cultist_name)
		if(talisman_cult_name)
			possible_talismans[talisman_cult_name] = J //This is to allow the menu to let cultists select talismans by name
	entered_talisman_name = input(user, "Choose a talisman to imbue.", "Talisman Choices") as null|anything in possible_talismans
	talisman_type = possible_talismans[entered_talisman_name]
	if(!Adjacent(user) || !src || QDELETED(src) || user.incapacitated() || rune_in_use || !talisman_type)
		return
	papers_on_rune = checkpapers()
	if(!papers_on_rune.len)
		to_chat(user, "<span class='cultitalic'>There must be a blank paper on top of [src]!</span>")
		fail_invoke()
		log_game("Talisman Creation rune failed - no blank papers on rune")
		return
	var/obj/item/weapon/paper/paper_to_imbue = papers_on_rune[1]
	..()
	visible_message("<span class='warning'>Dark power begins to channel into the paper!</span>")
	rune_in_use = 1
	if(!do_after(user, initial(talisman_type.creation_time), target = paper_to_imbue))
		rune_in_use = 0
		return
	new talisman_type(get_turf(src))
	visible_message("<span class='warning'>[src] glows with power, and bloody images form themselves on [paper_to_imbue].</span>")
	qdel(paper_to_imbue)
	rune_in_use = 0

/obj/effect/rune/imbue/proc/checkpapers()
	. = list()
	for(var/obj/item/weapon/paper/P in get_turf(src))
		if(!P.info && !istype(P, /obj/item/weapon/paper/talisman))
			. |= P

/obj/effect/rune/teleport
	cultist_name = "Teleport"
	cultist_desc = "warps everything above it to another chosen teleport rune."
	invocation = "Sas'so c'arta forbici!"
	icon_state = "2"
	color = "#551A8B"
	req_keyword = 1
	var/listkey

/obj/effect/rune/teleport/New(loc, set_keyword)
	..()
	var/area/A = get_area(src)
	var/locname = initial(A.name)
	listkey = set_keyword ? "[set_keyword] [locname]":"[locname]"
	GLOB.teleport_runes += src

/obj/effect/rune/teleport/Destroy()
	GLOB.teleport_runes -= src
	return ..()

/obj/effect/rune/teleport/invoke(var/list/invokers)
	var/mob/living/user = invokers[1] //the first invoker is always the user
	var/list/potential_runes = list()
	var/list/teleportnames = list()
	for(var/R in GLOB.teleport_runes)
		var/obj/effect/rune/teleport/T = R
		if(T != src && (T.z <= ZLEVEL_SPACEMAX))
			potential_runes[avoid_assoc_duplicate_keys(T.listkey, teleportnames)] = T

	if(!potential_runes.len)
		to_chat(user, "<span class='warning'>There are no valid runes to teleport to!</span>")
		log_game("Teleport rune failed - no other teleport runes")
		fail_invoke()
		return

	if(user.z > ZLEVEL_SPACEMAX)
		to_chat(user, "<span class='cultitalic'>You are not in the right dimension!</span>")
		log_game("Teleport rune failed - user in away mission")
		fail_invoke()
		return

	var/input_rune_key = input(user, "Choose a rune to teleport to.", "Rune to Teleport to") as null|anything in potential_runes //we know what key they picked
	var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
	if(!Adjacent(user) || !src || QDELETED(src) || user.incapacitated() || !actual_selected_rune)
		fail_invoke()
		return

	var/turf/T = get_turf(src)
	var/turf/target = get_turf(actual_selected_rune)
	if(is_blocked_turf(target, TRUE))
		to_chat(user, "<span class='warning'>The target rune is blocked. Attempting to teleport to it would be massively unwise.</span>")
		fail_invoke()
		return
	var/movedsomething = 0
	var/moveuserlater = 0
	for(var/atom/movable/A in T)
		if(A == user)
			moveuserlater = 1
			movedsomething = 1
			continue
		if(!A.anchored)
			movedsomething = 1
			A.forceMove(target)
	if(movedsomething)
		..()
		visible_message("<span class='warning'>There is a sharp crack of inrushing air, and everything above the rune disappears!</span>")
		to_chat(user, "<span class='cult'>You[moveuserlater ? "r vision blurs, and you suddenly appear somewhere else":" send everything above the rune away"].</span>")
		if(moveuserlater)
			user.forceMove(target)
	else
		fail_invoke()


//Rite of Offering: Converts or sacrifices a target.
/obj/effect/rune/convert
	cultist_name = "Offer"
	cultist_desc = "offers a noncultist above it to Nar-Sie, either converting them or sacrificing them."
	req_cultists_text = "2 for conversion, 3 for living sacrifices and sacrifice targets."
	invocation = "Mah'weyh pleggh at e'ntrath!"
	icon_state = "3"
	color = "#FFFFFF"
	req_cultists = 1
	allow_excess_invokers = 1
	rune_in_use = FALSE

/obj/effect/rune/convert/do_invoke_glow()
	return

/obj/effect/rune/convert/invoke(var/list/invokers)
	if(rune_in_use)
		return
	var/list/myriad_targets = list()
	var/turf/T = get_turf(src)
	for(var/mob/living/M in T)
		if(!iscultist(M))
			myriad_targets |= M
	if(!myriad_targets.len)
		fail_invoke()
		log_game("Offer rune failed - no eligible targets")
		return
	rune_in_use = TRUE
	visible_message("<span class='warning'>[src] pulses blood red!</span>")
	var/oldcolor = color
	color = "#7D1717"
	var/mob/living/L = pick(myriad_targets)
	var/is_clock = is_servant_of_ratvar(L)
	var/is_convertable = is_convertable_to_cult(L)
	if(L.stat != DEAD && (is_clock || is_convertable))
		invocation = "Mah'weyh pleggh at e'ntrath!"
		..()
		if(is_clock)
			L.visible_message("<span class='warning'>[L]'s eyes glow a defiant yellow!</span>", \
			"<span class='cultlarge'>\"Stop resisting. You <i>will</i> be mi-\"</span>\n\
			<span class='large_brass'>\"Give up and you will feel pain unlike anything you've ever felt!\"</span>")
			L.Weaken(4)
		else if(is_convertable)
			do_convert(L, invokers)
	else
		invocation = "Barhah hra zar'garis!"
		..()
		do_sacrifice(L, invokers)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 5)
	rune_in_use = FALSE

/obj/effect/rune/convert/proc/do_convert(mob/living/convertee, list/invokers)
	if(invokers.len < 2)
		for(var/M in invokers)
			to_chat(M, "<span class='warning'>You need more invokers to convert [convertee]!</span>")
		log_game("Offer rune failed - tried conversion with one invoker")
		return 0
	if(convertee.null_rod_check())
		for(var/M in invokers)
			to_chat(M, "<span class='warning'>Something is shielding [convertee]'s mind!</span>")
		log_game("Offer rune failed - convertee had null rod")
		return 0
	var/brutedamage = convertee.getBruteLoss()
	var/burndamage = convertee.getFireLoss()
	if(brutedamage || burndamage)
		convertee.adjustBruteLoss(-(brutedamage * 0.75))
		convertee.adjustFireLoss(-(burndamage * 0.75))
	convertee.visible_message("<span class='warning'>[convertee] writhes in pain \
	[brutedamage || burndamage ? "even as [convertee.p_their()] wounds heal and close" : "as the markings below [convertee.p_them()] glow a bloody red"]!</span>", \
 	"<span class='cultlarge'><i>AAAAAAAAAAAAAA-</i></span>")
	SSticker.mode.add_cultist(convertee.mind, 1)
	new /obj/item/weapon/tome(get_turf(src))
	convertee.mind.special_role = "Cultist"
	to_chat(convertee, "<span class='cultitalic'><b>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible, truth. The veil of reality has been ripped away \
	and something evil takes root.</b></span>")
	to_chat(convertee, "<span class='cultitalic'><b>Assist your new compatriots in their dark dealings. Your goal is theirs, and theirs is yours. You serve the Geometer above all else. Bring it back.\
	</b></span>")
	return 1

/obj/effect/rune/convert/proc/do_sacrifice(mob/living/sacrificial, list/invokers)
	if((((ishuman(sacrificial) || iscyborg(sacrificial)) && sacrificial.stat != DEAD) || is_sacrifice_target(sacrificial.mind)) && invokers.len < 3)
		for(var/M in invokers)
			to_chat(M, "<span class='cultitalic'>[sacrificial] is too greatly linked to the world! You need three acolytes!</span>")
		log_game("Offer rune failed - not enough acolytes and target is living or sac target")
		return FALSE
	var/sacrifice_fulfilled = FALSE

	if(sacrificial.mind)
		GLOB.sacrificed += sacrificial.mind
		if(is_sacrifice_target(sacrificial.mind))
			sacrifice_fulfilled = TRUE
	else
		GLOB.sacrificed += sacrificial

	new /obj/effect/overlay/temp/cult/sac(get_turf(src))
	for(var/M in invokers)
		if(sacrifice_fulfilled)
			to_chat(M, "<span class='cultlarge'>\"Yes! This is the one I desire! You have done well.\"</span>")
		else
			if(ishuman(sacrificial) || iscyborg(sacrificial))
				to_chat(M, "<span class='cultlarge'>\"I accept this sacrifice.\"</span>")
			else
				to_chat(M, "<span class='cultlarge'>\"I accept this meager sacrifice.\"</span>")

	var/obj/item/device/soulstone/stone = new /obj/item/device/soulstone(get_turf(src))
	if(sacrificial.mind)
		stone.invisibility = INVISIBILITY_MAXIMUM //so it's not picked up during transfer_soul()
		stone.transfer_soul("FORCE", sacrificial, usr)
		stone.invisibility = 0

	if(sacrificial)
		if(iscyborg(sacrificial))
			playsound(sacrificial, 'sound/magic/Disable_Tech.ogg', 100, 1)
			sacrificial.dust() //To prevent the MMI from remaining
		else
			playsound(sacrificial, 'sound/magic/Disintegrate.ogg', 100, 1)
			sacrificial.gib()
	return TRUE

//Ritual of Dimensional Rending: Calls forth the avatar of Nar-Sie upon the station.
/obj/effect/rune/narsie
	cultist_name = "Summon Nar-Sie"
	cultist_desc = "tears apart dimensional barriers, calling forth the Geometer. Requires 9 invokers."
	invocation = "TOK-LYR RQA-NAP G'OLT-ULOFT!!"
	req_cultists = 9
	icon = 'icons/effects/96x96.dmi'
	color = "#7D1717"
	icon_state = "rune_large"
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	scribe_delay = 450 //how long the rune takes to create
	scribe_damage = 40.1 //how much damage you take doing it
	var/used
	var/ignore_gamemode = FALSE

/obj/effect/rune/narsie/New()
	. = ..()
	GLOB.poi_list |= src

/obj/effect/rune/narsie/Destroy()
	GLOB.poi_list -= src
	. = ..()

/obj/effect/rune/narsie/talismanhide() //can't hide this, and you wouldn't want to
	return

/obj/effect/rune/narsie/invoke(var/list/invokers)
	if(used)
		return
	if(z != ZLEVEL_STATION)
		return

	var/datum/game_mode/cult/cult_mode

	if(SSticker.mode.name == "cult")
		cult_mode = SSticker.mode

	if(!cult_mode && !ignore_gamemode)
		for(var/M in invokers)
			to_chat(M, "<span class='warning'>Nar-Sie does not respond!</span>")
		fail_invoke()
		log_game("Summon Nar-Sie rune failed - gametype is not cult")
		return

	if(locate(/obj/singularity/narsie) in GLOB.poi_list)
		for(var/M in invokers)
			to_chat(M, "<span class='warning'>Nar-Sie is already on this plane!</span>")
		log_game("Summon Nar-Sie rune failed - already summoned")
		return
	//BEGIN THE SUMMONING
	used = 1
	..()
	send_to_playing_players('sound/effects/dimensional_rend.ogg') //There used to be a message for this but every time it was changed it got edgier so I removed it
	var/turf/T = get_turf(src)
	sleep(40)
	if(src)
		color = "#FF0000"
	if(cult_mode)
		cult_mode.eldergod = 0
	new /obj/singularity/narsie/large(T) //Causes Nar-Sie to spawn even if the rune has been removed

/obj/effect/rune/narsie/attackby(obj/I, mob/user, params)	//Since the narsie rune takes a long time to make, add logging to removal.
	if((istype(I, /obj/item/weapon/tome) && iscultist(user)))
		user.visible_message("<span class='warning'>[user.name] begins erasing the [src]...</span>", "<span class='notice'>You begin erasing the [src]...</span>")
		if(do_after(user, 50, target = src))	//Prevents accidental erasures.
			log_game("Summon Narsie rune erased by [user.mind.key] (ckey) with a tome")
			message_admins("[key_name_admin(user)] erased a Narsie rune with a tome")
			..()
	else
		if(istype(I, /obj/item/weapon/nullrod))	//Begone foul magiks. You cannot hinder me.
			log_game("Summon Narsie rune erased by [user.mind.key] (ckey) using a null rod")
			message_admins("[key_name_admin(user)] erased a Narsie rune with a null rod")
			..()

//Rite of Resurrection: Requires the corpse of a cultist and that there have been less revives than the number of people GLOB.sacrificed
/obj/effect/rune/raise_dead
	cultist_name = "Raise Dead"
	cultist_desc = "requires the corpse of a cultist placed upon the rune. Provided there have been sufficient sacrifices, they will be revived."
	invocation = null //Depends on the name of the user - see below
	icon_state = "1"
	color = "#C80000"
	var/static/revives_used = 0

/obj/effect/rune/raise_dead/examine(mob/user)
	..()
	if(iscultist(user) || user.stat == DEAD)
		var/revive_number = 0
		if(GLOB.sacrificed.len)
			revive_number = GLOB.sacrificed.len - revives_used
		to_chat(user, "<b>Revives Remaining:</b> [revive_number]")

/obj/effect/rune/raise_dead/invoke(var/list/invokers)
	var/turf/T = get_turf(src)
	var/mob/living/mob_to_revive
	var/list/potential_revive_mobs = list()
	var/mob/living/user = invokers[1]
	if(rune_in_use)
		return
	for(var/mob/living/M in T.contents)
		if(iscultist(M) && M.stat == DEAD)
			potential_revive_mobs |= M
	if(!potential_revive_mobs.len)
		to_chat(user, "<span class='cultitalic'>There are no dead cultists on the rune!</span>")
		log_game("Raise Dead rune failed - no corpses to revive")
		fail_invoke()
		return
	if(!GLOB.sacrificed.len || GLOB.sacrificed.len <= revives_used)
		to_chat(user, "<span class='warning'>You have GLOB.sacrificed too few people to revive a cultist!</span>")
		fail_invoke()
		return
	if(potential_revive_mobs.len > 1)
		mob_to_revive = input(user, "Choose a cultist to revive.", "Cultist to Revive") as null|anything in potential_revive_mobs
	else
		mob_to_revive = potential_revive_mobs[1]
	if(!src || QDELETED(src) || rune_in_use || !validness_checks(mob_to_revive, user))
		return
	rune_in_use = 1
	if(user.name == "Herbert West")
		user.say("To life, to life, I bring them!")
	else
		user.say("Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
	..()
	revives_used++
	mob_to_revive.revive(1, 1) //This does remove disabilities and such, but the rune might actually see some use because of it!
	mob_to_revive.grab_ghost()
	to_chat(mob_to_revive, "<span class='cultlarge'>\"PASNAR SAVRAE YAM'TOTH. Arise.\"</span>")
	mob_to_revive.visible_message("<span class='warning'>[mob_to_revive] draws in a huge breath, red light shining from [mob_to_revive.p_their()] eyes.</span>", \
								  "<span class='cultlarge'>You awaken suddenly from the void. You're alive!</span>")
	rune_in_use = 0

/obj/effect/rune/raise_dead/proc/validness_checks(mob/living/target_mob, mob/living/user)
	var/turf/T = get_turf(src)
	if(!user)
		return 0
	if(!Adjacent(user) || user.incapacitated())
		return 0
	if(!target_mob)
		fail_invoke()
		return 0
	if(!(target_mob in T.contents))
		to_chat(user, "<span class='cultitalic'>The cultist to revive has been moved!</span>")
		fail_invoke()
		log_game("Raise Dead rune failed - revival target moved")
		return 0
	var/mob/dead/observer/ghost = target_mob.get_ghost(TRUE)
	if(!ghost && (!target_mob.mind || !target_mob.mind.active))
		to_chat(user, "<span class='cultitalic'>The corpse to revive has no spirit!</span>")
		fail_invoke()
		log_game("Raise Dead rune failed - revival target has no ghost")
		return 0
	if(!GLOB.sacrificed.len || GLOB.sacrificed.len <= revives_used)
		to_chat(user, "<span class='warning'>You have sacrificed too few people to revive a cultist!</span>")
		fail_invoke()
		log_game("Raise Dead rune failed - too few sacrificed")
		return 0
	return 1

/obj/effect/rune/raise_dead/fail_invoke()
	..()
	for(var/mob/living/M in range(1,src))
		if(iscultist(M) && M.stat == DEAD)
			M.visible_message("<span class='warning'>[M] twitches.</span>")


//Rite of Disruption: Emits an EMP blast.
/obj/effect/rune/emp
	cultist_name = "Electromagnetic Disruption"
	cultist_desc = "emits a large electromagnetic pulse, increasing in size for each cultist invoking it, hindering electronics and disabling silicons."
	invocation = "Ta'gh fara'qha fel d'amar det!"
	icon_state = "5"
	allow_excess_invokers = 1
	color = "#4D94FF"

/obj/effect/rune/emp/invoke(var/list/invokers)
	var/turf/E = get_turf(src)
	..()
	visible_message("<span class='warning'>[src] glows blue for a moment before vanishing.</span>")
	switch(invokers.len)
		if(1 to 2)
			playsound(E, 'sound/items/Welder2.ogg', 25, 1)
			for(var/M in invokers)
				to_chat(M, "<span class='warning'>You feel a minute vibration pass through you...</span>")
		if(3 to 6)
			playsound(E, 'sound/magic/Disable_Tech.ogg', 50, 1)
			for(var/M in invokers)
				to_chat(M, "<span class='danger'>Your hair stands on end as a shockwave eminates from the rune!</span>")
		if(7 to INFINITY)
			playsound(E, 'sound/magic/Disable_Tech.ogg', 100, 1)
			for(var/M in invokers)
				var/mob/living/L = M
				to_chat(L, "<span class='userdanger'>You chant in unison and a colossal burst of energy knocks you backward!</span>")
				L.Weaken(2)
	qdel(src) //delete before pulsing because it's a delay reee
	empulse(E, 9*invokers.len, 12*invokers.len) // Scales now, from a single room to most of the station depending on # of chanters

//Rite of Astral Communion: Separates one's spirit from their body. They will take damage while it is active.
/obj/effect/rune/astral
	cultist_name = "Astral Communion"
	cultist_desc = "severs the link between one's spirit and body. This effect is taxing and one's physical body will take damage while this is active."
	invocation = "Fwe'sh mah erl nyag r'ya!"
	icon_state = "7"
	color = "#7D1717"
	rune_in_use = 0 //One at a time, please!
	construct_invoke = 0
	var/mob/living/affecting = null

/obj/effect/rune/astral/examine(mob/user)
	..()
	if(affecting)
		to_chat(user, "<span class='cultitalic'>A translucent field encases [user] above the rune!</span>")

/obj/effect/rune/astral/can_invoke(mob/living/user)
	if(rune_in_use)
		to_chat(user, "<span class='cultitalic'>[src] cannot support more than one body!</span>")
		log_game("Astral Communion rune failed - more than one user")
		return list()
	var/turf/T = get_turf(src)
	if(!(user in T))
		to_chat(user, "<span class='cultitalic'>You must be standing on top of [src]!</span>")
		log_game("Astral Communion rune failed - user not standing on rune")
		return list()
	return ..()

/obj/effect/rune/astral/invoke(var/list/invokers)
	var/mob/living/user = invokers[1]
	..()
	var/turf/T = get_turf(src)
	rune_in_use = 1
	affecting = user
	user.color = "#7D1717"
	user.visible_message("<span class='warning'>[user] freezes statue-still, glowing an unearthly red.</span>", \
						 "<span class='cult'>You see what lies beyond. All is revealed. While this is a wondrous experience, your physical form will waste away in this state. Hurry...</span>")
	user.ghostize(1)
	while(user)
		if(!affecting)
			visible_message("<span class='warning'>[src] pulses gently before falling dark.</span>")
			affecting = null //In case it's assigned to a number or something
			rune_in_use = 0
			return
		affecting.apply_damage(0.1, BRUTE)
		if(!(user in T))
			user.visible_message("<span class='warning'>A spectral tendril wraps around [user] and pulls [user.p_them()] back to the rune!</span>")
			Beam(user,icon_state="drainbeam",time=2)
			user.forceMove(get_turf(src)) //NO ESCAPE :^)
		if(user.key)
			user.visible_message("<span class='warning'>[user] slowly relaxes, the glow around [user.p_them()] dimming.</span>", \
								 "<span class='danger'>You are re-united with your physical form. [src] releases its hold over you.</span>")
			user.color = initial(user.color)
			user.Weaken(3)
			rune_in_use = 0
			affecting = null
			return
		if(user.stat == UNCONSCIOUS)
			if(prob(1))
				var/mob/dead/observer/G = user.get_ghost()
				to_chat(G, "<span class='cultitalic'>You feel the link between you and your body weakening... you must hurry!</span>")
		if(user.stat == DEAD)
			user.color = initial(user.color)
			rune_in_use = 0
			affecting = null
			var/mob/dead/observer/G = user.get_ghost()
			to_chat(G, "<span class='cultitalic'><b>You suddenly feel your physical form pass on. [src]'s exertion has killed you!</b></span>")
			return
		sleep(1)
	rune_in_use = 0

//Rite of the Corporeal Shield: When invoked, becomes solid and cannot be passed. Invoke again to undo.
/obj/effect/rune/wall
	cultist_name = "Form Barrier"
	cultist_desc = "when invoked, makes a temporary invisible wall to block passage. Can be invoked again to reverse this."
	invocation = "Khari'd! Eske'te tannin!"
	icon_state = "1"
	color = "#C80000"
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/density_timer
	var/recharging = FALSE

/obj/effect/rune/wall/New()
	..()
	GLOB.wall_runes += src

/obj/effect/rune/wall/examine(mob/user)
	..()
	if(density)
		to_chat(user, "<span class='cultitalic'>There is a barely perceptible shimmering of the air above [src].</span>")

/obj/effect/rune/wall/Destroy()
	density = 0
	GLOB.wall_runes -= src
	air_update_turf(1)
	return ..()

/obj/effect/rune/wall/BlockSuperconductivity()
	return density

/obj/effect/rune/wall/invoke(var/list/invokers)
	if(recharging)
		return
	var/mob/living/user = invokers[1]
	..()
	density = !density
	update_state()
	if(density)
		spread_density()
	user.visible_message("<span class='warning'>[user] [iscarbon(user) ? "places [user.p_their()] hands on":"stares intently at"] [src], and [density ? "the air above it begins to shimmer" : "the shimmer above it fades"].</span>", \
						 "<span class='cultitalic'>You channel your life energy into [src], [density ? "temporarily preventing" : "allowing"] passage above it.</span>")
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.apply_damage(2, BRUTE, pick("l_arm", "r_arm"))

/obj/effect/rune/wall/proc/spread_density()
	for(var/R in GLOB.wall_runes)
		var/obj/effect/rune/wall/W = R
		if(W.z == z && get_dist(src, W) <= 2 && !W.density && !W.recharging)
			W.density = TRUE
			W.update_state()
			W.spread_density()
	density_timer = addtimer(CALLBACK(src, .proc/lose_density), 900, TIMER_STOPPABLE)

/obj/effect/rune/wall/proc/lose_density()
	if(density)
		recharging = TRUE
		density = FALSE
		update_state()
		var/oldcolor = color
		add_atom_colour("#696969", FIXED_COLOUR_PRIORITY)
		animate(src, color = oldcolor, time = 50, easing = EASE_IN)
		addtimer(CALLBACK(src, .proc/recharge), 50)

/obj/effect/rune/wall/proc/recharge()
	recharging = FALSE
	add_atom_colour("#C80000", FIXED_COLOUR_PRIORITY)

/obj/effect/rune/wall/proc/update_state()
	deltimer(density_timer)
	air_update_turf(1)
	if(density)
		var/image/I = image(layer = ABOVE_MOB_LAYER, icon = 'icons/effects/effects.dmi', icon_state = "barriershimmer")
		I.appearance_flags = RESET_COLOR
		I.alpha = 60
		I.color = "#701414"
		add_overlay(I)
		add_atom_colour("#FF0000", FIXED_COLOUR_PRIORITY)
	else
		cut_overlays()
		add_atom_colour("#C80000", FIXED_COLOUR_PRIORITY)

//Rite of Joined Souls: Summons a single cultist.
/obj/effect/rune/summon
	cultist_name = "Summon Cultist"
	cultist_desc = "summons a single cultist to the rune. Requires 2 invokers."
	invocation = "N'ath reth sh'yro eth d'rekkathnor!"
	req_cultists = 2
	allow_excess_invokers = 1
	icon_state = "5"
	color = "#00FF00"

/obj/effect/rune/summon/invoke(var/list/invokers)
	var/mob/living/user = invokers[1]
	var/list/cultists = list()
	for(var/datum/mind/M in SSticker.mode.cult)
		if(!(M.current in invokers) && M.current && M.current.stat != DEAD)
			cultists |= M.current
	var/mob/living/cultist_to_summon = input(user, "Who do you wish to call to [src]?", "Followers of the Geometer") as null|anything in cultists
	if(!Adjacent(user) || !src || QDELETED(src) || user.incapacitated())
		return
	if(!cultist_to_summon)
		to_chat(user, "<span class='cultitalic'>You require a summoning target!</span>")
		fail_invoke()
		log_game("Summon Cultist rune failed - no target")
		return
	if(cultist_to_summon.stat == DEAD)
		to_chat(user, "<span class='cultitalic'>[cultist_to_summon] has died!</span>")
		fail_invoke()
		log_game("Summon Cultist rune failed - target died")
		return
	if(!iscultist(cultist_to_summon))
		to_chat(user, "<span class='cultitalic'>[cultist_to_summon] is not a follower of the Geometer!</span>")
		fail_invoke()
		log_game("Summon Cultist rune failed - target was deconverted")
		return
	if(cultist_to_summon.z > ZLEVEL_SPACEMAX)
		to_chat(user, "<span class='cultitalic'>[cultist_to_summon] is not in our dimension!</span>")
		fail_invoke()
		log_game("Summon Cultist rune failed - target in away mission")
		return
	cultist_to_summon.visible_message("<span class='warning'>[cultist_to_summon] suddenly disappears in a flash of red light!</span>", \
									  "<span class='cultitalic'><b>Overwhelming vertigo consumes you as you are hurled through the air!</b></span>")
	..()
	visible_message("<span class='warning'>A foggy shape materializes atop [src] and solidifes into [cultist_to_summon]!</span>")
	user.apply_damage(10, BRUTE, "head")
	cultist_to_summon.forceMove(get_turf(src))
	qdel(src)

//Rite of Boiling Blood: Deals extremely high amounts of damage to non-cultists nearby
/obj/effect/rune/blood_boil
	cultist_name = "Boil Blood"
	cultist_desc = "boils the blood of non-believers who can see the rune, rapidly dealing extreme amounts of damage. Requires 3 invokers."
	invocation = "Dedo ol'btoh!"
	icon_state = "4"
	color = "#C80000"
	light_color = LIGHT_COLOR_LAVA
	req_cultists = 3
	construct_invoke = 0
	var/tick_damage = 25
	rune_in_use = FALSE

/obj/effect/rune/blood_boil/do_invoke_glow()
	return

/obj/effect/rune/blood_boil/invoke(var/list/invokers)
	if(rune_in_use)
		return
	..()
	rune_in_use = TRUE
	var/turf/T = get_turf(src)
	visible_message("<span class='warning'>[src] turns a bright, glowing orange!</span>")
	set_light(6)
	color = "#FC9B54"
	for(var/M in invokers)
		var/mob/living/L = M
		L.apply_damage(10, BRUTE, pick("l_arm", "r_arm"))
		to_chat(L, "<span class='cultitalic'>[src] saps your strength!</span>")
	for(var/mob/living/L in viewers(T))
		if(!iscultist(L) && L.blood_volume)
			var/obj/item/weapon/nullrod/N = L.null_rod_check()
			if(N)
				to_chat(L, "<span class='userdanger'>\The [N] suddenly burns hotly before returning to normal!</span>")
				continue
			to_chat(L, "<span class='cultlarge'>Your blood boils in your veins!</span>")
			if(is_servant_of_ratvar(L))
				to_chat(L, "<span class='userdanger'>You feel an unholy darkness dimming the Justiciar's light!</span>")
	animate(src, color = "#FCB56D", time = 4)
	sleep(4)
	if(!src)
		return
	do_area_burn(T, 0.5)
	animate(src, color = "#FFDF80", time = 5)
	sleep(5)
	if(!src)
		return
	do_area_burn(T, 1)
	animate(src, color = "#FFFDF4", time = 6)
	sleep(6)
	if(!src)
		return
	do_area_burn(T, 1.5)
	new /obj/effect/hotspot(T)
	qdel(src)

/obj/effect/rune/blood_boil/proc/do_area_burn(turf/T, multiplier)
	for(var/mob/living/L in viewers(T))
		if(!iscultist(L) && L.blood_volume)
			var/obj/item/weapon/nullrod/N = L.null_rod_check()
			if(N)
				continue
			L.take_overall_damage(tick_damage*multiplier, tick_damage*multiplier)
			if(is_servant_of_ratvar(L))
				L.adjustStaminaLoss(tick_damage*0.5)


//Deals brute damage to all targets on the rune and heals the invoker for each target drained.
/obj/effect/rune/leeching
	cultist_name = "Drain Life"
	cultist_desc = "drains the life of all targets on the rune, restoring life to the user."
	invocation = "Yu'gular faras desdae. Umathar uf'kal thenar!"
	icon_state = "3"
	color = "#9F1C34"

/obj/effect/rune/leeching/can_invoke(mob/living/user)
	if(world.time <= user.next_move)
		return list()
	var/turf/T = get_turf(src)
	var/list/potential_targets = list()
	for(var/mob/living/carbon/M in T.contents - user)
		if(M.stat != DEAD)
			potential_targets += M
	if(!potential_targets.len)
		to_chat(user, "<span class='cultitalic'>There must be at least one valid target on the rune!</span>")
		log_game("Leeching rune failed - no valid targets")
		return list()
	return ..()

/obj/effect/rune/leeching/invoke(var/list/invokers)
	var/mob/living/user = invokers[1]
	user.changeNext_move(CLICK_CD_CLICK_ABILITY)
	..()
	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/M in T.contents - user)
		if(M.stat != DEAD)
			var/drained_amount = rand(10,20)
			M.apply_damage(drained_amount, BRUTE, "chest")
			user.adjustBruteLoss(-drained_amount)
			to_chat(M, "<span class='cultitalic'>You feel extremely weak.</span>")
	user.Beam(T,icon_state="drainbeam",time=5)
	user.visible_message("<span class='warning'>Blood flows from the rune into [user]!</span>", \
	"<span class='cult'>Blood flows into you, healing your wounds and revitalizing your spirit.</span>")


//Rite of Spectral Manifestation: Summons a ghost on top of the rune as a cultist human with no items. User must stand on the rune at all times, and takes damage for each summoned ghost.
/obj/effect/rune/manifest
	cultist_name = "Manifest Spirit"
	cultist_desc = "manifests a spirit as a servant of the Geometer. The invoker must not move from atop the rune, and will take damage for each summoned spirit."
	invocation = "Gal'h'rfikk harfrandid mud'gib!" //how the fuck do you pronounce this
	icon_state = "6"
	construct_invoke = 0
	color = "#C80000"

/obj/effect/rune/manifest/New(loc)
	..()
	notify_ghosts("Manifest rune created in [get_area(src)].", 'sound/effects/ghost2.ogg', source = src)

/obj/effect/rune/manifest/can_invoke(mob/living/user)
	if(!(user in get_turf(src)))
		to_chat(user, "<span class='cultitalic'>You must be standing on [src]!</span>")
		fail_invoke()
		log_game("Manifest rune failed - user not standing on rune")
		return list()
	var/list/ghosts_on_rune = list()
	for(var/mob/dead/observer/O in get_turf(src))
		if(O.client && !jobban_isbanned(O, ROLE_CULTIST))
			ghosts_on_rune |= O
	if(!ghosts_on_rune.len)
		to_chat(user, "<span class='cultitalic'>There are no spirits near [src]!</span>")
		fail_invoke()
		log_game("Manifest rune failed - no nearby ghosts")
		return list()
	return ..()

/obj/effect/rune/manifest/invoke(var/list/invokers)
	var/mob/living/user = invokers[1]
	var/list/ghosts_on_rune = list()
	for(var/mob/dead/observer/O in get_turf(src))
		if(O.client && !jobban_isbanned(O, ROLE_CULTIST))
			ghosts_on_rune |= O
	var/mob/dead/observer/ghost_to_spawn = pick(ghosts_on_rune)
	var/mob/living/carbon/human/new_human = new(get_turf(src))
	new_human.real_name = ghost_to_spawn.real_name
	new_human.alpha = 150 //Makes them translucent
	..()
	visible_message("<span class='warning'>A cloud of red mist forms above [src], and from within steps... a man.</span>")
	to_chat(user, "<span class='cultitalic'>Your blood begins flowing into [src]. You must remain in place and conscious to maintain the forms of those summoned. This will hurt you slowly but surely...</span>")
	var/turf/T = get_turf(src)
	var/obj/structure/emergency_shield/invoker/N = new(T)

	new_human.key = ghost_to_spawn.key
	SSticker.mode.add_cultist(new_human.mind, 0)
	to_chat(new_human, "<span class='cultitalic'><b>You are a servant of the Geometer. You have been made semi-corporeal by the cult of Nar-Sie, and you are to serve them at all costs.</b></span>")

	while(user in T)
		if(user.stat)
			break
		user.apply_damage(0.1, BRUTE)
		sleep(3)

	qdel(N)
	if(new_human)
		new_human.visible_message("<span class='warning'>[new_human] suddenly dissolves into bones and ashes.</span>", \
								  "<span class='cultlarge'>Your link to the world fades. Your form breaks apart.</span>")
		for(var/obj/I in new_human)
			new_human.dropItemToGround(I)
		new_human.dust()
